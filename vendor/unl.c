/* unl.c -- Unlambda 2.0 interpreter (CEK machine + Cheney copying GC).
 * Language reference: http://www.madore.org/~david/programs/unlambda/
 *   cc -O2 -o unl unl.c
 *   ./unl prog.unl            # program from file, input from stdin
 *   ./unl -s prog.unl         # reduction stats on stderr
 *   ./unl -h N prog.unl       # cap the heap at N cells per semispace
 * Implements: ` s k i v d c e r .x @ ?x |
 * d is delayed properly (decided after the operator has been evaluated);
 * c is full call/cc (a continuation is snapshotted into the heap and re-invocable).
 *
 * Three ideas are lifted from irori's Lazy K interpreter (github.com/irori/lazyk):
 *   - a two-space Cheney collector whose cost is O(live), not O(heap);
 *   - a heap that grows to ~8x the live set, so GCs stay rare and cheap;
 *   - immediate (unboxed) cells for the atoms, so s/k/i never touch the heap.
 * On top of that the continuation lives on a C array stack instead of the heap,
 * and ``s x y is specialised at construction time into B/C/S' style combinators
 * so that the k and i in the arms never have to be applied at all.
 * The inner loop is threaded (one indirect jump per case, GCC/Clang only) --
 * a single shared dispatch mispredicts on nearly every combinator.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* ---- cells --------------------------------------------------------------
 * A Cell is a tagged word.  The low 4 bits hold the tag; tags 0..14 mean the
 * rest of the word is a pointer to a 16-byte aligned Node, tag 15 means the
 * cell is an immediate atom and there is no heap object at all.
 * Every Node is exactly two Cells and the GC traces both, so the collector
 * needs no tag dispatch. */
typedef uintptr_t Cell;
typedef struct Node { Cell a, b; } Node;

enum {
  T_APP = 0,          /* a = operator term, b = operand term */
  T_K1,               /* `k x           : a = x */
  T_S1,               /* `s x           : a = x */
  T_S2,               /* ``s x y        : a = x, b = y */
  T_B,                /* ``s `k f y     : f (y z) */
  T_C,                /* ``s x `k g     : (x z) g */
  T_BC,               /* ``s `k f `k g  : f g */
  T_SI,               /* ``s i y        : z (y z) */
  T_CI,               /* ``s x i        : (x z) z */
  T_IK,               /* ``s i `k g     : z g */
  T_WI,               /* ``s i i        : z z */
  T_PROM,             /* `d term        : a = term */
  T_CONT,             /* continuation   : a = snapshot chain */
  T_CONS,             /* snapshot chain : a = element, b = rest */
  T_UNUSED14,
  T_IMM
};

/* atom codes, packed into an immediate together with the character of .x / ?x */
enum { A_K = 0, A_S, A_I, A_V, A_D, A_C, A_E, A_R, A_DOT, A_QUES, A_BAR, A_AT,
       A_KIND, A_FWD };

#define IMM(atom, ch) ((Cell)(((unsigned)(ch) << 8) | ((unsigned)(atom) << 4) | 15u))
#define ATOM(c)   (((c) >> 4) & 15u)
#define CHOF(c)   (((c) >> 8) & 255u)
#define TAG(c)    ((unsigned)((c) & 15u))
#define PTR(c)    ((Node *)((c) & ~(Cell)15))
#define MK(p, t)  ((Cell)(p) | (Cell)(t))

#define IMM_I IMM(A_I, 0)
#define IMM_V IMM(A_V, 0)
#define IMM_D IMM(A_D, 0)
#define IMM_FWD IMM(A_FWD, 0)

/* ---- continuation stack -------------------------------------------------
 * The machine is properly tail recursive, so this only ever gets as deep as
 * the program's own left spine (about half a million frames for qc.unl). */
enum { K_HALT = 0, K_ARG, K_APL, K_APR, K_SND };
typedef struct { Cell a, b; uintptr_t kind; } Frame;

static Frame *stk; static size_t sp, scap, smax;
static void grow_stk(void) {
  scap = scap ? scap * 2 : (1u << 16);
  stk = realloc(stk, scap * sizeof(Frame));
  if (!stk) { fprintf(stderr, "unl: out of memory (continuation stack)\n"); exit(3); }
}
#define PUSH(kd, aa, bb) do { \
    if (sp == scap) grow_stk(); \
    stk[sp].kind = (kd); stk[sp].a = (aa); stk[sp].b = (bb); sp++; \
  } while (0)

/* ---- heap ---------------------------------------------------------------
 * Two semispaces, Cheney copy on exhaustion.  next_cap is bumped to 8x the
 * live set after each collection (lazyk's policy), so the collector cost is
 * amortised down to a few percent instead of scanning a huge fixed pool. */
#define MIN_HEAP   (1u << 20)    /* smallest working set worth having (16 MB) */
#ifndef HEAP_SLACK
#define HEAP_SLACK 8             /* run in about 8x the live set, as lazyk does */
#endif

static Node *from_base, *to_base, *freep, *limit;
static size_t from_cap, to_cap, next_cap, max_cap;
static Cell R_val, R_ctl, g_a, g_b;
static Cell *pstk; static size_t pstk_n, pstk_cap;   /* parser's pending APP nodes */
static long long n_apply = 0, n_eval = 0, n_gc = 0, n_live = 0;
static int curch = -1, stats = 0;

static Node *heap_alloc(size_t n) {
  Node *p = aligned_alloc(16, n * sizeof(Node));
  if (!p) { fprintf(stderr, "unl: cannot allocate %zu heap cells\n", n); exit(3); }
  return p;
}

static Cell forward(Cell c) {
  Node *p, *q;
  if (TAG(c) == T_IMM) return c;
  p = PTR(c);
  if (p->a == IMM_FWD) return MK(p->b, TAG(c));
  q = freep++;
  q->a = p->a; q->b = p->b;
  p->a = IMM_FWD; p->b = (Cell)q;
  return MK(q, TAG(c));
}

/* Two-space Cheney copy.  next_cap is the size we actually run in and it follows
   the live set both up and down, so the spike at start-up does not pin the
   working set at its peak -- a big heap costs TLB misses on every allocation
   even when the collector itself is nearly free.  The buffers only ever grow. */
static void gc(void) {
  Node *scan; size_t i, live, need;
  n_gc++;
  need = (size_t)(limit - from_base);       /* to-space must be able to hold all of it */
  if (need < next_cap) need = next_cap;
  if (to_cap < need) { free(to_base); to_base = heap_alloc(need); to_cap = need; }
  scan = freep = to_base;
  R_val = forward(R_val); R_ctl = forward(R_ctl);
  g_a = forward(g_a); g_b = forward(g_b);
  for (i = 0; i < sp; i++) { stk[i].a = forward(stk[i].a); stk[i].b = forward(stk[i].b); }
  for (i = 0; i < pstk_n; i++) pstk[i] = forward(pstk[i]);
  while (scan < freep) { scan->a = forward(scan->a); scan->b = forward(scan->b); scan++; }
  live = (size_t)(freep - to_base);
  n_live = (long long)live;
  { Node *tb = from_base; size_t tc = from_cap;
    from_base = to_base; from_cap = to_cap; to_base = tb; to_cap = tc; }
  next_cap = live * HEAP_SLACK;
  if (next_cap < MIN_HEAP) next_cap = MIN_HEAP;
  if (next_cap > max_cap) next_cap = max_cap;
  { size_t use = next_cap < from_cap ? next_cap : from_cap;
    limit = from_base + use;
    if (freep >= limit || (size_t)(limit - freep) < use / 32 + 1) {
      fprintf(stderr, "unl: heap exhausted\n"); exit(3);
    }
  }
}

static Cell mk(unsigned tag, Cell a, Cell b) {
  Node *n;
  if (freep == limit) { g_a = a; g_b = b; gc(); a = g_a; b = g_b; g_a = g_b = IMM_V; }
  n = freep++;
  n->a = a; n->b = b;
  return MK(n, tag);
}

/* ``s x y is built once but applied many times, so pick the cheapest shape here.
   Each arm that is `k g or i can be discharged now instead of on every call. */
static Cell mk_s2(Cell p, Cell q) {
  unsigned tp = TAG(p), tq = TAG(q);
  if (tp == T_K1) {
    Cell f = PTR(p)->a;
    if (tq == T_K1) return mk(T_BC, f, PTR(q)->a);
    /* ``s `k f i behaves exactly like f, but handing back a bare d would let
       the `d test in K_ARG fire one application too early */
    if (q == IMM_I && f != IMM_D) return f;
    return mk(T_B, f, q);
  }
  if (p == IMM_I) {
    if (tq == T_K1) return mk(T_IK, PTR(q)->a, IMM_V);
    if (q == IMM_I) return mk(T_WI, IMM_V, IMM_V);
    return mk(T_SI, q, IMM_V);
  }
  if (tq == T_K1) return mk(T_C, p, PTR(q)->a);
  if (q == IMM_I) return mk(T_CI, p, IMM_V);
  return mk(T_S2, p, q);
}

/* ---- call/cc ------------------------------------------------------------
 * The stack is flattened into a heap list so that the GC owns it; capture and
 * restore are O(depth), which is fine because c is rare. */
static Cell capture(void) {
  Cell chain = IMM_V; size_t i;
  for (i = sp; i-- > 0;) {
    chain = mk(T_CONS, stk[i].b, chain);
    chain = mk(T_CONS, stk[i].a, chain);
    chain = mk(T_CONS, IMM(A_KIND, stk[i].kind), chain);
  }
  return mk(T_CONT, chain, IMM_V);
}

static void restore(Cell chain) {
  sp = 0;
  while (chain != IMM_V) {
    unsigned kind; Cell a, b;
    kind = CHOF(PTR(chain)->a); chain = PTR(chain)->b;
    a = PTR(chain)->a;          chain = PTR(chain)->b;
    b = PTR(chain)->a;          chain = PTR(chain)->b;
    PUSH(kind, a, b);
  }
}

/* ---- output -------------------------------------------------------------
 * .x fires tens of millions of times in a big run, so keep it off stdio. */
static unsigned char obuf[1 << 16]; static size_t obuf_n;
static void out_flush(void) {
  if (obuf_n) fwrite(obuf, 1, obuf_n, stdout);
  obuf_n = 0; fflush(stdout);
}
#define OUT(c) do { \
    if (obuf_n == sizeof obuf) { fwrite(obuf, 1, obuf_n, stdout); obuf_n = 0; } \
    obuf[obuf_n++] = (unsigned char)(c); \
  } while (0)

/* ---- parser ------------------------------------------------------------- */
static const char *src; static size_t srclen, spos;
static unsigned char *pfill;

static int nextc(void) {
  while (spos < srclen) {
    char ch = src[spos];
    if (ch == '#') { while (spos < srclen && src[spos] != '\n') spos++; continue; }
    if (ch==' '||ch=='\t'||ch=='\n'||ch=='\r'||ch=='\f'||ch=='\v') { spos++; continue; }
    spos++; return (unsigned char)ch;
  }
  return -1;
}

static Cell parse_leaf(int ch) {
  switch (ch) {
    case 'k': case 'K': return IMM(A_K, 0);
    case 's': case 'S': return IMM(A_S, 0);
    case 'i': case 'I': return IMM(A_I, 0);
    case 'v': case 'V': return IMM(A_V, 0);
    case 'd': case 'D': return IMM(A_D, 0);
    case 'c': case 'C': return IMM(A_C, 0);
    case 'e': case 'E': return IMM(A_E, 0);
    case 'r': case 'R': return IMM(A_R, 0);
    case '@':           return IMM(A_AT, 0);
    case '|':           return IMM(A_BAR, 0);
    case '.': case '?': {
      int x;
      if (spos >= srclen) { fprintf(stderr, "unl: EOF after %c\n", ch); exit(2); }
      x = (unsigned char)src[spos++];
      return IMM(ch == '.' ? A_DOT : A_QUES, x);
    }
    default: fprintf(stderr, "unl: bad char 0x%02x at %zu\n", ch, spos - 1); exit(2);
  }
}

/* Iterative: a  `.a`.b`.c... image is a LEFT spine hundreds of thousands deep,
   which would blow the C stack in a recursive descent parser. */
static Cell parse(void) {
  Cell t;
  for (;;) {
    int ch = nextc();
    if (ch < 0) { fprintf(stderr, "unl: unexpected EOF in program\n"); exit(2); }
    if (ch == '`') {                       /* application: two operands follow */
      if (pstk_n == pstk_cap) {
        pstk_cap = pstk_cap ? pstk_cap * 2 : 4096;
        pstk = realloc(pstk, pstk_cap * sizeof(Cell));
        pfill = realloc(pfill, pstk_cap);
        if (!pstk || !pfill) { fprintf(stderr, "unl: out of memory (parser)\n"); exit(3); }
      }
      /* allocate first: mk may collect, and the slot must not be live-but-garbage */
      { Cell ap = mk(T_APP, IMM_V, IMM_V);
        pfill[pstk_n] = 0;                 /* still waiting for the operator */
        pstk[pstk_n++] = ap; }
      continue;
    }
    t = parse_leaf(ch);
    for (;;) {                             /* deliver t to the innermost pending app */
      Node *ap;
      if (pstk_n == 0) return t;
      ap = PTR(pstk[pstk_n - 1]);
      if (!pfill[pstk_n - 1]) { ap->a = t; pfill[pstk_n - 1] = 1; break; }
      ap->b = t; pstk_n--; t = pstk[pstk_n];
    }
  }
}

static void report(void) {
  if (stats)
    fprintf(stderr, "[unl] applies=%lld evals=%lld gcs=%lld live=%lld heap=%zu stack=%zu\n",
            n_apply, n_eval, n_gc, n_live, from_cap, smax);
}

int main(int argc, char **argv) {
  const char *path = NULL; FILE *fp;
  char *buf; size_t cap, len; int i;
  Cell f = IMM_V, x = IMM_V;

  max_cap = 40000000;
  for (i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-s")) stats = 1;
    else if (!strcmp(argv[i], "-h") && i + 1 < argc) max_cap = (size_t)atol(argv[++i]);
    else path = argv[i];
  }
  if (!path) { fprintf(stderr, "usage: unl [-s] [-h cells] prog.unl\n"); return 2; }
  atexit(out_flush);                       /* the error paths must not eat buffered .x */
  fp = fopen(path, "rb"); if (!fp) { perror(path); return 2; }
  cap = 1 << 16; len = 0; buf = malloc(cap);
  for (;;) { size_t got;
    if (len == cap) { cap *= 2; buf = realloc(buf, cap); }
    got = fread(buf + len, 1, cap - len, fp); if (!got) break; len += got; }
  fclose(fp); src = buf; srclen = len; spos = 0;

  if (max_cap < (1u << 16)) max_cap = 1u << 16;
  from_cap = MIN_HEAP;                     /* the live set then decides the real size */
  if (from_cap > max_cap) from_cap = max_cap;
  from_base = heap_alloc(from_cap);
  freep = from_base; limit = from_base + from_cap;
  next_cap = from_cap;
  R_val = R_ctl = g_a = g_b = IMM_V;

  R_ctl = parse();
  free(buf); src = NULL;
  free(pstk); free(pfill); pstk = NULL; pfill = NULL; pstk_cap = 0;
  PUSH(K_HALT, IMM_V, IMM_V);

eval:
  { Cell t = R_ctl;
    n_eval++;
    while (TAG(t) == T_APP) { Node *p = PTR(t); PUSH(K_ARG, p->b, IMM_V); t = p->a; }
    R_ctl = IMM_V; R_val = t;
    if (sp > smax) smax = sp;
  }

  /* Threaded dispatch: every case ends with its own indirect jump, which gives
     the branch predictor one entry per combinator instead of one for the lot.
     kt selects on the top continuation frame, jt on the operator being applied. */
  { static void *const kt[] = { &&M_HALT, &&M_ARG, &&M_APL, &&M_APR, &&M_SND };
    static void *const jt[] = { &&L_ERR, &&L_K1, &&L_S1, &&L_S2, &&L_B, &&L_C,
      &&L_BC, &&L_SI, &&L_CI, &&L_IK, &&L_WI, &&L_PROM, &&L_CONT, &&L_ERR, &&L_ERR,
      &&L_aK, &&L_aS, &&L_aI, &&L_aV, &&L_aD, &&L_aC, &&L_aE, &&L_aR, &&L_aDOT,
      &&L_aQUES, &&L_aBAR, &&L_aAT };
#define RET()   goto *kt[stk[sp - 1].kind]
#define APPLY() do { unsigned t_ = TAG(f); n_apply++; \
                     if (t_ == T_IMM) t_ = 15u + (unsigned)ATOM(f); \
                     goto *jt[t_]; } while (0)
/* Hand a finished value back.  Nine of every ten frames just apply the value to
   something, so those two are peeled off here rather than dispatched through kt. */
#define RETV(vv) do { Cell v_ = (vv); \
    if (stk[sp - 1].kind == K_APL) { f = stk[sp - 1].a; x = v_; sp--; APPLY(); } \
    if (stk[sp - 1].kind == K_APR) { f = v_; x = stk[sp - 1].a; sp--; APPLY(); } \
    R_val = v_; RET(); } while (0)
  RET();

M_HALT: goto done;
M_ARG:  { Frame *fr = &stk[sp - 1];        /* `d t : hand the promise back unevaluated */
          if (R_val == IMM_D) { Cell t = fr->a; sp--; R_val = mk(T_PROM, t, IMM_V); RET(); }
          fr->kind = K_APL; R_ctl = fr->a; fr->a = R_val; goto eval; }
M_APL:  { Frame *fr = &stk[sp - 1]; f = fr->a; x = R_val; sp--; APPLY(); }
M_APR:  { Frame *fr = &stk[sp - 1]; f = R_val; x = fr->a; sp--; APPLY(); }
M_SND:  { Frame *fr = &stk[sp - 1]; f = fr->a; x = fr->b;
          fr->kind = K_APL; fr->a = R_val; APPLY(); }

/* The K_APR peeks below go one better than RETV: the closure that is about to be
   built would be taken apart again immediately, so it never needs a cell at all.
   Two of every five `k and half of every `s go this way. */
L_K1:   RETV(PTR(f)->a);
L_S1:   RETV(mk_s2(PTR(f)->a, x));
L_S2:   { Node *p = PTR(f); PUSH(K_SND, p->b, x); f = p->a; APPLY(); }
L_B:    { Node *p = PTR(f); PUSH(K_APL, p->a, IMM_V); f = p->b; APPLY(); }
L_C:    { Node *p = PTR(f); PUSH(K_APR, p->b, IMM_V); f = p->a; APPLY(); }
L_BC:   { Node *p = PTR(f); f = p->a; x = p->b; APPLY(); }
L_SI:   PUSH(K_APL, x, IMM_V); f = PTR(f)->a; APPLY();
L_CI:   PUSH(K_APR, x, IMM_V); f = PTR(f)->a; APPLY();
L_IK:   { Cell g = PTR(f)->a; f = x; x = g; APPLY(); }
L_WI:   f = x; APPLY();
L_PROM: PUSH(K_APR, x, IMM_V); R_ctl = PTR(f)->a; goto eval;
L_CONT: restore(PTR(f)->a); R_val = x; RET();
L_aI:   RETV(x);
L_aK:   if (stk[sp - 1].kind == K_APR) { sp--; RETV(x); }   /* ``k x g : just x */
        RETV(mk(T_K1, x, IMM_V));
L_aS:   if (stk[sp - 1].kind == K_APR) {  /* ``s x g : build the pair straight away */
          Cell g = stk[sp - 1].a; sp--; RETV(mk_s2(x, g)); }
        RETV(mk(T_S1, x, IMM_V));
L_aV:   RETV(f);
L_aD:   RETV(mk(T_PROM, x, IMM_V));
L_aC:   { Cell k; R_val = x;               /* capture allocates: park x on a root */
          k = capture(); f = R_val; x = k; APPLY(); }
L_aE:   goto done;
L_aR:   OUT('\n'); RETV(x);
L_aDOT: OUT(CHOF(f)); RETV(x);
L_aQUES: { Cell a = curch == (int)CHOF(f) ? IMM_I : IMM_V; f = x; x = a; APPLY(); }
L_aBAR:  { Cell a = curch < 0 ? IMM_V : IMM(A_DOT, curch); f = x; x = a; APPLY(); }
L_aAT:  { int g; Cell a;
          out_flush(); g = getchar();
          if (g == EOF) a = IMM_V; else { curch = g; a = IMM_I; }
          f = x; x = a; APPLY(); }
L_ERR:  fprintf(stderr, "unl: applying a non-function\n"); return 3;
  }

done:
  report();
  out_flush();
  return 0;
}

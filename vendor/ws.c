/* A Whitespace interpreter for qc.ws.
 * Language reference: https://esolangs.org/wiki/Whitespace
 *
 * Semantics: arbitrary-precision numbers (GMP), floor division and modulo,
 * heap cells default to 0, readc stores EOF as -1.
 *
 * The program is parsed once into an instruction array: number literals
 * become prebuilt mpz constants, labels resolve to instruction indices, and
 * call/ret use a direct return stack, so the hot loop is a bare switch.
 *
 * Usage: cc -O2 -o ws ws.c -lgmp && ./ws prog.ws
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gmp.h>

enum { PUSH, COPY, SLIDE, DUP, SWAP, POP, ADD, SUB, MUL, DIV, MOD,
       SET, GET, OUTC, OUTN, READC, READN, CALL, JUMP, JZ, JN, RET, END, MARK };

typedef struct { int op; long n; mpz_t v; } Insn;
static Insn *I;
static long ni, icap;

typedef struct { unsigned long long key; long pc, seq; } Label;
static Label *L;
static long nl, lcap;

static unsigned char *sym;              /* the source as 0 (space) / 1 (tab) / 2 (lf) */
static long nsym, cur;

static void die(const char *m) { fprintf(stderr, "ws: %s\n", m); exit(1); }

static int next(void) { return cur < nsym ? sym[cur++] : -1; }

static Insn *emit(int op) {
    if (ni == icap) I = realloc(I, (icap = icap ? icap * 2 : 1 << 12) * sizeof(Insn));
    I[ni] = (Insn){ .op = op };
    return &I[ni++];
}

/* a number literal: a sign symbol, then binary digits, terminated by lf */
static void number(mpz_t v) {
    static char buf[1 << 20];
    long i = 0;
    int c, sign = next();
    if (sign != 0 && sign != 1) die("bad number");
    while ((c = next()) == 0 || c == 1) {
        if (i >= (long)sizeof(buf) - 1) die("number too long");
        buf[i++] = '0' + c;
    }
    if (c != 2) die("unterminated number");
    buf[i] = 0;
    mpz_set_str(v, i ? buf : "0", 2);
    if (sign) mpz_neg(v, v);
}

/* a label: binary digits terminated by lf, packed into 1 word under a sentinel bit */
static unsigned long long label(void) {
    unsigned long long k = 1;
    int c;
    while ((c = next()) == 0 || c == 1) {
        if (k >> 62) die("label too long");
        k = k << 1 | c;
    }
    if (c != 2) die("unterminated label");
    return k;
}

static long small(void) {
    mpz_t v;
    mpz_init(v);
    number(v);
    long n = mpz_get_si(v);
    mpz_clear(v);
    return n;
}

/* the instruction table: symbols spelled as 0 (space) / 1 (tab) / 2 (lf); arg
   says what follows: N = bignum literal, n = small number, L = label, - = nothing */
static const struct { const char *pat; char arg; int op; } TAB[] = {
    {"00",   'N', PUSH},  {"010",  'n', COPY},  {"012",  'n', SLIDE},
    {"020",  '-', DUP},   {"021",  '-', SWAP},  {"022",  '-', POP},
    {"1000", '-', ADD},   {"1001", '-', SUB},   {"1002", '-', MUL},
    {"1010", '-', DIV},   {"1011", '-', MOD},   {"110",  '-', SET},
    {"111",  '-', GET},   {"1200", '-', OUTC},  {"1201", '-', OUTN},
    {"1210", '-', READC}, {"1211", '-', READN}, {"200",  'L', MARK},
    {"201",  'L', CALL},  {"202",  'L', JUMP},  {"210",  'L', JZ},
    {"211",  'L', JN},    {"212",  '-', RET},   {"222",  '-', END},
};
#define NTAB (sizeof(TAB) / sizeof(*TAB))

/* the encoding is a prefix code, so accumulate symbols until an entry matches */
static void parse(void) {
    char tok[8];
    int tn = 0, c;
    while ((c = next()) >= 0) {
        tok[tn++] = '0' + c;
        tok[tn] = 0;
        size_t k = 0;
        while (k < NTAB && strcmp(tok, TAB[k].pat)) k++;
        if (k == NTAB) {
            if (tn >= 4) die("bad instruction");
            continue;
        }
        switch (TAB[k].arg) {
        case 'N': { Insn *x = emit(PUSH); mpz_init(x->v); number(x->v); } break;
        case 'n': emit(TAB[k].op)->n = small(); break;
        case 'L': if (TAB[k].op != MARK) { emit(TAB[k].op)->n = (long)label(); break; }
                  if (nl == lcap) L = realloc(L, (lcap = lcap ? lcap * 2 : 1 << 10) * sizeof(Label));
                  L[nl] = (Label){ label(), ni, nl };   /* marks emit nothing */
                  nl++;
                  break;
        default:  emit(TAB[k].op); break;
        }
        tn = 0;
    }
    if (tn) die("truncated instruction");
}

static int labelcmp(const void *x, const void *y) {
    const Label *a = x, *b = y;
    if (a->key != b->key) return a->key < b->key ? -1 : 1;
    return a->seq < b->seq ? -1 : 1;                     /* a later mark wins */
}

/* rewrite the flow instructions' label keys into instruction indices */
static void patch(void) {
    qsort(L, nl, sizeof(Label), labelcmp);
    for (long i = 0; i < ni; i++) {
        if (I[i].op != CALL && I[i].op != JUMP && I[i].op != JZ && I[i].op != JN) continue;
        unsigned long long key = (unsigned long long)I[i].n;
        long lo = 0, hi = nl;
        while (lo < hi) {                                /* first index with key > target */
            long mid = (lo + hi) / 2;
            if (L[mid].key <= key) lo = mid + 1; else hi = mid;
        }
        if (lo == 0 || L[lo - 1].key != key) die("undefined label");
        I[i].n = L[lo - 1].pc;
    }
}

static mpz_t *st; static long sp, scap;
static mpz_t *hp; static long hcap;
static long *cs; static long csp, ccap;

static void need(long n) {
    if (sp + n <= scap) return;
    long o = scap;
    while (sp + n > scap) scap *= 2;
    st = realloc(st, scap * sizeof(mpz_t));
    for (long i = o; i < scap; i++) mpz_init(st[i]);
}

static long hgrow(const mpz_t a) {
    long i = mpz_get_si(a);
    if (i < hcap) return i;
    long o = hcap;
    while (i >= hcap) hcap *= 2;
    hp = realloc(hp, hcap * sizeof(mpz_t));
    for (long k = o; k < hcap; k++) mpz_init(hp[k]);
    return i;
}

static void readnum(mpz_t r) {
    char b[4096]; int i = 0, c;
    while ((c = getchar()) != EOF && (c == ' ' || c == '\t' || c == '\n')) ;
    for (; c != EOF && c >= '0' && c <= '9'; c = getchar()) b[i++] = c;
    b[i] = 0;
    mpz_set_str(r, b, 10);
}

static void run(void) {
    long a;
    scap = 1 << 16; st = malloc(scap * sizeof(mpz_t)); for (a = 0; a < scap; a++) mpz_init(st[a]);
    hcap = 1 << 16; hp = malloc(hcap * sizeof(mpz_t)); for (a = 0; a < hcap; a++) mpz_init(hp[a]);
    ccap = 1 << 12; cs = malloc(ccap * sizeof(long));
    for (long pc = 0; pc < ni; ) {
        Insn *x = &I[pc++];
        switch (x->op) {
        case PUSH:  need(1); mpz_set(st[sp++], x->v); break;
        case COPY:  need(1); mpz_set(st[sp], st[sp - 1 - x->n]); sp++; break;
        case SLIDE: mpz_swap(st[sp - 1], st[sp - 1 - x->n]); sp -= x->n; break;
        case DUP:   need(1); mpz_set(st[sp], st[sp - 1]); sp++; break;
        case SWAP:  mpz_swap(st[sp - 1], st[sp - 2]); break;
        case POP:   sp--; break;
        case ADD:   mpz_add(st[sp - 2], st[sp - 2], st[sp - 1]); sp--; break;
        case SUB:   mpz_sub(st[sp - 2], st[sp - 2], st[sp - 1]); sp--; break;
        case MUL:   mpz_mul(st[sp - 2], st[sp - 2], st[sp - 1]); sp--; break;
        case DIV:   mpz_fdiv_q(st[sp - 2], st[sp - 2], st[sp - 1]); sp--; break;
        case MOD:   mpz_fdiv_r(st[sp - 2], st[sp - 2], st[sp - 1]); sp--; break;
        case SET:   a = hgrow(st[sp - 2]); mpz_set(hp[a], st[sp - 1]); sp -= 2; break;
        case GET:   a = hgrow(st[sp - 1]); mpz_set(st[sp - 1], hp[a]); break;
        case OUTC:  sp--; putchar((int)mpz_get_ui(st[sp])); break;
        case OUTN:  sp--; mpz_out_str(stdout, 10, st[sp]); break;
        case READC: sp--; a = hgrow(st[sp]); mpz_set_si(hp[a], getchar()); break;
        case READN: sp--; a = hgrow(st[sp]); readnum(hp[a]); break;
        case CALL:  if (csp == ccap) cs = realloc(cs, (ccap *= 2) * sizeof(long));
                    cs[csp++] = pc; pc = x->n; break;
        case JUMP:  pc = x->n; break;
        case JZ:    sp--; if (mpz_sgn(st[sp]) == 0) pc = x->n; break;
        case JN:    sp--; if (mpz_sgn(st[sp]) < 0) pc = x->n; break;
        case RET:   pc = cs[--csp]; break;
        case END:   return;
        }
    }
}

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: %s prog.ws\n", argv[0]); return 1; }
    FILE *f = fopen(argv[1], "rb");
    if (!f) { perror(argv[1]); return 1; }
    fseek(f, 0, SEEK_END);
    long n = ftell(f);
    fseek(f, 0, SEEK_SET);
    unsigned char *p = malloc(n);
    n = fread(p, 1, n, f);
    fclose(f);

    sym = malloc(n);
    for (long i = 0; i < n; i++) {
        if      (p[i] == ' ')  sym[nsym++] = 0;
        else if (p[i] == '\t') sym[nsym++] = 1;
        else if (p[i] == '\n') sym[nsym++] = 2;
    }
    free(p);

    parse();
    patch();
    run();
    return 0;
}

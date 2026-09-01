/* A reference Piet interpreter for qc.piet.gif (npiet-compatible semantics).
 * Language reference: https://www.dangermouse.net/esoteric/piet.html
 *
 * Notes, chosen for qc.piet.gif:
 *  - in(char) at EOF pushes -1 (keeps the stack depth statically known).
 *  - deep rolls are lazy (see "stack" below) and whole-stack rolls are O(1);
 *    semantics unchanged.
 *  - block transitions are memoized per (block, dp, cc); semantics unchanged.
 *  - reads GIF via giflib (the library npiet uses); a single-image GIF only
 *    (animations are rejected, unlike npiet which silently takes the first).
 *
 * Build: cc -O2 -o piet piet.c -lgif
 * (-DPIETSTAT adds roll/flatten counters on stderr at exit)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gif_lib.h>

static int W, H;
static unsigned char *grid;   /* piet color per pixel: 0..17 hue*3+light, 18 white, 19 black */
static unsigned char pal[256][3];

static int pcolor(int idx) {
    static const int hue[6][3] = {{1,0,0},{1,1,0},{0,1,0},{0,1,1},{0,0,1},{1,0,1}};
    static const int val[3][2] = {{192,255},{0,255},{0,192}};   /* light/normal/dark x lo/hi */
    int r = pal[idx][0], g = pal[idx][1], b = pal[idx][2];
    if (r == 255 && g == 255 && b == 255) return 18;
    if (r == 0 && g == 0 && b == 0) return 19;
    for (int h = 0; h < 6; h++)
        for (int l = 0; l < 3; l++)
            if (r == val[l][hue[h][0]] && g == val[l][hue[h][1]] && b == val[l][hue[h][2]])
                return h * 3 + l;
    return 18;
}

static void read_gif(const char *path) {
    int err = 0;
    GifFileType *g = DGifOpenFileName(path, &err);
    if (!g) { fprintf(stderr, "%s: %s\n", path, GifErrorString(err)); exit(1); }
    if (DGifSlurp(g) != GIF_OK || g->ImageCount < 1) {
        fprintf(stderr, "%s: %s\n", path, GifErrorString(g->Error));
        exit(1);
    }
    if (g->ImageCount != 1) {
        fprintf(stderr, "%s: %d images; a Piet program is a single-image GIF\n", path, g->ImageCount);
        exit(1);
    }
    GifImageDesc *d = &g->SavedImages[0].ImageDesc;
    unsigned char *px = g->SavedImages[0].RasterBits;
    ColorMapObject *cm = d->ColorMap ? d->ColorMap : g->SColorMap;
    if (!cm) { fprintf(stderr, "%s: no color map\n", path); exit(1); }
    memset(pal, 255, sizeof(pal));    /* indexes beyond the color map read as white */
    for (int i = 0; i < cm->ColorCount && i < 256; i++) {
        pal[i][0] = cm->Colors[i].Red;
        pal[i][1] = cm->Colors[i].Green;
        pal[i][2] = cm->Colors[i].Blue;
    }
    W = g->SWidth; H = g->SHeight;
    grid = malloc((long)W * H);
    memset(grid, 18, (long)W * H);    /* the screen outside the first frame is white */
    /* blit the first frame at its offset (DGifSlurp already de-interlaces) */
    for (int y = 0; y < d->Height; y++)
        for (int x = 0; x < d->Width; x++)
            if (d->Top + y < H && d->Left + x < W)
                grid[(long)(d->Top + y) * W + d->Left + x] = pcolor(px[(long)y * d->Width + x]);
    DGifCloseFile(g, &err);
}

/* ---- stack: ring buffer base + lazy roll layers ------------------------
 *
 * qc.piet.gif keeps the whole program image on the stack and reaches a variable
 * by rolling it up to the top, using it, and rolling it back down.  Doing
 * that with memmove costs O(depth) twice per access (~13e9 element moves for
 * one run), so a deep roll instead just *records* an index remapping:
 *
 *   layer: view[0, up+down] = lower[down, up] ++ lower[0, down]   (top-index)
 *
 * push/pop are answered by the layer itself (values[] / popped), and the
 * common "fetch, modify, store back" pair collapses: a roll that is exactly
 * the inverse of the top layer pops that layer and writes the values that
 * were pushed onto it straight into the layer below (see roll()).  Layers
 * that survive are baked back into the flat ring buffer by flatten().
 */
static long *st;
static long sbase, ssize;             /* base ring buffer, bottom-indexed */
static const long scap = 1 << 22;
#define SCMASK ((1L << 22) - 1)
#define BASE(i) st[(sbase + (i)) & SCMASK]                 /* bottom-index */
#define BTOP(i) st[(sbase + ssize - 1 - (i)) & SCMASK]        /* top-index */

#define LMAX   24     /* max stacked layers before baking back down */
#define VCAP   64     /* pushes a layer can hold before baking back down */
#define SMALLD 64     /* rolls this shallow are cheaper done directly */

typedef struct {
    long up, down;      /* the rotation this layer applies to `lower` */
    long pushed;        /* values[] held by this layer (values[0] = oldest) */
    long popped;        /* elements popped off `lower` through this layer */
    long vsize;         /* size of this layer's view */
    long values[VCAP];
} Layer;
static Layer lay[LMAX];
static int nlay;

#ifdef PIETSTAT
static long ST_cancel, ST_flat, ST_flatcost, ST_small, ST_deep, ST_whole;
#define STAT(x) (x)++
#else
#define STAT(x) ((void)0)
#endif

static long vsz(void) { return nlay ? lay[nlay - 1].vsize : ssize; }

/* locate the slot of a top-index, walking the layer chain */
static long *sslot(long i) {
    for (int l = nlay; l > 0; l--) {
        Layer *L = &lay[l - 1];
        if (i < L->pushed) return &L->values[L->pushed - 1 - i];
        long j = i - L->pushed + L->popped;
        if (j < L->up) j += L->down;
        else if (j < L->up + L->down) j -= L->up;
        i = j;
    }
    return &BTOP(i);
}
#define sget(i)    (*sslot(i))
#define sset(i, v) (*sslot(i) = (v))

/* bake every layer back into the ring buffer, bottom-up */
static long *ftmp, ftmpcap;
static void flatten(void) {
    for (int l = 0; l < nlay; l++) {
        Layer *L = &lay[l];
        long d = L->up + L->down;
        if (d > ftmpcap) { ftmpcap = d + 1024; ftmp = realloc(ftmp, sizeof(long) * ftmpcap); }
        for (long i = 0; i < d; i++) ftmp[i] = BTOP(i);
        for (long i = 0; i < L->up; i++) BTOP(i) = ftmp[i + L->down];
        for (long i = L->up; i < d; i++) BTOP(i) = ftmp[i - L->up];
        ssize -= L->popped;
        for (long t = 0; t < L->pushed; t++) BASE(ssize++) = L->values[t];
#ifdef PIETSTAT
        ST_flatcost += d;
#endif
    }
    STAT(ST_flat);
    nlay = 0;
}

static void push(long v) {
    if (nlay) {
        Layer *L = &lay[nlay - 1];
        if (L->pushed < VCAP) { L->values[L->pushed++] = v; L->vsize++; return; }
        flatten();
    }
    BASE(ssize) = v; ssize++;
}
static long pop(void) {
    if (nlay) {
        Layer *L = &lay[nlay - 1];
        if (L->pushed) { L->vsize--; return L->values[--L->pushed]; }
        long v = sget(0);
        L->popped++; L->vsize--;
        return v;
    }
    return BASE(--ssize);
}

static void roll(long depth, long k) {
    long n = vsz();
    if (depth <= 0 || depth > n) return;
    k %= depth; if (k < 0) k += depth;
    if (k == 0) return;
    long down = k, up = depth - k;

    if (nlay == 0) {
        if (depth == ssize) {
            /* whole-stack roll: physically move only min(k, size-k) elements */
            STAT(ST_whole);
            if (k <= ssize - k) {
                for (long i = 0; i < k; i++)
                    st[(sbase - k + i) & SCMASK] = st[(sbase + ssize - k + i) & SCMASK];
                sbase = (sbase - k) & SCMASK;
            } else {
                long m = ssize - k;
                for (long i = 0; i < m; i++)
                    st[(sbase + ssize + i) & SCMASK] = st[(sbase + i) & SCMASK];
                sbase = (sbase + m) & SCMASK;
            }
            return;
        }
        if (depth <= SMALLD) {
            long tmp[SMALLD];
            long off = ssize - depth;
            STAT(ST_small);
            for (long i = 0; i < depth; i++) tmp[i] = BASE(off + i);
            for (long i = 0; i < depth; i++) BASE(off + (i + k) % depth) = tmp[i];
            return;
        }
    } else {
        Layer *L = &lay[nlay - 1];
        /* Does this roll undo the top layer?  If the layer's own pushes and
         * pops cancel out (pushed == popped) and its pushes all sit inside
         * the region it lifted up (pushed <= L->up), the pair reduces to
         * overwriting `pushed` slots of the layer below at top-indices
         * [L->down, L->down + pushed). */
        if (L->up == down && L->down == up && L->pushed == L->popped && L->pushed <= L->up) {
            long p = L->pushed, at = L->down, tmp[VCAP];
            STAT(ST_cancel);
            for (long t = 0; t < p; t++) tmp[t] = L->values[p - 1 - t];
            nlay--;
            for (long t = 0; t < p; t++) sset(at + t, tmp[t]);
            return;
        }
        if (depth <= SMALLD) {
            long tmp[SMALLD];
            STAT(ST_small);
            for (long i = 0; i < depth; i++) tmp[i] = sget(i);
            for (long i = 0; i < up; i++) sset(i, tmp[i + down]);
            for (long i = up; i < depth; i++) sset(i, tmp[i - up]);
            return;
        }
    }
    STAT(ST_deep);
    if (nlay == LMAX) flatten();
    Layer *L = &lay[nlay++];
    L->up = up; L->down = down; L->pushed = 0; L->popped = 0; L->vsize = n;
}

#ifdef PIETSTAT
static void statdump(void) {
    fflush(stdout);
    fprintf(stderr, "[piet] roll: whole=%ld small=%ld deep(layer)=%ld cancel=%ld\n",
            ST_whole, ST_small, ST_deep, ST_cancel);
    fprintf(stderr, "[piet] flatten: %ld times, %ld elements moved\n", ST_flat, ST_flatcost);
}
#endif

/* ---- blocks ---- */
static int *bid, nb;
static long *bsz;
static int *bex;   /* per block: 8 exit codels (dp*2+cc), packed x*H'?? -> x*65536+y; -1 = unset */
static const int DX[] = {1, 0, -1, 0}, DY[] = {0, 1, 0, -1};

/* memoized step out of a block: one entry per (block, dp, cc) */
typedef struct {
    unsigned short nx, ny;
    unsigned char dp, cc, op, kind;   /* kind: 0 unset, 1 block, 2 white, 3 halt */
    int tb;                           /* block landed on (kind 1) */
    int sz;                           /* size of the block stepped out of */
} Step;
static Step *mstep;

static void flood(void) {
    long N = (long)W * H;
    bid = malloc(sizeof(int) * N);
    memset(bid, -1, sizeof(int) * N);
    int *q = malloc(sizeof(int) * N);
    /* One entry per color block.  qc.piet.gif has far fewer blocks than pixels, but a
     * 1-codel-per-block image (any noise bitmap) reaches nb == N, so sizing this
     * at N/2 overflows the heap on exactly the images a differential fuzzer feeds
     * it -- the reference implementation must not be the one that falls over. */
    long *sz = malloc(sizeof(long) * (N + 16));
    for (long s = 0; s < N; s++) {
        if (bid[s] >= 0 || grid[s] >= 18) { if (grid[s] >= 18) bid[s] = -2; continue; }
        int c = grid[s];
        long qn = 0, cnt = 0;
        q[qn++] = s; bid[s] = nb;
        while (qn) {
            long p = q[--qn]; cnt++;
            int x = p % W, y = p / W;
            for (int d = 0; d < 4; d++) {
                int nx = x + DX[d], ny = y + DY[d];
                if (nx < 0 || ny < 0 || nx >= W || ny >= H) continue;
                long p2 = (long)ny * W + nx;
                if (bid[p2] == -1 && grid[p2] == c) { bid[p2] = nb; q[qn++] = p2; }
            }
        }
        sz[nb++] = cnt;
    }
    bsz = realloc(sz, sizeof(long) * nb);
    /* precompute exit codels: for each pixel update its block's 8 slots */
    bex = malloc(sizeof(int) * nb * 8);
    memset(bex, -1, sizeof(int) * nb * 8);
    long *key = malloc(sizeof(long) * nb * 8);   /* only read after bex[slot] is set */
    for (int y = 0; y < H; y++)
        for (int x = 0; x < W; x++) {
            int b = bid[(long)y * W + x];
            if (b < 0) continue;
            for (int dp = 0; dp < 4; dp++)
                for (int cc = 0; cc < 2; cc++) {
                    int cd = (dp + (cc ? 1 : 3)) % 4;
                    long k = ((long)(x * DX[dp] + y * DY[dp]) << 24) + (x * DX[cd] + y * DY[cd]);
                    long slot = (long)b * 8 + dp * 2 + cc;
                    if (bex[slot] < 0 || k > key[slot]) { key[slot] = k; bex[slot] = x << 16 | y; }
                }
        }
    free(key);
    free(q);
}

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: %s prog.gif\n", argv[0]); return 1; }
#ifdef PIETSTAT
    atexit(statdump);
#endif
    read_gif(argv[1]);
    flood();
    st = malloc(sizeof(long) * scap);
    mstep = calloc((long)nb * 8, sizeof(Step));
    unsigned *wseen = calloc((long)W * H * 8, sizeof(unsigned));
    unsigned wgen = 0;
    int x = 0, y = 0, dp = 0, cc = 0;
    if (grid[0] == 19) { fprintf(stderr, "black start\n"); return 1; }
    for (;;) {
        if (grid[(long)y * W + x] == 18) {           /* white: slide */
            int tries = 0;
            wgen++;
            while (tries < 8) {
                long vi = ((long)y * W + x) * 8 + dp * 2 + cc;
                if (wseen[vi] == wgen) { fflush(stdout); return 0; }  /* retrace */
                wseen[vi] = wgen;
                int nx = x + DX[dp], ny = y + DY[dp];
                if (nx < 0 || ny < 0 || nx >= W || ny >= H || grid[(long)ny * W + nx] == 19) {
                    cc = !cc; dp = (dp + 1) % 4; tries++;
                } else {
                    x = nx; y = ny;
                    if (grid[(long)ny * W + nx] != 18) break;
                    tries = 0;
                }
            }
            if (tries >= 8) { fflush(stdout); return 0; }
            continue;
        }
        int b = bid[(long)y * W + x];
        /* Stepping out of block b with (dp, cc) always lands on the same
         * codel and runs the same command, so memoize the whole transition
         * -- including the block landed on, which keeps the hot loop from
         * touching grid[]/bid[]/bsz[] at all. */
        for (;;) {
            Step *m = &mstep[(long)b * 8 + dp * 2 + cc];
            if (!m->kind) {
                int c = grid[(long)y * W + x], sdp = dp, scc = cc;
                m->kind = 3;                                /* trapped: halt */
                m->sz = (int)bsz[b];
                for (int att = 0; att < 8; att++) {
                    int e = bex[(long)b * 8 + sdp * 2 + scc];
                    int ex = e >> 16, ey = e & 0xFFFF;
                    int nx = ex + DX[sdp], ny = ey + DY[sdp];
                    if (nx < 0 || ny < 0 || nx >= W || ny >= H || grid[(long)ny * W + nx] == 19) {
                        if (att % 2 == 0) scc = !scc; else sdp = (sdp + 1) % 4;
                        continue;
                    }
                    int nc = grid[(long)ny * W + nx];
                    int dh = (nc / 3 - c / 3 + 6) % 6;
                    int dl = (nc % 3 - c % 3 + 3) % 3;
                    m->nx = nx; m->ny = ny; m->dp = sdp; m->cc = scc;
                    if (nc == 18) { m->kind = 2; m->op = 0; }   /* into white */
                    else { m->kind = 1; m->op = dh * 3 + dl; m->tb = bid[(long)ny * W + nx]; }
                    break;
                }
            }
            if (m->kind == 3) { fflush(stdout); return 0; }
            x = m->nx; y = m->ny; dp = m->dp; cc = m->cc;
            long v, w2;
            switch (m->op) {
            case 1: push(m->sz); break;
            case 2: if (vsz()) pop(); break;
            case 3: if (vsz() > 1) { v = pop(); push(pop() + v); } break;
            case 4: if (vsz() > 1) { v = pop(); push(pop() - v); } break;
            case 5: if (vsz() > 1) { v = pop(); push(pop() * v); } break;
            case 6: if (vsz() > 1) { v = pop(); w2 = pop();
                     if (v) { long r = w2 / v; if ((w2 % v) && ((w2 % v < 0) != (v < 0))) r--; push(r); }
                     else { push(w2); push(v); } } break;
            case 7: if (vsz() > 1) { v = pop(); w2 = pop();
                     if (v) { long r = w2 % v; if (r && ((r < 0) != (v < 0))) r += v; push(r); }
                     else { push(w2); push(v); } } break;
            case 8: if (vsz()) push(!pop()); break;
            case 9: if (vsz() > 1) { v = pop(); push(pop() > v ? 1 : 0); } break;
            case 10: if (vsz()) { v = pop() % 4; dp = (int)(((dp + v) % 4 + 4) % 4); } break;
            case 11: if (vsz()) { v = pop(); if (v % 2) cc = !cc; } break;
            case 12: if (vsz()) { v = pop(); push(v); push(v); } break;
            case 13: if (vsz() > 1) { long k = pop(); long dpt = pop(); roll(dpt, k); } break;
            case 14: case 15:   /* in(number) reads a raw char too; qc.piet.gif never uses it */
                { int ch = getchar(); push(ch == EOF ? -1 : ch); } break;
            case 16: if (vsz()) printf("%ld", pop()); break;
            case 17: if (vsz()) putchar((int)(pop() & 255)); break;
            }
            if (m->kind != 1) break;                        /* into white */
            b = m->tb;
        }
    }
}

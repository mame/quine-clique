/* A Befunge-93 interpreter for qc.bef.
 * Language reference: https://catseye.tc/view/Befunge-93/doc/Befunge-93.markdown
 *
 * Semantics qc.bef relies on: a playfield as large as the source (the image row
 * is tens of thousands of cells wide, far beyond Befunge-93's 80x25), cells and
 * stack values that hold at least 32-bit integers, unset cells reading as
 * space, and `~` reflecting the IP at EOF (the Funge-98 convention).
 *
 * Build: cc -O2 -o bef bef.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef long long cell;

static cell *grid;              /* row-major playfield, W x H */
static long W, H;
static cell *stack;
static long sp, cap;

static void push(cell v) {
    if (sp == cap) stack = realloc(stack, (cap = cap ? cap * 2 : 1024) * sizeof(cell));
    stack[sp++] = v;
}

static cell pop(void) { return sp ? stack[--sp] : 0; }

/* Make sure (x, y) is inside the playfield, growing it (filled with spaces) if not */
static void reserve(long x, long y) {
    if (x < 0 || y < 0) { fprintf(stderr, "negative coordinate (%ld, %ld)\n", x, y); exit(1); }
    if (x < W && y < H) return;
    long nw = x < W ? W : x + 1, nh = y < H ? H : y + 1;
    cell *g = malloc(nw * nh * sizeof(cell));
    for (long i = 0; i < nw * nh; i++) g[i] = ' ';
    for (long j = 0; j < H; j++) memcpy(g + j * nw, grid + j * W, W * sizeof(cell));
    free(grid);
    grid = g; W = nw; H = nh;
}

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: %s prog.bef\n", argv[0]); return 1; }
    FILE *f = fopen(argv[1], "rb");
    if (!f) { perror(argv[1]); return 1; }
    fseek(f, 0, SEEK_END);
    long n = ftell(f);
    fseek(f, 0, SEEK_SET);
    char *src = malloc(n + 1);
    n = fread(src, 1, n, f);
    fclose(f);

    /* lay the rows out on the playfield: W = the longest row, H = the number of rows */
    W = 0; H = 0;
    long len = 0;
    for (long i = 0; i < n; i++) {
        if (src[i] != '\n') { len++; continue; }
        if (len > W) W = len;
        len = 0; H++;
    }
    if (len > 0) { if (len > W) W = len; H++; }   /* last row without a newline */
    if (W < 1) W = 1;
    if (H < 1) H = 1;
    grid = malloc(W * H * sizeof(cell));
    for (long i = 0; i < W * H; i++) grid[i] = ' ';
    for (long i = 0, x = 0, y = 0; i < n; i++) {
        if (src[i] == '\n') { x = 0; y++; }
        else grid[y * W + x++] = (unsigned char)src[i];
    }
    free(src);

    static char obuf[1 << 16];
    setvbuf(stdout, obuf, _IOFBF, sizeof obuf);
    long x = 0, y = 0, dx = 1, dy = 0;
    int str = 0;
    for (;;) {
        cell c = grid[y * W + x];
        if (str) {
            if (c == '"') str = 0; else push(c);
        } else switch (c) {
        case '0': case '1': case '2': case '3': case '4':
        case '5': case '6': case '7': case '8': case '9': push(c - '0'); break;
        case '+': { cell b = pop(), a = pop(); push(a + b); break; }
        case '-': { cell b = pop(), a = pop(); push(a - b); break; }
        case '*': { cell b = pop(), a = pop(); push(a * b); break; }
        case '/': { cell b = pop(), a = pop(); push(b ? a / b : 0); break; }
        case '%': { cell b = pop(), a = pop(); push(b ? a % b : 0); break; }
        case '!': push(!pop()); break;
        case '`': { cell b = pop(), a = pop(); push(a > b); break; }
        case '>': dx = 1; dy = 0; break;
        case '<': dx = -1; dy = 0; break;
        case '^': dx = 0; dy = -1; break;
        case 'v': dx = 0; dy = 1; break;
        case '?': { int r = rand() & 3; dx = r == 0 ? 1 : r == 1 ? -1 : 0; dy = r == 2 ? 1 : r == 3 ? -1 : 0; break; }
        case '_': dx = pop() ? -1 : 1; dy = 0; break;
        case '|': dy = pop() ? -1 : 1; dx = 0; break;
        case '"': str = 1; break;
        case ':': { cell a = pop(); push(a); push(a); break; }
        case '\\': { cell b = pop(), a = pop(); push(b); push(a); break; }
        case '$': pop(); break;
        case '.': printf("%lld ", pop()); break;
        case ',': putchar((int)pop()); break;
        case '#': x = (x + dx + W) % W; y = (y + dy + H) % H; break;
        case 'g': { long gy = (long)pop(), gx = (long)pop();
                    push(gx >= 0 && gy >= 0 && gx < W && gy < H ? grid[gy * W + gx] : ' '); break; }
        case 'p': { long py = (long)pop(), px = (long)pop(); cell v = pop();
                    reserve(px, py); grid[py * W + px] = v; break; }
        case '&': { long long v; if (scanf("%lld", &v) == 1) push(v); else { dx = -dx; dy = -dy; } break; }
        case '~': { int ch = getchar(); if (ch != EOF) push(ch); else { dx = -dx; dy = -dy; } break; }
        case '@': fflush(stdout); return 0;
        case ' ': break;
        default: dx = -dx; dy = -dy; break;   /* unknown instruction: reflect, as Funge-98 does */
        }
        x = (x + dx + W) % W;
        y = (y + dy + H) % H;
    }
}

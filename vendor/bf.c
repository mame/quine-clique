/* A brainfuck interpreter for qc.bf.
 * Language reference: https://esolangs.org/wiki/Brainfuck
 *
 * Semantics qc.bf relies on: 8-bit wrapping cells, a tape much larger than
 * the default 30000 cells (qc.bf needs ~12 cells per bytecode byte), and any
 * of the common EOF conventions (leave-unchanged / 0 / 255 all work).
 *
 * Optimizations (all semantics-preserving on wrapping cells):
 *  - runs of +-<> collapse into one op with a signed argument
 *  - [-] / [+] become a single clear
 *  - [>>>] / [<<<] become a single strided scan
 *  - balanced multiply loops ([->>+++<<] etc.) become one fused op
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char *op;
static long *arg, *jmp, m;
static long *moff;            /* multiply-loop table: pairs of (offset, coef), -1 terminated per loop */

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: %s prog.bf\n", argv[0]); return 1; }
    FILE *f = fopen(argv[1], "rb");
    if (!f) { perror(argv[1]); return 1; }
    fseek(f, 0, SEEK_END);
    long n = ftell(f);
    fseek(f, 0, SEEK_SET);
    char *p = malloc(n);
    n = fread(p, 1, n, f);
    fclose(f);

    /* pass 1: collapse runs of +-<> into (op, arg); - and < become negative + and > */
    op = malloc(n + 1);
    arg = malloc((n + 1) * sizeof(long));
    m = 0;
    for (long i = 0; i < n; i++) {
        int c = p[i];
        if (!c || !strchr("+-<>[].,", c)) continue;
        int o = (c == '-') ? '+' : (c == '<') ? '>' : c;
        long d = (c == '-' || c == '<') ? -1 : (c == '+' || c == '>') ? 1 : 0;
        if ((o == '+' || o == '>') && m && op[m - 1] == o) { arg[m - 1] += d; continue; }
        op[m] = o; arg[m] = d; m++;
    }

    /* pass 2: rewrite loop idioms.  Z = clear, S = strided scan, M = multiply loop */
    moff = malloc((m + 2) * 2 * sizeof(long));
    long mn = 0;
    long w = 0;
    for (long i = 0; i < m; i++) {
        if (op[i] == '[' && i + 2 < m && op[i + 2] == ']') {
            if (op[i + 1] == '+' && (arg[i + 1] & 1)) { op[w] = 'Z'; arg[w++] = 0; i += 2; continue; }
            if (op[i + 1] == '>') { op[w] = 'S'; arg[w++] = arg[i + 1]; i += 2; continue; }
        }
        if (op[i] == '[') {                       /* multiply loop: only +/> inside, net move 0, t[0] -= 1 */
            long j = i + 1, mv = 0, d0 = 0, ok = 1;
            while (j < m && op[j] != ']' && op[j] != '[') {
                if (op[j] == '>') mv += arg[j];
                else if (op[j] == '+') { if (mv == 0) d0 += arg[j]; }
                else ok = 0;
                j++;
            }
            if (ok && j < m && op[j] == ']' && mv == 0 && (d0 & 0xFF) == 0xFF) {
                op[w] = 'M';
                arg[w++] = mn;
                mv = 0;
                for (long k = i + 1; k < j; k++) {
                    if (op[k] == '>') mv += arg[k];
                    else if (mv != 0) { moff[mn++] = mv; moff[mn++] = arg[k]; }
                }
                moff[mn++] = 0; moff[mn++] = 0;   /* terminator */
                i = j;
                continue;
            }
        }
        op[w] = op[i]; arg[w] = arg[i]; w++;
    }
    m = w;

    /* pass 3: match the surviving brackets */
    jmp = malloc(m * sizeof(long));
    long *stk = malloc(m * sizeof(long));
    long sp = 0;
    for (long i = 0; i < m; i++) {
        if (op[i] == '[') stk[sp++] = i;
        else if (op[i] == ']') {
            if (!sp) { fprintf(stderr, "unbalanced ]\n"); return 1; }
            long j = stk[--sp];
            jmp[i] = j; jmp[j] = i;
        }
    }
    if (sp) { fprintf(stderr, "unbalanced [\n"); return 1; }

    static unsigned char tape[1 << 24];
    unsigned char *t = tape;
    for (long i = 0; i < m; i++) {
        switch (op[i]) {
        case '+': *t += arg[i]; break;
        case '>': t += arg[i]; break;
        case 'Z': *t = 0; break;
        case 'S': while (*t) t += arg[i]; break;
        case 'M': if (*t) {
                      for (long k = arg[i]; moff[k]; k += 2) t[moff[k]] += moff[k + 1] * *t;
                      *t = 0;
                  }
                  break;
        case '.': putchar(*t); break;
        case ',': { int c = getchar(); if (c != EOF) *t = c; break; }
        case '[': if (!*t) i = jmp[i]; break;
        case ']': if (*t) i = jmp[i]; break;
        }
    }
    return 0;
}

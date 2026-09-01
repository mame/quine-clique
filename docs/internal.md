# How to implement Quine Clique

This document explains the design and implementation of Quine Clique in detail.

## 1. The big picture

Every member `qc.*` consists of the same two building blocks: "a program written in QCLang" and "a hand-written interpreter of QCLang".

```ruby
# qc.rb
core = "a program written in QCLang"
run_qclang(core)  # the hand-written part (different for each language)
```

```c
// qc.c
char *core = "a program written in QCLang";
int main() { run_qclang(core); }  // the hand-written part (different for each language)
```

QCLang is a mini language created for Quine Clique, and the `core` is a program written in QCLang that "inputs a language name X and outputs `qc.X`".
The `core` is identical across all 51 members.

So Quine Clique is made of two things.

- 51 QCLang interpreters (hand-written in each language)
- 1 QCLang program `core` (holding the sources of all 51 interpreters inside itself)

## 2. The QCLang specification

QCLang is a minimal language designed so that an interpreter can be written even in brainfuck or Piet.

Its model is a register machine with just one accumulator `acc` and eight registers `reg[0..7]`.

### Character set

A program may use 92 characters: the printable ASCII characters 32..126 minus the following 3.

* `"` double quote
* `'` single quote
* `\` backslash

This is the set of characters that can be embedded without escaping into the string literals of most languages.

### Instructions

An instruction is a 1-byte opcode. The character code `c` determines the effect.

| `c` | instruction | effect | pseudocode |
|---|---|---|---|
| 33 | `!.../` | print a string literal (closed by 47 `/`) | `print("...")` |
| 38 | `&` | read one character of the source | `acc := image[p]; p += 1` |
| 40, 41 | `(...)` | loop while `acc` is nonzero | `while (acc) { ... }` |
| 42 | `*` | output the character whose code is `acc` | `putc(acc)` |
| 48..55 | `0`..`7` | store `acc` into a register | `reg[c mod 8] := acc` |
| 56..63 | `8`..`?` | load a register into `acc` | `acc := reg[c mod 8]` |
| 64..71 | `@`..`G` | subtract a register from `acc` | `acc := acc - reg[c mod 8]` |
| 72..126 | `H`..`~` | assign an immediate to `acc` | `acc := c` |

Immediates only cover 72..126, so small values are built by subtraction.
For example, 1 is the 4 bytes `H7IG`: "`acc := 72`, `reg[7] := acc`, `acc := 73`, `acc := acc - reg[7]`".

The range of `acc` and `reg[0..7]` is -255..255; exceeding it is undefined behavior. Outputting a negative value with `*` is undefined behavior too.

The only ways to observe `acc` are `*` and `(` `)`, so as long as these two stay safe, nothing depends on how an implementation represents `acc`.
On implementations that wrap at 8 bits (as many brainfuck implementations do), -255..-1 and 1..255 collapse to the same representations, but no operation can tell them apart.
Zero tests cannot disagree because the only multiple of 256 in this range is 0 (once you produce -256, a wrapping implementation cannot tell it from 0).

At startup, `reg` is initialized with the bytes of the language name given as input (or the interpreter's own language name if there is no argument).
For `rb`, `reg[0] = 'r' (114)`, `reg[1] = 'b' (98)`, and the rest are 0.

### Escaping in strings

The characters usable inside `!.../` are 90: those usable in QCLang minus `/` and `H`.

`H` is the escape character: `Hx` outputs the character whose code is that of `x` minus 33. To output `/`, write `!HP/`.

`H` was picked from among the characters least used in the QCLang interpreter implementations (to keep the number of escapes down).

The opening and closing marks are distinct symbols so that the mode (inside a string literal vs. inside code) can be switched without consulting the current mode (seeing `!` always switches to string-literal mode, seeing `/` always switches to code mode).

### Reading the source

What `&` reads is not standard input but the string data of the program code itself.
`p` starts at 0 and advances by 1 on each `&`. At the end, 0 is returned.
Executing `&` again after the end has already been reached is undefined behavior.

### Bracket constraints

Reaching a `(` jumps to the matching `)`. At `)`, `acc` is inspected: if nonzero, control returns to just after the `(`; if zero, it proceeds to the next instruction.

No loop instruction may directly follow a `(`. Sequences like `((` or `()` are undefined behavior. `))` and `)(` are fine.

When a parenthesis is used inside a string literal, the parenthesis that textually matches it must also be inside a string literal (a restriction so that matching parentheses can be located from the text alone).
`( !(/ )` is invalid. `( !(/ ( ... ) !)/ )` is OK.

Parentheses nest at most 4 levels deep.

### Reference implementation

```ruby
i = entrypoint                             # execution position
p = 0                                      # read position of &
acc = 0
reg = [0] * 8
stack = []                                 # loop return positions
name.bytes.each_with_index do |b, k|
  reg[k % 8] = b
end

while i < image.size
  c = image[i]
  i += 1
  case
  when c == 33                             # !.../ string literal
    while image[i] != 47
      x = image[i]
      i += 1
      if x == 72                           # H = escape
        x = image[i] - 33
        i += 1
      end
      putc x
    end
    i += 1
  when c == 38                             # & read
    acc = image[p] || 0
    p += 1
  when c == 40                             # ( loop start
    if acc == 0
      d = 1                                # jump past the matching )
      while d > 0
        d += 1 if image[i] == 40
        d -= 1 if image[i] == 41
        i += 1
      end
    else
      stack << i                           # enter the body, remembering where to return
    end
  when c == 41                             # ) loop end
    acc != 0 ? i = stack.last : stack.pop
  when c == 42 then putc acc               # * output
  when c < 56  then reg[c % 8] = acc       # 0..7 store
  when c < 64  then acc = reg[c % 8]       # 8..? load
  when c < 72  then acc -= reg[c % 8]      # @..G subtract
  else              acc = c                # H..~ immediate
  end
end
```

## 3. A quine in QCLang

Thanks to `&`, self-reproduction takes 5 bytes.

```text
&(*&)
```

Read one byte with `&`, and while it is nonzero, repeat "output it and read the next". The whole `image` comes out as is.

Using this, a QCLang program that prints a Ruby quine looks like this:

```text
!core=HH/&(*&)!HH;run_qclang(core)/
```

`HH` is 72 - 33 = 39, i.e. `'`. The output is the following, which is exactly a Ruby program holding the original program in `core`.

```ruby
core='!core=HH/&(*&)!HH;run_qclang(core)/';run_qclang(core)
```

## 4. A multiquine in QCLang

Since `reg` holds the language name, branch on the name and switch the output.

```text
if reg is "rb": !core=HH/ &(*&) !HH;run_qclang_in_ruby(core)/
if reg is "py": !core=HH/ &(*&) !HH;run_qclang_in_python(core)/
...
```

In principle, the `core` is just this block, repeated for every member and concatenated.
The only comparison is subtraction, so it goes one character at a time: compute `acc := character of the name`, `acc := acc - reg[k]`,
and if the result is nonzero, clobber a flag register to 0. The flag survives only when everything matched.

Each language's [template](../src/templates) is prepared with holes in it.

```c
char g[]="<QCImage/>";...

int main(int A,char**v){
  ... // interpret g as QCLang
}
```

A template has two kinds of markers, at different meta levels and hence with different notations.
A marker like `<QCConst>image_len</QCConst>` is merely replaced by text fixed at build time (decimal constants such as
`image_len`, and the newlines that cannot be written because the lines are concatenated raw); on the `core` side it is
still the target language's source as is. `<QCImage/>`, on the other hand, is a hole: in the generated file it is filled
with `image`, while on the `core` side it is replaced by **the QCLang that prints it**.

## 5. Compressing

Built naively, the `core` is a blob of tens of kilobytes.
Since we want `qc.rb`, at least, to be ASCII art, compress it first.

```text
zcore = ppm_compress(core)
```

The compression is a variant of PPM; the context order and the weights were chosen by measuring exhaustively.

The problem is where to put the decompressor: QCLang lacks the expressive power to write PPM decompression,
and hand-writing it for every language would be painful. So the structure is asymmetric: only Ruby has the decompressor.

```text
qc.rb : embeds only zcore, and decompresses it at run time to get core
qc.X  : embeds both zcore and core (X != rb)
```

Everyone but `qc.rb` carries both because every member must be able to print `qc.rb`:
printing the text of `qc.rb` needs `zcore`, and a member needs `core` to run itself.
This duplication makes everyone but `qc.rb` longer; in exchange, a single decompressor suffices.

Note that `zcore` is kept free of spaces and `~`. The reason is in the next section.

## 6. Turning it into ASCII art

`zcore` is shaped into ASCII art inside `qc.rb`. Only spaces and newlines are inserted.

The whole text of `qc.rb` is poured into the stencil (`src/stencil.txt`; `#` is a data cell, space is a hole).

```text
qc.rb = D=' ++ fzcore ++ ' ++ <code that decompresses and runs it>
fzcore = stencil(zcore)  # zcore with spaces and newlines inserted into the shape of the picture
```

`qc.rb` recovers `zcore` by dropping the spaces and newlines, then PPM-decompresses it to get `core`.
The spaces that fell into holes and the newline at each row end vanish with this, so the digit sequence is exactly `zcore` again.

For the other `qc.X` to print `qc.rb`, this `fzcore` would have to be embedded as a string literal.
But many languages cannot put a raw newline in a string literal, so newlines are replaced with `~` (this is why `zcore` is kept free of `~`).

```text
efzcore = fzcore with its space runs run-length compressed and its newlines turned into ~
```

Members other than `qc.rb` embed `efzcore` and `core`. Only the arm that prints `qc.rb` expands the run-length compression;
when printing the other members, `efzcore` is copied verbatim.

## 7. Symbols and transformations

```text
core       = the QCLang program
zcore      = PPM(core)         a sequence over 90 characters (see below)
fzcore     = stencil(zcore)    with spaces and newlines inserted
efzcore    = mark(fzcore)      space runs folded into marks, newlines into ~
image      = efzcore ++ core   the byte sequence the interpreter holds
entrypoint = |efzcore|         the execution start position
```

`&` reads `image` from the start. Execution begins at `entrypoint`.
Seen from the QCLang program, data is placed in front of it, readable with `&`.
To print `qc.py`, output the whole `image`; to print `qc.rb`, output just the first `entrypoint` bytes (turning `~` back into newlines and the marks back into space runs).

The text of each member looks like this.

```ruby
# qc.rb
D='...fzcore...' # ASCII art

# strip the spaces and decompress the PPM to restore core
core = ppm_decompress(D.split.join)

# build image (a run of spaces folds into the 2 bytes "space + (39+length)")
g = D.gsub(/ {1,52}/) { " " + (39 + $&.size).chr }.tr("\n","~") + core

# interpret it as QCLang
run_qclang(g, entrypoint)
```

```python
# qc.py
g = b'...efzcore...core...';
run_qclang(g, entrypoint)
```

`entrypoint` is baked into the templates as a number.

## 8. The fixed point

The content of `core` depends on `entrypoint` and `|core|` (these two are embedded in the templates as immediates).
Meanwhile `entrypoint` is determined by `|zcore|`, and `zcore` is `core` compressed. It is circular.

```text
core       = build_core(entrypoint, core_len)
zcore      = PPM(core)
entrypoint = |mark(stencil(zcore))|
```

Neither `build_core` nor `PPM` is monotonic, so a solution closing the loop with equalities may not exist.
So give up on equalities and close it with inequalities plus padding.

```text
|build_core(entrypoint, core_len)| <= core_len      pad the tail of core to make up the shortfall
|PPM(core)|                        <= zcore_len     pad the tail of zcore to make up the shortfall
entrypoint = efzcore_len_from_zcore_len(zcore_len)  pure geometry arithmetic (fixed before the contents are)
```

`efzcore_len_from_zcore_len` is `|zcore| + number of newlines + bytes of the space-run RLE`. The number of runs is determined by the stencil alone (the band rows have no holes),
and the number of newlines comes from `|fzcore| = fzcore_len_from_zcore_len(zcore_len)`. The geometry of the text of `qc.rb` is governed by `|fzcore|` rather than by `|efzcore|`.

Padding is admissible because both get read and discarded.

- The padding of `core` is 48 (`0` = `reg[0] := acc`).
- The padding of `zcore` is `!`. (The decompressor just consumes one digit per normalization, and stops reading digits once core_len symbols are decoded.)

The solver is naive: put rough initial values into `core_len` and `zcore_len`, iterate a few times to get an estimate, then move by 1 from there looking for a solution satisfying all three conditions above.
The objective is `|zcore|`, so scan from **below** the estimate and take the first hit (neither map is monotonic, so solutions exist below the estimate too).
Only the points where `|image|` is a multiple of 3 are examined (because Piet emits its data part in sets of 3 rows).

## 9. Making the compression bite

PPM predicts by "have I seen this sequence before", so the more alike the interpreters' texts are, the better it compresses. Hence variable names are unified across all languages.

```text
g  image
i  execution position
p  read position of &
c  opcode being executed
a  acc
r  registers
s  stack position
d  parenthesis depth
```

In C the conditional operator would be shorter, but it is deliberately written with `if`-`else` to match the other languages; choices like this are made throughout.

As one more trick, the PPM prediction model is warmed up with the Ruby code part of `qc.rb`.
Before decompressing `zcore`, the Ruby decompressor obtains its own source by quining, warms the prediction model with it, and then restores `core`.

## 10. Implementing the esoteric members

Being lengthy, this moved to a separate document: [esolangs.md](esolangs.md).

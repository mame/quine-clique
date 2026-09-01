# Design and implementation notes on the esolangs

This document describes how brainfuck, Whitespace, Piet, Befunge, and Unlambda are implemented.

## Common design

Each of them consists of two parts: a Driver and a Generator.

* Driver: generates (the main part of) the VM code written in the target language. This is the heart of each member.
* Generator: generates the QCLang code that outputs the source of qc.X. It embeds the Driver's code.

## brainfuck

[brainfuck](https://en.wikipedia.org/wiki/Brainfuck) is a language with only 8 instructions.
The main difficulty is that the tape (memory) has no random access, so the point is to introduce a convention for how the tape is used.

### Overall structure of the program

qc.bf is structured as follows.

```text
qc.bf = Prologue + E(image) + Driver
```

* `Prologue`: a little initialization code
* `E(image)`: code that lays the bytes of image out on the tape
  * One byte is placed every 8 cells. To be precise, each byte of image minus 31 is placed. (a repetition of `"+" * (c - 31) + ">" * 8`)
  * Also, the cell right of the `entrypoint` byte is set to 1.
* `Driver`: the VM part that interprets core

### Convention for using the tape

The following is fixed.

* Cells with index ≡ 0 (mod 8) hold the bytes of image (minus 31).
* Cells with index ≡ 1 (mod 8) hold the entrypoint flag at startup, and the "already read by `&`" flag once execution has started.

Centered on the byte of the instruction currently being executed, the cells at the following offsets hold the following information.

| offset | name |moves| use |
|-----|------|:-:|---|
| -10 | `R6` | ✓ | `reg[6]` |
|  -9 | `R7` | ✓ | `reg[7]` |
|  -8 | -    |   | (the previous byte of image) |
|  -7 | -    |   | (the previous already-read flag) |
|  -6 | `S2` |   | temporary cell |
|  -5 | `R5` | ✓ | `reg[5]` |
|  -4 | `A`  | ✓ | `acc` |
|  -3 | `V`  |   | temporary cell |
|  -2 | `T`  |   | temporary cell |
|  -1 | `L`  | ✓ | lexer state (0 = code, 1 = in literal, 2 = in escape) |
|   0 | `D`  |   | the byte of image (value - 31) |
|   1 | `M`  |   | already-read flag |
|   2 | `S`  |   | temporary cell |
|   3 | `R0` | ✓ | `reg[0]` |
|   4 | `R1` | ✓ | `reg[1]` |
|   5 | `R2` | ✓ | `reg[2]` |
|   6 | `R3` | ✓ | `reg[3]` |
|   7 | `R4` | ✓ | `reg[4]` |
|   8 | -    |   | (the next byte of image) |
|   9 | -    |   | (the next already-read flag) |

The group of cells checked in the "moves" column (called the frame) moves along as execution proceeds and the current position changes.
That is, `R4` at offset 7 moves to offset 15, `R3` at offset 6 moves to offset 14, and so on, copied one by one.
This lets the current state be referenced relative to the instruction currently being executed.

The bytes of image are placed every 8 cells in order to minimize the Driver.
In theory any spacing of 3 cells or more would do, but a narrow spacing costs more `>` and `<` for relative references (reading and writing registers, etc.), which makes the Driver larger.
A spacing that is too wide, on the other hand, costs more `>` and `<` for moving the frame, which again makes the Driver larger.
The width that minimizes the Driver was 8 cells.

### Running the VM

After laying the data of image out on the tape, qc.bf goes back to the position with the entrypoint flag, clears the flag, initializes the cells of the frame, and starts executing.

Each instruction is executed by first branching on the value of `L` (the lexer state), as follows.

* If `L` is 0, the current byte is interpreted as an instruction
  * Basically, execute according to each instruction
  * `(` and `)` move the frame to the matching parenthesis (the nesting is counted in the `L` cell, so `L` moves with the frame too)
  * `&` moves to the leftmost cell whose already-read flag is not set, and comes back to the original position with its `D`.
    * (1) Set `A` = 1
    * (2) Move to the left end of the tape
    * (3) Move right to the position where the already-read flag (`M`) is 0
    * (4) Copy the value of `D` to `S`, set `M` = 1, and go back to the left end of the tape (carrying the value of `S`)
    * (5) Move right to the position where `A` is 1
    * (6) Move the value of `S` to `A`
* If `L` is 1
  * If the current byte is `H`, set `L` = 2
  * If the current byte is `/`, set `L` = 0
  * Otherwise, output the current byte as is and move the frame to the instruction one to the right
* If `L` is 2, output the current byte minus 33 and set `L` back to 1

### Multi-way branch

An idiom for doing something like a multi-way branch (switch statement) in brainfuck.
It is used in many places.

```text
>+<           # T = 1
[-            # V-- > 0
  [-          # V-- > 0
    [-        # V-- > 0
      ...
    ]
    >[- (handling for V = 2) ]<
  ]
  >[- (handling for V = 1) ]<
]
>[- (handling for V = 0) ]<
```

### Requirements on the brainfuck implementation

Any cell width of 8 bits or more works. Every cell is kept within -128..255.
No overflow or underflow is expected, so 8-bit wraparound, 16-bit, and bignum all behave the same.
The values passed to `.` are also kept within 0..255.

`,` is brainfuck's input instruction. Its behavior at EOF varies among implementations ("leave the cell unchanged", "write 0", "write -1"), but qc.bf works with any of them.

The tape must be longer than image * 8 cells.

### Structure of the Generator

Basically, it just straightforwardly generates the QCLang code that outputs the overall structure of the program.

```
qc.bf = Prologue + E(image) + Driver
```

`Prologue` and `Driver` are fixed, so they are output as is with the literal instruction `!.../`.
For `E(image)`, the byte read by `&` minus 31 is the number of `+` output in a loop, followed by `!>>>>>>>>/`.

## Whitespace

[Whitespace](https://en.wikipedia.org/wiki/Whitespace_(programming_language)) is a language whose instructions consist of only 3 characters: space, tab, and newline.
It is a stack machine, and the VM itself is relatively straightforward to write.

The points are that numbers must be written in binary, and that neither tab nor newline can be expressed straightforwardly in QCLang.

### Overall structure of the program

qc.ws is structured as follows.

```text
qc.ws = Prologue + E(image) + Driver
```

* `Prologue`: Whitespace code that just does `push 0` (a sentinel marking the end of image)
* `E(image)`: code that pushes each byte of image onto the stack
  * For each byte `c` of image, `push` the number `2**(c-32)` (described later)
* `Driver`: the VM part that interprets core

### Decoding image

As mentioned above, each byte `c` of image is pushed onto the stack as the number `2**(c-32)`.
At the beginning of `Driver`, each value is popped from the stack and divided by 2 until it becomes 0, and the value of `c` is recovered from the number of iterations.

```
pos = image_len - 1
while (V = pop) != 0  # until the sentinel
  c = 31
  while V != 0
    V /= 2            # divide by 2 until 0
    c += 1            # the number of iterations is the original c
  end
  heap[pos + 10] = c
  pos -= 1            # written in descending order, the reverse of the push order
end
```

The recovered values are placed at heap address 10 and up (heap 0..9 is used for the registers, the execution position, and so on).

The bytes of image are encoded this way because of how Whitespace represents numbers.
A Whitespace number is represented as "1 sign character + big-endian binary (space = 0, tab = 1) + newline".
QCLang cannot easily convert a byte read by `&` into this format, so instead it outputs a power of 2.
That is, to represent `c`, it outputs one tab followed by `c - 32` spaces, which represents the number `2**(c-32)`.

QCLang can output a byte in binary (in fact, Unlambda outputs little-endian binary).
But Whitespace needs it big-endian.
This is not impossible in QCLang either (compute the number with its bits reversed first), but it gets long, so powers of 2 were adopted.

### Implementation of the Driver

After decoding image, it really is just implementing the QCLang VM in Whitespace, and there is nothing special to note.

### Implementation of the Generator

The implemented Driver naturally consists of the 3 characters space, tab, and newline, and there are two ways to output these characters in QCLang code.

* String literal output: output with escapes, as `!H*/` (tab) or `!H+/` (newline) (a space can be output as is with `! /`).
* Register load + character output: keep the values of space, tab, and newline in 3 registers, and output with the register load instruction and the `*` instruction.

The former takes 1 byte for a space and 2 bytes for anything else (not counting the delimiters).
The latter takes 2 bytes for any character (but 1 byte when the same character repeats).
The Generator uses DP to combine these two output methods and outputs the Driver in the shortest QCLang code.

## Piet

[Piet](https://www.dangermouse.net/esoteric/piet.html) is a language that interprets an image as a program: a cursor runs around the image, and changes between adjacent colors are the instructions.

The main difficulty is writing it short.
Piet's branch instructions are expressed as changes of the direction of travel.
Since expressing complex control such as VM interpretation is hard, it is expressed as a loop that executes microcode (a branch is expressed as the number of the next microcode).

### Overall structure of the program

qc.piet.gif is a tall GIF image 96 pixels wide, and as file contents it is structured as follows.

```text
qc.piet.gif = Prologue + E(image) + Driver + Epilogue
```

* `Prologue`: the GIF file header and image descriptor.
* `E(image)`: the image part in which each byte `c` of image is converted into an instruction equivalent to Piet's `push c-31`. It takes up most of the picture. Called the "data part".
* `Driver`: the VM part that executes the bytes of image pushed onto the stack. Called the "code part".
* `Epilogue`: the GIF file trailer.

The number of bytes of `image` directly determines the height of the picture.
Since the size of a GIF is at most 65535 pixels, this is currently the size constraint of Quine Clique as a whole.

### Overall flow

Starting from the top-left pixel, it proceeds down the left edge of the picture through the data part.
The data part is an instruction that pushes one value onto the stack for every row it goes down.
Once it enters the code part at the bottom of the picture, it interprets the bytes of image piled on the stack.

The code part is a collection of 15 microcodes.
The right edge of the code part is the dispatch on the microcode number (called the big dispatch); the selected microcode is executed heading west, and it returns to the dispatch clockwise, repeatedly.

### Variables

Piet has no heap, only a stack (but it is Turing complete since it has an instruction to rotate the stack).

qc.piet.gif places the bytes of `image` and all of the current state on the stack.
From the bottom, the basic layout is `[the bytes of image; the variable area; the temporary area; the number of the microcode to execute next]`.

The variables are the following 17 (in order from the shallowest).

| var | contents |
|------|---|
| d  | lexer state (>0: parens being skipped, 0: normal, -1: in string literal, -2: right after escape in literal) |
| a  | accumulator (QCLang's `acc`) |
| np | data pointer (number of image bytes not yet read) |
| ni | instruction pointer (number of bytes to the end) |
| lp0..lp3| instruction pointers of the loop return targets (up to 4 nesting levels) |
| r0..r7| registers (8 of them) |
| t | up to which register has been initialized (used by `read_name_1`/`2`) |

### List of microcodes

The microcodes are the following 15. After placing the variables on the stack, it starts from `read_name_1`, repeats transitions, and finally reaches `halt` and terminates.

* `nextc`: reads the character at the current position from `image` and branches to one of `halt`/`skip_parens`/`dispatch_mode`.
* `dispatch_mode`: branches to one of `nextc`/`code`/`dispatch_lit`/`outc` depending on the current lexer state and the character.
* `outc`: outputs 1 byte depending on the current lexer state and the character, updates the lexer state, and returns to `nextc`.
* `skip_parens`: updates the lexer state depending on whether the current character is `(` or `)`, and returns to `nextc`.
* `dispatch_lit`: if the current character is `/` or `H`, updates the lexer state and returns to `nextc`. Otherwise proceeds to `outc`.
* `code`: branches to `img_read`/`loop_open`/`loop_close`/`outc`/`reg_lod_sto`/`reg_sub`/`imm` depending on the current character.
* `img_read`: executes the `&` instruction. Puts the data value of `image` into `a` on the stack and returns to `nextc`.
* `loop_open`: executes the `(` instruction. Updates the lexer state depending on whether `a` on the stack is 0 or not, and returns to `nextc`.
* `loop_close`: executes the `)` instruction. If `a` on the stack is nonzero, sets the instruction pointer back to the position of `(`, and returns to `nextc`.
* `imm`: executes an immediate instruction. Puts the immediate into `a` on the stack and returns to `nextc`.
* `reg_lod_sto`: executes a register load/store instruction. Manipulates `a` on the stack and the registers as appropriate, and returns to `nextc`.
* `reg_sub`: executes a register subtract instruction. Manipulates `a` on the stack and the registers as appropriate, and returns to `nextc`.
* `read_name_1`: reads the target language name from stdin. Proceeds to `read_name_2` if it could read, or to `nextc` if it could not.
* `read_name_2`: stores the value read from stdin into a register and returns to `read_name_1`.
* `halt`: end of the program. It has no body; the program runs into the block at the bottom right of the picture and terminates.

Each microcode ends by pushing the number of the microcode to execute next, and returns to the big dispatch.
A branch can therefore be expressed as computing "the number of the microcode to execute next".
The only place that branches with Piet's `pointer` instruction is the big dispatch.

### Implementation of the Generator

Since qc.piet.gif is a GIF byte sequence, much of it cannot be output with the literal output `!.../`.

For the Prologue and the Epilogue, it repeatedly generates each required byte by arithmetic and outputs it.
A shortest-path search is used to find the shortest arithmetic.

The data part and the code part are expressed as the image part of the GIF.
The image part is expressed with the so-called uncompressed GIF technique: each row is one sub-block, and placing an LZW "clear code" at the start of the row lets the following 96 pixels be expressed as 1 byte per pixel.
So in QCLang, one row is output as `[97 (the byte count of the sub-block), 128 (clear code), 96 pixels...]`.

The GIF color palette is set up so that the color numbers Piet needs are 74..91, 124, and 126.
All of these are characters that can be placed as is in a QCLang literal instruction, so one pixel can be expressed in 1 byte.

As the data part, 1 byte of `image` is encoded as 1 GIF row (98 bytes).
The data part cycles through colors of 3 lightness levels with a period of 3 rows.
For this reason, the length of `image` is required to be a multiple of 3.

## Befunge

[Befunge](https://en.wikipedia.org/wiki/Befunge) is a language with a two-dimensional instruction sequence: the IP (Instruction Pointer) walks a two-dimensional text file and executes instructions.
One character is one instruction, and a branch is expressed as a change of the IP's direction.
Since there are instructions that read and write cells with random access, it is relatively easy to implement.

### Overall structure of the program

The (runtime) structure of qc.bef is as follows.

```text
y=0  v  >0v  ++ image ++ sentinel
y=1  > [init1] #v_  > [fetch] [dispatch1]#v_ [dispatch2]#v_           ...
y=2  ^ [init2]  <                         > [code1] v    > [code2] v  ...
y=3                 ^ <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<...
y=4  state cells...
```

`v` / `^` / `>` / `<` are Befunge instructions that change the direction of the IP.
`#` is an instruction that skips the cell right after it in the direction of travel.
`_` is an instruction that turns the IP left or right depending on the value on top of the stack.
Therefore `#v_` is an idiom that goes right if the top of the stack is 0, and otherwise goes down via `v`.

* `[init1]` and `[init2]` are the initialization loop.
* `[fetch]` reads the byte at the current position.
* `[dispatch1]` branches to `[code1]` if its condition holds, and otherwise proceeds to the next `[dispatch2]`.
* Each `[code*]`, when done, goes to row y=3 via `v` and returns to `[fetch]`.

In reality, rows y=3 and y=4 mostly do not exist in qc.bef.
The initialization loop places the `<` characters on row y=3, which forms the loop back to `[fetch]`.

### Representation of the state

In Befunge, both the stack and the cells can be used as state.
qc.bef represents the state as follows.

| what | where |
|---|---|
| `i` (execution position = column number) | top of the stack |
| return target of `(` | the stack (below `i`) |
| `reg[0..7]` | (0..7, `Y_STATE`) |
| `d` (mode) | (`X_D` = 9, `Y_STATE`) |
| `acc` | (`X_A` = 8, `Y_STATE`) |
| `p` (the position `&` reads) | (`X_P` = 10, `Y_STATE`) |

### Implementation of the Generator

Nothing special. It just outputs according to the following definition.

```
qc.bef = "v  >0v" ++ image ++ "\0\n" ++ row1 ++ "\n" ++ row2 ++ "\n" ++ row3 ++ "\nbef\n"
```

## Unlambda

[Unlambda](http://www.madore.org/~david/programs/unlambda/) is a functional programming language based on the SKI combinators.
A program is basically expressed just by combining and applying functions: the 3 combinators `s` `k` `i`, a one-character output function, a one-character input function, an input-character comparison function, and so on.

It is the hardest language in Quine Clique.

### Overall structure of the program

`qc.unl` is structured as follows.

```text
qc.unl = "`" * N ++ Driver ++ eatoms ++ digits
```

`` ` `` is Unlambda's application operator, so the structure is that the terms of eatoms and digits are applied in turn to the expression representing the VM body.

* `Driver`: the Unlambda VM body. It consists mainly of `s` `k` `i` terms.
* `eatoms`: one-character output functions and input-character comparison functions, laid out for 513 values (256..-256).
* `digits`: each byte of `image` expressed in binary with `k` and `i` (details later).

The VM first receives `eatoms` and builds the data structure for "numbers", then receives `digits` and "compiles" the bytes of `image` into functions.

### VM design: values

Pairs and lists use the standard Church encoding, but the "numbers" held by the VM's accumulator and registers use a special representation, in order to associate them with printers and matchers.

Let an Element be a tuple of 4 terms `(printer, matcher, under, sel3)`.

* `printer`: the printer function for the char code of the number
* `matcher`: the matcher function that tests whether an input character equals the char code of the number
* `under`: the Element one less than the number
* `sel3`: a function representing the sign of the number (0 = positive, 1 = zero, 2 = negative)

A number is represented as an "ascending list of Elements".
That is, the number N is the list `[Element N, Element N+1, Element N+2, ..., Element 255]`.

This way, N + 1 is just `tl N`, and N - 1 is `cons(v.hd.under, v)`.

The first thing the VM does at initialization is to receive the `printer` and `matcher` functions contained in `eatoms` and build the lists representing these numbers.

### VM design: digits

The Unlambda VM does not decode each byte of `image` and dispatch on the instruction.
Instead, it looks at the "class" number attached to each byte (because decoding instructions in Unlambda is far too much work and would get long).

`digits` expresses each byte of `image` as a combination of 11 characters `k` and `i`.

The first 4 bits are the "class" number, which represents the meaning of the byte as a QCLang instruction (below).
The following 7 bits are the byte in little-endian binary.

| class | meaning |
|---|---|
| 0 | nop |
| 1 | lit (output the byte as is) |
| 2 | esc (output the byte minus 33) |
| 3 | out (the `*` instruction) |
| 4 | sto (register store instruction) |
| 5 | lod (register load instruction) |
| 6 | sub (register subtract instruction) |
| 7 | imm (immediate instruction) |
| 8 | rd (the `&` instruction) |
| 9 | lp (the `(` instruction) |
| 10 | rp (the `)` instruction) |

`nop` is used for literal output instructions.
For example, the 5-character literal output instruction `!aHx/` is annotated with classes like `nop`/`lit` (output `a`)/`nop`/`esc` (output `x` - 33)/`nop`.
The Unlambda VM does not interpret the literal output instruction itself; it just processes one character at a time by looking at this class number.

Attaching a class number to each byte of `image` is the Generator's job.

### VM design: compilation

The VM receives the data expressed as 11 bits per byte as described above, and "compiles" the QCLang into Unlambda closures.

One instruction is compiled as follows.

* Identify the `make_*` function corresponding to the class number.
* Pass `cont` (the closure of the next instruction), `v` (the value of the current byte), `slot` (the selector for the register number), and `after` (the closure of the instruction after leaving the loop) to that `make_*` function, which converts the instruction into an Unlambda closure.

Doing this for all instructions yields the Unlambda closure corresponding to the first byte of `image`.

Once compilation is complete, the VM executes the QCLang instruction sequence by calling that closure.

### Building the VM

That is all for the design of the VM. The following describes how the Unlambda code that behaves this way is generated.

unl.rb consists of the following 7 modules.

* VM: the QCLang interpreter written in a custom DSL
* Src: turns the DSL into an AST
* Typecheck: simple type check of the DSL
* AST: the AST of the DSL
* IR: the AST converted to an SKI basis
* Driver: compiles the VM written in the custom DSL into SKI text
* Generator: builds the QCLang code that outputs qc.unl

### VM construction: the custom DSL

The QCLang VM is written in an embedded DSL using Ruby syntax.

The DSL is a simple typed functional language.
The following declares the type of a pair.

```
type Pair[:A, :B], { fst: :A, snd: :B }
```

`fst[p]` or `p.fst` extracts the first element from the closure `p` representing a pair.

The following is the definition of a function `sign`, which takes an argument `v` of type `Num` and returns a value of type `Sel3`.

```
let([sign: Sel3], v: Num) { v.hd.entry.fst }
```

This custom DSL does not support currying or partial application (unlike Unlambda).
When they are needed, the function definitions must be split explicitly.
(Since η-reduction is performed in a later optimization, code that merely passes arguments through is basically not generated.)

This custom DSL is converted into the form of an `AST` by the `Src` module.
A simple type check is also performed by the `Typecheck` module.

### VM construction: AST

The AST is represented as nested arrays like the following.

```
AST :=
  ["var", name]              reference to a name (def / parameter / local binding)
| ["raw", spelling]          place an Unlambda spelling directly
| ["app", f, x, ..]          application (n arguments)
| ["fun", [params..], body]  function
| ["let", name, val, body]   local binding
| ["rec", name, fn]          self-recursion (may reference only its own name)
| ["church", n]              Church numeral
| ["value", form]            mark saying "already a value, OK to evaluate early"
```

`"value"` is a marker that controls the later η-reduction.
Blindly η-reducing `fun x -> (fst p) x` gives `(fst p)`, but in call-by-value Unlambda this is not necessarily safe if `(fst p)` has side effects.
However, the projections defined by `type` declarations are known to have no side effects, so this can be η-reduced safely (assuming the `p` part has no side effects).
Therefore, wrapping the application of `fst` in a `"value"` node declares that it is safe to η-reduce.

The AST data structure has its `"let"` and `"rec"` converted into `"fun"` and `"app"`, giving the IR data structure that follows.

### VM construction: IR

The IR is represented as nested arrays like the following.

```
IR :=
  [:raw, text]     atom (a built-in single character)
| [:app, f, x]     application (always binary; n-ary AST apps nest here)
| [:eager, M]      mark saying "M may be treated as a value"
| [:var, n]        variable bound by a lambda (gone after eliminate_var)
| [:lam, v, body]  lambda (one parameter; gone after eliminate_var)
```

In the IR, `"var"` and `"lam"` are first eliminated by bracket abstraction, giving the prototype of the Unlambda code.
After that, peephole optimization and common subexpression elimination are applied repeatedly, attempting to shorten the Unlambda code.
Once a fixed point is reached, it is lowered to the actual Unlambda code string.
This becomes the Unlambda Driver.

### Implementation of the Generator

The Unlambda Generator builds the QCLang code that outputs in the following order, as in the overall structure of the program.

* Output the required number of `` ` `` (just output in a loop)
* Output `Driver` (just output with the literal output instruction)
* Output `eatoms`
* Output `digits`

`eatoms` outputs a sequence of the printer functions and matcher functions (encoded appropriately as expressions) for building the numbers in the range 256 to -256.

For each byte of `image` read by the `&` instruction, `digits` first outputs the 4 bits of the corresponding class.
Then it outputs the byte itself as 7-bit little-endian binary.
These bit strings are expressed as binary numbers of `k` and `i`.

This process requires QCLang to decompose a 1-byte number into binary.
So division and remainder by 2 have to be computed in QCLang.
This is done by the following algorithm.

```
p = 0
h = t
while t != 0
  p = 1 - p  # alternates between 0 and 1
  h -= p     # decrements h once every 2 iterations
  t -= 1
end
# p is the LSB of t, and h is t / 2
```

Repeating this 7 times outputs 1 byte as 7-bit little-endian binary.

## Notes

The qc.X of these 5 languages are all tested with our own interpreters placed in the vendor directory.
So the correctness of qc.bf and the others depends on the correctness of those interpreters.

Ideally we would use reference implementations that are not our own, but because of the size and complexity of qc.X, they crashed or took far too long to run it, so we ended up writing all of them ourselves.

If you notice that an interpreter in the vendor directory does not implement the language specification correctly, please let us know.
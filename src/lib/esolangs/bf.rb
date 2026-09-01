# Generator for qc.bf (the QCLang VM written in brainfuck)
#
# The design is in the brainfuck section of docs/esolangs.md
module Brainfuck
  # Emitter that outputs brainfuck
  class Emitter
    def initialize
      @code = +""
    end

    # Remove every adjacent round trip (>< <> +- -+), leaving none, and return the result
    def code
      nil while @code.gsub!(/><|<>|\+-|-\+/, "")
      @code
    end

    # Append raw brainfuck
    def raw(s)
      @code << s
    end

    # Move the current position left or right by n
    def mv(n)
      raw(n >= 0 ? ">" * n : "<" * -n)
    end

    # Go over to off, emit the body, then come back to the original position
    def at(off)
      mv(off)
      yield
      mv(-off)
    end

    # mem[off] += n
    def add(off, n)
      at(off) { raw(n >= 0 ? "+" * n : "-" * -n) }
    end

    # mem[off] := 0
    def clear(off)
      at(off) { raw "[-]" }
    end

    # putchar(mem[off])
    def putc_at(off)
      at(off) { raw "." }
    end

    # while mem[off] != 0 { body }
    def loop_at(off)
      at(off) { raw "[" }
      yield
      at(off) { raw "]" }
    end

    # mem[to] += mem[from]; mem[from] := 0
    def move_val(from, to)
      at(from) { raw "[-"; at(to - from) { raw "+" }; raw "]" }
    end

    # mem[to] += mem[from] (mem[from] is preserved; mem[tmp] must be 0)
    def copy(from, to, tmp)
      at(from) { raw "[-"; at(to - from) { raw "+" }; at(tmp - from) { raw "+" }; raw "]" }
      move_val(tmp, from)
    end

    # if mem[off] != 0 { body } (consumes mem[off])
    def if_nz!(off)
      loop_at(off) { clear(off); yield }  # clear first, so the body can freely use off
    end

    # if mem[off] != 0 { body } (mem[off] must be 0 or 1; the clear takes only 1 byte)
    def if_flag!(off)
      loop_at(off) { add(off, -1); yield }
    end

    # mem[cell] := (mem[cell] - 1) mod 256 (mem[cell] must be 0..255; mem[tmp] and mem[flag] must be 0)
    def dec_wrap(cell, tmp, flag)
      move_val(cell, tmp)
      add(flag, 1)
      loop_at(tmp) { move_val(tmp, cell); add(cell, -1); add(flag, -1) }
      if_flag!(flag) { add(flag, 15); loop_at(flag) { add(flag, -1); add(cell, 17) } }
    end

    # if mem[off] == 0 { body } (consumes mem[off] and mem[flag])
    def if_z!(off, flag)
      add(flag, 1)
      if_nz!(off) { add(flag, -1) }
      if_flag!(flag) { yield }
    end

    # If mem[v] == a then t += 1; if mem[v] == b then t -= 1; otherwise yield
    # (consumes v; when yielding, v is "original value - b" and the block must return with v set to 0)
    def match2(v, t, a, b)
      add(v, -a)
      loop_at(v) do
        add(v, a - b)
        loop_at(v) { yield; add(t, 1) }
        add(t, -2)
      end
      add(t, 1)
    end

    # Nested matching that destructively counts down the value cell v (cases = {depth => proc})
    def ladder(v, f, cases)
      spans = cases.map { |k, b| [k.is_a?(Range) ? k : k..k, b] }
      raise "ladder: cases must cover the value range from 0 with no gaps" unless spans.first[0].begin.zero? &&
        spans.each_cons(2).all? { |(a, _), (b, _)| a.end + 1 == b.begin }
      maxd = spans.last[0].begin
      hook = spans.to_h { |r, b| [r.begin, b] }
      rec = nil
      rec = lambda do |d|
        loop_at(v) { add(v, -1); rec[d + 1] } if d <= maxd
        loop_at(f) { add(f, -1); hook[d]&.call } if hook.key?(d)
      end
      add(f, 1)
      rec[0]
    end
  end

  # Implement the QCLang VM in brainfuck
  class Driver < Emitter
    # Definition of the frame width (cell count) and the position of each lane
    W = 8                             # cells per frame
    D = 0                             # Data: a byte of the image (value - 31)
    M = 1                             # Mark: entrypoint during init, data pointer once execution starts
    R = [3, 4, 5, 6, 7, -5, -10, -9]  # Register: lanes that hold values temporarily
    A = -4                            # Accumulator: the accumulator
    L = -1                            # Lexical: lexer state
    S = 2                             # Scratch: all-purpose scratch (a lane that is always free in every frame)
    S2 = -6                           # Scratch2: second scratch (the S lane of the frame to the left)
    V = -3                            # Value: temporary cell for copies of D and comparisons
    T = -2                            # Temporary: temporary cell for copies

    # Carry lanes to the adjacent frame in direction dir, in an order that vacates the destination side first
    def carry_lanes(lanes, dir)
      lanes.sort_by { |c| -c * dir }.each { |c| move_val(c, c + dir * W) }
      mv(dir * W)
    end

    # Move to the left end of the image (the only frame with D = 0)
    def rewind_home(carry = [])
      # From the caller's point of view, the carry offsets end up shifted by +W
      mv(-W)
      loop_at(D) { carry.each { |c| move_val(c + W, c) }; mv(-W) }
    end

    # Walk in direction dir to the frame with the mk mark set, dragging the carry lanes (consumes the mark)
    def walk_to(mk, carry = [], dir: 1)
      add(mk, -1)
      loop_at(mk) do
        add(mk, 1)
        carry.each { |c| move_val(c, c + dir * W) }
        mv(dir * W)
        add(mk, -1)
      end
    end

    # Read the target language name (at most 6 chars) from stdin into RG0..RG5 at the cursor
    def read_name
      # Read 6 times, placing chars while rotating them through R[0]..R[5] in order
      add(L, 1)  # flag: terminator not reached yet
      add(S, 6)  # read count counter
      loop_at(S) do
        add(S, -1)
        5.times { |j| move_val(R[j + 1], R[j]) }  # rotate
        move_val(L, A)
        loop_at(A) do  # terminator not reached
          # do getc with A = 0; treat as terminator if A = 0, A + 1 = 0, or A = 10
          at(A) { raw "," }
          add(A, 1)
          copy(A, V, T)
          ladder(V, T,
            0..11  => -> { clear(A); add(A, 1) },  # terminator
            12..123 => nil)  # name character (48..122)
          add(A, -1)
          loop_at(A) do  # if not at the terminator
            move_val(A, R[5])  # put the char just read into R[5]
            add(L, 1)  # read the next one too
          end
        end
      end
      clear(L)
      copy(R[0], V, T)
      if_z!(V, T) do
        # No input: build the default "bf" as 17 * 6 = 102 ('f' is exactly 102)
        add(S, 17)
        loop_at(S) do
          add(S, -1)
          add(R[0], 6)
          add(R[1], 6)
        end
        add(R[0], -4)  # 'b' = 98
      end
    end

    # Execute the read instruction (acc := image[dp++])
    def read_arm
      clear(A); add(A, 1)   # & overwrites acc, so use it as the return-point mark
      rewind_home           # move to the left end
      loop_at(M) { mv(W) }  # move right until the already-read mark runs out
      copy(D, S2, M)        # S2 := D
      add(M, 1)             # increment the already-read mark (dp++)
      rewind_home([S2])     # move to the left end (carrying S2; when done it sits at S2 + W = S)
      walk_to(A, [S])       # move right to the return point (carrying S)
      loop_at(S) { add(S, 31); move_val(S, A) }  # arrived: restore the true value and drop it (skip +31 when S = 0)
    end

    # Execute a register instruction (sto/lod/sub/immediate)
    def reg_arm
      i = L  # L == 0 is guaranteed here, so borrow the L cell temporarily
      copy(D, i, T)
      add(i, -17)  # u = true value - 48
      add(S, 1)
      loop_at(S) do  # peel 8 off u as many times as possible, counting g
        add(S, -1)  # always 1 at the top of the loop
        copy(i, V, T)
        ladder(V, T, 0..7 => nil, 8..78 => -> { add(i, -8); add(S2, 1); add(S, 1) })
      end
      # mem[i] = c % 8, mem[S2] = (c - 48) / 8
      copy(i, S, T)  # back up mem[i]
      # bring the value of the operand register R[mem[i]] into V
      ladder(i, T, (0..7).to_h { |k| [k, -> { move_val(R[k], V) }] })
      ladder(S2, T,
        0 => -> { clear(V); copy(A, V, T) },  # sto: reg[i] := acc
        1 => -> { clear(A); copy(V, A, T) },  # lod: acc := reg[i]
        2 => -> do  # sub: acc -= reg[i]
          loop_at(V) { add(V, -1); dec_wrap(A, S2, i); add(T, 1) }
          move_val(T, V)  # restore V
        end,
        3..9 => -> { clear(A); copy(D, A, T); add(A, 31) },  # immediate 72..126
      )
      # Put V back into the operand register R[mem[i]]
      move_val(S, i)  # restore mem[i]
      ladder(i, T, (0..7).to_h { |k| [k, -> { move_val(V, R[k]) }] })
    end

    # Walk in direction dir, counting depth, to the matching bracket
    def scan(dir)
      dep = L  # L == 0 is guaranteed here, so borrow the L cell temporarily
      # Drag A only when going backward (going forward happens precisely because acc = 0)
      lanes = dir > 0 ? R + [dep] : R + [A, dep]
      add(dep, 1)
      loop_at(dep) do
        carry_lanes(lanes, dir)
        a, b = dir > 0 ? [9, 10] : [10, 9]  # 9 = '(' (40), 10 = ')' (41)
        copy(D, V, T)
        match2(V, dep, a, b) { add(V, b - 1); clear(V) }
      end
    end

    # Dispatch an instruction
    def code_arm
      copy(D, V, T)
      add(V, -2)
      ladder(V, T,
        0..4   => -> { add(L, 1) },                               # 33 ! (L 0 -> 1)
        5..6   => -> { read_arm },                                # 38 &
        7      => -> { copy(A, V, T); if_z!(V, T) { scan(1) } },  # 40 (
        8      => -> { copy(A, V, T); if_nz!(V) { scan(-1) } },   # 41 )
        9..14  => -> { putc_at(A) },                              # 42 *
        15..93 => -> { reg_arm },                                 # 48..126
      )
    end

    # Execute one byte in literal mode (L = 1)
    def lit_arm
      # 41+31 ('H') sets L = 2, 16+31 ('/') sets L = 0; otherwise output one char
      copy(D, V, T)
      match2(V, L, 41, 16) { add(V, 47); putc_at(V); clear(V) }
    end

    # Processing for one frame of the main loop
    def main_body
      copy(L, V, T)
      ladder(V, T,
        0 => -> { code_arm },
        1 => -> { lit_arm },
        2 => -> { add(D, -2); putc_at(D); add(D, 2); add(L, -1) },
      )
      # advance one frame
      carry_lanes(R + [A, L], 1)
    end

    # The driver of qc.bf (the GLUE and DRIVER pair)
    def build(_entrypoint)
      walk_to(M, dir: -1)       # from the tape end to the entrypoint mark
      read_name                 # load the language name into the registers
      loop_at(D) { main_body }  # main loop

      open = ">" * (-R.min + M) + "+" + ">" * (W - M)  # move to the entrypoint and consume the mark
      [open, code]
    end
  end

  # Spell out the QCLang that outputs qc.bf
  class Generator
    # qc.bf = GLUE ++ E(image) ++ DRIVER
    def source_printer(entrypoint, _core_len)
      open, close = Driver.new.build(entrypoint)
      QCAsm.esc(open) + image_printer(entrypoint) + QCAsm.esc(close)
    end

    private

    def image_printer(entrypoint)
      a = QCAsm

      # fix r3 = 43, r4 = 31, r5 = 1, r6 = 0
      s = +""
      lo = 72
      s << a.num(lo) + a.sto(7)
      s << [[1, 5], [43, 3], [31, 4]].map { |v, r| a.num(lo + v) + a.sub(7) + a.sto(r) }.join

      # code fragment that outputs "+" * (acc - 31) + ">" * W
      emit = +""
      emit << "#{a.sub(4)}#{a.sto(0)}"                           # acc -= 31
      emit << "(#{a.lod(3)}*#{a.lod(0)}#{a.sub(5)}#{a.sto(0)})"  # out("+" * acc)
      emit << a.esc(">" * Driver::W)  # out(">" * W)

      # repeat emit entrypoint times
      s << a.counted_loop(entrypoint, "&#{emit}", lo: 1, hi: 2, one: 5)

      # set M to 1 in the frame corresponding to the entrypoint
      s << "!#{">" * Driver::M}+#{"<" * Driver::M}/"

      # repeat emit for the rest
      s << "&(#{emit}&)"

      s << "#{a.lod(6)}#{a.sto(0)}"  # r0 := 0 (unmatchable from now on)
    end
  end
end

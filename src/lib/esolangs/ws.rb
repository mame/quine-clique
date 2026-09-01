# Generator for qc.ws (the QCLang VM written in Whitespace)
#
# The design is in the Whitespace section of docs/esolangs.md
module Whitespace
  class Asm
    # Label spellings (0 = space / 1 = tab), a search result decided by simulated annealing
    LABELS = {
      main: "", nextc: "110", skloop: "11", litm: "1", repl: "001",
      fin: "01", h_neg: "01001", h_lp: "0100", h_rp: "100", h_out: "010",
      regop: "1110", op_sto: "10010", sk40: "101", ret: "0",
      lit_end: "000", lit_esc: "0101", rdkey: "01110", zfill: "00",
      ld_in: "0000", ld_fin: "01000", ld_bit: "10", ld_wr: "10100",
    }.freeze
    raise "LABELS are not distinct" unless LABELS.values.uniq.size == LABELS.size

    def self.label(name) = LABELS.fetch(name).tr("01", " \t") + "\n"

    def initialize(pol = "")
      @out = +""
      @pol = pol.chars
    end

    def to_s = @out

    def emit(s)
      @out << s
    end

    # Numeric literal (sign + binary + LF; 0 has an empty body)
    def num(v)
      (v < 0 ? "\t" : " ") + (v == 0 ? "" : v.abs.to_s(2).tr("01", " \t")) + "\n"
    end

    # Spellings of instructions that take no argument
    OPS = {
      dupl: " \n ", swap: " \n\t", drop: " \n\n",
      add: "\t   ", sub: "\t  \t", div: "\t \t ", mod: "\t \t\t",
      store: "\t\t ",    # [addr, val] -> heap[addr] = val
      fetch: "\t\t\t",   # [addr] -> heap[addr]
      outc: "\t\n  ",
      readc: "\t\n\t ",  # [addr] -> heap[addr] = getc.ord
      ret: "\n\t\n",
      fin: "\n\n\n",
    }.freeze
    OPS.each { |name, spell| define_method(name) { emit(spell) } }

    # Spellings of instructions taking a label (call return positions live on a separate WS-side stack)
    JUMPS = { mark: "\n  ", call: "\n \t", jump: "\n \n", jz: "\n\t ", jn: "\n\t\t" }.freeze
    JUMPS.each { |name, spell| define_method(name) { |lbl| emit(spell + Asm.label(lbl)) } }

    def push(v)
      emit("  " + num(v))
    end

    # Push stack[-n-1]
    def copy(n)
      emit(" \t " + num(n))
    end

    # Add v to the top
    def padd(v)
      @pol.shift == "1" ? (push(-v); sub) : (push(v); add)
    end

    # Subtract v from the top
    def psub(v)
      @pol.shift == "1" ? (push(-v); add) : (push(v); sub)
    end

    # Push heap[v]
    def ld(v)
      push(v); fetch
    end

    # heap[v] := k
    def setc(v, k)
      push(v); push(k); store
    end

    # heap[v] += 1
    def incr(v)
      push(v); dupl; fetch; padd(1); store
    end

    # Lay out instructions inside a block
    def build(&b)
      instance_eval(&b)
      self
    end
  end

  # Implement the QCLang VM in Whitespace
  class Driver
    P, I = 8, 9  # data pointer and instruction pointer
    IMG = 10     # start address of image

    # Choice between "push k;add" and "push -k;sub" (decided by simulated annealing)
    PADD_SPELLS = "0100000000010000000000"

    # Build the VM body
    def build(entrypoint)
      a = Asm.new(PADD_SPELLS)
      unload(a, entrypoint)
      read_name(a)
      main_loop(a)
      nextc(a)
      reg_arm(a)
      lit_arm(a)
      a.to_s
    end

    # Copy the image data, pushed onto the stack in reverse order, into heap[IMG..]
    def unload(a, entrypoint)
      a.build do                    # [image.., image_len]
        dupl; padd 1; push 0        # [image.., image_len, image_len+1, 0]
        store                       # [image.., image_len] put a terminating 0 one past the image

        mark :ld_in                 # [.., D, pos]
        swap                        # [.., pos, D]
        dupl; jz :ld_fin            # D==0 = all done
        push 31                     # [.., pos, D, c] (we divide until it hits 0, so start from 31)
        mark :ld_bit                # [.., pos, D, c]
        swap                        # [.., pos, c, D]
        dupl; jz :ld_wr             # [.., pos, c, D] D==0 -> this byte is done
        push 2; div                 # [.., pos, c, D/2]
        swap; padd 1                # [.., pos, D/2, c+1]
        jump :ld_bit

        mark :ld_wr                 # [.., pos, c, 0]
        drop                        # [.., pos, c]
        copy 1; swap                # [.., pos, pos, c]
        store                       # [.., pos] heap[pos] := c
        psub 1                      # [.., pos] pos--
        jump :ld_in

        mark :ld_fin                # [pos, 0]
        swap; drop                  # [0] leave the bottom sentinel there as the initial value of acc

        setc I, entrypoint + IMG
      end
    end

    # Read the target language name from stdin into r0.. (up to the newline)
    def read_name(a)
      a.build do                    # [0] stack inherited from unload
        push(-1)                    # [a, w] (incremented first, so one before r0)
        mark :rdkey
        padd 1                      # [a, w] w++
        dupl; readc                 # [a, w] heap[w] := ch
        dupl; fetch                 # [a, w, ch]
        push 18; swap               # [a, w, RDV, ch] any 10 <= RDV < 48 will do
        sub; jn :rdkey              # [a, w] back to rdkey if ch < RDV

        # Put the default key "ws" in the slot holding the terminator and the one after it
        # If a name exists, the zero fill starting at w just erases it, so it survives only when w == 0
        dupl; push 119; store       # [a, w] heap[w] := 'w'
        dupl; padd 1                # [a, w, w+1]
        dupl; push 115; store       # [a, w, w+1] heap[w+1] := 's'
        push 1; swap; div           # [a, w, 1/(w+1)] (0 if w > 0)
        dupl; add; add              # [a, w + 2/(w+1)] advance by 2 only when the name is empty

        # Fill with 0 from the slot holding the newline up to one past r7 (= dp)
        mark :zfill                 # [a, w]
        dupl; push 0                # [a, w, w, 0]
        store                       # [a, w] heap[w] := 0
        padd 1                      # [a, w] w++
        dupl                        # [a, w, w]
        psub(P + 1); jn :zfill      # [a, w, w-(P+1)] back to zfill if w-(P+1) < 0
        drop                        # [a]
      end
    end

    # Fetch and dispatch of one instruction, plus the implementation of ( )
    def main_loop(a)
      a.build do
        mark :main
        call :nextc                 # [.., a, c-33]
        dupl; jz :litm              # [.., a, c-33] 33 '!' goes to litm
        psub 9                      # [.., a, c-42]
        dupl; jn :h_neg             # [.., a, c-42] 38 '&' / 40 '(' / 41 ')' go to h_neg
        dupl; jz :h_out             # [.., a, c-42] 42 '*' goes to h_out
        padd 42                     # [.., a, c]
        dupl; psub 72; jn :regop    # [.., a, c, c-72] c < 72 goes to regop

        # 72.. immediate instructions: drop the second from the top and return to main
        mark :repl                  # [.., x, a]
        swap; drop                  # [.., a]
        jump :main

        # 42 '*' character output
        mark :h_out                 # [.., a, 0]
        drop; dupl; outc            # [.., a] output a
        jump :main

        # 38 '&' / 40 '(' / 41 ')'
        mark :h_neg                 # [.., a, c-42]
        padd 1                      # [.., a, c-41]
        dupl; jz :h_rp              # [.., a, c-41] 41 ')' goes to h_rp
        padd 1; jz :h_lp            # [.., a, c-40] 40 '(' goes to h_lp

        # 38 '&' data input (h_neg has consumed the c-40)
        ld P; padd IMG; fetch       # [.., a, d] read D[P + IMG]
        incr P                      # [.., a, d] P++
        jump :repl                  # [.., d] repl discards the old acc

        # 40 '(' loop start
        mark :h_lp                  # [.., a] (entered with the c-40 consumed by h_neg)
        ld I; swap                  # [.., I0, a] push the return position under a
        call :skloop                # skip ahead to the matching )
        dupl                        # [.., I0, a, a] fed to the drop below

        # 41 ')' loop end; I0 is the return position pushed by the matching '('
        mark :h_rp                  # [.., I0, a, 0]
        drop                        # [.., I0, a]
        dupl; jz :repl              # [.., I0, a] if a==0, discard I0 and go to main
        push I; copy 2              # [.., I0, a, I, I0]
        store                       # [.., I0, a] heap[I] := I0 (back to the loop head)
        jump :main

        # Nested ( : dive one level then continue (call stack depth = nesting depth)
        mark :sk40                  # [.., a, 0]
        drop; call :skloop          # [.., a] skip one level's worth and come back
        mark :skloop                # [.., a] one level's worth starts here
        call :nextc; psub 7         # [.., a, c-40]
        dupl; jz :sk40              # [.., a, c-40] 40 '(' dives one level deeper
        psub 1; jz :ret             # [.., a] 41 ')' returns to the caller
        jump :skloop
      end
    end

    # Subroutine that fetches the next byte of image and advances i
    def nextc(a)
      a.build do
        mark :nextc
        ld I; fetch                 # [.., a, c] read heap[i] where i = heap[I]
        incr I                      # [.., a, c] I++
        dupl; jz :fin               # [.., a, c] c==0 means the terminator
        psub 33                     # [.., a, c-33]

        mark :ret
        ret                         # [.., a, c-33] return to the caller (skloop's exit also merges here)

        mark :fin
        fin
      end
    end

    # Register instructions 48..71
    def reg_arm(a)
      a.build do
        mark :regop                 # [.., a, c]
        dupl; push 8; mod           # [.., a, c, &r_k] (c%8 is the address)
        swap; push 8; div; psub 7   # [.., a, &r_k, t] (-1/0/1)
        dupl; jn :op_sto
        swap; fetch; swap           # [.., a, r_k, t]
        jz :repl                    # [.., a, r_k, t] t==0: lod (discards the a below)
        sub; jump :main             # [.., a - r_k] t==1: sub

        mark :op_sto                # [.., a, &r_k, -1]
        drop; copy 1                # [.., a, &r_k, a]
        store                       # [.., a] r_k := a
        jump :main
      end
    end

    # The literal instruction 33 '!'
    def lit_arm(a)
      a.build do
        mark :lit_esc               # [.., a, 0, c-33]
        drop                        # [.., a, 0]
        call :nextc; outc           # [.., a, 0] output the x-33 returned by nextc as-is

        mark :litm                  # [.., a, 0] (the c-33 of the 33 remains)
        call :nextc                 # [.., a, 0, c-33]
        dupl; psub 14; jz :lit_end  # [.., a, 0, c-33, c-47] c==47 '/' goes to lit_end
        dupl; psub 39; jz :lit_esc  # [.., a, 0, c-33, c-72] c==72 'H' goes to lit_esc
        padd 33; outc               # [.., a, 0]
        jump :litm

        mark :lit_end               # [.., a, 0, c-33]
        drop; drop                  # [.., a]
        jump :main
      end
    end
  end

  # Spell out the QCLang that outputs qc.ws
  class Generator
    # QCLang code generation
    R_SP = 3   # register holding a space (32)
    R_LF = 1   # register holding a newline (10)
    R_TAB = 4  # register holding a tab (9)
    R_ONE = 5  # register holding the constant 1
    R_C = 0    # register holding the byte just read
    R_PAD = 7  # unused register used for padding

    CHARS = [" ", "\t", "\n"].freeze

    # Build the shortest QCLang code fragment that outputs str (acc0 = char in acc, nil if unknown)
    def put_opt(str, acc0 = nil)
      # There are 2 ways to output each of the 3 characters
      #
      #   space:   literal "! /"   code lod(R_SP)+"*"
      #   newline: literal "!H+/"  code lod(R_LF)+"*"
      #   tab:     literal "!H*/"  code lod(R_TAB)+"*"
      #
      # Literals can be concatenated, and lod can be omitted when acc already holds the needed value.
      #
      # The optimal spelling must be found with DP.
      # The state s is 0..7: (char held by acc, inside a literal or not), 4 x 2 = 8.
      # The low 2 bits of s are acc (0..2 = space/tab/LF, 3 = none of them),
      # and the high bit is whether we are inside a literal (0 = outside, 1 = inside).
      regs = { " " => R_SP, "\n" => R_LF, "\t" => R_TAB }
      inf  = 1 << 30
      ix   = CHARS.each_with_index.to_h
      outc = regs.to_h { |ch, r| [ch, QCAsm.lod(r) + "*"] }  # when acc does not hold it
      escd = regs.keys.to_h { |ch| [ch, QCAsm.esc(ch)[1..-2]] }
      cost = [inf] * 8
      cost[acc0 ? ix[acc0] : 3] = 0
      bk = []  # bk[i][s'] = [s, spelling]
      str.each_char do |ch|
        ncost = [inf] * 8
        nb = [nil] * 8
        ci = ix[ch]
        w  = ch == " " ? 1 : 2  # a space needs no escape; tab and newline take 2 bytes due to the "H"
        oc = outc[ch]
        ec = escd[ch]

        8.times do |s|
          c0 = cost[s]
          next if c0 >= inf

          # Output via code
          to = ci
          pre = s >= 4 ? "/" : ""
          body = (s & 3) == ci ? "*" : oc
          c = c0 + pre.size + body.size
          ncost[to], nb[to] = c, [s, pre + body] if c < ncost[to]

          # Output via a literal
          to = 4 + (s & 3)
          pre = s < 4 ? "!" : ""
          body = ec
          c = c0 + pre.size + w
          ncost[to], nb[to] = c, [s, pre + body] if c < ncost[to]
        end

        cost = ncost
        bk << nb
      end
      fin = (0...8).min_by { |s| cost[s] + (s >= 4 ? 1 : 0) }
      out = +(fin >= 4 ? "/" : "")  # close it if we end inside a literal
      s = fin
      (bk.size - 1).downto(0) { |i| s, spell = bk[i][s]; out.prepend(spell) }
      [out, CHARS[fin & 3]]
    end

    # Worst-case byte count when push v is spelled via put_opt (depends only on v's bit length)
    def numeral_put_width(v) = 7 + 5 * v.bit_length / 3  # worst case is "101" repeated

    # Build the QCLang source
    def source_printer(entrypoint, core_len)
      a = QCAsm
      image_len = entrypoint + core_len

      # Initialize the registers
      lo = 72
      open = +""
      open << a.num(lo) + a.sto(R_PAD)
      open << [[1, R_ONE], [9, R_TAB], [10, R_LF], [32, R_SP]]
              .map { |v, r| a.num(lo + v) + a.sub(R_PAD) + a.sto(r) }.join
      open << put_opt(Asm.new.build { push 0 }.to_s, " ").first  # acc == 32 at this point

      # Embed image_len (padded so that the size is monotonic in core_len)
      close, acc = put_opt(Asm.new.build { push(Driver::IMG + image_len - 1) }.to_s, nil)
      close << a.sto(R_PAD) until close.size == numeral_put_width(Driver::IMG + image_len - 1)

      close << put_opt(Driver.new.build(entrypoint), acc).first
      close << a.lod(0) << a.sto(6)  # r6 := 0
      open + image_printer + close
    end

    # Scan the image front to back once with &, emitting one numeral per byte
    def image_printer
      a = QCAsm
      # Build the code that pushes the numeral for 2**(c-32)
      body = a.sub(R_SP) + a.sto(R_C) +              # c -> c - 32
             put_opt("   \t", nil).first +           # "  " + sign + leading bit
             a.lod(R_C) + "(" + a.lod(R_SP) + "*" +  # c - 32 copies of " "
               a.lod(R_C) + a.sub(R_ONE) + a.sto(R_C) + ")" +
             put_opt("\n", nil).first                # terminator of the numeral
      "&" + a.sto(R_C) + "(" + body + "&" + a.sto(R_C) + ")"
    end
  end
end

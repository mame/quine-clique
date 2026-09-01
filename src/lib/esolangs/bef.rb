# Generator for qc.bef (the QCLang VM written using only the Befunge-93 instruction set)
#
# The design is in the Befunge section of docs/esolangs.md
module Befunge
  # Implements the QCLang VM using only the Befunge-93 instruction set
  class Driver
    # y coordinates
    Y_IMAGE    = 0  # image row
    Y_DISPATCH = 1  # row with the code that fetches and dispatches instructions
    Y_CODE     = 2  # row with the code that executes instructions
    Y_RETURN   = 3  # row that returns to the instruction fetch
    Y_STATE    = 4  # state cell row

    # x coordinates of the state cells (y = Y_STATE)
    X_D = 9   # d (mode)
    X_A = 8   # acc
    X_P = 10  # READ pointer

    # bias subtracted right after the fetch
    BIAS = 40

    # the column one west of the `~` in the name-reading loop (the first cell the IP reversed at EOF steps on)
    X_EOF = 3

    # the column where image starts; before it, 0 is the first `v` and X_EOF..X_EOF+2 is the EOF escape route
    X_IMAGE = X_EOF + 3

    # for values with several spellings of the same length, settle on the spelling chosen by sweeping |zcore|
    # (a spelling that is no longer shortest cannot be placed; list only values that do not depend on entrypoint)
    NUMSEL = { 10 => "25*", 60 => "43*5*", 68 => "79*5+", 94 => "86*1-2*" }.freeze

    # synthesize a constant from just 0..9 and + - * (`a`..`f` are Funge-98, so unused)
    def num(v)
      raise "neg num #{v}" if v < 0
      @num ||= {}
      @num[v] ||= begin
        if v <= 9
          v.to_s
        else
          best = nil
          (2..9).each do |b|
            a, c = v.divmod(b)
            cands = ["#{num(a)}#{b}*#{c.zero? ? "" : "#{num(c)}+"}"]
            cands << "#{num(a + 1)}#{b}*#{num(b - c)}-" if c.positive?
            cands.each { |s| best = s if best.nil? || s.size < best.size }
          end
          if (sel = NUMSEL[v])
            raise "NUMSEL[#{v}] is not shortest" unless sel.size == best.size
            best = sel
          end
          best or raise "num(#{v})?"
        end
      end
    end

    # place a code fragment
    def put(y, x, s)
      return x if s.empty?
      r = @lines[y]
      r << " " * (x + s.size - r.size) if x + s.size > r.size
      raise "overlap at (#{x},#{y}): #{r[x, s.size].inspect} vs #{s.inspect}" \
        unless r[x, s.size] == " " * s.size
      r[x, s.size] = s
      x + s.size
    end

    def rd(x) = "#{num(x)}#{Y_STATE}g"
    def wr(x) = "#{num(x)}#{Y_STATE}p"

    # spelling that moves the value on the stack from c-from to c-to
    def delta(from, to)
      return "" if from == to
      to > from ? "#{num(to - from)}-" : "#{num(from - to)}+"
    end

    # build a loop (exits with the loop-count number left sitting on the stack)
    def emit_loop(x, count, body)
      # y=1   >[: count -]#v_
      # y=2   ^[ body   \] <
      put(1, x, ">")
      put(2, x, "^")
      pad = [body.size - count.size - 1, 0].max
      x = put(1, x + 1, "#{count}#{" " * pad}\#v_")
      v = x - 2
      put(2, v, "<")
      put(2, v - body.size, body.reverse)  # mirrored text since it runs westward
      x  # the cell after the `_`
    end

    # generate the initialization code
    def emit_init(entrypoint)
      # read one line from stdin and write it into the register positions
      #
      # X = 0; while (c = getchar) > 10 { (X, Y_STATE) := c; X += 1 }
      #
      # the terminator is "10 or less" to catch, besides newline, implementations that return -1 or 0 on EOF
      count = ":\#^~>:#{num(10)}`"
      raise "X_EOF #{X_EOF} is misaligned with the \#^ in count" unless count[X_EOF - 2, 2] == "\#^"
      put(0, X_EOF, ">0v")  # have the IP that came up push 0 and drop back down
      x = emit_loop(0, count, "\\#{Y_STATE}p1+")
      x = put(1, x, "$")  # [X,X,c] -> [X,X] (the lower X is unused)

      # zero-initialize everything after the register positions, and fill Y_RETURN with `<`
      #
      # X += (X == 0 ? 3 : 0)  # only when X is 0, advance it to 3, keeping the `bef` placed there
      # while X != entry_col { (X, Y_STATE) := 0; (X, Y_RETURN) := ?<; X += 1 }
      x = emit_loop(x, ":!3*+:#{num(entrypoint + X_IMAGE)}-",
                       ":0\\#{Y_STATE}p:#{num(60)}\\#{Y_RETURN}p1+")

      # (x_main, Y_RETURN) := ?^ (to get back to the main loop), and the initial value of the READ pointer.
      # `&` advances p by 1 before reading, so store the column just before image
      tail = ->(m) { "#{num(94)}#{num(m)}#{Y_RETURN}p#{num(X_IMAGE - 1)}#{num(X_P)}#{Y_STATE}p" }

      # x_main appears in its own spelling, so find the smallest fixed point
      x_main = (x + 1..).find { |m| m - x >= tail[m].size }
      put(1, x, tail[x_main])

      # the entrypoint + X_IMAGE left on the stack is not dropped; it becomes the initial value of i
      x_main
    end

    # build the main dispatch and code
    def each_arm
      dg = rd(X_D)
      dp = wr(X_D)
      ag = rd(X_A)
      ap = wr(X_A)

      # if c == 0 { exit } (the trailing sentinel; BIAS is not yet subtracted, so the spelling is just `:!`)
      yield ":!", "@"

      # if d > 0 { d += (c == 40) - (c == 41) }
      yield "#{delta(0, BIAS)}#{dg}0`", "#{delta(BIAS, 40)}:!\\1-!-#{dg}+#{dp}"

      # if d && c == 72 ("H") { putchar(image[i] - 33); i += 1 }
      yield ":#{delta(BIAS, 72)}!#{dg}*", "$:1+\\#{Y_IMAGE}g#{num(32)}-1-,"

      # if c == 47 ("/") { d = 0 }
      yield ":#{delta(BIAS, 47)}!", "!#{dp}"

      # if d { putchar(c) }
      yield dg, "#{delta(BIAS, 0)},"

      # try in the order 33 -> 40 -> 41 -> 42 -> 38
      # the difference between adjacent thresholds is the spelling itself, so the ordering affects length
      k = BIAS
      pre = ->(v) { r = delta(k, v); k = v; r }

      # if c == 33 ("!") { d = a negative value (anything works) }
      yield ":#{delta(k, 33)}!", dp  # d = 33 - BIAS (reuse the value of the condition)

      # if c == 40 ("(") { acc == 0 ? d = 1 : push(i) }
      yield "#{pre[40]}:!", "+:#{ag}\#v_$1#{dp}"

      # if c == 41 (")") && acc != 0 { i = top }
      yield "#{pre[41]}:!#{ag}*", "+$:"

      # if c == 41 (")") && acc == 0 { pop }
      yield ":!", "+\\$"

      # if c == 42 ("*") { putchar(acc) }
      yield "#{pre[42]}:!", "+#{ag},"

      # if c == 38 ("&") { v = image[p]; p += 1; acc = v }
      yield "#{pre[38]}:!", "+#{rd(X_P)}1+:#{wr(X_P)}#{Y_IMAGE}g#{ap}"

      # q = (c-48)/8 splits into sto / lod / sub / imm...

      # if q == 0 { reg[c % 8] = acc }
      yield "#{delta(k, 48)}:8/:!", "+#{ag}\\8%#{Y_STATE}p"

      # if q == 1 { acc = reg[c % 8] }
      yield "1-:!", "+8%#{Y_STATE}g#{ap}"

      # if q == 2 { acc -= reg[c % 8] }
      yield "1-:!", "+#{ag}\\8%#{Y_STATE}g-#{ap}"

      # else { acc = c }
      yield nil, "$#{num(48)}+#{wr(X_A)}"
    end

    # build the three rows y=1 through y=3
    def rows(entrypoint)
      raise "entrypoint #{entrypoint} < 255 (undercuts the field width)" if entrypoint < 255
      @lines = [+"", +"", +"", +""]
      put(0, 0, "v")  # drop the just-started IP down to Y_DISPATCH
      x_main = emit_init(entrypoint)
      raise "x_main #{x_main} <= state cells" if x_main <= 11

      # [i] -> [i+1, c] (BIAS is subtracted after the sentinel check)
      x_dispatch = put(1, x_main, ">:1+\\#{Y_IMAGE}g")
      x_code = x_main
      # x_dispatch: just past the _ on row 0; x_code: just past the end of the arm on row 1
      each_arm do |cond, code|
        # place the condition
        x = cond ? put(1, x_dispatch, cond) + 1 : x_dispatch
        v = [x, x_code].max  # the column of the `v`
        x_dispatch = cond ? put(1, v - 1, "#v_") : put(1, v, "v")
        # place the matched code (land on `>` in the drop column, go east, fall onto the rail at the trailing `v`)
        x_code = put(2, v, code == "@" ? code : ">#{code}v")
      end

      rows = @lines.map(&:rstrip)
      check!(rows, x_main, entrypoint + X_IMAGE)
      rows
    end

    # check that the code is valid
    def check!(rows, x_main, entry_col)
      allowed = "0123456789+-*/%!`><^v?_|\":\\$.,#pg&~@ "
      rows.each_with_index do |row, y|
        next if y == Y_IMAGE  # the rest of the image row is filled by image
        row.each_char.with_index do |ch, i|
          raise "row#{y}[#{i}] = #{ch.inspect} is not Befunge-93" unless allowed.include?(ch)
        end
      end
      raise "x_main #{x_main} overlaps state cells" if x_main < 11
      raise "dispatch[x_main] != >" unless rows[Y_DISPATCH][x_main] == ">"
      raise "code[x_main] not blank" unless (rows[Y_CODE][x_main] || " ") == " "
      # virtual rail: at runtime, (0..entry_col-1, Y_RETURN) becomes `<` and (x_main, Y_RETURN) becomes `^`
      raise "x_main #{x_main} >= entry_col" unless x_main < entry_col
      rows[Y_CODE].each_char.with_index do |ch, i|
        next unless ch == "v" && i != X_EOF
        raise "arm exit v at #{i} <= x_main" unless i > x_main
        raise "arm exit v at #{i} >= entry_col #{entry_col}" unless i < entry_col
      end
      rows[Y_DISPATCH].each_char.with_index do |ch, i|
        next unless ch == "v" && i > x_main
        landing = rows[Y_CODE][i]
        raise "gadget v at #{i} falls through" unless landing && landing != " "
        raise "gadget v at #{i} lands on #{landing.inspect}" unless [">", "<", "@", ","].include?(landing)
      end
      # init loop: right below a `>` on Y_DISPATCH is `^`; right below a `v` is `<` or `>`
      # X_EOF..X_EOF+2 is the EOF escape route (`^` `~` `>`), so exclude it
      (0...x_main).each do |i|
        next if (X_EOF..X_EOF + 2).cover?(i)
        raise "init loop head #{i}" if rows[Y_DISPATCH][i] == ">" && rows[Y_CODE][i] != "^"
        raise "init loop exit #{i}" if rows[Y_DISPATCH][i] == "v" && !"<>".include?(rows[Y_CODE][i])
      end
      # EOF escape route: go up from the `^` straddled by `#` to the image row, push 0 at `>0v`, and come down
      raise "eof bridge" unless rows[Y_DISPATCH][X_EOF - 1, 2] == "\#^"
      raise "eof escape" unless rows[Y_IMAGE][X_EOF, 3] == ">0v"
      raise "image col" unless rows[Y_IMAGE].size == X_IMAGE
    end

    # the driver of qc.bef (a pair of the image row and everything after it)
    def build(entrypoint)
      # the sentinel at the end of image is NUL; a READ past the end just returns 0
      rows = self.rows(entrypoint) + ["bef"]  # the default language name
      raise "default key row is not Y_STATE" unless rows.size == Y_STATE + 1
      [rows[Y_IMAGE], "\0\n#{rows.drop(1).join("\n")}\n"]
    end
  end

  # spells the QCLang that outputs qc.bef
  class Generator
    # image can be streamed through as-is, so just insert a pass-through image_printer
    def source_printer(entrypoint, _core_len)
      open, close = Driver.new.build(entrypoint)
      QCAsm.esc(open) + "&(*&)" + QCAsm.esc(close)
    end
  end
end

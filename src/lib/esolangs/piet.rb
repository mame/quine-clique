# Generator for qc.piet.gif (the QCLang VM written in Piet)
#
# The design is in the Piet section of docs/esolangs.md
module Piet
  # Palette
  module Palette
    module_function

    # Build-time color numbers (logical colors): 0=black 1=white 2..19=colors (6 hues x 3 lightness levels)
    BLACK = 0
    WHITE = 1
    CBASE = 2

    def color(h, l) = CBASE + h * 3 + l  # h: 0..5, l: 0=light 1=normal 2=dark

    HUE = 4  # Hue of the data part (fixed; only the lightness cycles; the value is from |zcore| measurements)

    # Piet commands expressed as color differences (hue, lightness)
    OPS = { push: [0, 1], pop: [0, 2], add: [1, 0], sub: [1, 1], mul: [1, 2],
            div: [2, 0], mod: [2, 1], not: [2, 2], gt: [3, 0], ptr: [3, 1],
            sw: [3, 2], dup: [4, 0], roll: [4, 1], inn: [4, 2], inc: [5, 0],
            outn: [5, 1], outc: [5, 2] }

    # The next color when executing op from color c
    def nxt(c, op) = color(((c - CBASE) / 3 + OPS[op][0]) % 6, ((c - CBASE) % 3 + OPS[op][1]) % 3)

    # Physical color numbers (GIF palette numbers)
    # Taken from a contiguous range placeable raw in QCLang literals (32..126 excluding " ' \\ / H)
    CODES = [126, 124, *74..91].freeze

    def code(c) = CODES[c]
  end

  # Piet integer construction (computes a short op sequence that produces integer n, by DP)
  class Immediate
    MAXPUSH     = 72   # Upper bound pushable directly
    CHEAP_LIMIT = 600  # Upper bound for building the body of a remainder edge recursively
    SMALL       = 16   # Upper bound of the remainder added/subtracted via sums and differences
    DOUBLE      = 10   # Upper bound for doubling (dup; add); a loss for larger n (measured)

    def initialize
      @memo = { 0 => [[:push, 1], [:not]] }      # 0 is: push 1, then not
      1.upto(6) { |n| @memo[n] = [[:push, n]] }  # 1..6 are pushed directly

      @factors = {}
    end

    def op_cells(ops) = ops.sum { |o, a| o == :push ? a : 1 }  # Number of codels the op sequence consumes

    def push_cells(n) = n.negative? ? push_neg(n) : push_pos(n)

    private

    # How to split n = a * b (2 <= a <= b)
    def factors(n) = @factors[n] ||= (2..Integer.sqrt(n)).filter_map { |a| [a, n / a] if (n % a).zero? }

    # Op sequence that pushes a * b (if a == b, dup makes it a single build)
    def mul(a, b) = a == b ? push_cells(a) + [[:dup], [:mul]] : push_cells(a) + push_cells(b) + [[:mul]]

    # The cheapest op sequence among the candidates
    def cheapest(cands) = cands.min_by { |ops| [op_cells(ops), ops.size] }

    # Shortest op sequence that pushes n >= 0
    def push_pos(n)
      # Build several candidates and return the shortest
      @memo[n] ||= begin
        # Candidate: naive digit representation
        naive, q = [], n
        while q > MAXPUSH
          q, r = q.divmod(MAXPUSH)
          naive = [[:push, MAXPUSH], [:mul], *(r.zero? ? [] : [[:push, r], [:add]])] + naive
        end
        cands = [n.zero? ? [[:push, 1], [:not]] : [[:push, q]] + naive]
        if n <= CHEAP_LIMIT
          # Doubling candidate a + a
          cands << push_cells(n / 2) + [[:dup], [:add]] if n.even? && n.between?(2, DOUBLE)
          # Product candidate a * b
          cands.concat(factors(n).map { |a, b| mul(a, b) })
          (1...[n, SMALL + 1].min).each do |r|
            rest = push_cells(r)
            # Slightly shifted candidate a - r
            cands << push_cells(n - r) + rest + [[:add]] if n - r >= 2
            # Slightly shifted candidate a*b + r
            cands.concat(factors(n + r).filter_map { |a, b| mul(a, b) + rest + [[:sub]] if b < n })
          end
        else
          # For large numbers, only search a*b + r and a*b - r
          (-SMALL..SMALL).each do |r|
            prod = cheapest(factors(n - r).map { |a, b| mul(a, b) })
            rest = r.zero? ? [] : push_cells(r.abs) + [[r.negative? ? :sub : :add]]
            cands << prod + rest if prod
          end
        end
        cheapest(cands)
      end
    end

    # Shortest op sequence that pushes a negative n (search by sweeping a in n = a - b)
    def push_neg(n)
      @memo[n] ||= cheapest((0..SMALL).map { |a| push_cells(a) + push_cells(a - n) + [[:sub]] })
    end
  end

  # DSL that builds up the op sequence for one routine
  class Routine
    # Lane order (from the top)
    # The constraints of the computed jumps are checked by Driver#check_slots!
    SLOTS = %i[read_name_1 img_read nextc loop_open loop_close outc dispatch_lit code
               skip_parens read_name_2 dispatch_mode reg_lod_sto reg_sub imm].freeze

    # Slot number of routine name
    def self.pc(name)
      SLOTS.index(name) || (name == :halt ? SLOTS.size : raise("unknown routine #{name}"))
    end

    # The stack is in principle in the state [IMAGE..; VARS..; temporaries..]
    # d: lexer state (>0: parens being skipped, 0: normal, -1: in string literal, -2: right after escape in literal)
    # a: accumulator
    # np: data pointer (number of image bytes not yet read)
    # ni: instruction pointer (number of bytes to the end)
    # lp0..lp3: instruction pointers of the loop return targets (up to 4 nesting levels)
    # r0..r7: registers (8 of them)
    # t: up to which register has been initialized (used by read_name_1/2)
    VARS = %i[d a np ni lp0 lp1 lp2 lp3 r0 r1 r2 r3 r4 r5 r6 r7 t].freeze

    # Stack effect of each command
    EFFECT = {
      push: 1, pop: -1, add: -1, sub: -1, mul: -1, div: -1, mod: -1,
      not: 0, gt: -1, dup: 1, roll: -2, inc: 1, outc: -1,
    }

    # The assembled op sequence
    attr_reader :ops

    def initialize(imm, entry: 0, exit: 0, &blk)
      # entry / exit are the stack depths at the entrance and the exit
      @imm = imm
      @ops = []
      @depth = entry  # current stack depth (number of temporaries)
      instance_eval(&blk)
      raise "routine exit depth is #{@depth}; with exit: #{exit} it should be #{exit + 1}" if @depth != exit + 1
    end

    def op(o, *a)
      @ops << [o, *a]
      @depth += EFFECT[o]
    end

    # Push an integer
    def push(n)
      @imm.push_cells(n).each { |o, *a| op(o, *a) }
    end

    %i[pop add sub mul div mod not gt dup inc outc].each { |o| define_method(o) { op(o) } }

    # Self-declared stack depth adjustment around roll
    def adjust(d)
      @depth += d
    end

    # Rotate the window of depth d by k
    def roll_lit(d, k)
      return if d <= 1 || (k % d).zero?  # do not emit an identity roll
      k = [k, k - d, k + d].min_by { |v| @imm.op_cells(@imm.push_cells(v)) }  # Pick the k mod d that pushes shortest
      push d; push(k); op(:roll)
    end

    def pc(name) = Routine.pc(name)

    # Depth of variable x within the variable area (not counting temporaries)
    def vindex(x) = VARS.index(x) + 1

    # Where variable x currently sits on the stack (deeper by the temporaries piled on top)
    def vdepth(x) = @depth + vindex(x)

    # Copy the value of variable x to the top
    def getv(x)
      d = vdepth(x)  # rotate the window once to duplicate, then rotate back
      return dup if d == 1
      roll_lit(d, -1); adjust(+1); dup
      roll_lit(d + 1, 1); adjust(-1)
    end

    # Consume the top and write it into variable x
    def setv(x)
      d = vdepth(x)
      roll_lit(d, -1); adjust(+1); pop
      roll_lit(d - 1, 1); adjust(-1)
    end

    # Lift variable x to the top, rewrite it with blk, and return it to the same slot
    def modv(x)
      # Rolls drop from 4 to 2. blk may consume temporary space (subtracted from the restore depth)
      d = vdepth(x)
      roll_lit(d, -1); adjust(+1)
      t1 = @depth
      yield
      roll_lit(d - (t1 - @depth), 1); adjust(-1)
    end

    def swap = roll_lit(2, 1)                       # Swap at depth 2
    def eq(v) = (push(v); sub; op(:not))            # Constant comparison (x == v)
    def lift(n) = (push(-n); op(:roll); adjust(n))  # Lift n items from the window bottom
    def sink(n) = (push(n); op(:roll); adjust(-n))  # Stash n items into the window bottom

    # ---- Constant multiply-add (vanishes when the ordering hits) -------------------------------------
    # pc math is mostly "multiply the difference and add a base"; with the right slot order it becomes *1 or +0
    def mulk(k) = ((push(k); mul) unless k == 1)
    def addk(k) = ((push(k); add) unless k.zero?)

    # Copy the value at depth D to the top (for reading IMAGE)
    def pick_rt
      # D must already be pushed on top
      dup; push 1; add; lift(1)  # [target, D, ...]
      dup; roll_lit(3, -1)       # [D, target, target, ...]
      push 1; add; sink(1)       # put one back into its place, leave one on top (window = D+1)
    end
  end

  # The board of the Piet code part
  class Board
    # Tried to write outside the board (raised when a rail eats up the columns)
    class Outside < RuntimeError; end

    # The init rail does not fit (decided by image_len and entrypoint alone, so give up immediately)
    class InitRailTooLong < RuntimeError; end

    attr_reader :rows

    # The board ground. ' ' is white, '#' is black.
    # 1..4 fold the cursor coming from the data part back in the x direction.
    # (1->2: push(5), 2->3: push(5), 4->1: pointer turns it right, then to 2->x)
    # A...J: with stack top (pc) 0, branch to head west from a etc.; if nonzero, fold back to the lane below.
    # (J->A: dup, A->B: not, B->C: not, C->D: dup, D->E: add, E->F: ptr,
    #   F->G: push(2), G->H: push(1), H->I: sub, I->J: sub)
    GROUND = <<END.lines.reject { |l| l.start_with?("+") }.map { |l| l.chomp[1..-2] }.freeze
+------------------------------------------------------------------------------------------------+
|1111122#########################################################################################|
|#4 3222x->                                                                                      |
|#######AA                                                                                      J|
|      AA                                                                               <-aFEDCBA|
|                                                                                          FGHIJ#|
|                                                                                      <-bFEDCBA#|
|                                                                                         FGHIJ##|
|                                                                                     <-cFEDCBA##|
|                                                                                        FGHIJ###|
|                                                                                    <-dFEDCBA###|
|                                                                                       FGHIJ####|
|                                                                                   <-eFEDCBA####|
|                                                                                      FGHIJ#####|
|                                                                                  <-fFEDCBA#####|
|                                                                                     FGHIJ######|
|                                                                                 <-gFEDCBA######|
|                                                                                    FGHIJ#######|
|                                                                                <-hFEDCBA#######|
|                                                                                   FGHIJ########|
|                                                                               <-iFEDCBA########|
|                                                                                  FGHIJ#########|
|                                                                              <-jFEDCBA#########|
|                                                                                 FGHIJ##########|
|                                                                             <-kFEDCBA##########|
|                                                                                FGHIJ###########|
|                                                                            <-lFEDCBA###########|
|                                                                               FGHIJ############|
|                                                                           <-mFEDCBA############|
|                                                                              FGHIJ#DD##########|
|                                                                          <-nFEDCBA  D##########|
+------------------------------------------------------------------------------------------------+
END

    # Set up the pens that paint the ground and write the rails
    def initialize(lmod, seed)
      # Decide the colors of the GROUND symbols
      c1, c2, c3 = (0..2).map { |i| Palette.color(Palette::HUE, (lmod + i) % 3) }
      c4 = Palette.color((Palette::HUE + 3) % 6, (lmod + 2) % 3)  # c4 -> c1 is pointer
      ring = %i[not not dup add ptr push push sub sub dup]
             .each_with_object([Palette.color(seed / 3 % 6, seed % 3)]) { |o, l| l << Palette.nxt(l.last, o) }
      raise "the color ring does not close" unless ring.pop == ring.first
      tbl = { "1" => c1, "2" => c2, "3" => c3, "4" => c4, "#" => Palette::BLACK }
      ring.each_with_index { |c, i| tbl[(?A.ord + i).chr] = c }
      @north = c3  # north of the board counts as the last row of the data part

      # Allocate the board data and initialize it with GROUND
      @rows = GROUND.map { |line| [Palette::BLACK] * line.size }
      init, lanes = nil, []
      # Header and color-ring cells must not be painted over (a rail grown too long would eat the ring)
      @fixed = {}
      GROUND.each_with_index do |line, y|
        line.each_char.with_index do |ch, x|
          init = [x, y] if ch == "x"
          lanes << [x, y] if ch.match?(/[a-w]/)
          white = ch.match?(/[ <\->a-z]/)
          self[x, y] = white ? Palette::WHITE : tbl.fetch(ch) { raise "unknown ground character #{ch.inspect}" }
          @fixed[[x, y]] = true unless white || ch == "#"
        end
      end

      # x-> is the init_lane and <-a etc. are the main_lanes; prepare the Pen objects that draw from them
      @init_pen = Pen.new(self, *init, 1, Palette.nxt(c2, :pop),
                          pdy: -1, free: Palette::BLACK, xmin: init[0] + 1)
      @lane_pens = lanes.map { |x, y| Pen.new(self, x, y, -1, Palette.nxt(ring[5], :pop)) }
    end

    def width = @rows[0].size
    def inside?(x, y) = x.between?(0, width - 1) && y.between?(0, @rows.size - 1)

    def [](x, y)
      return nil unless x.between?(0, width - 1)
      y.negative? ? @north : @rows[y]&.[](x)
    end

    def []=(x, y, clr)
      raise Outside, "(#{x},#{y}) is outside the image" unless inside?(x, y)
      raise Outside, "(#{x},#{y}) is a fixed ground cell" if @fixed&.[]([x, y])
      @rows[y][x] = clr
    end

    # Paint the init lane (the x-> of GROUND)
    def paint_init_lane(ops)
      @init_pen.paint(ops)
      raise InitRailTooLong, "init rail too long" if @init_pen.x >= width
    end

    # Paint each lane's rail westward from its origin (the <-a etc. of GROUND)
    def paint_main_lanes(slotted)
      slotted.each_with_index do |ops, s|
        @lane_pens[s].paint(ops)
        raise Outside, "slot #{s} rail too long" if @lane_pens[s].x < 0
      end
      check_touch!
    end

    # Check that painted cells do not touch a fixed ground cell in the same color
    #
    # Touching fuses the blocks and changes the meaning of the picture, but painting itself succeeds, so check last
    # (depends on the lane base color; some seeds make the init rail color hit the color ring right below)
    def check_touch!
      @fixed.each_key do |(x, y)|
        c = @rows[y][x]
        [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
          next if !inside?(x + dx, y + dy) || @fixed[[x + dx, y + dy]]  # fixed-to-fixed contact is the ground design
          raise Outside, "rail touches fixed cell (#{x},#{y}) with same color" if @rows[y + dy][x + dx] == c
        end
      end
    end

    # Writes an op sequence onto the board
    class Pen
      attr_reader :x

      # Set up a pen at (x, y) on board, heading in direction dx
      def initialize(board, x, y, dx, clr, pdy: nil, free: nil, xmin: nil)
        # dx = direction of travel (east/west only)
        # pdy = direction to spill into the pocket, free = color counted as free, xmin = west end allowed to spill
        @board, @x, @y, @dx, @clr = board, x, y, dx, clr
        @pdy, @free, @xmin = pdy, free, xmin
      end

      # Paint the op sequence and place the exit codel at the end
      def paint(ops)
        len = ops.sum { |o, a| o == :push ? a : 1 } + 1  # the +1 is the exit codel placed at the end
        room = @dx > 0 ? @board.width - 1 - @x : @x
        save = @pdy ? [len - room, 0].max : nil
        ops.each do |o, arg|
          n = o == :push ? arg : 1
          if save && n > 1
            cols = pocket_cols(n).first(save)
            cols.each { |cx| @board[cx, @y + @pdy] = @clr }
            save -= cols.size; n -= cols.size
          end
          n.times { @board[@x, @y] = @clr; @x += @dx }
          @clr = Palette.nxt(@clr, o)
        end
        @board[@x, @y] = @clr
        @x += @dx
      end

      private

      # Choose the cells that spill an n-codel block into the pocket (keep 1 cell in the main row)
      def pocket_cols(n)
        py = @y + @pdy
        return [] if n < 2 || !@board.inside?(@x, py)
        back = (0...(n - 1)).map { |i| @x - @dx * i }
                            .take_while { |cx| cx >= @xmin && @board[cx, py] == @free }
        back.pop while back.any? && !pocket_ok?(back, n)

        # If the back is not enough, also spill forward (into this block's own columns)
        fwd = []
        (1..(n - 1 - back.size)).each do |j|
          cx = @x + @dx * j
          break unless @board[cx, py] == @free && 2 * (j + 1) <= n - back.size - 1 &&
                       pocket_ok?(back + fwd + [cx], n)
          fwd << cx
        end

        back + fwd
      end

      # Check that spilling cand into the pocket does not fuse it with a neighboring block
      def pocket_ok?(cand, n)
        py = @y + @pdy
        far = py + @pdy  # the row on the far side of the pocket
        main = (0...(n - cand.size)).map { |i| @x + @dx * i }
        cand.all? do |cx|
          [[cx, @y, main.include?(cx)], [cx, far, false],
           [cx - 1, py, cand.include?(cx - 1)], [cx + 1, py, cand.include?(cx + 1)]]
            .all? { |ax, ay, own| own || @board[ax, ay] != @clr }
        end
      end
    end
  end

  # Building the code part
  class Driver
    # Depending on image_len this fails to fit in the lanes with a few % probability (callers just try the next value)
    class PlacementFailed < RuntimeError; end

    def initialize
      @imm = Piet::Immediate.new  # spelling of immediates (also used to estimate the rails)
      @main_lanes = define_main_lanes.values_at(*Routine::SLOTS)  # op sequences arranged in slot order
    end

    # Op sequence of the init lane
    def define_init_lane(n, entrypoint)
      # Initial values of each of VARS
      values = Routine::VARS.reverse.map do |nm|
        case nm
        when :r3, :r2, :r1, :r0 then "piet".bytes[Routine::VARS.index(nm) - Routine::VARS.index(:r0)]
        when :ni then n - entrypoint
        when :np then n
        else 0
        end
      end

      # Push VARS with their initial values
      cells = ->(v) { @imm.op_cells(@imm.push_cells(v)) }
      Routine.new(@imm, entry: 1, exit: Routine::VARS.size) do
        pop
        prev = nil
        values.each do |v|
          d = prev ? v - prev : nil
          if d&.zero?
            dup                                   # a value equal to the previous one is duplicated
          elsif d && cells[d.abs] + 2 < cells[v]
            dup; push(d.abs)
            d.negative? ? sub : add               # built as a difference from the previous value
          else
            push v
          end
          prev = v
        end

        # The first routine to execute is read_name_1
        push pc(:read_name_1)
      end.ops
    end

    # Spell out the QCLang VM and return { routine name => op sequence }
    def define_main_lanes
      check_slots!
      lanes = {}
      m = Routine::VARS.size
      r0_depth = Routine::VARS.index(:r0) + 1

      # Fetch one byte and branch
      #
      # from: every routine that finished its body
      # to: halt, skip_parens, dispatch_mode
      # stack: [garbage] -> [c, pc]
      # code:
      #   c = image[ni]; ni -= 1
      #   pc = ni == 0 ? halt : d > 0 ? skip_parens : dispatch_mode
      lanes[:nextc] = Routine.new(@imm, entry: 1, exit: 1) do
        pop                                       # [IMAGE..; VARS..]  discard the value the previous routine left
        getv(:d); push 0; op(:gt)                 # [IMAGE..; VARS..; g]  g = (d > 0)
        dup; add                                  # [IMAGE..; VARS..; 2g]  skip_parens is 2 slots over
        modv(:ni) do                              # [IMAGE..; VARS..; g, ni]
          dup; push(m + 1); add                   # [IMAGE..; VARS..; g, ni, ni+m+1]
          pick_rt                                 # [IMAGE..; VARS..; g, ni, c]  c = IMAGE[ni]
          swap; dup; push 1; sub                  # [IMAGE..; VARS..; g, c, ni, ni-1]
        end                                       # [IMAGE..; VARS..; g, c, ni]
        op(:not)                                  # [IMAGE..; VARS..; g, c, e]  e = (ni == 0)
        mulk(pc(:halt) + 2 - pc(:dispatch_mode))  # the 2 anticipates subtracting g
        roll_lit(3, -1); sub                      # [IMAGE..; VARS..; c, e * (...) - 2g]
        addk(pc(:dispatch_mode))                  # [IMAGE..; VARS..; c, pc]
        # pc = ni == 0 ? halt : d > 0 ? skip_parens : dispatch_mode (= skip_parens + 2)
        # at the end this becomes halt + 2 - 2g, but any pc >= halt hits no lane and passes through
      end

      # Choose the destination by mode, and intercept '!'
      #
      # from: nextc
      # to: nextc (33 '!'), code (d == 0), dispatch_lit (d == -1), outc (d == -2)
      # stack: [c] -> [c, pc]
      # code:
      #   g = (c == '!') * (d == 0); d -= g     '!' only opens a literal (d := -1) and emits nothing
      #   pc = g ? nextc : code - d             nextc is slot 0, so the multiplication can drop it
      #
      # 33 '!' takes priority over the mode; d == 0 is multiplied in, so a '!' under escape passes through
      # code / dispatch_lit / outc line up in this order, so one code - d covers the 3-way branch
      lanes[:dispatch_mode] = Routine.new(@imm, entry: 1, exit: 1) do
        dup; eq(2)                                # [IMAGE..; VARS..; c, t]  t = (c == '!')
        modv(:d) do                               # [IMAGE..; VARS..; c, t, d]
          dup; dup; op(:not)                      # [IMAGE..; VARS..; c, t, d, d, d==0]
          roll_lit(4, -1); mul                    # [IMAGE..; VARS..; c, d, d, g]  g = t * (d==0)
          dup; op(:not)                           # [IMAGE..; VARS..; c, d, d, g, w]
          push(pc(:code) - pc(:nextc))            # [IMAGE..; VARS..; c, d, d, g, w, code-nextc]
          roll_lit(5, 2)                          # [IMAGE..; VARS..; c, w, code, d, d, g]
          sub                                     # [IMAGE..; VARS..; c, w, code, d, d-g]  on '!', d := -1
        end                                       # [IMAGE..; VARS..; c, w, code, d]
        add                                       # [IMAGE..; VARS..; c, w, code - nextc + d]
        mul; addk(pc(:nextc))                     # [IMAGE..; VARS..; c, pc]
      end

      # Output one character
      #
      # from: dispatch_mode (d == -2), dispatch_lit, code (42 '*')
      # to: nextc
      # stack: [c] -> [junk, pc]
      # code:
      #   putchar(d == 0 ? a : c + 64 + 33*d)   d = -1 gives c + 31 (the original byte), -2 gives c - 2
      #   d = (d == 0) - 1                      escape goes -2 -> -1, the rest stay
      #
      # the 3 inlets d = -2 (escape) / -1 (plain literal) / 0 (output of `*`) are folded into one path
      lanes[:outc] = Routine.new(@imm, entry: 1, exit: 1) do
        modv(:d) do                               # [IMAGE..; VARS..; c, d]
          dup; op(:not)                           # [IMAGE..; VARS..; c, d, g]  g = (d == 0)
          dup; push 1; sub                        # [IMAGE..; VARS..; c, d, g, g-1]  d := g - 1
        end                                       # [IMAGE..; VARS..; c, d, g]
        roll_lit(3, 1)                            # [IMAGE..; VARS..; g, c, d]
        push 33; mul; push 64; add                # [IMAGE..; VARS..; g, c, 33d + 64]
        add                                       # [IMAGE..; VARS..; g, cbyte]  cbyte = c + 64 + 33d
        dup; getv(:a); sub                        # [IMAGE..; VARS..; g, cbyte, cbyte - a]
        roll_lit(3, -1); mul; sub                 # [IMAGE..; VARS..; g ? a : cbyte]
        outc; push 1; push(pc(:nextc))            # [IMAGE..; VARS..; junk, pc]
      end

      # Count parens; when they close, drop one loop level
      #
      # from: nextc (d > 0)
      # to: nextc
      # stack: [c] -> [junk, pc]
      # code:
      #   d += (c == '(') - (c == ')')
      #   if d == 0 { pop one level of lp }   the ) that brings d back to 0 is the matching close
      lanes[:skip_parens] = Routine.new(@imm, entry: 1, exit: 1) do
        push 9; sub; dup; op(:not)                # [IMAGE..; VARS..; c-9, c=='(']  9 = '('(40) - 31
        swap; eq(1); sub                          # [IMAGE..; VARS..; delta]  delta = (c=='(') - (c==')')
        modv(:d) { add; dup }                     # [IMAGE..; VARS..; d]  get a copy of the new d
        k = vindex(:lp0)
        op(:not); dup; op(:not)                   # [IMAGE..; VARS..; g, ng]  g = (d == 0)
        roll_lit(vdepth(:lp0), -1); adjust(1)     # [IMAGE..; VARS..(lp0 pulled out); g, ng, lp0]
        mul                                       # [IMAGE..; VARS..; g, X]  X = lp0 * ng
        swap; push 3; mul; push(k); add           # [IMAGE..; VARS..; X, D]  D = k + 3*g
        sink(1); push 1; push(pc(:nextc))         # X to depth D (if g=1, a 0 goes into lp3 = pop)
      end

      # Dispatch one byte inside a literal
      #
      # from: dispatch_mode (d == -1)
      # to: nextc (47 '/' and 72 'H'), outc (the rest)
      # stack: [c] -> [c, pc]
      # code:
      #   u = (c == 'H') - (c == '/')  1 = escape by 'H', -1 = close by '/', 0 = plain character
      #   d = -u - 1                   -2 = pass the next byte through, 0 = end of the literal
      #   pc = nextc + (u == 0) * (outc - nextc)
      #
      # 'H' only discards c, so it jumps straight to nextc (nextc drops the top at its entrance)
      lanes[:dispatch_lit] = Routine.new(@imm, entry: 1, exit: 1) do
        dup; push 16; sub                         # [IMAGE..; VARS..; c, y]  y = c - 16
        dup; eq(25)                               # [IMAGE..; VARS..; c, y, f]  f = (c == 'H')
        swap; op(:not)                            # [IMAGE..; VARS..; c, f, g]  g = (c == '/')
        sub; dup                                  # [IMAGE..; VARS..; c, u, u]  u = f - g = 1/0/-1
        modv(:d) do                               # [IMAGE..; VARS..; c, u, u, d]  here d == -1
          mul; push 1; sub                        # [IMAGE..; VARS..; c, u, d]  d := -u - 1
        end                                       # [IMAGE..; VARS..; c, u]
        op(:not)                                  # [IMAGE..; VARS..; c, z]  z = (u == 0)
        mulk(pc(:outc) - pc(:nextc))
        addk(pc(:nextc))                          # [IMAGE..; VARS..; c, pc]
      end

      # Dispatch commands to the routine of each group
      #
      # from: dispatch_mode (d == 0)
      # to: img_read / loop_open / loop_close / outc / reg_lod_sto / reg_sub / imm
      # stack: [c] -> [x, pc]  (the routines behind receive x, not c)
      # code:
      #   x = c - 17; u = x + 16;  z = u / 16  # z = 0 low group / 1 sto,lod / 2 or more sub,immediates
      #   pc = (z == 0) * (x + A) + (z > 1) * ((x > 23) + 1) + B
      #
      # where
      #   B = reg_lod_sto
      #   A = 17 - (7 - img_read) - B
      #   loop_open = img_read + 2
      #   loop_close = img_read + 3
      #   outc = img_read + 4
      #   reg_sub = reg_lod_sto + 1
      #   imm = reg_lod_sto + 2
      lanes[:code] = Routine.new(@imm, entry: 1, exit: 1) do
        b = pc(:reg_lod_sto)
        a = pc(:img_read) + 10 - b                # low-group bias (lo = byte - 38 + img_read = x + a + b)
        push 17; sub                              # [IMAGE..; VARS..; x]
        dup; dup; dup; push 16; add               # [IMAGE..; VARS..; x, x, x, u]  u = x + 16
        push 16; op(:div)                         # [IMAGE..; VARS..; x, x, x, z]  z = u / 16
        dup; op(:not)                             # [IMAGE..; VARS..; x, x, x, z, nz]
        roll_lit(4, 1)                            # [IMAGE..; VARS..; x, nz, x, x, z]  nz waits between the two x
        push 1; op(:gt)                           # [IMAGE..; VARS..; x, nz, x, x, gz]  gz = (z > 1)
        swap; push 23; op(:gt); push 1; add       # [IMAGE..; VARS..; x, nz, x, gz, s]  s = (x > 23) + 1
        mul; roll_lit(3, 1)                       # [IMAGE..; VARS..; x, gz * s, nz, x]  sink the product first
        push(a); add; mul; add                    # [IMAGE..; VARS..; x, gz * s + nz * (x + a)]
        push(b); add                              # [IMAGE..; VARS..; x, pc]
      end

      # 38 '&': read one byte of image into acc
      #
      # from: code
      # to: nextc
      # stack: [x] -> [junk, pc]
      # code:
      #   a = np == 0 ? 0 : image[np]
      #   np -= 1
      #
      # No branch: "read, then multiply by 0" (at np == 0 the depth points at the deepest variable slot, so it is safe).
      # One copy of np is carried around, used both for the depth math and for the mask (the second getv disappears)
      lanes[:img_read] = Routine.new(@imm, entry: 1, exit: 1) do
        pop
        modv(:a) do                               # [IMAGE..; VARS..; a]
          pop; adjust(-1)                         # [IMAGE..; VARS..(a pulled out)]  tighten the depth by the hole
          modv(:np) { dup; push 1; sub }          # [IMAGE..; VARS..; np]  np := np - 1
          dup; push(m); add                       # [IMAGE..; VARS..; np, np+m]  1 shallower since a is out
          pick_rt                                 # [IMAGE..; VARS..; np, IMAGE[np]] (debris if np == 0)
          push 31; add; swap                      # [IMAGE..; VARS..; byte, np]
          op(:not); op(:not)                      # [IMAGE..; VARS..; byte, np != 0]
          mul; adjust(+1)                         # [IMAGE..; VARS..; a]  the debris is erased by the multiplication
        end                                       # [IMAGE..; VARS..]
        push 1; push(pc(:nextc))                  # [IMAGE..; VARS..; junk, pc]
      end

      # 40 '(': loop entrance
      #
      # from: code
      # to: nextc
      # stack: [x] -> [junk, pc]
      # code:
      #   push lp down one level, lp0 = ni   lp3 falls off (nesting up to 4 levels)
      #   d = (a == 0)                       skip if a == 0 (d > 0), else into the body
      lanes[:loop_open] = Routine.new(@imm, entry: 1, exit: 1) do
        pop; getv(:ni)                            # [IMAGE..; VARS..; ni]
        roll_lit(vdepth(:lp3), -1); pop           # [IMAGE..; VARS..(lp3 dropped); ni]
        roll_lit(vdepth(:lp0), 1)                 # [IMAGE..; VARS..(lp0 = ni)]
        raise "VARS: d must be exactly one above a" if vindex(:d) + 1 != vindex(:a)
        w = vdepth(:a)
        roll_lit(w, -2); adjust(2); pop           # [IMAGE..; VARS..; a]  drop d
        dup; op(:not)                             # [IMAGE..; VARS..; a, not(a)]
        roll_lit(w, 2); adjust(-2)                # [IMAGE..; VARS..]  back to the slots of a and d
        push 1; push(pc(:nextc))                  # [IMAGE..; VARS..; junk, pc]
      end

      # 41 ')': loop end
      #
      # from: code
      # to: nextc
      # stack: [x] -> [junk, pc]
      # code:
      #   f = (a != 0);  ni = f ? lp0 : ni    if f, return to the entrance (peek)
      #   if !f { pop one level of lp }
      #
      # Always pull lp0 out to make X = lp0 * f, set ni := ni*not(f) + X, and bury X back at depth
      # D = k + 3*not(f) (when f = 0, lp1..lp3 shift up one)
      lanes[:loop_close] = Routine.new(@imm, entry: 1, exit: 1) do
        k = vindex(:lp0)
        pop; getv(:a); op(:not); op(:not)         # [IMAGE..; VARS..; f]  f = (a != 0)
        roll_lit(vdepth(:lp0), -1); adjust(1)     # [IMAGE..; VARS..(lp0 pulled out); f, lp0]
        mul                                       # [IMAGE..; VARS..; X]  X = lp0 * f
        dup; dup; op(:not)                        # [IMAGE..; VARS..; X, X, nf]  lp0 != 0, so not(X) = nf
        modv(:ni) { mul; add }                    # [IMAGE..; VARS..; X]  ni := ni*nf + X
        dup; op(:not); push 3; mul                # [IMAGE..; VARS..; X, 3*nf]
        push(k); add                              # [IMAGE..; VARS..; X, D]  D = k + 3*nf
        sink(1); push 1; push(pc(:nextc))         # X to depth D (if nf=1, a 0 goes into lp3 = pop)
      end

      # 72..126 immediates: put a constant into acc
      #
      # from: code
      # to: nextc
      # stack: [x] -> [junk, pc]
      # code:
      #   a = x + 48                         the x that code passes is the original byte - 48
      lanes[:imm] = Routine.new(@imm, entry: 1, exit: 1) { push 48; add; setv(:a); push 1; push(pc(:nextc)) }

      # 48..63 sto / lod: copy a value between acc and a register
      #
      # from: code
      # to: nextc
      # stack: [x] -> [junk, pc]
      # code:
      #   i = x % 8;  f = x / 8              x is 0..15, so f is directly the lod flag
      #   a = r[i] = f ? r[i] : a            sto and lod both amount to "put the same value into both"
      lanes[:reg_lod_sto] = Routine.new(@imm, entry: 1, exit: 1) do
        dup; push 8; op(:mod)                     # [IMAGE..; VARS..; x, i]
        push(r0_depth); add                       # [IMAGE..; VARS..; x, D-1]  D = depth of r[i]
        dup; push 2; add; lift(1)                 # [IMAGE..; VARS..(r[i] pulled out); x, D-1, r]
        modv(:a) do                               # [IMAGE..; VARS..; x, D, r, a]
          push 2; roll_lit(5, -1)                 # [IMAGE..; VARS..; D, r, a, 2, x]  x has been kept waiting
          push 8; op(:div); op(:not)              # [IMAGE..; VARS..; D, r, a, 2, not(f)]  f = x / 8 is lod
          op(:roll); pop; dup                     # [IMAGE..; VARS..; D, v, v]  conditionally swap and drop w
        end                                       # [IMAGE..; VARS..; D-1, v]
        swap; sink(1)                             # [IMAGE..; VARS..]  r[i] := v
        push 1; push(pc(:nextc))                  # [IMAGE..; VARS..; junk, pc]
      end

      # 64..71 sub: subtract a register from acc
      #
      # from: code
      # to: nextc
      # stack: [x] -> [junk, pc]
      # code:
      #   a -= r[x % 8]
      lanes[:reg_sub] = Routine.new(@imm, entry: 1, exit: 1) do
        dup; push 8; op(:mod)                     # [IMAGE..; VARS..; x, i]
        push(r0_depth + 1); add                   # [IMAGE..; VARS..; x, D]  D = depth of r[i] (pick_rt adds 1)
        pick_rt                                   # [IMAGE..; VARS..; x, r]  r = r[x % 8]
        modv(:a) { swap; sub }                    # [IMAGE..; VARS..; x]  a -= r (one round trip for read and write)
        push(pc(:nextc))                          # [IMAGE..; VARS..; x, pc]  x itself serves as the junk
      end

      # Read one character of the target language name from stdin
      #
      # from: initial, read_name_2
      # to: read_name_2, nextc (at the end; falls straight into the main loop)
      # stack: [] -> [v, pc]
      # code:
      #   v = getchar();  end = (v == EOF || v == '\n')
      #   pc = nextc + ne * (read_name_2 - nextc)
      lanes[:read_name_1] = Routine.new(@imm, exit: 1) do
        inc; dup; push 1; add                     # [IMAGE..; VARS..; v, v+1]
        dup; push 11; sub; mul                    # [IMAGE..; VARS..; v, (v+1) * (v-10)]
        op(:not); op(:not); mul                   # [IMAGE..; VARS..; v]  collapses to 0 at the end
        dup; op(:not)                             # [IMAGE..; VARS..; v, end]  turning into 0 marks the end
        op(:not)                                  # [IMAGE..; VARS..; v, ne]  ne = (not at the end)
        mulk(pc(:read_name_2) - pc(:nextc))
        addk(pc(:nextc))                          # [IMAGE..; VARS..; v, pc]
      end

      # Write the character just read into a register
      #
      # from: read_name_1
      # to: read_name_1
      # stack: [v] -> [pc]
      # code:
      #   r[t] = v;  r[t+1] = 0;  t += 1
      #
      # r[t+1] is also cleared to keep "the register after the last written character is always 0" (leftover
      # read-ahead would turn `c` or `cpp` into another name). Adjacent slots, so one window round trip writes both
      lanes[:read_name_2] = Routine.new(@imm, entry: 1) do
        modv(:t) { dup; push 1; add }             # [IMAGE..; VARS..; v, t]  t += 1 (receiving the old t)
        push(r0_depth + 1); add                   # [IMAGE..; VARS..; v, D]  D = depth of r[t]
        dup; push 2; add; lift(2)                 # [IMAGE..; VARS..(r[t] and r[t+1] pulled out); v, D, r[t], r[t+1]]
        pop; dup; sub; roll_lit(3, 1)             # [IMAGE..; VARS..; 0, v, D]  subtract r[t] to make a 0
        sink(2)                                   # [IMAGE..; VARS..]  v -> r[t], 0 -> r[t+1]
        push(pc(:read_name_1))                    # [IMAGE..; VARS..; pc]
      end

      # halt has no lane (pc(:halt) = SLOTS.size, so it hits no lane and the IP falls into the white trap at the bottom)
      lanes.transform_values(&:ops)
    end

    # Check that the ordering supports the computed jumps (for the formulas, see the comments in define_main_lanes)
    def check_slots!
      s = Routine::SLOTS.each_with_index.to_h
      {
        "high map of code  reg_sub = reg_lod_sto + 1"           => s[:reg_sub] == s[:reg_lod_sto] + 1,
        "high map of code  imm = reg_lod_sto + 2"               => s[:imm] == s[:reg_lod_sto] + 2,
        "low map of code  loop_open = img_read + 2"             => s[:loop_open] == s[:img_read] + 2,
        "low map of code  loop_close = img_read + 3"            => s[:loop_close] == s[:img_read] + 3,
        "low map of code  outc = img_read + 4"                  => s[:outc] == s[:img_read] + 4,
        "code + d of dispatch_mode  dispatch_lit = code - 1"    => s[:dispatch_lit] == s[:code] - 1,
        "code + d of dispatch_mode  outc = code - 2"            => s[:outc] == s[:code] - 2,
        "dispatch_mode - 2g of nextc  dispatch_mode = skip_parens + 2"   => s[:dispatch_mode] == s[:skip_parens] + 2,
      }.each { |msg, ok| raise "slot order violates a constraint (#{msg})" unless ok }
    end

    # Lane base-color try order (paint failure tries the next; only |zcore| moves); re-sweep the head when arms change
    PSEEDS = [13, *0..17].uniq.freeze

    # Return the cell array of the code part
    def image(n, entrypoint)
      img = err = nil  # the shape is as in GROUND, the contents are logical colors
      PSEEDS.each do |sd|
        img = begin
          g = Board.new(n % 3, sd)
          g.paint_init_lane(define_init_lane(n, entrypoint))
          g.paint_main_lanes(@main_lanes)
          g.rows
        rescue Board::InitRailTooLong => e
          raise PlacementFailed, "image(n=#{n}, ep=#{entrypoint}): #{e.message}"
        rescue Board::Outside => e
          err = e
          nil
        end
        break if img
      end
      img or raise PlacementFailed, "image(n=#{n}, ep=#{entrypoint}): does not fit (#{err.message})"
    end
  end

  # The side that spells the QCLang (open / image_printer / close) that outputs qc.piet.gif
  class Generator
    BLACK = Palette.code(Palette::BLACK)
    WHITE = Palette.code(Palette::WHITE)

    # The fixed header to output first
    def header(w, h)
      # Color table (128 colors)
      tbl = [[0, 0, 0]] * 128
      tbl[WHITE] = [0xFF, 0xFF, 0xFF]
      [[0xFF, 0x00, 0x00], [0xFF, 0xFF, 0x00], [0x00, 0xFF, 0x00],
       [0x00, 0xFF, 0xFF], [0x00, 0x00, 0xFF], [0xFF, 0x00, 0xFF]].each_with_index do |(r, g, b), hue|
        tbl[Palette.code(Palette.color(hue, 0))] = [r | 0xC0, g | 0xC0, b | 0xC0]
        tbl[Palette.code(Palette.color(hue, 1))] = [r, g, b]
        tbl[Palette.code(Palette.color(hue, 2))] = [r & 0xC0, g & 0xC0, b & 0xC0]
      end

      # GIF header (signature + screen descriptor + color table) + image descriptor
      +"GIF89a".b << [w, h].pack("v2") << 0xF6.chr << BLACK.chr << 0.chr <<
        tbl.flatten.pack("C*") << 0x2C.chr << [0, 0, w, h].pack("v4") << 0.chr << 7.chr
    end

    # QCLang register number assignment (r0..r7)
    CNT  = 0  # Remaining run-length count (same register as the black fill, so the spelling matches the data part)
    FULL = 1  # Constant 127 = row width 96 + bias 31 / During the header it holds the color table's 192
    BYTE = 2  # image byte (where & lands; r0 is clobbered in close)
    BIAS = 3  # Data-part bias 31 (during the header it holds the color table's 255)
    ZERO = 4  # Fixed 0
    ONE  = 5  # Fixed 1
    CLR  = 6  # Fixed CLEAR (128)
    SC   = 7  # Scratch
    KEY_OF = "piet".bytes.each_with_index.to_h { |b, k| [k, b] }.freeze  # key characters left by the matching

    # GIF dimensions are at most 65535 pixels
    MAXHEIGHT = 65_535

    # image does not fit in the GIF height
    class TooTall < RuntimeError
      attr_reader :max

      def initialize(max)
        super("piet: image does not fit in the GIF height #{MAXHEIGHT} (limit #{@max = max})")
      end
    end

    def initialize
      @driver = Driver.new
      @rs = {}  # known-constant table -> table of shortest op sequences (memo of rsynth)
    end

    # The QCLang that outputs qc.piet.gif
    def source_printer(entrypoint, core_len)
      n = entrypoint + core_len
      code_rows = @driver.image(n, entrypoint).map { |r| r.map { |c| Palette.code(c) } }
      w, h = code_rows[0].size, n + code_rows.size
      raise TooTall.new(MAXHEIGHT - code_rows.size) if h > MAXHEIGHT

      open, close = +"", +""

      # Initial register values (the language name piet)
      reg_of = { ?i.ord => 1, ?e.ord => 2, ?t.ord => 3, 0 => ZERO }  # ?p => CNT is omitted since RLE crushes it

      # Register setup for outputting the fixed header (128: clear code, 192/255: color table, 1: fixed 1)
      { 128 => CLR, 192 => FULL, 255 => BIAS, 1 => ONE }.each do |v, r|
        reg_of.delete(reg_of.invert[r])
        open << "#{val(v, reg_of)}#{a.sto(r)}"
        reg_of[v] = r
      end

      # Generate the code that outputs the fixed header
      open << emit(header(w, h).bytes, reg_of)[0]  # non-printable bytes go out via registers

      # Register setup for outputting the data part
      { 31 => BIAS, 127 => FULL }.each do |v, r|
        open << "#{val(v, reg_of)}#{a.sto(r)}"
        reg_of[v] = r
      end

      # Generate the code that outputs the data part (emit the image bytes one row at a time)
      image_printer = +"&#{a.sto(BYTE)}("  # read the first byte and enter the loop
      # Output in 3-row units for the push-repeating lightness change (image_len is required to be a multiple of 3)
      3.times do |l|
        # A row is formed as [97, CLEAR, clr, clr, ..., clr, BLACK, BLACK, ..., BLCK] (clr appears IMAGE[o] - 31 times)
        image_printer << "#{a.num(97)}*#{a.lod(CLR)}*"  # head of the subblock [97, CLEAR]
        image_printer << "#{a.lod(BYTE)}#{a.sub(BIAS)}#{a.sto(CNT)}"  # CNT := run = byte - 31
        image_printer << "(#{val(Palette.code(Palette.color(Palette::HUE, l)))}*#{dec(CNT)})"
        image_printer << "#{a.lod(FULL)}#{a.sub(BYTE)}#{a.sto(CNT)}"  # CNT := 96 - run = 127 - byte
        image_printer << "(#{val(BLACK)}*#{dec(CNT)})"
        image_printer << "&#{a.sto(BYTE)}"  # read the next byte
      end
      image_printer << ")"

      # Register setup for the code part and trailer (31 / 0 / 1 / 127 / 128 survive the data part, so keep as is)
      reg_of = { 0 => ZERO, 1 => ONE, 31 => BIAS, 127 => FULL, 128 => CLR }

      # Generate the code that outputs the code part and the trailer
      acc = nil
      code_rows.each do |row|
        body, acc = emit(row + [BLACK] * (w - row.size), reg_of, 128)
        close << "#{a.num(97)}*#{a.lod(CLR)}*" << body
      end
      tail, acc = emit([1, 0x81, 0, 0x3B], reg_of, acc)
      close << tail

      # r0 := 0 (dispatch impossible from now on); r6 also to the conventional 0
      close << (acc.zero? ? "" : a.lod(ZERO)) + a.sto(0) + a.sto(6)

      open + image_printer + close
    end

    private

    def a = QCAsm  # QCLang assembler

    RNG = -129..255  # range of values rsynth has spellings for (wider by the -1 and 128..255 that fit in registers)

    # Table of the shortest op sequences for "acc := v", seeded from the known-constant table regs
    def rsynth(regs)
      # Shortest paths over the QCAsm.num "acc := w - m*acc" chains plus lod and subtraction of known registers
      @rs[regs.sort] ||= begin
        # Seeds are 1-character values (immediates and lod of known registers); edges are subtracting known registers
        seeds = QCAsm::ALLOWED.select { |v| v >= 72 }.to_h { |v| [v, v.chr] }
        regs.each { |v, r| seeds[v] ||= a.lod(r) }
        subs = regs.reject { |v, _| v.zero? }.map { |v, r| [v, a.sub(r)] }
        # While holding the scratch, only spellings that do not use the scratch can be built
        d = shortest(seeds) { |w| subs.map { |k, t| [w - k, t] } }
        # acc := w - m*acc (save acc to the scratch -> build w -> subtract m times)
        scr = d.flat_map { |w, t| (1..3).map { |m| [w, m, "#{a.sto(SC)}#{t}#{a.sub(SC) * m}"] } }
        c = shortest(seeds) do |u|
          subs.map { |k, t| [u - k, t] } + scr.map { |w, m, t| [w - m * u, t] }
        end
        # Ties go to the QCAsm.num spelling (the same shape as elsewhere in core lets PPM predict better)
        c.each_key { |v| t = a.num(v); c[v] = t if t.size <= c[v].size }
        c
      end
    end

    # From the seeds { value => spelling }, follow the edges to find the shortest spelling of each value
    def shortest(seeds)
      # An edge is "value -> [[next value, spelling to append], ..]"
      best = {}
      q = []  # buckets by spelling length; [value, spelling so far, spelling to append]
      add = ->(v, p, t) { ((q[p.size + t.size] ||= []) << [v, p, t]) if RNG.cover?(v) && !best[v] }
      seeds.each { |v, t| add[v, "", t] }
      n = 0
      while n < q.size  # additions always go into later buckets, so growing during iteration is fine
        q[n]&.each do |v, p, t|
          next if best[v]
          best[v] = p + t
          yield(v).each { |w, u| add[w, best[v], u] }
        end
        n += 1
      end
      best
    end

    # Spelling for acc := v (values listed in reg_of are not synthesized but emitted with lod)
    def val(v, reg_of = {}) = (r = reg_of[v]) ? a.lod(r) : rsynth(reg_of).fetch(v)

    def dec(r) = "#{a.lod(r)}#{a.sub(ONE)}#{a.sto(r)}"  # r -= 1

    # If the same pixel repeats RLE times or more, make it a counting loop
    RLE = 40

    # The spelling that emits an arbitrary byte sequence, and the acc afterwards
    def emit(bytes, reg_of = {}, acc = nil)
      s, lit = +"", +""

      # Additionally escape ( ), which QCAsm.esc passes through
      flush = -> { (s << a.esc(lit, [40, 41]); lit = +"") unless lit.empty? }

      # Handle runs of the same value together
      bytes.chunk_while { |x, y| x == y }.each do |r|
        v, run = r[0], r.size

        # The countdown loop count must be a value that fits in a register (the rsynth range is -129..255)
        raise "run too long: #{run} > 255 (did the physical color placement change?)" if run > 255

        if run >= RLE
          # Emit with a countdown loop (the spelling is fixed to one form; the more uniform, the better PPM predicts)
          flush.call
          s << "#{acc == run ? "" : val(run, reg_of)}#{a.sto(CNT)}(#{val(v, reg_of)}*#{dec(CNT)})"
          acc = 0  # the countdown loop exits with acc = 0
        elsif (32..126).cover?(v)
          run.times { lit << v.chr }
        else
          flush.call
          s << (acc == v ? "" : val(v, reg_of)) + "*" * run  # * does not clobber acc
          acc = v
        end
      end
      flush.call
      [s, acc]
    end
  end
end

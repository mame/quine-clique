# Build the Quine Clique core
#
# The entry point is src/qc.rb.gen.rb; this file holds the machinery.
#
# See docs/internal.md for the design and the vocabulary.

# Assembler for QCLang code
module QCAsm
  # Bytes allowed in the core
  ALLOWED  = ((32..126).to_a - [34, 39, 92]).freeze
  OK       = Array.new(256) { |v| ALLOWED.include?(v) }.freeze  # indexable form

  module_function

  def sto(n) = (48 + n).chr
  def lod(n) = (56 + n).chr
  def sub(n) = (64 + n).chr

  # Return a QCLang literal !.../ that prints the given text
  def esc(s, extra = [])
    return "" if s.empty?
    "!" + s.bytes.map { |v|
      next v.chr if OK[v] && v != 47 && v != 72 && !extra.include?(v)
      raise "literal byte #{v} cannot be escaped (H#{(v + 33).chr})" unless OK[v + 33]
      "H" + (v + 33).chr
    }.join + "/"
  end

  IMM  = (72..126).select { |v| OK[v] }.freeze
  MEMO = {}
  # Shortest spelling of acc := v (register 7 is the scratch)
  def num(v, c = 8)
    return nil if c < 1 || v.abs > 255
    return v.chr if v >= 72 && OK[v]
    m = MEMO[c] ||= {}
    return m[v] if m.key?(v)
    best = nil
    (1..2).each do |k|
      IMM.each do |d|
        next unless (d - v) % k == 0
        t = num((d - v) / k, c - 2 - k)  # build V = (d-v)/k, then d - V*k = v
        best = t + sto(7) + d.chr + sub(7) * k if t && (best.nil? || t.size + 2 + k < best.size)
      end
    end
    m[v] = best
  end

  # The range num must cover (a gap would surface as a nil far away, so stop here)
  (-129..255).each { |v| num(v) || raise("num #{v} cannot be synthesized") }

  # Split total = r + q * b (r in 0..255, q+1 and b in 1..255) so that the spelling total
  # num(r) + num(q+1) + num(b) is shortest; returns [b, q, r] (shared by the two-level counters)
  def counter_split(total)
    best = nil
    (1..255).each do |b|
      qmin = [((total - 255).to_f / b).ceil, 0].max
      (qmin..[total / b, 254].min).each do |q|
        r = total - q * b
        c = num(r).size + num(q + 1).size + num(b).size
        best = [c, b, q, r] if best.nil? || c < best[0]
      end
    end
    raise "counter_split: #{total} does not fit in two levels" unless best
    best[1..]
  end

  # Return a two-level counter that repeats body total times
  def counted_loop(total, body, lo:, hi:, one:)
    # Register one must already hold 1.  Split total = r + q*b and run
    #
    #   lo := r; hi := q+1
    #   hi ( lo ( body; lo-- ) lo := b; hi-- )
    #
    # The outer loop runs q+1 times; the inner runs r times first, then b times: r + q*b in total.
    dec = ->(r) { lod(r) + sub(one) + sto(r) }
    if total <= 255
      one = num(total) + sto(lo) + lod(lo) + "(" + body + dec[lo] + ")"
      return [body * total, one].min_by(&:size)
    end
    b, q, r = counter_split(total)
    num(r) + sto(lo) + num(q + 1) + sto(hi) + lod(hi) + "(" +
      lod(lo) + "(" + body + dec[lo] + ")" +
      num(b) + sto(lo) + dec[hi] + ")"
  end

  # Validate QCLang code
  def check!(b)
    bad = b.bytes.reject { |v| OK[v] }.uniq
    raise "core has bytes outside the alphabet: #{bad.inspect}" unless bad.empty?
    raise "core contains a Ruby interpolation hazard" if b =~ /#[{$@]/
    seg = b.split(%r{(!(?:H.|[^/H])*/)}m)
    core = seg.each_slice(2).map(&:first)
    raise "unterminated literal" if core.any? { |t| t.include?("!") }
    bad = core.join.bytes.uniq.reject { |c| [38, 40, 41, 42, *48..126].include?(c) }
    raise "unassigned opcode: #{bad.map(&:chr).inspect}" unless bad.empty?
    raise "no parenthesis may directly follow (" if core.any? { |t| t =~ /\([()]/ }
    st = []
    seg.each_with_index do |t, k|
      kind = k.odd? ? :lit : :code
      t.each_char do |ch|
        st << kind if ch == "("
        raise "paren matching disagrees with naive scanning (unbalanced parens in a literal)" if
          ch == ")" && st.pop != kind
      end
    end
    raise "unbalanced ( (#{st.size} left open)" unless st.empty?
  end
end

# PPM compression (escape estimation generalizes Method D)
class PPMCompressor
  # A strict mirror of the expander in templates/tmpl.rb (change both or neither)

  # Output symbols (the 90 characters that may appear as zcore digits)
  DIGITS = ((33..126).to_a - [34, 39, 92, 126]).freeze

  # Maximum context order
  MAXORD = 9

  # Weight of one symbol of count c (to sum at once, pass the count total as c and the symbol count as n)
  def weight(c, n = 1) = 11 * c - 5 * n

  # Escape weight (higher orders should estimate it lighter)
  def esc_weight(o) = 32 - 3 * o

  # One symbol counts as INC
  INC = 3

  def pinc(o) = (o + 1) / 2  # priming counts one symbol heavier at higher orders
  PORD = 1                   # priming updates from order 1 (order 0 is skipped; its 1-symbol distribution tells nothing)

  # An order-d context is keyed by 95**d + the last d symbols of the history
  POW  = (-1..MAXORD).map { |d| 95**d }.freeze

  # The history is never read past order MAXORD
  SMOD = POW[MAXORD + 1]

  # Table of what followed one context, and how often
  class Ctx
    attr_reader :counts

    def initialize
      @sum = 0      # count total
      @counts = []  # [symbol, count, symbol, count, ...] (symbols ascending)
    end

    # Count total and number of the symbols not in the exclusion set x
    def totals(x)
      return [@sum, @counts.size >> 1] if x.zero?
      sum = c = 0
      i = 0
      n = @counts.size
      while i < n
        (sum += @counts[i + 1]; c += 1) if x[@counts[i]].zero?
        i += 2
      end
      [sum, c]
    end

    # Bit set of the symbols seen
    def mask
      m = 0
      i = 0
      n = @counts.size
      while i < n
        m |= 1 << @counts[i]
        i += 2
      end
      m
    end

    # Count symbol y n times
    def bump(y, n)
      @sum += n
      i = 0
      i += 2 while (j = @counts[i]) && j < y
      if j == y
        @counts[i + 1] += n
      else
        @counts.insert(i, y, n)
      end
    end
  end

  def initialize(bytes, prime: nil)
    @bytes = bytes
    # Order -1 is a context that pretends to have seen all 95 symbols equally
    # The 3 absent symbols (" ' \\) stay in (excluding them costs 24 bytes of expander, a worse deal)
    ctx = Ctx.new
    95.times { |y| ctx.bump(y, 99) }
    @h = { POW[0] => ctx }
    @s = 0
    if prime
      # Warm the model with the tmpl.rb source (the history s is not rewound)
      prime.each { |bv| update(bv - 32, PORD, nil) if QCAsm::OK[bv] }
    end
  end

  # Record symbol y into the order o..MAXORD contexts, inc each (pinc(order) if nil), and push it onto history s
  def update(y, o, inc = INC)
    o.upto(MAXORD) do |d|
      t = POW[d + 1]
      (@h[t + @s % t] ||= Ctx.new).bump(y, inc || pinc(d))
    end
    @s = (@s * 95 + y) % SMOD
  end

  def compress
    # PPM compression: encode bytes as an interval [low, low+w) inside [0, 1)
    # low = ls[0]*90**-1 + ls[1]*90**-2 + ... (w is on the same scale; one tick is 90**-|ls|)
    ls = []
    w = 1
    @bytes.each do |bv|
      QCAsm::OK[bv] or raise "byte #{bv} (#{bv.chr.inspect}) not in source alphabet"
      y = bv - 32
      d = MAXORD + 1  # context order
      x = 0  # exclusion set (a 95-bit integer)
      loop do
        t = POW[d]
        d -= 1
        e = @h[t + @s % t]
        next unless e
        # Give each non-excluded symbol its weight, and escape esc_weight(d) x the symbol count;
        # m is the former's sum, and the interval's total width is m + v
        esc = esc_weight(d)
        cs = e.counts
        sum, n = e.totals(x)
        m = weight(sum, n)
        v = n * esc
        next if v.zero?
        # Normalize where the decoder does (width below 1e7: scale by 90 and add a digit)
        while w < 1e7
          ls << 0
          w *= 90
        end
        # If the total width exceeded w, r would be 0 and the decoder would break
        raise "range coder: total width #{m + v} does not fit in width #{w}" if m + v > w
        r = w / (m + v)
        # One scan picks up both the cumulative weight below y and y's own slot
        cum = 0
        i = 0
        while (j = cs[i]) && j < y
          cum += weight(cs[i + 1]) if x[j].zero?
          i += 2
        end
        if (found = j == y && x[y].zero?)
          fr = weight(cs[i + 1])
        else
          # escape (add this context's symbols to the exclusion set and drop one order)
          cum = m
          fr = v
          x |= e.mask
        end
        # Narrow the interval to [low + r*cum, low + r*(cum+fr))
        c = r * cum
        i = ls.size - 1
        while c > 0
          c += ls[i]
          ls[i] = c % 90
          c /= 90
          i -= 1
        end
        w = r * fr
        break if found
      end
      # Record from the found order upward and push onto the history (keys rebuild from @s)
      update(y, d)
    end

    # Emit most significant first, using the DIGITS characters
    ls.map { |d| DIGITS[d] }.pack("C*")
  end
end

# The ASCII-art stencil and the qc.rb geometry it determines
class Geometry
  FZCORE_OPEN = "D='"

  # Run-length bytes fall within 40..91, safe inside any language's string literal
  RUN_LEN_BIAS = 39
  MAX_RUN      = 52

  def initialize(path)
    @rows = File.readlines(File.join(__dir__, path), chomp: true)
    @width = @rows[0].size
    raise "stencil: ragged rows (all rows must be width #{@width})" unless @rows.all? { |r| r.size == @width }
    raise "stencil: run-length bytes leave the alphabet" unless
      (RUN_LEN_BIAS + 1..RUN_LEN_BIAS + MAX_RUN).all? { |v| QCAsm::OK[v] }
    @spaces = @rows.join.count(" ")
    @space_rle_bytes = @rows.sum { |r| r.scan(/ {1,#{MAX_RUN}}/).size } * 2
  end

  def fzcore_len_from_zcore_len(zcore_len)
    # Add the stencil's spaces and newlines
    zcore_len + @spaces + (FZCORE_OPEN.size + zcore_len + @spaces) / @width
  end

  def efzcore_len_from_zcore_len(zcore_len)
    # Replace the space runs inside fzcore with their run-length codes
    fzcore_len_from_zcore_len(zcore_len) - @spaces + @space_rle_bytes
  end

  # Return the two qc.rb code fragments that sandwich the zcore (tail = text kept at the end of the last row)
  def source_wrapper(source, entrypoint, tail = 0)
    # entrypoint is strictly increasing in |zcore|, so it inverts by binary search
    zcore_len = (0..entrypoint).bsearch { |k| efzcore_len_from_zcore_len(k) >= entrypoint }
    raise "stencil: no |zcore| corresponds to entrypoint=#{entrypoint}" unless
      zcore_len && efzcore_len_from_zcore_len(zcore_len) == entrypoint

    # The column of the closing ' (rows cycle at @width chars + 1 newline)
    quote_col = (FZCORE_OPEN.size + fzcore_len_from_zcore_len(zcore_len)) % (@width + 1)

    # The first close row spans the ' column to the row end; pile up ;s so it fits exactly
    head_len = @width - quote_col
    src = ";eval$s=%w(#{source})*\"\""
    src.prepend ";" until (src.size + tail) % @width == (head_len - 1) % @width
    src.prepend "'"  # close the fzcore
    [FZCORE_OPEN, ([src.slice!(0, head_len)] + src.scan(/.{1,#{@width}}/)).join("\n") + "\n"]
  end

  # Cross-check the finished qc.rb against the lengths the geometry arithmetic placed
  def verify!(qc, zcore, entrypoint)
    # The zcore alphabet has no ', so the first '...' is exactly the fzcore
    fzcore = qc[/'(.*?)'/m, 1]
    raise "fzcore mismatch" unless fzcore.delete(" \n") == zcore
    # tmpl.rb's g is what assembles the efzcore, so only the length is checked here
    raise "entrypoint mismatch" unless fzcore.gsub(/ {1,#{MAX_RUN}}/, "  ").size == entrypoint
  end

  # Pour open + zcore + close into the stencil to make qc.rb; tail is placed verbatim at the end of the last row
  def pour(src, tail = "")
    src = src.split.join + tail
    rows = @rows.join("\n") + "\n"
    pad = "#" * @width + "\n"
    rows = pad + rows + pad until rows.count("#") >= src.size
    rows.slice!(0, pad.size) if rows.count("#") - @width >= src.size
    raise "stencil: capacity #{rows.count("#")} != data #{src.size}" unless rows.count("#") == src.size
    qc = rows.gsub("#") { src.slice!(0, 1) }
    raise "stencil: the tail is broken up by the art" unless qc.end_with?(tail + "\n")
    qc
  end
end
GEOMETRY = Geometry.new("../stencil.txt")

# Required down here because langs.rb uses QCAsm
require_relative "langs"

# Build the core (the QCLang program that concatenates every language's arm)
class CoreBuilder
  # Start the zcore_len search SCAN below the estimate
  SCAN = (ENV["QCSCAN"] || 24).to_i

  # Try CTRY cores per zcore_len_target
  CTRY = (ENV["QCCTRY"] || 3).to_i

  # If none of the CTRY satisfies, jump zcore_len_target to the smallest |zcore| found - JBACK
  JBACK = (ENV["QCJBACK"] || 15).to_i

  def initialize(keys = Lang::MEMBERS.map(&:key))
    @langs = Lang::ARMS.select { |l| keys.include?(l::Ext) }
  end

  # Return one language's arm (from name matching through the on-match code)
  def build_arm(lang, entrypoint, core_len)
    a = QCAsm
    zero = 6  # r6 stays 0 throughout matching
    flag = 7  # r7 is the flag (initialized nonzero; cleared when matching fails)
    emit = ->(x) {
      case x
      when Array       then x.map { |y| emit[y] }.join
      when :flag_clear then a.lod(zero) + a.sto(flag)
      else x
      end
    }
    neq = ->(slot, ch, then_) {
      reg = slot == :flag ? flag : slot
      (ch == "\0" ? a.lod(reg) : a.num(ch.ord) + a.sub(reg)) + "(" + emit[then_] + ")"
    }

    # Initialize r7 to nonzero
    src = a.lod(0) + a.sto(flag)
    # Match the language name (a mismatch clears r7)
    src += emit[lang.match(&neq)]
    # If the name matched (r7 still nonzero), print the body
    src + neq[:flag, "\0", lang.source_printer(entrypoint, core_len)]
  end

  # Build the core for the given entrypoint and core_len
  def build_core(entrypoint, core_len)
    a = QCAsm

    # Prologue: if r6 is nonzero, zero r0 and r6 (after which no language name can match)
    src = a.lod(6) + "(" + a.sub(6) + a.sto(0) + a.sto(6) + ")"

    # Concatenate every language's arm
    src + @langs.map { |l| build_arm(l.new, entrypoint, core_len) }.join
  rescue Piet::Driver::PlacementFailed
    nil
  end

  # Find the core fixed point (a core whose embedded entrypoint and core_len are consistent)
  def build
    # Iterate a few times with provisional embedded values to estimate them
    core_len_est = 43_700
    zcore_len_est = 13_000
    entrypoint_est = GEOMETRY.efzcore_len_from_zcore_len(zcore_len_est)
    5.times do
      core_len_est += 1 until (core = build_core(entrypoint_est, core_len_est))
      zcore = PPMCompressor.new(
        core.bytes,
        prime: Lang::Ruby.new.source(entrypoint_est, core.size).bytes,
      ).compress
      core_len_est = core.size
      zcore_len_est = zcore.size
      entrypoint_est = GEOMETRY.efzcore_len_from_zcore_len(zcore_len_est)
    end

    # Search for the exact fixed point
    scan = SCAN
    zcore_len_target = zcore_len_est - scan
    loop do
      entrypoint_tmp = GEOMETRY.efzcore_len_from_zcore_len(zcore_len_target)

      # Try CTRY core_lens per zcore_len_target
      core_len_target = core_len_est - scan
      best_zcore_len = Float::INFINITY
      CTRY.times do
        core_tmp = nil
        loop do
          # Build a core assuming |core| = core_len_target
          if (entrypoint_tmp + core_len_target) % 3 == 0  # Piet requires |image| to be a multiple of 3
            core_tmp = build_core(entrypoint_tmp, core_len_target)

            # The core is found if it fits within core_len_target
            break if core_tmp && core_tmp.size <= core_len_target
          end
          # Otherwise grow core_len_target and retry
          core_len_target += 1
        end

        # Pad the found core with dummy instructions up to core_len_target
        core_tmp = core_tmp.dup
        core_tmp << 48.chr until core_tmp.size == core_len_target

        # Compress it; if that fits within zcore_len_target, the fixed point is found
        zcore_tmp = PPMCompressor.new(
          core_tmp.bytes,
          prime: Lang::Ruby.new.source(entrypoint_tmp, core_tmp.size).bytes,
        ).compress
        best_zcore_len = zcore_tmp.size if zcore_tmp.size < best_zcore_len
        warn "  z=#{zcore_len_target} cl=#{core_len_target} |zcore|=#{zcore_tmp.size}" if ENV["QCLOG"]

        if zcore_tmp.size <= zcore_len_target
          # Fixed point found
          QCAsm.check!(core_tmp)

          # Pad the zcore with dummy digits up to zcore_len_target
          zpad = zcore_len_target - zcore_tmp.size
          return [core_tmp, zcore_tmp + PPMCompressor::DIGITS[0].chr * zpad, entrypoint_tmp, zpad]
        end

        # Miss; try the next candidate core_len
        core_len_target += 1
      end

      # No luck; grow zcore_len_target and retry
      # The smallest |zcore| seen approximates the next feasible floor, so jump straight there
      zcore_len_target = [zcore_len_target + 1, best_zcore_len - JBACK].max
    end
  end
end

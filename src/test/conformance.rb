# Check that every member's QCLang VM satisfies the spec (the Battery section below)
# No full build: only the VM part runs, on tiny test images (entrypoint = 0, image = the program itself)
# How each source is assembled and run comes from langs.rb (test_source / Build / Run)
#
#   ruby src/test/conformance.rb            # all members
#   ruby src/test/conformance.rb zig kt     # selected members only
#   ruby src/test/conformance.rb --battery  # show the spec's expected outputs

require_relative "../lib/core_builder"

# QCVM: the reference implementation of QCLang = the sole norm of the spec (naive, template-independent)
module QCVM
  module_function

  def run(image, key, entry = 0)
    g = image.bytes
    r = [0] * 8
    key.to_s.bytes.each_with_index { |b, k| r[k % 8] = b }  # name -> logical r0..
    out = +"".b
    i = entry
    dp = 0
    a = 0
    st = []
    while (c = g[i])
      i += 1
      case
      when c == 33                        # literal !.../ (Hx -> x-33 happens only here)
        until g[i] == 47
          x = g[i]
          i += 1
          if x == 72
            x = g[i] - 33
            i += 1
          end
          out << (x & 255)
        end
        i += 1
      when c == 38                        # READ: acc := image[dp] (0 past the end; only one over-read is specified)
        a = g[dp] || 0
        dp += 1
      when c == 40                        # while-acc: if acc == 0, jump past the matching )
        if a == 0
          d = 1
          while d > 0
            d += 1 if g[i] == 40
            d -= 1 if g[i] == 41
            i += 1
          end
        else
          st << i
        end
      when c == 41 then a != 0 ? i = st[-1] : st.pop
      when c == 42 then out << (a & 255)  # output (specified for acc 0..255 only; negatives split mod-256 VMs)
      when c < 56 then r[c % 8] = a       # store
      when c < 64 then a = r[c % 8]       # load
      when c < 72 then a -= r[c % 8]      # sub (raw integers, negatives fine; output/zero tests agree)
      else a = c                          # immediate 72..126: acc := the opcode itself
      end
    end
    out
  end
end

module Battery
  TMP = "#{__dir__}/tmp"
  Dir.mkdir(TMP) unless Dir.exist?(TMP)
  A = QCAsm

  # Member class by extension (non-member names like "x" "u" give nil = match with plain Lang)
  def self.lang(k) = Lang.subclasses.find { |l| l::Ext == k }

  # Build an arm for name key and body body (impersonates source_printer; the trailing lod(6)
  # covers the "body ends with acc = 0 and r6 = 0" convention)
  def self.arm(key, body)
    lang = (lang(key) || Lang).new(key)
    lang.define_singleton_method(:source_printer) { |*| body + A.lod(6) }
    CoreBuilder.new.build_arm(lang, 0, 0)
  end

  # Spec rows
  n = ->(v) { A.num(v) }
  q = n  # every constant is num()-synthesized
  dec0 = A.lod(0) + A.sub(1) + A.sto(0)  # r0 -= r1
  countdown3 = n[1] + A.sto(1) + n[3] + A.sto(0) +
               A.lod(0) + "(" + q[122] + "*" + dec0 + A.lod(0) + ")"
  nested = n[1] + A.sto(2) +             # outer 2 x (inner 2 'a') + 'b'
           n[2] + A.sto(0) + A.lod(0) + "(" +
             n[2] + A.sto(1) + A.lod(1) + "(" + q[97] + "*" +
               A.lod(1) + A.sub(2) + A.sto(1) + A.lod(1) + ")" +
             q[98] + "*" +
             A.lod(0) + A.sub(2) + A.sto(0) + A.lod(0) + ")"
  cnests = n[1] + A.sto(3) +
           QCAsm.counted_loop(260, q[120] + "*", lo: 0, hi: 1, one: 3)  # 'x' x 260 (two-level counter)
  disp   = Battery.arm("x", "!hi/") + Battery.arm("y", "!yo/")
  # A short name must not falsely hit a longer name that has it as a prefix (terminator check)
  prefix = Battery.arm("u", "!U/") + Battery.arm("uvw", "!W/")
  # c/cpp and js/ts each take two names on one arm; cppx / tsx must be rejected
  alias2 = Battery.arm("c", "!C/") + Battery.arm("js", "!J/")
  six    = Battery.arm("g", "!g/") + Battery.arm("groovy", "!G/")
  # A name with a digit needs constant synthesis (scratch r6) during matching
  digit  = Battery.arm("f90", "!F/") + Battery.arm("groovy", "!G/")

  # [label, program (= image), key]
  ROWS = [
    ["literal",        "!ab/",                                            "x"],
    ["lit-escapes",    "!aH+bHFcHIdHJeHEf/",                              "x"],  # \n % ( ) $
    ["lit-raw-amp-sp", "!a& b/",                                          "x"],
    ["imm-direct",     "H*" + 126.chr + "*",                              "x"],  # both ends of the immediates, 72/126
    ["imm-span",       (72..126).reject { |v| [92, 123, 125].include?(v) }
                               .map { |v| v.chr + "*" }.join,             "x"],
    ["imm-synth",      n[40] + "*" + n[66] + "*",                       "x"],  # below 67 is synthesized
    ["sto-lod-8regs",  (0..7).map { |k| q[65 + k] + A.sto(k) }.join +
                       (0..7).map { |k| A.lod(k) + "*" }.join,            "x"],
    ["sub",            q[97] + A.sto(0) + q[122] + A.sub(0) + "*",      "x"],  # 25
    ["sub-neg-loop",   q[97] + A.sto(0) + q[33] + A.sub(0) +
                       "(" + "!N/" + A.lod(0) + A.sub(0) + ")" + "!e/",   "x"],
    ["num-0-1-126",    n[0] + "*" + n[1] + "*" + n[126] + "*",         "x"],
    ["countdown",      countdown3,                                        "x"],
    ["skip-nested",    n[0] + "(" + "!x/" + "(" + "!y/" + ")" + ")" + "!ok/", "x"],
    ["nested-loops",   nested,                                            "x"],
    ["counted-nests",  cnests,                                            "x"],
    ["read-first",     "&*",                                              "x"],
    ["read-advance",   "&!/&*",                                           "x"],
    ["self-copy",      "&(*&)!-/",                                        "x"],
    ["self-copy-esc",  "!aH+/&(*&)",                                      "x"],
    ["dispatch-x",     disp,                                              "x"],
    ["dispatch-y",     disp,                                              "y"],
    ["dispatch-miss",  disp,                                              "z"],
    ["prefix-short",   prefix,                                            "u"],
    ["prefix-long",    prefix,                                            "uvw"],
    ["alias-c",        alias2,                                            "c"],
    ["alias-cpp",      alias2,                                            "cpp"],
    ["alias-cppx",     alias2,                                            "cppx"],
    ["alias-js",       alias2,                                            "js"],
    ["alias-ts",       alias2,                                            "ts"],
    ["alias-tsx",      alias2,                                            "tsx"],
    ["name-6char-g",   six,                                               "g"],
    ["name-6char-gvy", six,                                               "groovy"],
    ["digit-name-f90", digit,                                             "f90"],
    ["digit-name-gvy", digit,                                             "groovy"],
    ["out-high",       [126, 127, 128, 200, 254, 255].map { |v| A.num(v) + "*" }.join, "x"],
  ].freeze

  ROWS.each { |_, code, _| A.check!(code) }  # each row must itself satisfy the code invariants

  EXPECTED = ROWS.map { |_, code, key| QCVM.run(code, key) }.freeze
end

# --battery: show each row's expected output
if ARGV.first == "--battery"
  Battery::ROWS.each_with_index do |(label, _, key), idx|
    puts "%2d %-15s key=%-7s %s" % [idx, label, key.inspect, Battery::EXPECTED[idx].inspect]
  end
  exit
end

TMP = Battery::TMP
Dir.mkdir("#{TMP}/build") unless Dir.exist?("#{TMP}/build")
# bf's Build refers to vendor/, so make it visible from TMP
File.symlink("../../../vendor", "#{TMP}/vendor") unless File.symlink?("#{TMP}/vendor")

# Runaway guard: a broken VM may print forever, so wrap in timeout (a healthy run is instant)
def run_cmd(cmd, limit: 10)
  out = IO.popen("timeout #{limit} #{cmd}", "r+", err: "#{TMP}/err", chdir: TMP) { |io|
    io.close_write
    io.read(1 << 20)  # output cap 1MB (avoids being read-blocked by a runaway)
  }
  [out.to_s.b, $?.success?]
end

def subst(cmd, key, src, bin)
  c = cmd.gsub("SRC", src).gsub("BIN", bin)
  key ? c.gsub("KEY", key) : c.gsub("KEY", "").rstrip
end

# Assemble member name's VM via test_source (langs.rb) and check all spec rows + the default-key row
def member(name)
  m = Lang::MEMBERS.find { |x| x.key == name }
  lang = Battery.lang(name).new
  rows = Battery::ROWS.zip(Battery::EXPECTED) +
         [[["default-key", Battery.arm(lang.class::Alias || name, "!ok/") + Battery.arm("x", "!no/"), nil], "ok"]]
  fails = 0
  rows.each_with_index do |((label, code, key), expected), idx|
    File.write("#{TMP}/qc.#{name}", lang.test_source(code))
    # Compilation gets its own limit (zig takes 6-9 s, kt more; squeezing into 10 s gives false negatives under load)
    _, built = m.build ? run_cmd(subst(m.build, key, "qc.#{name}", "build/#{name}"), limit: 180) : [nil, true]
    got, ok = built ? run_cmd(subst(m.run, key, "qc.#{name}", "build/#{name}")) : ["(compile failed)", false]
    next if ok && got == expected.b
    fails += 1
    puts "FAIL #{name} ##{idx} #{label}: key=#{key.inspect}"
    puts "  want: #{expected.b.inspect[0, 120]}"
    puts "  got:  #{got.inspect[0, 120]}#{ok ? "" : "  (exit NG; see #{TMP}/err)"}"
  end
  puts(fails.zero? ? "#{name}: #{rows.size} checks passed" : "#{name}: #{fails} FAILURES")
  fails.zero?
end

# Aliases share the primary's file; bef / ws / piet / unl have no template
targets = ARGV.empty? ? Lang::MEMBERS.map(&:key).reject { |k| Battery.lang(k)::Alias } - %w[bef ws piet unl] : ARGV
bad = targets - Lang::MEMBERS.map(&:key)
abort "unknown member(s): #{bad.join(", ")}" unless bad.empty?
exit targets.map { |name| member(name) }.all?

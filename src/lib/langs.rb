# Generators for the languages that cannot use a handwritten template
require_relative "esolangs/bf"
require_relative "esolangs/bef"
require_relative "esolangs/ws"
require_relative "esolangs/piet"
require_relative "esolangs/unl"

# One member = one class (the member table and the arm order are at the bottom: ARMS / MEMBERS)
#
#   Ext      extension = the member's key = the name that dispatch matches
#   Name     the language name shown in README
#   Comment  what a template comment line starts with
#   Apt      Ubuntu package name
#   Build    how to compile, when compilation is needed
#   Run      how to run (the caller fills SRC / BIN / KEY)
#   Alias    when one arm serves two names
#   Out      the file name the member is saved as (default qc.<Ext>)
class Lang
  # Defaults for attributes left unwritten
  Alias = nil
  Apt   = nil
  Build = nil
  Out   = nil

  def initialize(key = self.class::Ext)
    @key = key
  end
  attr_reader :key

  RAW_TEMPLATES = {}

  # Return the member's source, the template with <QCConst> filled in (<QCImage/> is left as is)
  def source(entrypoint, core_len)
    raw = RAW_TEMPLATES[@key] ||= process_template(
      File.readlines(File.join(__dir__, "../templates", "tmpl.#{self.class::Ext}"))
          .reject { |l| l.strip.start_with?(self.class::Comment) }
    )
    raw.gsub(%r{<QCConst>(\w+)</QCConst>}) {
      case $1
      when "newline"    then "\n"
      when "entrypoint" then entrypoint.to_s
      when "core_len"   then core_len.to_s
      when "image_len"  then (entrypoint + core_len).to_s
      else raise "unknown constant: #{$1}"
      end
    }
  end

  # For conformance: a runnable source with image = the program itself and entrypoint = 0
  def test_source(image) = source(0, image.bytesize).gsub("<QCImage/>") { image_literal(image) }
  # How image text is embedded (languages that need escaping override this)
  def image_literal(image) = image

  # (customization point) Process the template
  def process_template(lines)
    # By default, drop newlines and indentation (a space goes only between adjacent alphanumerics)
    ls = lines.map(&:strip).reject(&:empty?)
    ls.each_with_index.map { |l, i|
      nxt = ls[i + 1]
      l + (nxt && l[-1] =~ /[A-Za-z0-9_]/ && nxt[0] =~ /[A-Za-z0-9_]/ ? " " : "")
    }.join
  end

  # (customization point) Build the QCLang fragment that matches the name placed in r0..r5
  def match(&neq)
    raise "name too long (max 6): #{key}" if key.size > 6
    raise "name needs a synthesized char: #{key}" if key.bytes.any? { |c| QCAsm.num(c).size > 1 }
    # 6-char names put no terminator check (r6 == 0); the guard at the core head covers it
    (key.size < 6 ? key + "\0" : key).chars.map.with_index { |ch, i| neq[i, ch, :flag_clear] }
  end

  # (customization point) The QCLang placed in the image hole; the default is self-copy
  def image_printer = "&(*&)"

  # (customization point) Build the QCLang fragment that prints the member's source
  def source_printer(entrypoint, core_len)
    open, close = source(entrypoint, core_len).split("<QCImage/>", -1).map { |t| QCAsm.esc(t) }
    open + image_printer + close
  end

  # ---- Language definitions ----

  class Ruby < Lang
    Ext     = "rb"
    Name    = "Ruby"
    Comment = "#"
    Apt     = "ruby"
    Run     = "ruby SRC KEY"
    Trailer = "# Copyright (c) 2026 Yusuke Endoh (@mametter), @hirekoke"  # the end of the last row

    # The two texts sandwiching the zcore: qc.rb = bootstrap[0] ++ fzcore ++ bootstrap[1]
    def bootstrap(entrypoint, core_len)
      GEOMETRY.source_wrapper(source(entrypoint, core_len), entrypoint, Trailer.size)
    end

    # For conformance: feed a raw image to the VM part, same text as $s (the PPM expander is outside the spec)
    def test_source(image)
      src = source(0, 0)
      cut = src.index("i=0;a=p=c=0") or raise "rb template: VM marker not found"
      "g=#{image.bytes.inspect};" + src[cut..]
    end

    def source_printer(entrypoint, core_len)
      open, close = bootstrap(entrypoint, core_len)
      # Read the image's efzcore byte by byte and assemble qc.rb's fzcore: '~' becomes a
      # newline, a space-run RLE (space + length) becomes that many spaces, digits pass through.
      # An RLE is 2 bytes, so the length byte leaves a "just saw a space" flag in r6 for the next turn
      # Registers: r0=byte r1/r2=counters r3=32 r4=length bias r5=1 r6=spaces left r7=flag
      a = QCAsm
      z0 = a.lod(0) + a.sub(0)  # acc := 0 (to exit branches)
      # r6 (spaces left) is guaranteed 0 at body start, so it is not initialized
      s2 = a.num(32) + a.sto(3) + a.num(Geometry::RUN_LEN_BIAS) + a.sto(4) +
           a.num(1) + a.sto(5)
      # After the space-printing loop r6 is always 0, so later branch exits need only the
      # 1-byte lod(6) (sole exception: the space-run RLE branch right after r6 := 1)
      z6 = a.lod(6)
      body = +""
      body << "&" + a.sto(0)                                          # r0 := image[dp++]
      body << a.lod(6) + "(" + a.lod(0) + a.sub(4) + a.sto(6) +
              z0 + a.sto(0) + ")"                                     # continuing an RLE: the space count
      body << a.lod(6) + "(" + a.lod(3) + "*" +
              a.lod(6) + a.sub(5) + a.sto(6) + ")"                    # print that many spaces
      body << a.num(126) + a.sto(7) + a.sub(0) + "(" + z6 + a.sto(7) + ")"
      body << a.lod(7) + "(" + a.num(10) + "*" + z6 + a.sto(0) + ")"  # r7 != 0 iff '~' (newline)
      body << a.lod(3) + a.sto(7) + a.sub(0) + "(" + z6 + a.sto(7) + ")"
      body << a.lod(7) + "(" + a.lod(5) + a.sto(6) + z0 + a.sto(0) + ")"  # r7 != 0 iff a space-run RLE
      body << a.lod(0) + "(" + a.lod(0) + "*" + z6 + ")"              # none of those: pass through
      s2 << QCAsm.counted_loop(entrypoint, body, lo: 1, hi: 2, one: 5)  # entrypoint times
      s2 << z6 + a.sto(0)  # r0 := 0 (no more matches after this)
      QCAsm.esc(open) + s2 + QCAsm.esc(close.chomp + Trailer + "\n")
    end

    # The rb template's code part; the same form also feeds the PPM priming sequence
    def source(entrypoint, core_len)
      t = super
      # No backslash: the %w join would take it as an escape, and the decoder priming's
      # tr set %("') assumes no backslash ever appears in $s
      raise "rb template core must not contain a backslash" if t.include?("\\")
      # No spaces: %w(...)*"" would drop them, shrinking the data and shifting the geometry
      # remainder. conformance hits source directly and would pass; it would only surface in
      # a full build, as a stencil capacity mismatch
      raise "rb template core must not contain whitespace" if t =~ /\s/
      t
    end
  end

  class Python < Lang
    Ext     = "py"
    Name    = "Python"
    Comment = "#"
    Apt     = "python3"
    Run     = "python3 SRC KEY"

    # Indentation is significant; keep it
    def process_template(lines) = lines.reject { |l| l.strip.empty? }.join
  end

  class JavaScript < Lang
    Ext     = "js"
    Name    = "JavaScript"
    Comment = "//"
    Apt     = "nodejs"
    Run     = "node SRC KEY"

    # Matches both js and ts
    def match(&neq)
      [neq[0, ?j, neq[0, ?t, :flag_clear]],
       neq[1, ?s, :flag_clear],
       neq[2, ?\0, :flag_clear]]
    end
  end

  class TypeScript < Lang
    Alias = "js"
    Ext   = "ts"
    Name  = "TypeScript"
    Apt   = "node-typescript"
    Build = "tsc --typeRoots $(node -p \"require('path').resolve(" \
            "require.resolve('@types/node/package.json'),'../..')\") " \
            "--types node --outFile BIN.js SRC"
    Run   = "node BIN.js KEY"
  end

  class Perl < Lang
    Ext     = "pl"
    Name    = "Perl"
    Comment = "#"
    Apt     = "perl"
    Run     = "perl SRC KEY"
  end

  class PHP < Lang
    Ext     = "php"
    Name    = "PHP"
    Comment = "#"
    Apt     = "php-cli"
    Run     = "php SRC KEY"
  end

  class Lua < Lang
    Ext     = "lua"
    Name    = "Lua"
    Comment = "--"
    Apt     = "lua5.3"
    Run     = "lua5.3 SRC KEY"
  end

  class R < Lang
    Ext     = "r"
    Name    = "R"
    Comment = "#"
    Apt     = "r-base"
    Run     = "Rscript SRC KEY"
  end

  class Bash < Lang
    Ext     = "bash"
    Name    = "Bash"
    Comment = "#"
    Apt     = "bash"
    Run     = "bash SRC KEY"
  end

  class Scheme < Lang
    Ext     = "scm"
    Name    = "Scheme"
    Comment = ";"
    Apt     = "guile-3.0"
    Run     = "guile --no-auto-compile -s SRC KEY"
  end

  class Tcl < Lang
    Ext     = "tcl"
    Name    = "Tcl"
    Comment = "#"
    Apt     = "tcl"
    Run     = "tclsh SRC KEY"

    # For conformance: the same escaping image_printer does, done on the text
    def image_literal(image) = image.gsub(/[\[$]/) { "\\#{$&}" }

    # Inside the string literal, insert a backslash before '[' and '$' (escaping)
    def image_printer
      a = QCAsm
      b = 1
      zero = a.lod(6)  # acc := 0 (r6 stays 0)
      # r7 is num's scratch, so the synthesized 36 doubles as the flag
      "&(" + a.sto(b) + a.num(36) + a.sto(7) + a.sub(b) +
        "(" + a.num(91) + a.sub(b) +
          "(" + zero + a.sto(7) + ")" + ")" +  # clear the flag unless b is '$' or '['
        a.lod(7) + "(" + a.esc("\\") + zero + ")" +
        a.lod(b) + "*&)"
    end
  end

  class C < Lang
    Ext     = "c"
    Name    = "C"
    Comment = "//"
    Apt     = "gcc"
    Build   = "cc -Wno-trigraphs -o BIN SRC"
    Run     = "BIN KEY"

    # Matches both c and cpp
    def match(&neq)
      [neq[0, ?c, :flag_clear],
       neq[1, ?\0, [neq[1, ?p, :flag_clear], neq[2, ?p, :flag_clear],
                    neq[3, ?\0, :flag_clear]]]]
    end
  end

  class CPlusPlus < Lang
    Alias = "c"
    Ext   = "cpp"
    Name  = "C++"
    Apt   = "g++"
    Build = "g++ -Wno-trigraphs -o BIN SRC"
    Run   = "BIN KEY"
  end

  class Crystal < Lang
    Ext     = "cr"
    Name    = "Crystal"
    Comment = "#"
    Apt     = "crystal"
    Build   = "crystal build --no-debug -o BIN SRC"
    Run     = "BIN KEY"
  end

  class CSharp < Lang
    Ext     = "cs"
    Name    = "C#"
    Comment = "//"
    Apt     = "mono-devel"
    Build   = "mcs -out:BIN.exe SRC"
    Run     = "mono BIN.exe KEY"
  end

  class D < Lang
    Ext     = "d"
    Name    = "D"
    Comment = "//"
    Apt     = "gdc"
    Build   = "gdc -o BIN SRC"
    Run     = "BIN KEY"
  end

  class Fortran < Lang
    Ext     = "f90"
    Name    = "Fortran"
    Comment = "!"
    Apt     = "gfortran"
    Build   = "gfortran -ffree-line-length-none -o BIN SRC"
    Run     = "BIN KEY"

    # Matches f90
    def match(&neq)
      # '9' and '0' are outside the immediate range and need synthesis, which clobbers the flag r7 as scratch
      [neq[0, ?f, :flag_clear],
       neq[:flag, ?\0, [neq[1, ?9, :flag_clear],
                        neq[:flag, ?\0, [neq[2, ?0, :flag_clear], neq[3, ?\0, :flag_clear]]]]]]
    end
  end

  class Go < Lang
    Ext     = "go"
    Name    = "Go"
    Comment = "//"
    Apt     = "golang"
    Run     = "go run SRC KEY"
  end

  class Java < Lang
    Ext     = "java"
    Name    = "Java"
    Comment = "//"
    Apt     = "openjdk-25-jdk"
    Build   = "javac -d build SRC"
    Run     = "java -cp build qc KEY"
  end

  class Kotlin < Lang
    Ext     = "kt"
    Name    = "Kotlin"
    Comment = "//"
    Apt     = "kotlin"
    Build   = "env JAVA_OPTS=\"-Xmx256M -Xms32M --enable-native-access=ALL-UNNAMED --sun-misc-unsafe-memory-access=allow\" kotlinc SRC -include-runtime -d BIN.jar"
    Run     = "java -jar BIN.jar KEY"

    # Inside the string literal, insert a backslash before '$' (escaping)
    def image_printer
      a = QCAsm
      b = 1
      zero = a.lod(6)  # acc := 0 (r6 stays 0)
      # r7 is num's scratch, so the synthesized 36 doubles as the flag
      "&(" + a.sto(b) + a.num(36) + a.sto(7) + a.sub(b) +
        "(" + zero + a.sto(7) + ")" +  # clear the flag if b != '$'
        a.lod(7) + "(" + a.esc("\\") + zero + ")" +
        a.lod(b) + "*&)"
    end
  end

  class Nim < Lang
    Ext     = "nim"
    Name    = "Nim"
    Comment = "#"
    Apt     = "nim"
    Build   = "nim c -d:release --hints:off -o:BIN SRC"
    Run     = "BIN KEY"

    # Indentation is significant; keep it
    def process_template(lines) = lines.reject { |l| l.strip.empty? }.join
  end

  class Pascal < Lang
    Ext     = "pas"
    Name    = "Pascal"
    Comment = "//"
    Apt     = "fp-compiler"
    Build   = "fpc -oBIN SRC"
    Run     = "BIN KEY"
  end

  class Rust < Lang
    Ext     = "rs"
    Name    = "Rust"
    Comment = "//"
    Apt     = "rustc"
    Build   = "rustc -o BIN SRC"
    Run     = "BIN KEY"
  end

  class Swift < Lang
    Ext     = "swift"
    Name    = "Swift"
    Comment = "//"
    Apt     = "swiftlang"
    Build   = "swiftc -o BIN SRC"
    Run     = "BIN KEY"
  end

  class Zig < Lang
    Ext     = "zig"
    Name    = "Zig"
    Comment = "//"
    Apt     = "zig"
    Build   = "zig build-exe -femit-bin=BIN -O Debug SRC"
    Run     = "BIN KEY"
  end

  class Clojure < Lang
    Ext     = "clj"
    Name    = "Clojure"
    Comment = ";"
    Apt     = "clojure"
    Run     = "clojure SRC KEY"
  end

  class Groovy < Lang
    Ext     = "groovy"
    Name    = "Groovy"
    Comment = "//"
    Apt     = "groovy"
    Run     = "groovy SRC KEY"
  end

  class OCaml < Lang
    Ext     = "ml"
    Name    = "OCaml"
    Comment = "(*"
    Apt     = "ocaml"
    Run     = "ocaml SRC KEY"
  end

  class Elixir < Lang
    Ext     = "exs"
    Name    = "Elixir"
    Comment = "#"
    Apt     = "elixir"
    Run     = "elixir SRC KEY"
  end

  class Forth < Lang
    Ext     = "fs"
    Name    = "Forth"
    Comment = "\\"
    Apt     = "gforth"
    Run     = "gforth SRC KEY"

    # Replace newlines with spaces
    def process_template(lines) = lines.map(&:strip).reject(&:empty?).join(" ")
  end

  class CommonLisp < Lang
    Ext     = "lisp"
    Name    = "Common Lisp"
    Comment = ";"
    Apt     = "clisp"
    # Pin the external format with -E iso-8859-1 so that write-char emits 1 char = 1 byte
    Run     = "clisp -E iso-8859-1 SRC KEY"
  end

  class Octave < Lang
    Ext     = "octave"
    Name    = "Octave"
    Comment = "%"
    Apt     = "octave"
    # Octave resolves scripts by basename, so start it where qc.m (Objective-C) is absent
    Run     = "sh -c 'mkdir -p build;cd build;exec octave -qf ../SRC KEY'"
  end

  class CoffeeScript < Lang
    Ext     = "coffee"
    Name    = "CoffeeScript"
    Comment = "#"
    Apt     = "coffeescript"
    Run     = "coffee SRC KEY"

    # Indentation is significant; keep it
    def process_template(lines) = lines.reject { |l| l.strip.empty? }.join
  end

  class Vala < Lang
    Ext     = "vala"
    Name    = "Vala"
    Comment = "//"
    Apt     = "valac"
    Build   = "valac -o BIN SRC"
    Run     = "BIN KEY"
  end

  class Haxe < Lang
    Ext     = "hx"
    Name    = "Haxe"
    Comment = "//"
    Apt     = "haxe"
    # The type name must start uppercase, so copy the file first and hand it to -main
    Build   = "cp SRC build/Qc.hx && haxe -cp build -main Qc -neko BIN.n"
    Run     = "neko BIN.n KEY"
  end

  class Pike < Lang
    Ext     = "pike"
    Name    = "Pike"
    Comment = "//"
    Apt     = "pike8.0"
    Run     = "pike SRC KEY"
  end

  class FSharp < Lang
    Ext     = "fsx"
    Name    = "F#"
    Comment = "//"
    Apt     = "dotnet-sdk-10.0"
    Run     = "dotnet fsi SRC KEY"
  end

  class Awk < Lang
    Ext     = "awk"
    Name    = "AWK"
    Comment = "#"
    Apt     = "gawk"
    # gawk turns %c into locale-dependent multibyte, so run it under the C locale
    Run     = "env LC_ALL=C awk -f SRC KEY"

    # mawk / nawk reject string literals over 8KB, so break them with "" every 126 bytes
    def image_printer
      a = QCAsm
      b, cnt, one, flg = 3, 4, 5, 7
      zero = a.lod(6)  # acc := 0 (r6 stays 0)
      a.num(1) + a.sto(one) + a.num(126) + a.sto(cnt) +
        "&" + a.sto(b) + "(" + "*" +
        a.lod(cnt) + a.sub(one) + a.sto(cnt) +  # one fewer digit remaining
        a.lod(one) + a.sto(flg) +
        a.lod(cnt) + "(" + zero + a.sto(flg) + ")" +  # clear the flag if digits remain
        a.lod(flg) + "(" + a.esc(%q("")) +
          a.num(126) + a.sto(cnt) + zero + ")" +
        "&" + a.sto(b) + ")"
    end
  end

  class Erlang < Lang
    Ext     = "erl"
    Name    = "Erlang"
    Comment = "%"
    Apt     = "erlang"
    Run     = "escript SRC KEY"
  end

  class Prolog < Lang
    Ext     = "prolog"
    Name    = "Prolog"
    Comment = "%"
    Apt     = "swi-prolog"
    # --no-threads: at halt the gc thread sometimes refuses to die, and the unflushed output is lost
    Run     = "swipl --no-threads -O SRC KEY"
  end

  class PostScript < Lang
    Ext     = "ps"
    Name    = "PostScript"
    Comment = "%"
    Apt     = "ghostscript"
    Run     = "gs -q -dNODISPLAY -dBATCH -- SRC KEY"
  end

  class Haskell < Lang
    Ext     = "hs"
    Name    = "Haskell"
    Comment = "--"
    Apt     = "ghc"
    Build   = "ghc -outputdir BIN.d -o BIN SRC"
    Run     = "BIN KEY"
  end

  class StandardML < Lang
    Ext     = "sml"
    Name    = "Standard ML"
    Comment = "(*"
    Apt     = "mlton"
    Build   = "mlton -output BIN SRC"
    Run     = "BIN KEY"
  end

  class Racket < Lang
    Ext     = "rkt"
    Name    = "Racket"
    Comment = ";"
    Apt     = "racket"
    Run     = "racket SRC KEY"
  end

  class Scala < Lang
    Ext     = "scala"
    Name    = "Scala"
    Comment = "//"
    Apt     = "scala"
    Run     = "scala -nc SRC KEY"
  end

  class ObjectiveC < Lang
    Ext     = "m"
    Name    = "Objective-C"
    Comment = "//"
    Apt     = "gobjc"
    Build   = "gcc -Wno-trigraphs -o BIN SRC"
    Run     = "BIN KEY"
  end

  class Brainfuck < Lang
    Ext  = "bf"
    Name = "brainfuck"
    Apt  = "gcc"
    Run  = "echo KEY | vendor/bin/bf SRC"

    def source_printer(entrypoint, core_len) = ::Brainfuck::Generator.new.source_printer(entrypoint, core_len)

    # For conformance: no template, so assemble GLUE + E(image) + DRIVER directly
    def test_source(image)
      open, close = ::Brainfuck::Driver.new.build(0)
      e = +open
      e << ">" * ::Brainfuck::Driver::M << "+" << "<" * ::Brainfuck::Driver::M  # the entry = 0 mark goes on frame 1
      image.bytes.each { |c| e << "+" * (c - 31) << ">" * ::Brainfuck::Driver::W }
      e << close
    end
  end

  class Befunge < Lang
    Ext  = "bef"
    Name = "Befunge"
    Run  = "echo KEY | vendor/bin/bef SRC"

    def source_printer(entrypoint, core_len) = ::Befunge::Generator.new.source_printer(entrypoint, core_len)
  end

  class Whitespace < Lang
    Ext  = "ws"
    Name = "Whitespace"
    Apt  = "libgmp-dev"  # numbers are bignums, so ws.c rides on GMP
    Run  = "echo KEY | vendor/bin/ws SRC"

    def source_printer(entrypoint, core_len) = ::Whitespace::Generator.new.source_printer(entrypoint, core_len)
  end

  class Piet < Lang
    Ext  = "piet"
    Name = "Piet"
    Out  = "qc.piet.gif"
    Apt  = "libgif-dev"  # piet.c reads the GIF via giflib, like npiet
    Run  = "echo KEY | vendor/bin/piet SRC"

    def self.generator = @generator ||= ::Piet::Generator.new

    def source_printer(entrypoint, core_len) = self.class.generator.source_printer(entrypoint, core_len)
  end

  class Unlambda < Lang
    Ext  = "unl"
    Name = "Unlambda"
    Apt  = "gcc"
    Run  = "echo KEY | vendor/bin/unl -h 40000000 SRC"

    def self.generator = @generator ||= ::Unlambda::Generator.new

    def source_printer(entrypoint, core_len) = self.class.generator.source_printer(entrypoint, core_len)
  end
end

# Build the member table after every subclass is defined
class Lang
  all = subclasses

  # Arm order in the core (the order PPM compresses best = similar arms adjacent)
  ARMS = %w[
    clj lisp rkt rs c scala f90 scm r lua go ps vala pike pas kt m ml hs zig sml
    octave groovy ws coffee swift py fs nim fsx tcl bf java php bash d pl exs rb
    js erl cs prolog cr unl hx bef awk piet
  ].map { |k| all.find { |l| l::Ext == k } or raise "ARMS: no such member: #{k}" }
  raise "ARMS is missing an arm-bearing member" unless ARMS.size == all.count { |l| !l::Alias }

  # Info for the Makefile
  Member = Struct.new(:key, :name, :file, :apt, :build, :run)
  MEMBERS = ARMS.flat_map { |l| [l, *all.select { |m| m::Alias == l::Ext }] }
                .map { |l| Member.new(l::Ext, l::Name, l::Out || "qc.#{l::Ext}", l::Apt, l::Build, l::Run) }
end

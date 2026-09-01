# Generator for qc.unl (the QCLang VM written in Unlambda)
#
# The design is in the Unlambda section of docs/esolangs.md
#
# VM: the QCLang interpreter written in a custom DSL
# Src: turns the DSL into an AST
# Typecheck: simple type check of the DSL
# AST: the AST of the DSL (labels are strings)
# IR: the AST converted to an SKI basis (labels are Symbols)
# Driver: compiles the VM written in the custom DSL into SKI text
# Generator: builds the QCLang code that outputs qc.unl
module Unlambda
  # The QCLang interpreter in a custom DSL
  VM = -> do
    %i[pair cons element probe slot leaf rest ledger rctx nfold env fix fn].each { |n|
      Object.const_set(n.to_s.capitalize, Src::TypeName.new(n)) }

    # Type definitions
    Res    = :result                             # result of the whole program (not observable)
    Num    = Cons[Element]                       # VM numbers (described below)
    Data   = Cons[Num]                           # the sequence read by &
    Regs   = Cons[Num]                           # the 8 registers
    Church = Fn[[Fn[[:A], :A], :A], :A]          # Church numeral \f x. f^n x
    Sel3   = Fn[[Fn[[:A], :A], :A, :A], :A]      # projection choosing among 3 (pos / zero / neg)

    # Compile phase: read the image bytes and build up the Step function
    Step   = Fn[[Num, Regs, Data], Res]          # executes one QCLang instruction; args are (acc, regs, dp)
    Lstk   = Cons[Step]                          # stack piling up "the instruction that ')' returns to"
    Maker  = Fn[[Step, Slot, Num, Step], Step]   # makes Step; args (return step, register, accumulator, next step)
    Lstkop = Fn[[Lstk, Step], Lstk]              # function operating on the return-target stack
    Comp   = Fn[[Rest], Rest]                    # in-progress data of the image build (Step, data, return stack)
    Dg     = Fn[[:any, :any], :any]              # digit; selects one of two (i is 1, k is 0)

    # Init phase: read stdin and build up the registers
    Chars  = Fn[[Data], Data]                    # data accumulating the characters read by read_name
    Done   = Fn[[Regs], Res]                     # continuation taking the register list in read_name
    Escape = Fn[[Chars], Res]                    # continuation escaping the read_name loop
    Again  = Fn[[Chars, Rctx], Res]              # rest of the reading loop
    Walk   = Fn[[Num, Rctx, Again, Chars], Res]  # find_char itself (for recursion)

    # Run phase: instructions with side effects
    Prn    = Fn[[:A], :A]                        # printer (prints, then returns its argument)
    Mat    = Fn[[:A], :A]                        # matcher; ?c acts as i on a hit and v on a miss

    # Pairs and lists
    type Pair[:A, :B], { fst: :A, snd: :B }
    type Cons[:A], { hd: :A, tl: Cons[:A] }
    let([second: Fn[[:A, :B], :B]]) { fun(a: :A, b: :B) { b } }  # projection choosing the 2nd of a pair (`ki)

    # A value (Num) is represented as a sequence of Elements.
    # An Element is a tuple (printer: Prn, matcher: Mat, under: Element, sel3: Sel3):
    # it holds the printer and matcher of char code N, a reference to the Element of N-1, and the sign of N.
    # A Num is a sequence of Elements; Num k has the shape (Elem k::Elem k+1::Elem k+2::...).
    # Num + 1 is the List's tl, and Num - 1 can be computed as cons(v.hd.under, v).
    type Probe, { under: Element, matcher: Mat }
    type Element, { entry: Pair[Sel3, Prn], dig: Probe }
    let([sign: Sel3], v: Num) { v.hd.entry.fst }
    let([printer: Prn], v: Num) { v.hd.entry.snd }
    let([dec: Num], v: Num) { cons(v.hd.dig.under, v) }
    let([inc: Num], v: Num) { v.tl }
    rec([subn: Num], b: Num, a: Num) {  # subtraction a - b
      let([sub_pos: Num], b: Num, f: Fn[[Num, Num], Num], a: Num) { f[dec[b], dec[a]] }
      let([sub_zero: Num], b: Num, f: Fn[[Num, Num], Num], a: Num) { a }
      let([sub_neg: Num], b: Num, f: Fn[[Num, Num], Num], a: Num) { f[b.tl, a.tl] }
      b.sign[fun(z: Fn[[Num, Fn[[Num, Num], Num], Num], Num]) { sub_pos }, sub_zero, sub_neg][b, subn, a]
    }

    # Register selector: a (getter, setter) pair
    type Slot, { getter: Fn[[Regs], Num], setter: Fn[[Num, Regs], Regs] }

    # Instruction evaluators: take the current return target, register selector, opcode, and next step to make a Step
    let([make_imm: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # immediate instruction
      fun(acc: Num, regs: Regs, dp: Data) { cont[v, regs, dp] }
    }
    let([make_nop: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # does nothing; used for zcore part, '!', '/'
      fun(acc: Num, regs: Regs, dp: Data) { cont[acc, regs, dp] }
    }
    let([make_lit: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # print v as is
      fun(acc: Num, regs: Regs, dp: Data) { cont[v.printer[acc], regs, dp] }
    }
    let([make_esc: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # print v-33
      fun(acc: Num, regs: Regs, dp: Data) { cont[church(16)[dec, church(16)[dec, v.dec]].printer[acc], regs, dp] }
    }
    let([make_out: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # '*': print acc
      fun(acc: Num, regs: Regs, dp: Data) { cont[acc.printer[acc], regs, dp] }
    }
    let([make_sto: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # '0'..'7': write acc to a register
      fun(acc: Num, regs: Regs, dp: Data) { cont[acc, sl.setter[acc, regs], dp] }
    }
    let([make_lod: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # '8'..'?': read a register into acc
      fun(acc: Num, regs: Regs, dp: Data) { cont[sl.getter[regs], regs, dp] }
    }
    let([make_sub: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # '@'..'G': subtract a register from acc
      fun(acc: Num, regs: Regs, dp: Data) { cont[subn[sl.getter[regs], acc], regs, dp] }
    }
    let([make_rd: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # '&': read one from the data sequence
      fun(acc: Num, regs: Regs, dp: Data) { cont[dp.hd, regs, dp.tl] }
    }
    let([make_rp: Fn[[Num, Regs, Data], Fn[[Step], Res]]], after: Step, sl: Slot, v: Num, cont: Step) {  # ')': entry fn
      fun(acc: Num, regs: Regs, dp: Data) { fun(h: Step) { h[acc, regs, dp] } }
    }
    let([enter_inner: Step], l: Step, body: Step) {  # enter the subsequence (the ')' function returns to loop head l)
      fun(acc: Num, regs: Regs, dp: Data) { body[acc, regs, dp][l] }
    }
    let([make_lp: Step], after: Step, sl: Slot, v: Num, cont: Step) {  # '(': start of a loop
      rec([lp: Res], acc: Num, regs: Regs, dp: Data) {
        # if acc == 0, exit to after; if acc != 0, enter the loop body
        acc.sign[raw(?i), after, enter_inner[lp, cont]][acc, regs, dp]
      }
    }

    # Read the string on stdin and build up the list of 8 registers
    type Rctx, { start: Num, escape: Escape }
    # Search Nums from 0 upward for one matching the char read by '@' (call rc.escape on discovery)
    rec([find_char: Res], cand: Num, rc: Rctx, again: Again, chars: Chars) {
      let([find_char_hit: Res], cand: Num, rc: Rctx, again: Again, chars: Chars) {
        again[fun(x: Data) { chars[cons(cand, x)] }, rc] }
      let([find_char_end: Escape], walk: Walk, cand: Num, rc: Rctx, again: Again) { rc.escape }
      let([find_char_cmp: Escape], walk: Walk, cand: Num, rc: Rctx, again: Again) { fun(chars: Chars) {
        cand.hd.dig.matcher[raw(?i)][fun(c: Rctx, g: Again, r: Chars) { find_char_hit[cand, c, g, r] }, rc, again, chars][
          walk[cand.inc, rc, again, chars]]
      } }
      cand.sign[raw(?i), find_char_end, find_char_cmp][find_char, cand, rc, again][chars]
    }
    # Call '@' and find_char the current character
    rec([read_name_loop: Res], chars: Chars, rc: Rctx) {
      let([read_name_scan: Res], rc: Rctx, again: Again, chars: Chars) { find_char[rc.start.inc, rc, again, chars] }
      raw(?@)[raw(?i)][read_name_scan, rc, read_name_loop, chars][rc.escape[chars]]
    }
    # Perform the reading of the language name
    let([read_name_start: Res], cs: Num, done: Done) {
      # append a list of eight 0s, and call the continuation done with it as the registers
      let([read_name_fin: Res], v0: Num, done: Done, chars: Chars) {
        done[chars[church(8)[fun(l: Data) { cons(v0, l) }, raw(?k)]]]
      }
      # default language name "unl" used when none is given
      let([default_key: Chars], v0: Num) {
        let(:m) { church(108)[inc, v0] }
        (let(:n) { church(2)[inc, m] }
         fun(x: Data) { cons(church(7)[inc, n], cons(n, cons(m, x))) })
      }
      # if even one character was read, use it; if none was read, use the default
      let([read_name_default: Data], dk: Chars, l: Data) { l.hd.sign[raw(?i), dk[l], l] }
      # actually perform the read
      read_name_loop[fun(l: Data) { read_name_default[default_key[cs], l] },
                     rctx(cs, fun(chars: Chars) { read_name_fin[cs, done, chars] })]
    }
    let([read_name: Regs], cs: Num) { raw(?c)[fun(done: Done) { read_name_start[cs, done] }] }

    # In-progress data while building from the image bytes
    type Ledger, { lstack: Lstk, data: Data }
    type Rest, { link: Ledger, step: Step }
    # Building Step etc. from the image bytes is complete, so enter language-name reading + the main loop
    let([run: Res], comp: Comp, cs: Num) {
      # result built from the image bytes: all.step is the compiled function, all.link.data the data sequence
      let(:all) { comp[rest(ledger(raw(?k), raw(?k)[cs]), raw(?v))] }

      # build up the register list for the language name given by cs, and pass it to all.step
      fun(regs: Regs) { all.step[cs, regs, all.link.data] }[read_name[cs]]
    }

    # Building from the image bytes (each byte is represented as a redundant 11 bits)
    type Nfold, { weight: Church, nums: Cons[Church] }    # temp data for building a Church numeral
    type Fix, { load_byte_rec: Fn[[Env], Res], v0: Num }  # ref to load_byte for recursive calls, and the constant 0
    type Env, { base: Fix, comp: Comp }                   # ... and the in-progress data
    type Leaf, { lstk: Lstkop, mk: Maker }                # leaf data of class_tree
    # Build a 7-bit value into Church numerals: weight := weight * 2; nums := cons(weight, nums.hd + weight * bit)
    let([value_step: Nfold], nf: Nfold, d: Dg) {
      let([cdouble: Church], w: Church) { fun(f: Fn[[:A], :A], x: :A) { w[f, w[f, x]] } }
      let([cadd: Church], n: Church, w: Church) { fun(f: Fn[[:A], :A], x: :A) { n[f, w[f, x]] } }
      nfold(cdouble[nf.weight], cons(d[raw(?k), raw(?i)][nf.nums.hd, cadd[nf.nums.hd, nf.weight]], nf.nums))
    }
    # Locate a leaf of the class_tree from 4 bits
    let([cls_step: :any], node: Pair[:A, :A], d: Dg) { node[d[raw(?k), raw(?i)]] }
    # The sentinel arrived, so building is done; move on to execution
    let([image_end: Res], lk: Comp, e: Env) { run[e.comp, e.base.v0] }
    # Recursively call load_byte
    let([next_byte: Res], lk: Comp, e: Env) {
      e.base.load_byte_rec[env(e.base, fun(r: Rest) { e.comp[lk[r]] })]
    }
    # Build one byte of the image into the Comp
    let([process_byte: Comp], lf: Leaf, v: Num, sl: Slot) {
      fun(tail: Rest) {
        # lf.lstk: pushes/pops the return-target stack (push at '(', pop at ')')
        # lf.mk: makes a Step from the return target, register, opcode, and next step
        rest(ledger(lf.lstk[tail.link.lstack, tail.step], cons(v, tail.link.data)),
             lf.mk[tail.link.lstack.hd, sl, v, tail.step])
      }
    }
    # Build the image bytes into the Comp
    let([load_byte: Res], e: Env) {
      # functions operating on the return-target stack
      let([lstk_keep: Lstk], ls: Lstk, ns: Step) { ls }
      let([lstk_pop: Lstk], ls: Lstk, ns: Step) { ls.tl }
      let([lstk_push: Lstk], ls: Lstk, ns: Step) { cons(ns, ls) }

      # class_tree: the binary tree matching the 4 class bits
      let(:cls_nop) { leaf(lstk_keep, make_nop) }  # "!", "/", "H", and every byte before the entrypoint
      let(:cls_lit) { leaf(lstk_keep, make_lit) }  # bytes inside a literal
      let(:cls_esc) { leaf(lstk_keep, make_esc) }  # right after "H": print v-33
      let(:cls_out) { leaf(lstk_keep, make_out) }  # "*"
      let(:cls_sto) { leaf(lstk_keep, make_sto) }  # "0".."7"
      let(:cls_lod) { leaf(lstk_keep, make_lod) }  # "8".."?"
      let(:cls_sub) { leaf(lstk_keep, make_sub) }  # "@".."G"
      let(:cls_imm) { leaf(lstk_keep, make_imm) }  # 72..126 (code mode)
      let(:cls_rd) { leaf(lstk_keep, make_rd) }    # "&"
      let(:cls_lp) { leaf(lstk_pop, make_lp) }     # "("
      let(:cls_rp) { leaf(lstk_push, make_rp) }    # ")"
      let(:cls0_3) { pair(pair(cls_nop, cls_lit), pair(cls_esc, cls_out)) }
      let(:cls4_7) { pair(pair(cls_sto, cls_lod), pair(cls_sub, cls_imm)) }
      let(:cls8_11) { pair(pair(cls_rd, cls_lp), pair(cls_rp, cls_rp)) }  # 11 is a copy of 10
      let(:class_tree) { pair(pair(cls0_3, cls4_7), pair(cls8_11, cls8_11)) }

      # make the register selector from the low 3 bits of the opcode
      let([mk_slot: Slot], sl: Slot) {
        slot(fun(t: Regs) { sl.getter[t.tl] },
            fun(v: Num, t: Regs) { cons(t.hd, sl.setter[v, t.tl]) })
      }

      # read 4 bits, then 7 bits, then advance the computation by one byte
      let([digit: Fn[[Fn[[:any], Res]], Fn[[:any], :any]]], step: Fn[[:any, Dg], :any]) {
        fun(g: Fn[[:any], Res]) { fun(st: :any) { fun(d: Dg) { g[step[st, d]] } } }
      }
      church(4)[digit[cls_step], fun(lf: Leaf) {
        church(7)[digit[value_step], fun(nf: Nfold) {
          let(:sl) { nf.nums.tl.tl.tl.tl.hd[mk_slot, slot(hd, fun(v: Num, t: Regs) { cons(v, t.tl) })] }
          let(:v) { nf.nums.hd[inc, e.base.v0] }
          v.sign[raw(?i), image_end, next_byte][process_byte[lf, v, sl], e]
        }][nfold(raw(?i), raw(?k)[second])]
      }][class_tree]
    }

    # Starting point for loading the image data
    let([boot: Res], el: Fn[[Element], Num]) {
      let(:zero) { church(256)[inc, el[raw(?i)]] }
      let(:b) { fix(load_byte, zero) }
      b.load_byte_rec[env(b, raw(?i))]
    }

    # Read 513 eatoms (256..-256) and build up the sequence of Nums
    let([eat_entry: Fn[[Fn[[Element], Num]], :any]], h: Fn[[Fn[[Element], Num]], Res]) {
      fun(acc: Fn[[Element], Num]) {
        fun(q: Mat, x: Pair[Sel3, Prn]) {
          h[fun(under: Element) { let(:y) { element(x, probe(under, q)) }; cons(y, acc[y]) }]
        }
      }
    }

    let([main: Res]) { church(513)[eat_entry, boot][raw(?i)] }
  end

  # Convert the DSL above into an AST (see module AST for the AST definition)
  module Src
    # Name of a type. Type arguments can be given as in Pair[:A, :B]; written bare, it is an argument-less type
    class TypeName
      def initialize(n) = @n = n
      def [](*a) = [@n, *a]
      def to_sym = @n
    end

    # Value of an expression. Postfix x.f becomes an application of a var here
    class W
      attr_reader :f
      def initialize(f) = @f = f
      def [](*a) = W.new(["app", @f, *a.map { |x| x.f }])
      def method_missing(name, *a)
        a.empty? ? W.new(["app", ["var", name.to_s], @f]) : super
      end
      def respond_to_missing?(_, _ = false) = true
    end

    def forms = (@forms ||= {})  # name -> body (AST); held by build's o

    module_function

    # Run the DSL block and return forms (name -> AST)
    def build(&blk)
      o = Object.new
      o.extend(Src)
      o.instance_exec(&blk)
      o.forms
    end

    # Type tables (for Typecheck)
    %i[field_type type_fields type_vars param_type ret_type lambda_type owner].each do |n|
      define_method(n) { (@tabs ||= {})[n] ||= {} }
      module_function n
    end
    def cur = @cur                 # name of the def being built (nil = top level)
    def locals = (@locals ||= [])  # record of local lets per block

    # Types are normalized when entered into tables (bare TypeName -> [:name]; Typecheck sees only normal forms)
    def canon_type(t)
      case t
      when TypeName then [t.to_sym]
      when Array
        t[0] == :fn ? [:fn, t[1].map { |x| canon_type(x) }, canon_type(t[2])] :
                      [t[0], *t[1..].map { |x| canon_type(x) }]
      else t
      end
    end

    # Split a declaration [name: return type]
    def decl(a)
      raise "write a declaration as let([name: return type], param: type, ..)" unless
        a.is_a?(Array) && a.size == 1 && a[0].is_a?(Hash) && a[0].size == 1
      k, v = a[0].first
      [k.to_s, v]
    end

    # Names and types go on the declaration; blocks are arg-less. let(:x) { e } is a local binding (let x = e in rest)
    def let(name, **ps, &blk)
      return Src.local(name, blk) if name.is_a?(Symbol)
      Src.top(self, name, ps, blk)
    end

    # A function that references itself
    def rec(name, **ps, &blk)
      return Src.top(self, name, ps, blk, rec: true) if Src.cur.nil?
      n, ret = Src.decl(name)
      W.new(["rec", n, Src.fform(blk, ps, n, ret)])
    end

    # Reference to a def. Forward references and undefined names become vars here (expand rejects nonexistent names)
    def method_missing(name, *a)
      w = W.new(["var", name.to_s])
      a.empty? ? w : w[*a]
    end
    def respond_to_missing?(_, _ = false) = true

    def fun(**ps, &blk) = W.new(Src.fform(blk, ps, nil, nil))
    def church(n) = W.new(["church", n])
    def raw(c) = W.new(["raw", c])

    # Pair construction
    def mkpair(a, b) = a == b ? ["app", ["raw", "k"], a] :
      ["app", ["raw", "s"], ["app", ["raw", "s"], ["raw", "i"], ["app", ["raw", "k"], a]], ["app", ["raw", "k"], b]]

    # Record type declaration
    def type(name, fields)
      name, vars = name.is_a?(Array) ? [name[0], name[1..]] : [name.to_sym, []]
      raise "type #{name} takes 2 fields (split nesting into separate types)" unless fields.size == 2
      raise "the ctor of type #{name} collides with field #{name}" if Src.owner[name.to_s]
      fields.each_key { |f| raise "field #{f} collides with the ctor of type #{f}" if Src.type_fields[f.to_s] }
      fields.each { |f, t| Src.field_type[f.to_s] = Src.canon_type(t) }
      fields.each_key { |f| (Src.owner[f.to_s] ||= []) << name.to_s }
      Src.type_fields[name.to_s] = fields.keys.map(&:to_s)
      Src.type_vars[name.to_s] = vars
      fields.keys.each_with_index do |fs, j|
        f = fs.to_s
        g = ["fun", ["r"], ["value", ["app", ["var", "r"], j.zero? ? ["raw", "k"] : ["var", "second"]]]]
        raise "field #{f} comes on a different side in #{name}" if forms[f] && forms[f] != g
        forms[f] = g
        singleton_class.define_method(f) { |*vs| w = W.new(["var", f]); vs.empty? ? w : w[*vs] }
      end
      singleton_class.define_method(name) { |a, b| W.new(Src.mkpair(a.f, b.f)) }
      name.to_s
    end

    # Run the block to get the body AST
    def fform(blk, pst, n, ret)
      raise "no parameters in the block of #{n || @cur} (write them with types on the declaration side)" unless
        blk.parameters.empty?
      ps = pst.keys.map(&:to_s)
      ps.each { |q| raise "param #{q} of #{n || @cur} collides with a Ruby method" if Object.new.respond_to?(q, true) }
      ts = ps.zip(pst.values.map { |t| canon_type(t) }).to_h
      lambda_type[[n || @cur, ps]] = ts
      if n then ret_type[n] = canon_type(ret); param_type[n] = ts end
      locals << []
      body = blk.call.f
      locals.pop.reverse_each { |nm, rhs| body = ["let", nm, rhs, body] }
      ps.empty? ? body : ["fun", ps, body]
    end

    # Local let. Record the value and return a var; fform wraps the rest of the block in a let
    def local(name, blk)
      raise "write a local let(:#{name}) inside a block" if locals.empty?
      locals.last << [name.to_s, blk.call.f]
      W.new(["var", name.to_s])
    end

    # Mark projections out of record types as side-effect-free
    def mark_values(t, fs = type_fields.values.flatten)
      return t unless t.is_a?(Array) && t[0].is_a?(String)
      u = [t[0], *t[1..].map { |x| mark_values(x, fs) }]
      u[0] == "app" && u.size == 3 && u[1][0] == "var" && u[2][0] != "app" &&
        fs.include?(u[1][1]) ? ["value", u] : u
    end

    # Register one top-level def
    def top(m, name, ps, blk, rec: false)
      n, ret = decl(name)
      raise "#{n} is defined twice" if m.forms.key?(n)
      old, @cur = @cur, n
      f = mark_values(fform(blk, ps, n, ret))
      m.forms[n] = rec ? ["rec", n, f] : f
      m.singleton_class.define_method(n) { |*a| w = W.new(["var", n]); a.empty? ? w : w[*a] }
      n
    ensure
      @cur = old
    end
  end

  # Simple type check
  module Typecheck
    module_function

    class Bad < StandardError; end
    def bad!(*info) = raise(Bad, info.inspect)

    def var?(t) = t.is_a?(Symbol) && t.to_s.start_with?(/[A-Z]/)
    def fn?(t)  = t.is_a?(Array) && t[0] == :fn

    # Map only the type variables with the block (subst / fresh / skolem / skolems are all instances of this)
    def map_vars(t, &blk)
      return blk.(t) if var?(t)
      return t unless t.is_a?(Array)
      fn?(t) ? [:fn, t[1].map { |x| map_vars(x, &blk) }, map_vars(t[2], &blk)] :
               [t[0], *t[1..].map { |x| map_vars(x, &blk) }]
    end

    def subst(t, map) = map_vars(t) { |v| resolve(v, map) }

    # A type variable follows its binding chain to a representative (:A!1 -> :A -> concrete type)
    def resolve(t, map)
      8.times { break unless var?(t) && map[t] && map[t] != t; t = map[t] }  # ad hoc
      t
    end

    # Match up types while binding type variables
    def unify(p, a, map)
      p, a = resolve(p, map), resolve(a, map)
      return if p == :any || a == :any || p == a
      return map[p] = a if var?(p)
      return map[a] = p if var?(a)
      if fn?(p) || fn?(a)
        bad!(p, a) unless fn?(p) && fn?(a)
        if p[1].size == a[1].size
          p[1].zip(a[1]).each { |x, y| unify(x, y, map) }
          unify(p[2], a[2], map)
        elsif [p[2], a[2]].any? { |x| x == :any }
          [p[1].size, a[1].size].min.times { |i| unify(p[1][i], a[1][i], map) }
        else
          bad!(p, a)  # argument and parameter counts do not match
        end
      elsif p.is_a?(Array) && a.is_a?(Array)
        bad!(p, a) unless p[0] == a[0]
        p[1..].zip(a[1..]).each { |x, y| unify(x, y, map) if y }
      elsif p != a
        bad!(p, a)
      end
    end

    # Apply arguments to a function type
    def apply(t, args)
      return t if args.empty?
      return apply(t[1] == t[2] ? t[1] : :any, args[1..]) if t.is_a?(Array) && t[0] == :pair
      bad!(t, :applied) if t.is_a?(Array) && Src.type_fields[t[0].to_s]  # Res is opaque, so applying it is fine
      return :any unless fn?(t)
      bad!(t, :saturation, args.size) unless t[1].size == args.size
      map = {}
      args.size.times { |i| unify(t[1][i], args[i], map) }
      subst(t[2], map)
    end

    # Fresh type variables
    def fresh(t, seen = {}) = map_vars(t) { |v| seen[v] ||= :"#{v}!#{@gen = (@gen || 0) + 1}" }

    def skolem(t, sk) = map_vars(t) { |v| sk[v] || v }

    # Build the table replacing type variables in the def's declaration with rigid constants
    def skolems(n)
      acc = {}
      ((Src.param_type[n] || {}).values + [Src.ret_type[n]].compact)
        .each { |t| map_vars(t) { |v| acc[v] = true } }
      acc.keys.to_h { |v| [v, [:"#{v}#"]] }
    end

    def sigof(n)
      return nil unless Src.ret_type.key?(n)
      ps = Src.param_type[n] || {}
      ps.empty? ? Src.ret_type[n] : [:fn, ps.values, Src.ret_type[n]]
    end

    # Compute types while checking application saturation, printing positions, projection chains, etc.
    def type_of(f, env, where, sk = {})
      case f[0]
      when "var" then env[f[1]] || (g = sigof(f[1])) && fresh(g) || :any
      when "fun"
        lt = Src.lambda_type[[where, f[1]]] || {}
        ps = f[1].map { |q| skolem(lt[q] || :any, sk) }
        [:fn, ps, type_of(f[2], env.merge(f[1].zip(ps).to_h), where, sk)]
      when "let"
        type_of(f[3], env.merge(f[1] => type_of(f[2], env, where, sk)), where, sk)
      when "rec"
        type_of(f[2], env.merge(f[1] => sigof(f[1]) || :any), where, sk)
      when "church" then Church  # \f x. f^n x
      when "raw" then :any       # built-in (raw(?i) etc.)
      when "value" then type_of(f[1], env, where, sk)
      else  # "app"
        h = f[1]
        hn = h[0] == "var" ? h[1] : nil
        if hn && Src.owner[hn] && f.size == 3
          g = f[2]
          bad!(where, :chain, hn) if g[0] == "app" && g.size == 3 && g[1][0] == "var" &&
                                     Src.ret_type.key?(g[1][1]) && !Src.owner[g[1][1]]
          t = type_of(f[2], env, where, sk)
          rec = t.is_a?(Array) && Src.type_fields[t[0].to_s] ? t[0].to_s : nil
          bad!(hn, t) if fn?(t) || t == Res
          if rec.nil? then :any
          else
            bad!(hn, t) unless Src.owner[hn].include?(rec)
            fresh(subst(Src.field_type[hn] || :any, (Src.type_vars[rec] || []).zip(t[1..]).to_h))
          end
        else
          apply(type_of(h, env, where, sk), f[2..].map { |a| type_of(a, env, where, sk) })
        end
      end
    end

    def run(env)
      env.each do |n, f|
        sk = skolems(n)
        t = type_of(f, {}, n, sk)
        unify(skolem(sigof(n), sk), t, {}) if Src.ret_type.key?(n)
      end
      env
    end
  end

  # AST representing the VM DSL
  module AST
    # AST definition :=
    #   ["var", name]              reference to a name (def / parameter / local binding)
    # | ["raw", spelling]          place an Unlambda spelling directly
    # | ["app", f, x, ..]          application (n arguments)
    # | ["fun", [params..], body]  function
    # | ["let", name, val, body]   local binding
    # | ["rec", name, fn]          self-recursion (may reference only its own name)
    # | ["church", n]              Church numeral
    # | ["value", form]            mark saying "already a value, OK to evaluate early"

    module_function

    $gensym = 0
    def gensym(p) = "%#{p}#{$gensym += 1}"

    # Transform an AST
    def map_kids(form)
      case form[0]
      when "var", "raw", "church" then form
      when "fun"   then ["fun", form[1], yield(form[2], form[1])]
      when "rec"   then ["rec", form[1], yield(form[2], [form[1]])]
      when "let"   then ["let", form[1], yield(form[2], []), yield(form[3], [form[1]])]
      when "value" then ["value", yield(form[1], [])]
      when "app"   then ["app", *form[1..].map { |g| yield(g, []) }]
      else raise "bad form #{form.inspect}"
      end
    end

    # Replace the symbol name with the form repl
    def subst(form, name, repl)
      return form[1] == name ? repl : form if form[0] == "var"
      map_kids(form) { |g, bs| bs.include?(name) ? g : subst(g, name, repl) }
    end

    # Count how many times name occurs free
    def count_free(form, name)
      return form[1] == name ? 1 : 0 if form[0] == "var"
      n = 0
      map_kids(form) { |g, bs| n += bs.include?(name) ? 0 : count_free(g, name); g }
      n
    end

    # Rebind every binding to a fresh %p name
    def alpha(form, map = {})
      return ["var", map.fetch(form[1], form[1])] if form[0] == "var"
      nm = []
      f = map_kids(form) { |g, bs|
        nm << (bs.empty? ? map : map.merge(bs.to_h { |b| [b, gensym("p")] }))
        alpha(g, nm[-1]) }
      case form[0]
      when "fun" then ["fun", form[1].map { |b| nm[0][b] }, f[2]]
      when "app", "value", "raw" then f
      else raise "bad form #{form.inspect}"  # already desugared, so no let / rec here
      end
    end

    # May an argument be dropped or duplicated? Everything but an application is a value
    def value?(form) = form[0] != "app"

    # Size estimate (to bound duplication)
    def size(form)
      case form[0]
      when "var"   then 1
      when "raw"   then form[1].size
      when "fun"   then 4 + size(form[2])
      when "value" then size(form[1])
      when "app"   then form[1..].sum { |g| size(g) } + form.size - 2
      else raise "bad form #{form.inspect}"
      end
    end

    # Detect self-application
    def self_app?(f) = f[0] == "app" && f.size == 3 && f[1] == f[2] && f[1][0] == "var"

    # Spellings of Church numerals
    CHURCH = {
      2 => "``s``s`kski",
      4 => "```sii``s``s`kski",
      7 => "``s``s`ksk``s``s`ksk``s``s`ksk```sii``s``s`kski",
      8 => "```s``s`ksk``s``s`kski``s``s`kski",
      16 => "```s``s`kski```sii``s``s`kski",
      108 => "````s`ksk```sii``s``s`kski```sii``s``s`ksk``s``s`kski",
      256 => "```sii```sii``s``s`kski",
      512 => "````s`ksk```sii```sii``s``s`kski``s``s`kski",
      513 => "``s``s`ksk````s`ksk```sii```sii``s``s`kski``s``s`kski",
    }.transform_values do |str|
      i = -1
      parse = -> { (c = str[i += 1]) == "`" ? ["app", parse[], parse[]] : ["raw", c] }
      parse[]
    end

    # Reduce to var / app / fun / raw / value only
    #
    #   church n                =>  the expression above
    #   let x = e in B          =>  (\x. B) e
    #   rec f = (fun ARGS . B)  =>  (\F. F F) (\s. B[f := (s s)])
    def desugar(form)
      return ["value", CHURCH.fetch(form[1])] if form[0] == "church"
      f = map_kids(form) { |g,| desugar(g) }
      case f[0]
      when "let" then ["app", ["fun", [f[1]], f[3]], f[2]]
      when "rec"
        v = gensym("s")
        inner = ["fun", [v], subst(f[2], f[1], ["app", ["var", v], ["var", v]])]
        fv = gensym("F")
        ["app", ["fun", [fv], ["app", ["var", fv], ["var", fv]]], inner]
      when "var", "app", "fun", "value", "raw" then f
      else raise "bad form #{form.inspect}"
      end
    end

    # Expand the top-level definitions, making main into one big lambda expression
    def expand(form, env, bound = [])
      if form[0] == "var" && !bound.include?(form[1])
        d = env[form[1]] or raise "unbound symbol: #{form[1]}"
        return ["value", expand(d, env)]
      end
      map_kids(form) { |g, bs| expand(g, env, bound + bs) }
    end
  end

  # Internal representation for optimizing the AST
  module IR
    # IR definition :=
    #   [:raw, text]     atom (a built-in single character)
    # | [:app, f, x]     application (always binary; n-ary AST apps nest here)
    # | [:eager, M]      mark saying "M may be treated as a value"
    # | [:var, n]        variable bound by a lambda (gone after eliminate_var)
    # | [:lam, v, body]  lambda (one parameter; gone after eliminate_var)

    module_function

    # Constructors
    def raw(s) = [:raw, s]
    def app(f, x) = [:app, f, x]
    def eager(t) = t[0] == :eager ? t : [:eager, t]  # never stack marks

    # Constructors that avoid duplicate creation
    RAWS = {}
    APPS = {}.compare_by_identity
    def iraw(s) = RAWS[s] ||= [:raw, s]
    def iapp(f, x) = (APPS[f] ||= {}.compare_by_identity)[x] ||= [:app, f, x]

    S = iraw("s")
    I = iraw("i")
    K = iraw("k")

    # Unlambda expressions without side effects
    SAFE_RE = /\A[`skiv]*\z/

    SIZE = {}.compare_by_identity
    def size(t) = SIZE[t] ||= t[0] == :app ? size(t[1]) + size(t[2]) + 1 : t[1].size

    PURE = {}.compare_by_identity  # pure = made only of s k i v
    def pure?(t) = PURE.fetch(t) { PURE[t] = t[0] == :app ? pure?(t[1]) && pure?(t[2]) : !!SAFE_RE.match?(t[1]) }

    # Build the Unlambda code string
    def text(t) = t[0] == :app ? "`" + text(t[1]) + text(t[2]) : t[1]

    # Does v occur free in t? (same role as AST's count_free)
    def free_in?(v, t)
      case t[0]
      when :var then t[1] == v
      when :app then free_in?(v, t[1]) || free_in?(v, t[2])
      when :lam then t[1] != v && free_in?(v, t[2])
      when :raw then false
      when :eager then free_in?(v, t[1])
      else raise "bad node #{t.inspect}"
      end
    end

    # For N not containing x, may \x. N be turned into `k N?
    def eager_safe?(t)
      # Dangerous if N has side effects or is in a state where evaluation could proceed.
      case t[0]
      when :raw, :var, :eager then true  # all values; combining them does nothing
      when :app
        h = t
        n = 0
        (h = h[1]; n += 1) while h[0] == :app
        (h[0] == :eager ||
         h[0] == :raw && SAFE_RE.match?(h[1]) && !(h[1] == "s" && n >= 3)) &&
          eager_safe?(t[1]) && eager_safe?(t[2])
      else raise "bad node #{t.inspect}"
      end
    end

    # May \x. F x be turned into F?
    def eta_safe?(t)
      # Dangerous if F has side effects or is in a state where evaluation could proceed.
      case t[0]
      when :raw then SAFE_RE.match?(t[1])
      when :var, :eager then true
      when :app then eta_safe?(t[1]) && eta_safe?(t[2])
      else raise "bad node #{t.inspect}"
      end
    end

    # eager_safe? / eta_safe? are not theoretically correct, and their division of labor is heuristic.
    # Being properly conservative would grow core, so tests vouch for them instead

    DUPMAX = 12

    # Replace (\x. M) N with M[x := N]
    def inline_call(form, env)
      d = form[1]
      d = d[1] while d[0] == "value"   # expanded defs arrive marked
      return nil unless d[0] == "fun"  # rec defs are not reduced (their body is an application)
      return nil if form[2..].any? { |a| AST.self_app?(a) }
      uses = d[1].map { |p| AST.count_free(d[2], p) }  # occurrences in the body per parameter
      args = form[2..]
      raise "unsaturated application: #{args.size} args (#{d[1].size} params)" unless args.size == d[1].size
      uses.each_with_index do |n, i|
        next if n == 1
        return nil unless AST.value?(args[i])
        return nil if n > 1 && (n - 1) * AST.size(args[i]) > DUPMAX
      end
      a = AST.alpha(d)
      body = args.each_with_index.inject(a[2]) { |b, (arg, i)| AST.subst(b, a[1][i], ["value", arg]) }
      from_ast(body, env)
    end

    # Convert an AST into IR
    def from_ast(form, env)
      case form[0]
      when "value"
        eager(from_ast(form[1], env))
      when "var" then env[form[1]] ? [:var, form[1]] : raise("unbound symbol: #{form[1]}")
      when "fun"
        body = from_ast(form[2], env.merge(form[1].to_h { |v| [v, true] }))
        form[1].reverse.reduce(body) { |b, v| [:lam, v, b] }
      when "raw" then [:raw, form[1]]
      when "app"
        (form.size > 2 && inline_call(form, env)) ||
          form[1..].map { |f| from_ast(f, env) }.reduce { |f, x| app(f, x) }
      else raise "bad form #{form.inspect}"
      end
    end

    # bracket abstraction (extracting the variable)
    def abstract(v, t)
      case t[0]
      when :var    then t[1] == v ? raw("i") : app(raw("k"), t)
      when :eager  then free_in?(v, t) ? abstract(v, t[1]) : app(raw("k"), t)
      when :app
        return app(raw("k"), t) if !free_in?(v, t) && eager_safe?(t)
        f, x = t[1], t[2]
        # eta: \v.`F v == F; sound when evaluating F early cannot be observed
        xe = x[0] == :eager ? x[1] : x  # marks never stack, so one level is enough
        return f if xe == [:var, v] && !free_in?(v, f) && eta_safe?(f)
        app(app(raw("s"), abstract(v, f)), abstract(v, x))
      when :raw then app(raw("k"), t)
      else raise "bad node #{t.inspect}"
      end
    end

    # Eliminate lambdas and variables
    def eliminate_var(t)
      case t[0]
      when :lam    then (a = abstract(t[1], eliminate_var(t[2])); eager_safe?(a) ? eager(a) : a)
      when :app    then app(eliminate_var(t[1]), eliminate_var(t[2]))
      when :eager  then eager(eliminate_var(t[1]))
      when :raw, :var then t
      else raise "bad node #{t.inspect}"
      end
    end

    # Intern the fully transformed tree (stripping the :eager marks along the way)
    def intern(t)
      case t[0]
      when :eager then intern(t[1])
      when :app   then iapp(intern(t[1]), intern(t[2]))
      when :raw   then iraw(t[1])
      else raise "bad node #{t.inspect}"
      end
    end

    # Alternate peephole and CSE until nothing shrinks
    def shrink(t)
      loop do
        t = Peephole.run(t)
        u = CSE.run(t)
        return t if u.equal?(t)
        t = u
      end
    end
  end

  # ---- Peephole --------------------------------------------------------------
  module Peephole
    # R1  ```s`kA X Y  ->  `A`XY        (-4)
    # R2  `(A B)(C B)  ->  ```sACB      (-|B|+1)
    # R3  `A``Y`kAC    ->  ````ssY`kAC  (-|A|+3)

    module_function

    # Rebuild from the leaves, applying the peephole rules and CANON
    def run(t)
      return t unless t[0] == :app
      m = app(run(t[1]), run(t[2]))
      CANON[m] || m
    end

    # Try applying R1 / R2 / R3
    def app(f, x)
      n = IR.iapp(f, x)
      # R1: ```s`kA X Y -> `A`XY
      if f[0] == :app && (g = f[1])[0] == :app && g[1].equal?(IR::S) &&
         (kA = g[2])[0] == :app && kA[1].equal?(IR::K)
        app(kA[2], app(f[2], x))
      elsif !IR.pure?(n)  # R2 / R3 duplicate, delete, or reorder subterms, so pure terms only
        n
      # R3: `A``Y`kAC -> ````ssY`kAC
      elsif IR.size(f) >= 5 && x[0] == :app && (q = x[1])[0] == :app &&
            (ka = q[2])[0] == :app && ka[1].equal?(IR::K) && ka[2].equal?(f)
        app(app(app(app(IR::S, IR::S), q[1]), ka), x[2])
      else
        # R2: `(A B)(C B) -> ```sACB
        lim = IR.size(n)
        best = nil
        2.times do |i|
          a, b = i.zero? ? [f[0] == :app ? f[1] : nil, f[2]] : [IR::I, f]
          next unless a
          2.times do |j|
            c, e = j.zero? ? [x[0] == :app ? x[1] : nil, x[2]] : [IR::I, x]
            next unless c && e.equal?(b)
            sz = 4 + IR.size(a) + IR.size(c) + IR.size(b)
            best = [sz, a, c, b] if sz < lim && (best.nil? || sz < best[0])
          end
        end
        best ? app(app(app(IR::S, best[1]), best[2]), best[3]) : n
      end
    end

    # Empirical normalization
    rd = ->(str, i = [-1]) { (c = str[i[0] += 1]) == "`" ? IR.iapp(rd[str, i], rd[str, i]) : IR.iraw(c) }
    CANON = {
      "``s`kk``si`k`ki"       => "``s`s`kk`k`ki",
      "```ss`si`kk"           => "``s`si`kk",
      "``s`ks``s`si`kk"       => "``s`s`s`ks`kk",
      "``s`k`si``s`si`kk"     => "``s`s`s`k`si`kk",
      "``si``sii"             => "``s`sii",
      "``s`k``sii``ss`ki"     => "```ssi``ss`ki",
      "```s``s`kski``si`k`ki" => "``s``ss`ki`k`ki",
      "``s``si`k`ki`k`ki"     => "``s``ss`ki`k`ki",
      "``s`k``sii`s``s`ksk"   => "```ssi`s``s`ksk",
      "``s`k`s`kk``si`kk"     => "``s`s`k`s`kk`kk",
      "`kv"                   => "v",
    }.to_h { |k, v| [rd[k], rd[v]] }.compare_by_identity
  end

  # Common subexpression extraction
  module CSE
    # (...M...M...) -> (\x. (...x...x...)) M

    module_function

    # Replace occurrences of subexpression c with a variable
    def mark(t, c)
      return [[:var, "%h"], true] if t.equal?(c)
      e, f = t[0] == :app ? begin
        a, af = mark(t[1], c)
        b, bf = mark(t[2], c)
        [[:app, a, b], af | bf]
      end : [t, false]
      [!f && IR.pure?(t) ? [:eager, e] : e, f]
    end

    # A common subexpression inside a subtree was extracted, so rebuild the whole tree
    def graft(t, old, new)
      return new if t.equal?(old)
      t[0] == :app ? IR.iapp(graft(t[1], old, new), graft(t[2], old, new)) : t
    end

    # Repeat the search-and-share of common subexpressions
    def run(cur)
      best_t = cur
      seen = {}.compare_by_identity  # interned, so object identity tells whether shapes match
      seen[cur] = true
      loop do
        # Tally occurrences: count how many paths reach the same object
        occ = Hash.new(0).compare_by_identity
        stack = [cur]
        until stack.empty?
          t = stack.pop
          occ[t] += 1
          stack << t[1] << t[2] if t[0] == :app
        end
        top = nil
        occ.each do |c, cnt|
          # candidates are only "pure subterms of 3+ chars appearing 2+ times"
          next unless cnt >= 2 && IR.size(c) >= 3 && IR.pure?(c)
          # the binding site is "a node whose both children contain occurrences" = where occurrences meet.
          # collect them while returning "contains c?" on the way back up the DFS
          ds = []
          meets = ->(t) do
            return true if t.equal?(c)
            return false unless t[0] == :app
            a = meets.(t[1])
            b = meets.(t[2])
            ds << t if a && b
            a || b
          end
          meets.(cur)
          # actually swap the common subexpression for a variable, redo eliminate_var, and measure the size
          ds.sort_by! { |d| IR.size(d) }.each do |d|
            node = IR.intern(IR.eliminate_var([:app, [:lam, "%h", mark(d, c)[0]], c]))
            whole = graft(cur, d, node)
            delta = IR.size(whole) - IR.size(cur)
            top = [delta, whole] if delta < 0 && (top.nil? || delta < top[0])
          end
        end
        # if there is no profitable move, finish with the smallest tree so far
        break best_t unless top
        cur = top[1]
        # coming back to the same shape means going in circles, so stop
        break best_t if seen[cur]
        seen[cur] = true
        best_t = cur if IR.size(cur) < IR.size(best_t)
      end
    end
  end

  # Build the Unlambda code of the QCLang VM
  module Driver
    def self.image(src = Typecheck.run(Src.build(&VM)))
      env = src.transform_values { |b| AST.desugar(b) }
      IR.text(IR.shrink(IR.intern(IR.eliminate_var(IR.from_ast(AST.expand(env.fetch("main"), env), {})))))
    end
  end

  # Builds the QCLang code that outputs qc.unl
  class Generator
    # Spelling of an element's (sign, printer) pair
    PAIR  = "``s``si`k"
    SIGNS = { neg: "`k`ki", zero: "`kk", pos: "k" }
    NTBL  = 513 * 2  # number of eatoms arguments (513 elements x 2)

    # Representation of the argument sequences expressing char classes
    CLS = {
      nop: 0, lit: 1, esc: 2, out: 3, sto: 4, lod: 5, sub: 6, imm: 7, rd: 8, again: 9, rp: 10
    }.transform_values do |n|
      3.downto(0).map { |b| n[b] == 1 ? "i" : "k" }.join
    end

    NARG = 4 + 7  # number of arguments per byte

    # QCLang register number assignment (r0..r7)
    C   = 3  # constant 0
    W   = 1  # entrypoint high counter (when m==3), temp for opcode comparison, etc.
    T   = 2  # current byte (receiver of &)
    P   = 0  # various uses
    ONE = 4  # constant 1
    M   = 5  # mode (0 = run / 1 = lit / 2 = esc / 3 = data)
    G   = 6  # entrypoint low counter (when m==3), branch flag for opcode comparison, etc.
    H   = 7  # scratch

    # The VM is image-independent, so build once even if the fixed-point search calls source_printer hundreds of times
    def image = @image ||= Driver.image

    # The QCLang that outputs qc.unl
    def source_printer(entrypoint, core_len)
      # Rough flow
      #
      #   print "`" * (NARG*(image_len+1) + NTBL)    # output a large run of '`'
      #   print VM                                   # output the VM body
      #   print eatoms                               # output the printers and matchers
      #   gw := entrypoint                           # entrypoint = r + q*b held in 2 registers
      #   while &:                                   # next byte into acc (0 when exhausted)
      #     case m:                                  # classify (print the 4 class digits and advance m)
      #       3 data: print nop; m = 0 if (gw -= 1) == 0
      #       2 esc:; print esc; m := 1
      #       1 lit:
      #         if "/": print nop; m := 0
      #         if "H": print nop; m := 2
      #         otherwise: print lit
      #       0 run:
      #         print CLS[t]                         # output the class matching the byte
      #   print "k" * NARG                           # terminator (one byte of value 0)
      a = QCAsm
      image_len = entrypoint + core_len
      s = +""

      # ONE := 1; M := 3; G := 10 (exploiting that R0/R1/R2 are 'u','n','l')
      s << a.num(118) + a.sub(P) + a.sto(ONE)
      s << a.num(111) + a.sub(T) + a.sto(M)
      s << a.num(120) + a.sub(W) + a.sto(G)

      # print "`" * (nbq = NARG*(image_len+1) + NTBL)
      #
      #   q, rem := nbq divmod k  # search for k and q that come out shortest
      #   q times: print "`" * k
      #   print "`" * rem
      nbq = NARG * (image_len + 1) + NTBL
      bq = ->(k) {
        q, rem = nbq.divmod(k)
        a.counted_loop(q, a.esc("`" * k), lo: P, hi: T, one: ONE) +
          (rem.zero? ? "" : a.esc("`" * rem))
      }
      kmin = (nbq / 65_025.0).ceil + 1
      s << (kmin..kmin + 32).map { |k| bq[k] }.each_with_index.min_by { |q, i| [q.size, -i] }[0]

      # print VM
      s << a.esc(image)

      # print eatoms: output 256 down to -256
      #
      #   print "v" PAIR zero "`ki"                          # top sentinel (256 but treated as zero)
      #   p := w := 255                                      # stash 255 in w for use on the negative side too
      #   while p != 10: print "?" p PAIR pos "`k." p; p--   # c = 255..11 (the guard is p - g)
      #   10 times:  print "v" PAIR pos "`k." p; p--         # c = 10..1 (chars never in names get matcher v)
      #   print "v" PAIR zero "`k." 0                        # the element of value 0 (char 0 comes from acc)
      #   255 times: print "v" PAIR neg "`kv"                # printers on the negative side are fixed to v
      #   print "vi"                                         # bottom sentinel (-256)
      s << a.num(255) + a.sto(P) + a.sto(W)  # p := w := 255

      # 256: top sentinel (sign treated as 0 since it is a sentinel)
      s << a.esc("v" + PAIR + SIGNS[:zero] + "`ki")

      # 255 -> 11
      s << "(" + a.esc("?") + a.lod(P) + "*" +
                 a.esc(PAIR + SIGNS[:pos] + "`k.") + "*" +
                 a.sub(ONE) + a.sto(P) + a.sub(G) + ")"  # G holds 10

      # 10 -> 1 (no matcher)
      s << a.lod(P) +
           "(" + a.esc("v" + PAIR + SIGNS[:pos] + "`k.") + "*" +
                 a.sub(ONE) + a.sto(P) + ")"

      # 0
      s << a.esc("v" + PAIR + SIGNS[:zero] + "`k.") + a.lod(C) + "*"

      # -1 -> -255 (no matcher/printer)
      s << a.lod(W) +
           "(" + a.esc("v" + PAIR + SIGNS[:neg] + "`kv") + a.sub(ONE) + ")"

      # -256: bottom sentinel (a complete dummy)
      s << a.esc("vi")

      # g := r; w := q + 1 (entrypoint = r + q * b).
      b, q, r = QCAsm.counter_split(entrypoint)
      r, q = b, q - 1 if r.zero?
      s << a.num(r) + a.sto(G) + a.num(q + 1) + a.sto(W)

      # Conditional branch
      # Preconditions: keep H nonnegative, put the condition in acc; the body must end with acc = 0
      ifz = ->(body) { "(" + a.lod(C) + a.sto(H) + ")" + a.lod(H) + "(" + body + ")" }

      # match condition against char v (w := h := v; acc := t - v)
      cmp = ->(v) { a.num(v) + a.sto(W) + a.sto(H) + a.lod(T) + a.sub(W) }

      # Idiom that halves t: called with p == 0, it lands in the state h = t/2, p = t%2, t = 0
      #   h := t; while t: p := 1-p; h -= p; t -= 1
      half = a.lod(T) + a.sto(H) +
             "(" + a.lod(ONE) + a.sub(P) + a.sto(P) +
                   a.lod(H) + a.sub(P) + a.sto(H) +
                   a.lod(T) + a.sub(ONE) + a.sto(T) + ")"

      # Branch for case m == 3 (data)
      #   print CLS[nop]; g--
      #   if g == 0: g := b; w--; if w == 0: m := 0
      data = a.esc(CLS[:nop]) +
             a.lod(G) + a.sto(H) + a.sub(ONE) + a.sto(G) +
             ifz[a.num(b) + a.sto(G) +
                 a.lod(W) + a.sto(H) + a.sub(ONE) + a.sto(W) +
                   ifz[a.lod(C) + a.sto(M)]]

      # Branch for case m == 2 (esc)
      #   print CLS[esc]; m := 1
      esc = a.esc(CLS[:esc]) + a.lod(ONE) + a.sto(M) + a.lod(C)

      # Branch for case m == 1 (lit)
      #   g := acc (= 1); print "kkk"
      #   cmp '/'; if acc == 0: m := 0; g := 0           # closing
      #   cmp 'H'; if acc == 0: m := 'J' - w; g := 0     # the next byte is an escape
      #   print 107 - 2g; acc := 0                       # the last digit ('k' = nop / 'i' = lit)
      lit = a.sto(G) +
            cmp[47] + ifz[a.lod(C) + a.sto(M) + a.sto(G)] +
            cmp[72] + ifz[a.num(74) + a.sub(W) + a.sto(M) + a.lod(C) + a.sto(G)] +
            a.esc("kkk") + a.num(107) + a.sub(G) + a.sub(G) + "*" +  # g==0->lit, g==1->nop
            a.lod(C)

      # Branch for case m == 0 (run)
      #   g := acc                                       # acc is nonnegative on entry
      #   cmp '!'(33); p := acc; if p == 0: print CLS[nop]; m := 1; g := 0
      #   p -= 5; if p == 0: print CLS[rd];    g := 0    # 38 "&"
      #   p -= 2; if p == 0: print CLS[again]; g := 0    # 40 "("
      #   p -= 1; if p == 0: print CLS[rp];    g := 0    # 41 ")"
      #   p -= 1; if p == 0: print CLS[out];   g := 0    # 42 "*"
      #   if g:                                          # the rest: 4-way branch on q = (t - 48) >> 3
      #     w := t; t := p - 6 (= t - 48)
      #     half; t := h; half; t := h; half; p := h     # p = q; t is restored from w
      #     if p == 0: sto / 1: lod / 2: sub / else: imm
      dlt = ->(n) { a.lod(P) + a.sto(H) + a.sub(ONE) * n + a.sto(P) }
      run = a.sto(G) +
            cmp[33] + a.sto(P) +
            ifz[a.esc(CLS[:nop]) + a.lod(ONE) + a.sto(M) + a.lod(C) + a.sto(G)] +
            dlt[5] + ifz[a.esc(CLS[:rd])  + a.lod(C) + a.sto(G)] +
            dlt[2] + ifz[a.esc(CLS[:again])  + a.lod(C) + a.sto(G)] +
            dlt[1] + ifz[a.esc(CLS[:rp])  + a.lod(C) + a.sto(G)] +
            dlt[1] + ifz[a.esc(CLS[:out]) + a.lod(C) + a.sto(G)] +
            a.lod(G) + "(" +
              a.lod(T) + a.sto(W) + a.lod(P) + a.sub(ONE) * 6 + a.sto(T) +
              a.lod(C) + a.sto(P) +
              half + a.sto(P) + a.lod(H) + a.sto(T) +
              half + a.sto(P) + a.lod(H) + a.sto(T) +
              half +
              a.lod(H) + a.sto(P) + a.lod(W) + a.sto(T) +
              a.lod(ONE) + a.sto(H) + a.lod(P) +              ifz[a.esc(CLS[:sto]) + a.lod(C) + a.sto(G)] +
              a.lod(P) + a.sto(H) + a.sub(ONE) +              ifz[a.esc(CLS[:lod]) + a.lod(C) + a.sto(G)] +
              a.lod(P) + a.sto(H) + a.sub(ONE) + a.sub(ONE) + ifz[a.esc(CLS[:sub]) + a.lod(C) + a.sto(G)] +
              a.lod(G) + "(" + a.esc(CLS[:imm]) + a.lod(C) + ")" +
            ")"

      # case m (the copy of m is p; esc = case m == 2 is written inline here: print esc; m := 1)
      classify = a.lod(M) + a.sto(H) + a.sto(P) + a.sub(ONE) * 3 + ifz[data] +
                 a.lod(P) + a.sto(H) + a.sub(ONE) * 2 + ifz[esc] +
                 a.lod(P) + a.sto(H) + a.sub(ONE) + ifz[lit] +
                 a.lod(ONE) + a.sto(H) + a.lod(P) + ifz[run]

      # Print the 7 digits of the value, LSB first
      #   t := t + 128; acc := t - 1
      #   while acc: half; print(107 - 2p); t := h; acc := h - 1
      emit = a.sub(T) + a.sto(P) + a.num(128) + a.sub(P) + a.sto(T) +
             a.sub(ONE) +
             "(" + a.lod(C) + a.sto(P) + half +
                   a.num(107) + a.sub(P) + a.sub(P) + "*" +
                   a.lod(H) + a.sto(T) + a.sub(ONE) + ")"

      # Main loop
      #  while &: t := acc; classify; emit
      s << "&(" + a.sto(T) + classify + emit + "&)"

      s << a.esc("k" * NARG)
      s
    end
  end
end

if __FILE__ == $PROGRAM_NAME  # checks DSL discipline and the VM byte count
  forms = Unlambda::Src.build(&Unlambda::VM)
  Unlambda::Typecheck.run(forms)
  puts "VM = #{Unlambda::Driver.image(forms).size} B" \
       " (rec: #{forms.select { |_, b| b[0] == "rec" }.keys.join(" ")})"
  puts "check: ok (#{Unlambda::Src.ret_type.size} type annotations / #{forms.size} defs)"
end

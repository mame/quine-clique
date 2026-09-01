# Ruby
# No whitespace inside a code line: the build concatenates all code lines and re-wraps them into
# %w(...)*"", so in-line whitespace vanishes. End every statement with ; (then a line may break
# freely after an operator). No backslashes either (%w interprets them; the build checks).
# Syntax that needs a space: " " -> 32.chr, a ? b : c -> (expr)?a:b, modifier while -> (stmt)while(cond).
# The code part is rounded up in steps of the stencil width, so once the padding runs out
# one more byte moves |core| by a whole row.
#
# This template is the code part only; line 1, D='<fzcore>';, is prepended verbatim by Lang::Ruby
# Variable names: D = fzcore, g = image

# ==== The expander: order-9 PPM (escape estimation generalizes Method D) + range coder ====
# An exact mirror of PPMCompressor in core_builder.rb; symbol = byte - 32 (92 valid of the 95: not " ' \)

# ---- the digit sequence e: zcore is one base-90 fraction, its digits tr'd onto !..z so byte-33 is the value ----
e=D.split.join.tr("!#-&()-[]-}","!-z").bytes;
w=1;
k=p;
# ---- the context table h: key 95**d + s%95**d (the 95**d offset encodes the depth); order -1 sees all 95 symbols ----
h={};
n=s=0;
h[95**-1]=[99]*95;
# ---- model update: count y in the contexts of order o..9 by k ((order+1)/2 while priming), push y onto the history s ----
u=->y,o{
  o.upto(9){t=95**_1;(h[t+s%t]||=[0]*95)[y]+=k||(_1+1)/2};
  s=(s*95+y)%95**10
};
# ---- priming: warm the model with qc.rb's own code $s before reading D (order 0 skipped; shrinks |zcore| by 3%) ----
$s.tr(%("'),"").bytes{u[_1-32,1]};
k=3;
# ---- the main decode: g = efzcore (blank runs and newlines folded, mirroring Geometry) + the decoded core ----
# per symbol, try the contexts d = 9..-1 in turn; order -1 holds every symbol, so the while always terminates
g=D.gsub(/[[:blank:]]{1,52}/){32.chr+(39+_1.size).chr}.tr(10.chr,"~").bytes+(1..<QCConst>core_len</QCConst>).map{
  y=p;
  d=10;
  x=0;
  while(!y);
    t=95**d-=1;
    b=h[t+s%t];
    if(b);
      # weights: a non-excluded symbol with count c gets 11c-5 (generalized PPM Method D)
      # m = their sum, v = (32-3d) * number of distinct symbols = the escape's weight, so the total width is m+v
      # a = prefix sums of the weights, q = bitmask of the symbols present here (recorded into x on escape)
      m=v=q=0;
      a=(0..94).map{
        (c=b[_1])>0&&(q|=2**_1;x[_1]<1&&(m+=c*11-5;v+=32-d*3));m
      };
      # v==0 means everything is excluded: pass through without narrowing the interval
      if(v>0);
        # below width 1e7, consume a digit and scale n,w by 90 (keeps them Fixnums); the leftover top w-r*(m+v) is discarded
        (n=n*90+e.shift-33;w*=90)while(w<1e7);
        f=n/(r=w/(m+v));
        if(f<m);
          # symbol region: the symbol is where the prefix sum first exceeds f
          y=a.index{f<_1};
          m=a[y]-v=b[y]*11-5;
        else;
          # escape region: record the symbols seen here into x and move on
          x|=q;
        end;
        n-=r*m;
        w=r*v;
      end;
    end;
  end;
  # the matched order is d as left by the loop (t=95**d-=1 decrements first)
  u[y,d];
  y+32
};

# ---- run the register VM from the entrypoint (spelling matches tmpl.cr, including the no-op to_i) ----
i=<QCConst>entrypoint</QCConst>;a=p=c=0;l=g.size;r=[0]*99;s=8;
# the target language name goes into logical r0.. (r[(48+k)%8] is logical rk)
z=ARGV[0]||"rb";
z.bytes.each{|x|r[c%8]=x.to_i;c+=1};
# main loop: QCLang's definition verbatim, stopping at the end of the image
(
  c=g[i];i+=1;
  c<34?(
    (c=g[i];
    i+=1;
    if(c==72);c=g[i]-33;i+=1;end;
    putc(c))while(g[i]!=47);
    i+=1
  ):c<39?(
    a=g[p]||0;
    p+=1
  ):c<41?(
    r[s]=i;s+=1;
    d=1;
    (c=g[i+=1];c>>1==20&&d+=81-2*c)while(d>0)
  ):c<42?(
    s-=1;a!=0&&(i=r[s];s+=1)
  ):c<43?
    putc(a)
  :c<56?(
    r[c%8]=a
  ):(
    a=c<64?r[c%8]:c<72?a-r[c%8]:c
  )
)while(i<l)#"One_is_the_All,_and_through_it_the_All,_and_into_it_the_All.

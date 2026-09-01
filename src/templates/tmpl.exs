# Elixir

import Process,only: [put: 2,get: 2];
defmodule Q do

  # ---- a sentinel 0 at the end removes the range guard (at most one read past the end) ----
  def b(j),do: :binary.at(<< ~S"<QCImage/>",0>>,j);

  def o(x),do: :io.put_chars([x]);

  # ---- literal output loop (the Hx -> x-33 escape happens only here) and ( ) skipping ----
  def li(i) do c=b(i);cond do c==47->i+1;c==72->o(b(i+1)-33);li(i+2);true->o(c);li(i+1) end end;
  def sk(i,d) do c=b(i+1);d=if c>39 and c<42,do: d+81-2*c,else: d;if d>0,do: sk(i+1,d),else: i+1 end;

  # ---- main loop (tail recursive; branches on ranges of c with cond) ----
  def s(i,p,a,f) do if i<<QCConst>image_len</QCConst> do c=b(i);i=i+1;cond do c<34->s(li(i),p,a,f);
    c<39->s(i,p+1,b(p),f);
    c<41->s(sk(i,1),p,a,[i|f]);
    c<42->if a==0,do: s(i,p,a,tl(f)),else: s(hd(f),p,a,f);
    c<43->o(a);s(i,p,a,f);
    c<56->put(rem(c,8),a);s(i,p,a,f);
    c<64->s(i,p,get(rem(c,8),0),f);
    c<72->s(i,p,a-get(rem(c,8),0),f);
    true->s(i,p,c,f);
  end end end end;

# ---- start: put the name into r[0..] and run from the entrypoint ----
:io.setopts([{:encoding,:latin1}]);
Enum.reduce(to_charlist(hd(System.argv++["exs"])),0,fn x,c->put(c,x);c+1 end);
Q.s(<QCConst>entrypoint</QCConst>,0,0,[])

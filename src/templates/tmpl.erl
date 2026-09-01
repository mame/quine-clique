% Erlang
% escript skips line 1 (reserved for a shebang), so start with a blank line
<QCConst>newline</QCConst>
main(V)->io:setopts([{encoding,latin1}]),
  lists:foldl(fun(G,C)->put(C,G),C+1 end,0,hd(V++["erl"])++[0,0,0,0,0,0,0,0]),
  s(<QCConst>entrypoint</QCConst>,0,0,[]).<QCConst>newline</QCConst>

% ---- read: a sentinel 0 at the end removes the range guard (at most one read past the end) ----
b(J)->binary:at(<<"<QCImage/>",0>>,J).<QCConst>newline</QCConst>

% ---- literal output loop (the Hx -> x-33 escape happens only here) and ( ) skipping ----
li(K)->C=b(K),if C==47->K+1;C==72->io:put_chars([b(K+1)-33]),li(K+2);true->io:put_chars([C]),li(K+1) end.<QCConst>newline</QCConst>
sk(K,E)->C=b(K+1),R=if C>39,C<42->E+81-2*C;true->E end,if R>0->sk(K+1,R);true->K+1 end.<QCConst>newline</QCConst>

% ---- main loop (tail recursive; branches on ranges of C with if) ----
s(K,P,A,L)->if K<<QCConst>image_len</QCConst>->C=b(K),J=K+1,
    if C<34->s(li(J),P,A,L);
      C<39->s(J,P+1,b(P),L);
      C<41->s(sk(J,1),P,A,[J|L]);
      C<42->if A==0->s(J,P,A,tl(L));true->s(hd(L),P,A,L) end;
      C<43->io:put_chars([A]),s(J,P,A,L);
      C<56->put(C rem 8,A),s(J,P,A,L);
      C<64->s(J,P,get(C rem 8),L);
      C<72->s(J,P,A-get(C rem 8),L);
      true->s(J,P,C,L) end;
    true->ok end.<QCConst>newline</QCConst>

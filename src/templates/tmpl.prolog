% Prolog
% ---- optimization comes from -O in Run (applies to the whole file; faster than an in-source directive) ----
:- initialization(main,main).<QCConst>newline</QCConst>

% ---- registers are the arguments of the compound term R; writes use nb_setarg/3 (10x faster than flag/3) ----
% names are at most 6 chars, so the 1-based index of string_code/3 can be passed as is
main(V):-set_stream(user_output,type(binary)),
  append(V,[prolog],[S|_]),
  R=r(0,0,0,0,0,0,0,0),
  forall(string_code(Q,S,B),nb_setarg(Q,R,B)),
  string_codes("<QCImage/>",G),
  length(E,<QCConst>entrypoint</QCConst>),append(E,D,G),
  s(D,G,0,[],R).<QCConst>newline</QCConst>

% ---- past the end is [], so no range guard is needed ----
% b returns the head and the rest at once (READ needs both)
b([C|J],C,J).<QCConst>newline</QCConst>
b([],0,[]).<QCConst>newline</QCConst>

% ---- literal output loop (the Hx -> x-33 escape happens only here) and ( ) skipping ----
li([C|J],K):-(C==47->K=J
  ;C==72->J=[I|Z],B is I-33,put_byte(B),li(Z,K)
  ;put_byte(C),li(J,K)).<QCConst>newline</QCConst>
sk([_|J],O,K):-J=[C|_],(C>39,C<42->E is O+81-2*C;E=O),(E>0->sk(J,E,K);K=J).<QCConst>newline</QCConst>

% ---- main loop (tail recursive; branches on ranges of C in the same order as tmpl.erl) ----
% the register index is computed once up front rather than in each branch (the three branches then share one spelling)
s([C|J],P,A,L,R):-Q is C/\7+1,(C<34->li(J,K),s(K,P,A,L,R)
  ;C<39->b(P,I,T),s(J,T,I,L,R)
  ;C<41->sk(J,1,K),s(K,P,A,[J|L],R)
  ;C<42->(A==0->L=[_|X],s(J,P,A,X,R);L=[Z|_],s(Z,P,A,L,R))
  ;C<43->put_byte(A),s(J,P,A,L,R)
  ;C<56->nb_setarg(Q,R,A),s(J,P,A,L,R)
  ;C<64->arg(Q,R,I),s(J,P,I,L,R)
  ;C<72->arg(Q,R,I),B is A-I,s(J,P,B,L,R)
  ;s(J,P,C,L,R)).<QCConst>newline</QCConst>
s([],_,_,_,_).<QCConst>newline</QCConst>

\ Forth

: d dup <QCConst>image_len</QCConst> < if s" <QCImage/>" drop + c@ else drop 0 then ;

\ ---- state ----
0 value a 0 value b 0 value p 0 value l 0 value r 0 value c
create y 99 cells allot

\ ---- main: init the state, put the name into r[0..], then run (names are at most 6 chars, so no mod 8) ----
: s y 8 cells erase 8 to l <QCConst>entrypoint</QCConst> to b
  next-arg dup 0= if 2drop s" fs" then
  0 ?do dup I + c@ I cells y + ! loop drop
  begin b d b 1 + to b dup while to c
    c 34 < if begin b d b 1 + to b dup 47 <> while dup 72 = if drop b d b 1 + to b 33 - then emit repeat drop
    else c 39 < if p d to a p 1 + to p
    else c 41 < if b l cells y + ! l 1 + to l 1 to r
      begin r while b 1 + to b b d 2/ 20 = if r 81 b d 2* - + to r then repeat
    else c 42 < if a if l 1- cells y + @ to b else l 1- to l then
    else c 43 < if a emit
    else c 56 < if a c 8 mod cells y + !
    else c 64 < if c 8 mod cells y + @ else c 72 < if a c 8 mod cells y + @ - else c then then to a
    then then then then then then
  repeat drop ;
s bye

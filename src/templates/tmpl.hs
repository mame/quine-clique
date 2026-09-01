-- Haskell

import System.IO;
import System.Environment;
l="<QCImage/>";
i(c:_)=fromEnum c;
i _=0;
p=putChar.toEnum;
b r w a e g d=if null r then return()else if d<0 then(if c==47 then b n w a e g 0 else if c==72 then p(i n-33)>>b(drop 1 n)w a e g d else p c>>b n w a e g d)
 else if d>0 then b n w a e g(if div c 2==20 then d+81-2*c else d)
 else if c<34 then b n w a e g(-1)
 else if c<39 then b n(drop 1 w)(i w)e g 0
 else if c<41 then(if a==0 then b n w a e g 1 else b n w a e(n:g)0)
 else if c<42 then(if a==0 then b n w a e(drop 1 g)0 else b(g!!0)w a e g 0)
 else if c<43 then p a>>b n w a e g 0
 -- After a store, force every register (foldr seq): left lazy, the e!!s thunks chain to the older register lists
 -- and memory grows with the executed instructions (32 GB+ for the unl output vs a flat 10 MB when forced)
 else if c<56 then foldr seq(b n w a f g 0)f
 else if c<64 then b n w(e!!mod c 8)e g 0
 else if c<72 then b n w(a-e!!mod c 8)e g 0
 else b n w c e g 0 where{c=i r;n=drop 1 r;f=[if s==mod c 8 then a else e!!s|s<-[0..7]]};
main=do{
hSetEncoding stdout char8;
v<-getArgs;
-- Put the name (the default key if no argument) into r0..
b(drop <QCConst>entrypoint</QCConst> l)l 0[i(drop s((v++["hs"])!!0))|s<-[0..7]][]0}

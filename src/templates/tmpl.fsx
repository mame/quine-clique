// F#

let b j=int "<QCImage/>\000".[j]<QCConst>newline</QCConst>
let o=System.Console.OpenStandardOutput()<QCConst>newline</QCConst>
let mutable a=0<QCConst>newline</QCConst>
let mutable i=<QCConst>entrypoint</QCConst><QCConst>newline</QCConst>
let mutable p=0<QCConst>newline</QCConst>
let r=Array.create 99 0<QCConst>newline</QCConst>
let mutable s=8<QCConst>newline</QCConst>
let mutable d=0<QCConst>newline</QCConst>
let u()=(i<-i+1;b(i-1))<QCConst>newline</QCConst>
String.iteri(fun c x->Array.set r c (int x))(Array.append fsi.CommandLineArgs [|"fsx"|]).[1]<QCConst>newline</QCConst>
while i<<QCConst>image_len</QCConst> do let c=u()in if c<34 then((while b i<>47 do(let c=u()in o.WriteByte(byte(if c=72 then u()-33 else c))));
  i<-i+1)else if c<39 then(a<-b p;
  p<-p+1)else if c<41 then(Array.set r s i;s<-s+1;
  d<-1;
  while d>0 do(i<-i+1;
    let c=b i in if c/2=20 then d<-d+81-2*c))
else if c<42 then(if a=0 then s<-s-1 else i<-Array.get r (s-1))
else if c<43 then o.WriteByte(byte a)else if c<56 then Array.set r (c%8) a
else if c<64 then a<-Array.get r (c%8)else if c<72 then a<-a-Array.get r (c%8)else a<-c<QCConst>newline</QCConst>
o.Flush()

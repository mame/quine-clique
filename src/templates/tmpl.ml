(* OCaml *)

let b j=Char.code "<QCImage/>\000".[j]
(* ---- state (a=acc, i=instruction pos, p=READ pos, r=registers + () return stack, s=stack top, d=skip depth) ---- *)
let a=ref 0 let i=ref <QCConst>entrypoint</QCConst> let p=ref 0 let r=Array.make 99 0 let s=ref 8 let d=ref 0

(* ---- u = read and advance; then put the name into r[0..] ---- *)
let u()=(i:= !i+1;b(!i-1))let()=String.iteri(fun c x->Array.set r c(Char.code x))(Array.append Sys.argv[|"ml"|]).(1);

(* ---- main loop (an else-if chain over ranges of c) ---- *)
while !i<<QCConst>image_len</QCConst> do let c=u()in if c<34 then((while b(!i)<>47 do(let c=u()in print_char(Char.chr(if c=72 then u()-33 else c)))done);
  i:= !i+1)else if c<39 then(a:=b(!p);
  p:= !p+1)else if c<41 then(Array.set r(!s)(!i);s:= !s+1;
  d:=1;
  while !d>0 do(i:= !i+1;
    let c=b(!i)in if c/2=20 then d:= !d+81-2*c)done)
else if c<42 then(if !a=0 then s:= !s-1 else i:=Array.get r(!s-1))
else if c<43 then print_char(Char.chr(!a))else if c<56 then Array.set r(c mod 8)(!a)
else if c<64 then a:=Array.get r(c mod 8)else if c<72 then a:= !a-Array.get r(c mod 8)else a:=c done

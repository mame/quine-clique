(* Standard ML *)

fun b j=ord(String.sub("<QCImage/>\000",j))
val a=ref 0 val i=ref <QCConst>entrypoint</QCConst> val p=ref 0 val r=Array.array(99,0) val s=ref 8 val d=ref 0

(* ---- u = read and advance; then put the name into r[0..] ---- *)
fun u()=(i:= !i+1;b(!i-1))
val()=CharVector.appi(fn(c,x)=>Array.update(r,c,ord x))(hd(CommandLine.arguments()@["sml"]))

(* ---- main loop (an else-if chain over ranges of c) ---- *)
val()=while !i<<QCConst>image_len</QCConst> do let val c=u()in if c<34 then((while b(!i)<>47 do(let val c=u()in print(str(chr(if c=72 then u()-33 else c)))end));
  i:= !i+1)else if c<39 then(a:=b(!p);
  p:= !p+1)else if c<41 then(Array.update(r,!s,!i);s:= !s+1;
  d:=1;
  while !d>0 do(i:= !i+1;
    let val c=b(!i)in if c div 2=20 then d:= !d+81-2*c else()end))
else if c<42 then(if !a=0 then s:= !s-1 else i:=Array.sub(r,!s-1))
else if c<43 then print(str(chr(!a)))else if c<56 then Array.update(r,c mod 8,!a)
else if c<64 then a:=Array.sub(r,c mod 8)else if c<72 then a:= !a-Array.sub(r,c mod 8)else a:=c end

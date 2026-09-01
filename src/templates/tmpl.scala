// Scala

val g="<QCImage/>";
val r=new Array[Int](99);
val z=(args:+"scala").head;
var i=<QCConst>entrypoint</QCConst>;var p,a,c,d=0;var l=<QCConst>image_len</QCConst>;var s=8;
// Put the name (the default key if no argument) into r0..
while(c<z.length){
  r(c%8)=z(c);c+=1
};
val o=System.out;
while(i<l){
  c=g(i);
  i+=1;
  // 33 !.../ literal (the Hc -> c-33 escape happens only here)
  if(c<34){
    while(g(i)!=47){
      c=g(i);
      i+=1;
      if(c==72){c=g(i)-33;i+=1};
      o.write(c)
    };
    i+=1
  }
  // 38 & READ (0 past the end)
  else if(c<39){
    a=0;
    if(p<l)a=g(p);
    p+=1
  }
  // 40 ( loop start; if acc==0, skip to the matching )
  else if(c<41){
    r(s)=i;s+=1;
    d=1;
    while(d>0){
      i+=1;
      c=g(i);
      if(c>>1==20)d+=81-2*c
    }
  }
  // 41 ) loop end; if acc!=0, jump back to the start
  else if(c<42){
    s-=1;
    if(a!=0){i=r(s);s+=1}
  }
  // 42 * output one byte
  else if(c<43)o.write(a)
  // 48..55 store / 56..63 load / 64..71 sub / 72..126 immediate
  else if(c<56)r(c%8)=a
  else if(c<64)a=r(c%8)
  else if(c<72)a=a-r(c%8)
  else a=c
};
o.flush()

// Kotlin

val g="<QCImage/>".map{it.toInt()};
var i=<QCConst>entrypoint</QCConst>;
var p=0;
var a=0;
var l=<QCConst>image_len</QCConst>;

fun main(n:Array<String>){
  val r=IntArray(99);
  var s=8;
  // c = the opcode being examined (also reused while scanning literals/parens); d = paren depth, used only in the ( branch
  var c=0;
  var d:Int;
  // Put the name (the default key if no argument) into r0..
  for(x in(n+"kt")[0]){r[c%8]=x.toInt();c+=1};
  val o=System.out;
  while(i<l){
    c=g[i];
    i+=1;
    // 33 !.../ literal (the Hx -> c-33 escape happens only here)
    if(c<34){
      while(g[i]!=47){
        c=g[i];
        i+=1;
        if(c==72){c=g[i]-33;i+=1};
        o.write(c)
      };
      i+=1
    }
    // 38 & READ (0 past the end)
    else if(c<39){
      a=0;
      if(p<l)a=g[p];
      p+=1
    }
    // 40 ( loop start; if acc==0, skip to the matching )
    else if(c<41){
      r[s++]=i;
      d=1;
      while(d>0){
        i+=1;
        c=g[i];
        if(c/2==20)d+=81-2*c
      }
    }
    // 41 ) loop end; if acc!=0, jump back to the start
    else if(c<42){
      s--;if(a!=0)i=r[s++]
    }
    // 42 * output one byte
    else if(c<43)o.write(a)
    // 48..55 store / 56..63 load / 64..71 sub
    // (the space in `=a else{` is required, so this line cannot be split)
    else if(c<56)r[c%8]=a
    else if(c<64)a=r[c%8]
    else if(c<72)a=a-r[c%8]
    else a=c
  };
  o.flush()
}

// Java

interface qc{
  // All variables are locals of main (no static fields, matching the other languages).
  static void main(String[]n){
    var g="<QCImage/>".getBytes();
    int[]r=new int[99];
    int i=<QCConst>entrypoint</QCConst>,p=0,a=0,c=0,d=0,s=8,l=<QCConst>image_len</QCConst>;
    // Put the name (the default key if no argument) into r0..
    var z=n.length>0?n[0]:"java";
    for(;c<z.length();c++)
      r[c%8]=z.charAt(c);
    var o=System.out;
    while(i<l){
      c=g[i];
      i+=1;
      // 33 !.../ literal (the Hc -> c-33 escape happens only here)
      // c is spent at this point, so it is reused as a scratch variable (the next iteration reloads c=g[i])
      if(c<34){
        while(g[i]!=47){
          c=g[i];
          i+=1;
          if(c==72){c=g[i]-33;i+=1;}
          o.write(c);
        }
        i+=1;
      }
      // 38 & READ (0 past the end)
      else if(c<39){
        a=0;
        if(p<l)a=g[p];
        p+=1;
      }
      // 40 ( loop start; if acc==0, skip to the matching )
      else if(c<41){
        r[s++]=i;
        d=1;
        while(d>0){
          i+=1;
          c=g[i];
          if(c>>1==20)d+=81-2*c;
        }
      }
      // 41 ) loop end; if acc!=0, jump back to the start
      else if(c<42){
        s--;
        if(a!=0)i=r[s++];
      }
      // 42 * output one byte
      else if(c<43)
        o.write(a);
      // 48..55 store
      else if(c<56)
        r[c%8]=a;
      // 56..63 load / 64..71 sub / 72..126 immediate
      else{
        a=c<64?r[c%8]:c<72?a-r[c%8]:c;
      }
    }
    o.flush();
  }
}

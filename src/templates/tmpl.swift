// Swift

import Glibc;
var g="<QCImage/>".utf8.map{Int($0)};
var r=[Int](repeating:0,count:99);
var i=<QCConst>entrypoint</QCConst>,p=0,a=0,c=0,d=0,s=8,l=<QCConst>image_len</QCConst>;

// Put the name (the default key if no argument) into r0..
for x in(CommandLine.arguments+["swift"])[1].utf8{r[c%8]=Int(x);c+=1};

func o(_ x:Int){putchar(Int32(x))};

while(i<l){
  c=g[i];
  i+=1;
  // 33 !.../ literal (the Hx -> c-33 escape happens only here)
  // c is spent at this point, so it is reused as a scratch variable (likewise in the ( scan below)
  if(c<34){
    while(g[i] != 47){c=g[i];i+=1;if(c==72){c=g[i]-33;i+=1};o(c)};
    i+=1
  }
  // 38 & READ (0 past the end)
  else if(c<39){
    a=0;
    if(p<l){a=g[p]};
    p+=1
  }
  // 40 ( loop start; if acc==0, skip to the matching )
  else if(c<41){
    r[s]=i;
    s+=1;
    d=1;
    while(d>0){
      i+=1;
      c=g[i];
      if(c>>1==20){d+=81-2*c}
    }
  }
  // 41 ) loop end; if acc!=0, jump back to the start
  else if(c<42){
    s-=1;
    if(a != 0){i=r[s];s+=1}
  }
  // 42 * output one byte
  else if(c<43){o(a)}
  // 48..55 store
  else if(c<56){r[c%8]=a}
  // 56..63 load / 64..71 sub / 72..126 immediate
  else if(c<64){a=r[c%8]}
  else if(c<72){a=a-r[c%8]}
  else{a=c}
}

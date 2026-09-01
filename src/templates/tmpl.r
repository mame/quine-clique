# R

g=utf8ToInt("<QCImage/>");
z=utf8ToInt(c(commandArgs(T),"r")[1]);
r=integer(99);
r[1:length(z)]=z;
p=1;i=<QCConst>entrypoint</QCConst>+1;a=d=0;l=<QCConst>image_len</QCConst>;s=8;
f=file("/dev/stdout","wb");
while(i<=l){
  c=g[i];i=i+1;
  if(d){
    # Mode continuation: d<0 prints up to 47 '/' (the Hx -> x-33 escape happens only here), d>0 counts ( ) and skips until depth 0
    if(d<0){
      if(c-47){
        if(c==72){c=g[i]-33;i=i+1};writeBin(as.raw(c),f)
      }else d=0
    }else if(c%/%2==20)d=d+81-2*c
  # 33 '!' literal start
  }else if(c<34)d=-1 else if(c<39){
  # 38 '&' READ: a=g[p] (0 past the end)
    a=0;if(p<=l)a=g[p];p=p+1
  # 40 '(' loop: enter (push) if acc!=0, else switch to skip mode
  }else if(c<41){
    if(a){s=s+1;r[s]=i}else d=1
  # 41 ')' loop end: if acc!=0 jump to the return position (peek), else pop
  }else if(c<42){
    if(a)i=r[s]else s=s-1
  # 42 '*' output / 48..55 store / 56.. load(c<64)/sub(c<72)/immediate
  }else if(c<43)writeBin(as.raw(a),f)else if(c<56)r[c%%8+1]=a else if(c<64)a=r[c%%8+1]else if(c<72)a=a-r[c%%8+1]else a=c
}

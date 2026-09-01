// JavaScript / TypeScript

var g=Buffer.from('<QCImage/>');
var r=[0,0,0,0,0,0,0,0];
var z=process.argv[2]||'js';
var i=<QCConst>entrypoint</QCConst>,p=0,a=0,c=0,d=0,s=8,l=<QCConst>image_len</QCConst>;
for(;c<z.length;c++)r[c%8]=z.charCodeAt(c);
var o=y=>process.stdout.write(Buffer.from([y]));
while(i<l){
  c=g[i];
  i+=1;
  // 33 '!' literal: the inner loop prints up to 47 '/' (the Hx -> x-33 escape happens only here)
  if(c<34){while(g[i]!=47){c=g[i];i+=1;if(c==72){c=g[i]-33;i+=1;}o(c);}i+=1;}
  // 38 '&' READ: a=g[p] (&(*&) reads one byte past the end, so guard with if(p<l))
  else if(c<39){a=0;if(p<l)a=g[p];p+=1;}
  // 40 '(' loop: push the return position, then the inner loop skips to the matching )
  else if(c<41){r[s++]=i;d=1;while(d>0){i+=1;c=g[i];if(c>>1==20)d+=81-2*c;}}
  // 41 ')' loop end: always pop; if acc!=0, push again and jump to the return position
  else if(c<42){s--;if(a!=0)i=r[s++];}
  // 42 '*' output
  else if(c<43)o(a);
  // 48..55 store
  else if(c<56)r[c%8]=a;
  // 56.. load(c<64)/sub(c<72)/immediate
  else{a=c<64?r[c%8]:c<72?a-r[c%8]:c;}
}

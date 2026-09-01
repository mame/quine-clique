// D

import core.stdc.stdio;
void o(int x){putchar(x);}
string g="<QCImage/>";
int[]r=new int[99];
int i=<QCConst>entrypoint</QCConst>,p=0,a=0,c=0,d=0,s=8,l=<QCConst>image_len</QCConst>;

void main(string[]n){
  // Put the name (the default key if no argument) into r0..; appending the default key avoids a branch
  string z=(n~"d")[1];
  for(;c<z.length;c++)
    r[c%8]=z[c];
  while(i<l){
    c=g[i];
    i+=1;
    if(c<34){while(g[i]!=47){c=g[i];i+=1;if(c==72){c=g[i]-33;i+=1;}o(c);}i+=1;}
    else if(c<39){a=0;if(p<l)a=g[p];p+=1;}
    else if(c<41){r[s++]=i;d=1;while(d>0){i+=1;c=g[i];if(c>>1==20)d+=81-2*c;}}
    else if(c<42){s--;if(a!=0)i=r[s++];}
    else if(c<43)o(a);
    else if(c<56)r[c%8]=a;
    else{a=c<64?r[c%8]:c<72?a-r[c%8]:c;}
  }
}

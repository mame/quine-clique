// C / C++

#include<stdio.h><QCConst>newline</QCConst>

void o(int x){putchar(x);}
char g[]="<QCImage/>";
int r[99];
int i=<QCConst>entrypoint</QCConst>,p=0,a=0,c=0,d=0,s=8,l=<QCConst>image_len</QCConst>;

int main(int A,char**v){
  // Put the name (the default key if no argument) into r0..
  const char*z=A>1?v[1]:"c";
  for(;z[c];c++)
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

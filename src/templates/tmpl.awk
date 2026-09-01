# AWK

BEGIN{
  for(c=32;c<127;c++)t[sprintf("%c",c)]=c;
  i=<QCConst>entrypoint</QCConst>;p=0;s=8;l=<QCConst>image_len</QCConst>;
  for(c=0;c<l;c++)g[c]=t[substr("<QCImage/>",c+1,1)];
  # a BEGIN-only program never reads input, so ARGV[1] is not opened as a file
  z=ARGV[1];
  if(z=="")z="awk";
  for(c=0;c<length(z);c++)r[c%8]=t[substr(z,c+1,1)];
  while(i<l){
    c=g[i];
    i+=1;
    if(c<34){while(g[i]!=47){c=g[i];i+=1;if(c==72){c=g[i]-33;i+=1;}printf("%c",c);}i+=1;}
    else if(c<39){a=0;if(p<l)a=g[p];p+=1;}
    else if(c<41){r[s++]=i;d=1;while(d>0){i+=1;c=g[i];if(int(c/2)==20)d+=81-2*c;}}
    else if(c<42){s--;if(a!=0)i=r[s++];}
    else if(c<43)printf("%c",a);
    else if(c<56)r[c%8]=a;
    else{a=c<64?r[c%8]:c<72?a-r[c%8]:c;}
  }
}

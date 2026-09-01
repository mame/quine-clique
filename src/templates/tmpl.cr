# Crystal

g=<<-'E'.codepoints;
i=<QCConst>entrypoint</QCConst>;a=p=c=0;l=<QCConst>image_len</QCConst>;r=[0]*99;s=8;
z=ARGV[0]?||"cr";
z.bytes.each{|x|r[c%8]=x.to_i;c+=1};
def o(x);
  STDOUT.write_byte x.to_u8;
end;

while i<l;
  c=g[i];
  i+=1;
  if c<34;
    while g[i]!=47;c=g[i];i+=1;if c==72;c=g[i]-33;i+=1;end;o(c);end;
    i+=1;
  elsif c<39;
    a=g[p]?||0;
    p+=1;
  elsif c<41;
    r[s]=i;
    s+=1;
    d=1;
    while d>0;
      i+=1;
      c=g[i];
      if c>>1==20;d+=81-2*c;end;
    end;
  elsif c<42;
    s-=1;
    if a!=0;i=r[s];s+=1;end;
  elsif c<43;
    o(a);
  elsif c<56;
    r[c%8]=a;
  elsif c<64;
    a=r[c%8];
  elsif c<72;
    a=a-r[c%8];
  else;
    a=c;
  end;
end
<QCConst>newline</QCConst><QCImage/><QCConst>newline</QCConst>E

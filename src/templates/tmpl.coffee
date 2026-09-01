# CoffeeScript

g=Buffer.from('<QCImage/>')
r=[0,0,0,0,0,0,0,0]
z=process.argv[2]||'coffee'
i=<QCConst>entrypoint</QCConst>;p=0;a=0;c=0;d=0;s=8;l=<QCConst>image_len</QCConst>
for c in [0...z.length]
 r[c%8]=z.charCodeAt(c)
o=(y)->process.stdout.write(Buffer.from([y]))
while i<l
 c=g[i];i+=1
 if c<34
  while g[i]!=47
   c=g[i];i+=1
   if c==72 then c=g[i]-33;i+=1
   o(c)
  i+=1
 else if c<39
  a=0;if p<l then a=g[p]
  p+=1
 else if c<41
  r[s]=i;s+=1;d=1
  while d>0
   i+=1;c=g[i]
   if c>>1==20 then d+=81-2*c
 else if c<42
  s-=1;if a!=0 then i=r[s];s+=1
 else if c<43 then o(a)
 else if c<56 then r[c%8]=a
 else if c<64 then a=r[c%8]
 else if c<72 then a=a-r[c%8]
 else a=c

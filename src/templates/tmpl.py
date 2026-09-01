# Python

import sys
g=b"<QCImage/>"
i=<QCConst>entrypoint</QCConst>;a=p=c=0;l=<QCConst>image_len</QCConst>;r=[0]*99;s=8
for x in(sys.argv+["py"])[1]:r[c%8]=ord(x);c+=1
def o(x):sys.stdout.buffer.write(bytes([x]))
while i<l:
 c=g[i];i+=1
 if c<34:
  while g[i]!=47:
   c=g[i];i+=1
   if c==72:c=g[i]-33;i+=1
   o(c)
  i+=1
 elif c<39:
  a=0
  if p<l:a=g[p]
  p+=1
 elif c<41:
  r[s]=i;s+=1;d=1
  while d>0:
   i+=1;c=g[i]
   if c>>1==20:d+=81-2*c
 elif c<42:
  s-=1
  if a!=0:i=r[s];s+=1
 elif c<43:o(a)
 elif c<56:r[c%8]=a
 elif c<64:a=r[c%8]
 elif c<72:a=a-r[c%8]
 else:a=c

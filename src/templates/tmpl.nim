# Nim

import os,sequtils
var g="<QCImage/>".mapIt(it.ord)
var i=<QCConst>entrypoint</QCConst>;var p,a,c,d=0;var l=<QCConst>image_len</QCConst>;var s=8;var r:array[99,int]
for x in(commandLineParams() & @["nim"])[0]:r[c mod 8]=x.ord;c+=1
proc o(x:int)=stdout.write x.char
while i<l:
 c=g[i];i+=1
 # c is spent at this point, so it is reused as a scratch variable (the next iteration reloads c=g[i])
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
   if c div 2==20:d+=81-2*c
 elif c<42:
  s-=1;if a!=0:i=r[s];s+=1
 elif c<43:o(a)
 elif c<56:r[c mod 8]=a
 elif c<64:a=r[c mod 8]
 elif c<72:a=a-r[c mod 8]
 else:a=c

-- Lua

g="<QCImage/>";
function b(j)return g:byte(j+1)or 0 end;
r={[0]=0,0,0,0,0,0,0,0};
c=0;for x in(arg[1]or"lua"):gmatch"." do r[c%8]=x:byte();c=c+1 end;
i,p,a,d,s,l=<QCConst>entrypoint</QCConst>,0,0,0,8,<QCConst>image_len</QCConst>;
while i<l do;
  c=b(i);
  i=i+1;
  -- 33 '!' literal: the inner loop prints up to 47 '/' (the Hx -> x-33 escape happens only here)
  if c<34 then;
    while b(i)~=47 do;c=b(i);i=i+1;if c==72 then c=b(i)-33;i=i+1 end;io.write(string.char(c))end;
    i=i+1;
  -- 38 '&' READ: a=g[p] (0 past the end)
  elseif c<39 then;
    a=b(p);
    p=p+1;
  -- 40 '(' loop: push the return position, then the inner loop skips to the matching )
  elseif c<41 then;
    r[s]=i;
    s=s+1;
    d=1;
    while d>0 do;
      i=i+1;
      c=b(i);
      if c>>1==20 then d=d+81-2*c end;
    end;
  -- 41 ')' loop end: always pop; if acc!=0, push again and jump to the return position
  elseif c<42 then;
    s=s-1;
    if a~=0 then i=r[s];s=s+1 end;
  -- 42 '*' output / 48..55 store / 56.. load(c<64)/sub(c<72)/immediate
  elseif c<43 then io.write(string.char(a));
  elseif c<56 then r[c%8]=a;
  elseif c<64 then a=r[c%8];
  elseif c<72 then a=a-r[c%8];
  else a=c end;
end

// Pascal

var g,z:ansistring;
r:array[0..99]of longint;
i,p,a,c,d,s:longint;

begin
  g:='<QCImage/>';
  z:=ParamStr(1);
  if z='' then z:='pas';
  for c:=1 to length(z)do r[(c-1)mod 8]:=ord(z[c]);
  i:=<QCConst>entrypoint</QCConst>+1;
  p:=1;
  s:=8;
  while i<=<QCConst>image_len</QCConst> do begin
    c:=ord(g[i]);
    i:=i+1;
    if c<34 then begin
      while ord(g[i])<>47 do begin
        c:=ord(g[i]);
        i:=i+1;
        if c=72 then begin
          c:=ord(g[i])-33;
          i:=i+1
        end;
        write(chr(c))
      end;
      i:=i+1
    end
    else if c<39 then begin
      a:=0;
      if p<=<QCConst>image_len</QCConst> then a:=ord(g[p]);
      p:=p+1
    end
    else if c<41 then begin
      r[s]:=i;
      s:=s+1;
      d:=1;
      while d>0 do begin
        i:=i+1;
        c:=ord(g[i]);
        if c div 2=20 then d:=d+81-2*c
      end
    end
    else if c<42 then begin
      if a=0 then s:=s-1
      else i:=r[s-1]
    end
    else if c<43 then write(chr(a))
    else if c<56 then r[c mod 8]:=a
    else if c<64 then a:=r[c mod 8]
    else if c<72 then a:=a-r[c mod 8]
    else a:=c
  end
end.

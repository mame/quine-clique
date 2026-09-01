# Bash

while IFS= read -n1 x;do printf -v "g[j++]" %d "'$x";done<<<'<QCImage/>';
while IFS= read -n1 x;do printf -v "r[c++]" %d "'$x";done<<<"${1:-bash}";
# E[v] is the \0nnn escape of byte v; output is batched in O and flushed every ~10k chars (O+= is O(n) per append)
for((v=0;v<256;v++));do
  printf -v "E[v]" '\\0%03o' $v;
done;
i=<QCConst>entrypoint</QCConst>;
s=8;
while((c=g[i++]));do
  if((d));then
    if((d<0));then
      if((c-47));then
        v=$c;
        if((v==72));then
          let v=g[i++]-33;
        fi;
        O+=${E[v]};
        ((${#O}<9990))||{ printf %b "$O";O=;};
      else
        d=0;
      fi;
    elif((c>>1==20));then
      let d+=81-2*c;
    fi;
  elif((c<43));then
    if((c<34));then
      d=-1;
    elif((c<39));then
      ((a=g[p++]));
    elif((c<41));then
      if((a));then
        ((r[s++]=i));
      else
        d=1;
      fi;
    elif((c<42));then
      let s--;
      if((a));then
        ((i=r[s++]));
      fi;
    else
      O+=${E[a]};
      ((${#O}<9990))||{ printf %b "$O";O=;};
    fi;
  elif((c<56));then
    ((r[c%8]=a));
  else
    let "a=c<64?r[c%8]:c<72?a-r[c%8]:c";
  fi;
done;
printf %b "$O"

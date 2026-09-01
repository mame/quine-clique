# PHP

<?php $G=unpack("C*",'<QCImage/>');
$r=[0,0,0,0,0,0,0,0];
$c=0;foreach(unpack("C*",$argv[1]??"php")as$x)$r[$c++]=$x;
$a=$d=0;$s=7;$i=<QCConst>entrypoint</QCConst>+1;$p=1;
while($c=$G[$i]??0){
  $i+=1;
  if($d){
    # Mode continuation: d<0 prints up to 47 '/' (Hx -> x-33); d>0 counts ( ) and skips until depth 0
    if($d<0){if($c-47){if($c==72){$c=$G[$i]-33;$i+=1;}print chr($c);}else{$d=0;}}
    elseif($c>>1==20){$d+=81-2*$c;}
  }
  # 33 '!' literal start
  elseif($c<34){$d=-1;}
  # 38 '&' READ: a=g[p] (0 past the end); p starts at 1 (unpack is 1-based)
  elseif($c<39){$a=$G[$p]??0;$p+=1;}
  # 40 '(' loop: enter (push) if acc!=0, else switch to skip mode (d is always 0 here)
  elseif($c<41){if($a){$r[++$s]=$i;}else{$d=1;}}
  # 41 ')' loop end: always pop; if acc!=0, push again and jump to the return position
  elseif($c<42){$s--;if($a){$i=$r[++$s];}}
  # 42 '*' output
  elseif($c<43){print chr($a);}
  # 48..55 store
  elseif($c<56){$r[$c%8]=$a;}
  # 56.. load(c<64)/sub(c<72)/immediate
  else{$a=$c<64?$r[$c%8]:($c<72?$a-$r[$c%8]:$c);}
}

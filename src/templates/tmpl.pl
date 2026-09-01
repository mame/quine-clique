# Perl

@G=unpack"C*",'<QCImage/>';
@r=(0)x8;
$c=0;$r[$c++]=$_ for unpack"C*",$ARGV[0]||"pl";
$p=$a=$d=0;$s=7;$i=<QCConst>entrypoint</QCConst>;
while($c=$G[$i]){
  $i+=1;
  if($d){
    # Mode continuation: d<0 prints up to 47 '/' (Hx -> x-33); d>0 counts ( ) and skips until depth 0
    if($d<0){if($c-47){if($c==72){$c=$G[$i]-33;$i+=1;}print chr($c);}else{$d=0;}}
    elsif($c>>1==20){$d+=81-2*$c;}
  }
  # 33 '!' literal start
  elsif($c<34){$d=-1;}
  # 38 '&' READ: a=g[p] (0 past the end)
  elsif($c<39){$a=$G[$p]||0;$p+=1;}
  # 40 '(' loop: enter (push) if acc!=0, else switch to skip mode (d is always 0 here)
  elsif($c<41){if($a){$r[++$s]=$i;}else{$d=1;}}
  # 41 ')' loop end: always pop; if acc!=0, push again and jump to the return position
  elsif($c<42){$s--;if($a){$i=$r[++$s];}}
  # 42 '*' output
  elsif($c<43){print chr($a);}
  # 48..55 store
  elsif($c<56){$r[$c%8]=$a;}
  # 56.. load(c<64)/sub(c<72)/immediate
  else{$a=$c<64?$r[$c%8]:($c<72?$a-$r[$c%8]:$c);}
}

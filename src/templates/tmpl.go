// Go

package main;
import "os";

// o: output acc as one raw byte
func o(x int){os.Stdout.Write([]byte{byte(x)})};

var g="<QCImage/>";
var i=<QCConst>entrypoint</QCConst>;
var p,a,c,d int;
var s=8;
var l=<QCConst>image_len</QCConst>;
var r [99]int;

func main(){
  z:=append(os.Args,"go")[1];
  for(c<len(z)){r[c%8]=int(z[c]);c+=1};
  for(i<l){
    c=int(g[i]);
    i+=1;
    if(c<34){for(g[i]!=47){c=int(g[i]);i+=1;if(c==72){c=int(g[i])-33;i+=1};o(c)};i+=1}
    else if(c<39){a=0;if(p<l){a=int(g[p])};p+=1}
    else if(c<41){r[s]=i;s+=1;d=1;for(d>0){i+=1;c=int(g[i]);if(c>>1==20){d+=81-2*c}}}
    else if(c<42){s-=1;if(a!=0){i=r[s];s+=1}}
    else if(c<43){o(a)}
    else if(c<56){r[c%8]=a}
    else if(c<64){a=r[c%8]}
    else if(c<72){a=a-r[c%8]}
    else{a=c}
  }
}

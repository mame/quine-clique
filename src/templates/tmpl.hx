// Haxe

class Qc{
  static function main(){
    // Put the name (the default key if no argument) into r0..
    var z=Sys.args().length>0?Sys.args()[0]:"hx";
    var i=<QCConst>entrypoint</QCConst>,p=0,a=0,c=0,d=0,s=8,l=<QCConst>image_len</QCConst>;
    var g=[for(x in 0...l)"<QCImage/>".charCodeAt(x)];
    var r=[0,0,0,0,0,0,0,0];
    while(c<z.length){r[c%8]=z.charCodeAt(c);c+=1;}
    var y=Sys.stdout();
    function o(x)y.writeByte(x);
    while(i<l){
      c=g[i];
      i+=1;
      // 33 !.../ literal (the Hc -> c-33 escape happens only here)
      if(c<34){while(g[i]!=47){c=g[i];i+=1;if(c==72){c=g[i]-33;i+=1;}o(c);}i+=1;}
      // 38 & READ (0 past the end)
      else if(c<39){a=0;if(p<l)a=g[p];p+=1;}
      // 40 ( loop start; if acc==0, skip to the matching )
      else if(c<41){r[s++]=i;d=1;while(d>0){i+=1;c=g[i];if(c>>1==20)d+=81-2*c;}}
      // 41 ) loop end; if acc!=0, jump back to the start
      else if(c<42){s--;if(a!=0)i=r[s++];}
      // 42 * output one byte
      else if(c<43)o(a);
      // 48..55 store
      else if(c<56)r[c%8]=a;
      // 56..63 load / 64..71 sub / 72..126 immediate
      else{a=c<64?r[c%8]:c<72?a-r[c%8]:c;}
    }
    y.flush();
  }
}

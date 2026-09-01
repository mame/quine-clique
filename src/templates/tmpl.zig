// Zig

const std=@import("std");
var g="<QCImage/>";
var i:usize=<QCConst>entrypoint</QCConst>;
var p:usize=0;
var a:i32=0;
var c:u8=0;
var d:i32=0;
var s:usize=8;
var l:usize=<QCConst>image_len</QCConst>;
var r=[_]i32{0}**99;

// o: output acc as one raw byte (* is specified only for acc in 0..255, so @intCast is fine)
fn o(x:i32)void{
  _=std.posix.write(1,&[_]u8{@intCast(x)}) catch 0;
}

pub fn main()void{
  const z=if(std.os.argv.len>1)std.mem.span(std.os.argv[1])else"zig";
  // Put the name (the default key if no argument) into r0..
  while(c<z.len){r[c%8]=z[c];c+=1;}
  while(i<l){
    c=g[i];
    i+=1;
    if(c<34){while(g[i]!=47){c=g[i];i+=1;if(c==72){c=g[i]-33;i+=1;}o(c);}i+=1;}
    else if(c<39){a=0;if(p<l)a=g[p];p+=1;}
    else if(c<41){r[s]=@intCast(i);s+=1;d=1;while(d>0){i+=1;c=g[i];if(c>>1==20)d+=81-2*@as(i32,c);}}
    else if(c<42){s-=1;if(a!=0){i=@intCast(r[s]);s+=1;}}
    else if(c<43){o(a);}
    else if(c<56){r[c%8]=a;}
    else if(c<64){a=r[c%8];}
    else if(c<72){a=a-r[c%8];}
    else{a=@intCast(c);}
  }
}

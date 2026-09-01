// Rust

use std::io::*;

// o: output acc as one raw byte (the Result of write is discarded)
fn o(x:i32){_=stdout().write(&[x as u8]);}

fn main(){
  let g=b"<QCImage/>";
  let mut i=<QCConst>entrypoint</QCConst>;
  let mut r=[0;99];
  let mut s=8;
  let l=<QCConst>image_len</QCConst>;
  let mut p=0;
  let mut a=0;
  let mut c=0;
  for x in std::env::args().nth(1).unwrap_or("rs".into()).bytes(){r[c%8]=x as i32;c+=1}
  while i<l{
    let c=g[i]as usize;
    i+=1;
    if c<34{while g[i]!=47{let mut c=g[i];i+=1;if c==72{c=g[i]-33;i+=1};o(c as i32)};i+=1}
    else if c<39{a=0;if p<l{a=g[p]as i32};p+=1}
    else if c<41{r[s]=i as i32;s+=1;let mut d=1;while d>0{i+=1;let c=g[i];if c>>1==20{d+=81-2*c as i32}}}
    else if c<42{s-=1;if a!=0{i=r[s]as usize;s+=1}}
    else if c<43{o(a)}
    else if c<56{r[c%8]=a}
    else if c<64{a=r[c%8]}
    else if c<72{a=a-r[c%8]}
    else{a=c as i32}
  }
}

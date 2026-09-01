# Tcl

binary scan "<QCImage/>" c* p;
lappend p 0;
set v [lrepeat 99 0];
binary scan [lindex "$argv tcl" 0] c* i;
set c 0;
foreach a $i {lset v [expr $c%8] $a;incr c};
set r 0;set b <QCConst>entrypoint</QCConst>;set a 0;set d 0;set s 7;
fconfigure stdout -t binary;
while {[set c [lindex $p $b]]} {
  incr b;
  if {$d} {
    # Mode continuation: d<0 prints up to 47 '/' (the Hx -> x-33 escape happens only here), d>0 counts ( ) and skips until depth 0
    if {$d<0} {
      if {$c-47} {
        if {$c==72} {set c [expr [lindex $p $b]-33];incr b};puts -nonewline [format %c $c]
      } {set d 0}
    } elseif {$c>>1==20} {incr d [expr 81-2*$c]}
  } elseif {$c<34} {set d -1} elseif {$c<39} {
    # 38 '&' READ: a=p[r] (0 past the end)
    set a [lindex $p $r];incr r
  } elseif {$c<41} {
    # 40 '(' loop: enter (push) if acc!=0, else switch to skip mode
    if {$a} {lset v [incr s] $b} {set d 1}
  } elseif {$c<42} {
    # 41 ')' loop end: if acc!=0 jump to the return position (peek), else pop
    if {$a} {set b [lindex $v $s]} {incr s -1}
  } elseif {$c<43} {puts -nonewline [format %c $a]} elseif {$c<56} {
    # 42 '*' output (the branch above) / 48..55 store
    lset v [expr $c%8] $a
  } else {
    # 56.. load(c<64)/sub(c<72)/immediate
    set a [expr $c<64?[lindex $v [expr $c%8]]:$c<72?$a-[lindex $v [expr $c%8]]:$c]
  }
}

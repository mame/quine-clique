all: test

members: qc.clj qc.lisp qc.rkt qc.rs qc.c qc.cpp qc.scala qc.f90 \
  qc.scm qc.r qc.lua qc.go qc.ps qc.vala qc.pike qc.pas \
  qc.kt qc.m qc.ml qc.hs qc.zig qc.sml qc.octave qc.groovy \
  qc.ws qc.coffee qc.swift qc.py qc.fs qc.nim qc.fsx qc.tcl \
  qc.bf qc.java qc.php qc.bash qc.d qc.pl qc.exs qc.rb \
  qc.js qc.ts qc.erl qc.cs qc.prolog qc.cr qc.unl qc.hx \
  qc.bef qc.awk qc.piet.gif

build output:
	mkdir -p $@

vendor/bin/%: vendor/%.c
	$(MAKE) -C vendor bin/$*

qc.clj: qc.rb
	ruby qc.rb clj > $@

qc.lisp: qc.rb
	ruby qc.rb lisp > $@

qc.rkt: qc.rb
	ruby qc.rb rkt > $@

qc.rs: qc.rb
	ruby qc.rb rs > $@

qc.c: qc.rb
	ruby qc.rb c > $@

qc.cpp: qc.rb
	ruby qc.rb cpp > $@

qc.scala: qc.rb
	ruby qc.rb scala > $@

qc.f90: qc.rb
	ruby qc.rb f90 > $@

qc.scm: qc.rb
	ruby qc.rb scm > $@

qc.r: qc.rb
	ruby qc.rb r > $@

qc.lua: qc.rb
	ruby qc.rb lua > $@

qc.go: qc.rb
	ruby qc.rb go > $@

qc.ps: qc.rb
	ruby qc.rb ps > $@

qc.vala: qc.rb
	ruby qc.rb vala > $@

qc.pike: qc.rb
	ruby qc.rb pike > $@

qc.pas: qc.rb
	ruby qc.rb pas > $@

qc.kt: qc.rb
	ruby qc.rb kt > $@

qc.m: qc.rb
	ruby qc.rb m > $@

qc.ml: qc.rb
	ruby qc.rb ml > $@

qc.hs: qc.rb
	ruby qc.rb hs > $@

qc.zig: qc.rb
	ruby qc.rb zig > $@

qc.sml: qc.rb
	ruby qc.rb sml > $@

qc.octave: qc.rb
	ruby qc.rb octave > $@

qc.groovy: qc.rb
	ruby qc.rb groovy > $@

qc.ws: qc.rb
	ruby qc.rb ws > $@

qc.coffee: qc.rb
	ruby qc.rb coffee > $@

qc.swift: qc.rb
	ruby qc.rb swift > $@

qc.py: qc.rb
	ruby qc.rb py > $@

qc.fs: qc.rb
	ruby qc.rb fs > $@

qc.nim: qc.rb
	ruby qc.rb nim > $@

qc.fsx: qc.rb
	ruby qc.rb fsx > $@

qc.tcl: qc.rb
	ruby qc.rb tcl > $@

qc.bf: qc.rb
	ruby qc.rb bf > $@

qc.java: qc.rb
	ruby qc.rb java > $@

qc.php: qc.rb
	ruby qc.rb php > $@

qc.bash: qc.rb
	ruby qc.rb bash > $@

qc.d: qc.rb
	ruby qc.rb d > $@

qc.pl: qc.rb
	ruby qc.rb pl > $@

qc.exs: qc.rb
	ruby qc.rb exs > $@

qc.js: qc.rb
	ruby qc.rb js > $@

qc.ts: qc.rb
	ruby qc.rb ts > $@

qc.erl: qc.rb
	ruby qc.rb erl > $@

qc.cs: qc.rb
	ruby qc.rb cs > $@

qc.prolog: qc.rb
	ruby qc.rb prolog > $@

qc.cr: qc.rb
	ruby qc.rb cr > $@

qc.unl: qc.rb
	ruby qc.rb unl > $@

qc.hx: qc.rb
	ruby qc.rb hx > $@

qc.bef: qc.rb
	ruby qc.rb bef > $@

qc.awk: qc.rb
	ruby qc.rb awk > $@

qc.piet.gif: qc.rb
	ruby qc.rb piet > $@

build/qc.rs.exe: qc.rs | build
	rustc -o build/qc.rs.exe qc.rs

build/qc.c.exe: qc.c | build
	cc -Wno-trigraphs -o build/qc.c.exe qc.c

build/qc.cpp.exe: qc.cpp | build
	g++ -Wno-trigraphs -o build/qc.cpp.exe qc.cpp

build/qc.f90.exe: qc.f90 | build
	gfortran -ffree-line-length-none -o build/qc.f90.exe qc.f90

build/qc.vala.exe: qc.vala | build
	valac -o build/qc.vala.exe qc.vala

build/qc.pas.exe: qc.pas | build
	fpc -obuild/qc.pas.exe qc.pas

build/qc.kt.exe.jar: qc.kt | build
	env JAVA_OPTS="-Xmx256M -Xms32M --enable-native-access=ALL-UNNAMED --sun-misc-unsafe-memory-access=allow" kotlinc qc.kt -include-runtime -d build/qc.kt.exe.jar

build/qc.m.exe: qc.m | build
	gcc -Wno-trigraphs -o build/qc.m.exe qc.m

build/qc.hs.exe: qc.hs | build
	ghc -outputdir build/qc.hs.exe.d -o build/qc.hs.exe qc.hs

build/qc.zig.exe: qc.zig | build
	zig build-exe -femit-bin=build/qc.zig.exe -O Debug qc.zig

build/qc.sml.exe: qc.sml | build
	mlton -output build/qc.sml.exe qc.sml

build/qc.swift.exe: qc.swift | build
	swiftc -o build/qc.swift.exe qc.swift

build/qc.nim.exe: qc.nim | build
	nim c -d:release --hints:off -o:build/qc.nim.exe qc.nim

build/qc.class: qc.java | build
	javac -d build qc.java

build/qc.d.exe: qc.d | build
	gdc -o build/qc.d.exe qc.d

build/qc.ts.exe.js: qc.ts | build
	tsc --typeRoots $$(node -p "require('path').resolve(require.resolve('@types/node/package.json'),'../..')") --types node --outFile build/qc.ts.exe.js qc.ts

build/qc.cs.exe.exe: qc.cs | build
	mcs -out:build/qc.cs.exe.exe qc.cs

build/qc.cr.exe: qc.cr | build
	crystal build --no-debug -o build/qc.cr.exe qc.cr

build/qc.hx.exe.n: qc.hx | build
	cp qc.hx build/Qc.hx && haxe -cp build -main Qc -neko build/qc.hx.exe.n

test-clj-clj: qc.clj qc.clj | output
	clojure qc.clj > output/qc.clj.clj
	diff -s qc.clj output/qc.clj.clj

test-clj-lisp: qc.clj qc.lisp | output
	clojure qc.clj lisp > output/qc.clj.lisp
	diff -s qc.lisp output/qc.clj.lisp

test-clj-rkt: qc.clj qc.rkt | output
	clojure qc.clj rkt > output/qc.clj.rkt
	diff -s qc.rkt output/qc.clj.rkt

test-clj-rs: qc.clj qc.rs | output
	clojure qc.clj rs > output/qc.clj.rs
	diff -s qc.rs output/qc.clj.rs

test-clj-c: qc.clj qc.c | output
	clojure qc.clj c > output/qc.clj.c
	diff -s qc.c output/qc.clj.c

test-clj-cpp: qc.clj qc.cpp | output
	clojure qc.clj cpp > output/qc.clj.cpp
	diff -s qc.cpp output/qc.clj.cpp

test-clj-scala: qc.clj qc.scala | output
	clojure qc.clj scala > output/qc.clj.scala
	diff -s qc.scala output/qc.clj.scala

test-clj-f90: qc.clj qc.f90 | output
	clojure qc.clj f90 > output/qc.clj.f90
	diff -s qc.f90 output/qc.clj.f90

test-clj-scm: qc.clj qc.scm | output
	clojure qc.clj scm > output/qc.clj.scm
	diff -s qc.scm output/qc.clj.scm

test-clj-r: qc.clj qc.r | output
	clojure qc.clj r > output/qc.clj.r
	diff -s qc.r output/qc.clj.r

test-clj-lua: qc.clj qc.lua | output
	clojure qc.clj lua > output/qc.clj.lua
	diff -s qc.lua output/qc.clj.lua

test-clj-go: qc.clj qc.go | output
	clojure qc.clj go > output/qc.clj.go
	diff -s qc.go output/qc.clj.go

test-clj-ps: qc.clj qc.ps | output
	clojure qc.clj ps > output/qc.clj.ps
	diff -s qc.ps output/qc.clj.ps

test-clj-vala: qc.clj qc.vala | output
	clojure qc.clj vala > output/qc.clj.vala
	diff -s qc.vala output/qc.clj.vala

test-clj-pike: qc.clj qc.pike | output
	clojure qc.clj pike > output/qc.clj.pike
	diff -s qc.pike output/qc.clj.pike

test-clj-pas: qc.clj qc.pas | output
	clojure qc.clj pas > output/qc.clj.pas
	diff -s qc.pas output/qc.clj.pas

test-clj-kt: qc.clj qc.kt | output
	clojure qc.clj kt > output/qc.clj.kt
	diff -s qc.kt output/qc.clj.kt

test-clj-m: qc.clj qc.m | output
	clojure qc.clj m > output/qc.clj.m
	diff -s qc.m output/qc.clj.m

test-clj-ml: qc.clj qc.ml | output
	clojure qc.clj ml > output/qc.clj.ml
	diff -s qc.ml output/qc.clj.ml

test-clj-hs: qc.clj qc.hs | output
	clojure qc.clj hs > output/qc.clj.hs
	diff -s qc.hs output/qc.clj.hs

test-clj-zig: qc.clj qc.zig | output
	clojure qc.clj zig > output/qc.clj.zig
	diff -s qc.zig output/qc.clj.zig

test-clj-sml: qc.clj qc.sml | output
	clojure qc.clj sml > output/qc.clj.sml
	diff -s qc.sml output/qc.clj.sml

test-clj-octave: qc.clj qc.octave | output
	clojure qc.clj octave > output/qc.clj.octave
	diff -s qc.octave output/qc.clj.octave

test-clj-groovy: qc.clj qc.groovy | output
	clojure qc.clj groovy > output/qc.clj.groovy
	diff -s qc.groovy output/qc.clj.groovy

test-clj-ws: qc.clj qc.ws | output
	clojure qc.clj ws > output/qc.clj.ws
	diff -s qc.ws output/qc.clj.ws

test-clj-coffee: qc.clj qc.coffee | output
	clojure qc.clj coffee > output/qc.clj.coffee
	diff -s qc.coffee output/qc.clj.coffee

test-clj-swift: qc.clj qc.swift | output
	clojure qc.clj swift > output/qc.clj.swift
	diff -s qc.swift output/qc.clj.swift

test-clj-py: qc.clj qc.py | output
	clojure qc.clj py > output/qc.clj.py
	diff -s qc.py output/qc.clj.py

test-clj-fs: qc.clj qc.fs | output
	clojure qc.clj fs > output/qc.clj.fs
	diff -s qc.fs output/qc.clj.fs

test-clj-nim: qc.clj qc.nim | output
	clojure qc.clj nim > output/qc.clj.nim
	diff -s qc.nim output/qc.clj.nim

test-clj-fsx: qc.clj qc.fsx | output
	clojure qc.clj fsx > output/qc.clj.fsx
	diff -s qc.fsx output/qc.clj.fsx

test-clj-tcl: qc.clj qc.tcl | output
	clojure qc.clj tcl > output/qc.clj.tcl
	diff -s qc.tcl output/qc.clj.tcl

test-clj-bf: qc.clj qc.bf | output
	clojure qc.clj bf > output/qc.clj.bf
	diff -s qc.bf output/qc.clj.bf

test-clj-java: qc.clj qc.java | output
	clojure qc.clj java > output/qc.clj.java
	diff -s qc.java output/qc.clj.java

test-clj-php: qc.clj qc.php | output
	clojure qc.clj php > output/qc.clj.php
	diff -s qc.php output/qc.clj.php

test-clj-bash: qc.clj qc.bash | output
	clojure qc.clj bash > output/qc.clj.bash
	diff -s qc.bash output/qc.clj.bash

test-clj-d: qc.clj qc.d | output
	clojure qc.clj d > output/qc.clj.d
	diff -s qc.d output/qc.clj.d

test-clj-pl: qc.clj qc.pl | output
	clojure qc.clj pl > output/qc.clj.pl
	diff -s qc.pl output/qc.clj.pl

test-clj-exs: qc.clj qc.exs | output
	clojure qc.clj exs > output/qc.clj.exs
	diff -s qc.exs output/qc.clj.exs

test-clj-rb: qc.clj qc.rb | output
	clojure qc.clj rb > output/qc.clj.rb
	diff -s qc.rb output/qc.clj.rb

test-clj-js: qc.clj qc.js | output
	clojure qc.clj js > output/qc.clj.js
	diff -s qc.js output/qc.clj.js

test-clj-ts: qc.clj qc.ts | output
	clojure qc.clj ts > output/qc.clj.ts
	diff -s qc.ts output/qc.clj.ts

test-clj-erl: qc.clj qc.erl | output
	clojure qc.clj erl > output/qc.clj.erl
	diff -s qc.erl output/qc.clj.erl

test-clj-cs: qc.clj qc.cs | output
	clojure qc.clj cs > output/qc.clj.cs
	diff -s qc.cs output/qc.clj.cs

test-clj-prolog: qc.clj qc.prolog | output
	clojure qc.clj prolog > output/qc.clj.prolog
	diff -s qc.prolog output/qc.clj.prolog

test-clj-cr: qc.clj qc.cr | output
	clojure qc.clj cr > output/qc.clj.cr
	diff -s qc.cr output/qc.clj.cr

test-clj-unl: qc.clj qc.unl | output
	clojure qc.clj unl > output/qc.clj.unl
	diff -s qc.unl output/qc.clj.unl

test-clj-hx: qc.clj qc.hx | output
	clojure qc.clj hx > output/qc.clj.hx
	diff -s qc.hx output/qc.clj.hx

test-clj-bef: qc.clj qc.bef | output
	clojure qc.clj bef > output/qc.clj.bef
	diff -s qc.bef output/qc.clj.bef

test-clj-awk: qc.clj qc.awk | output
	clojure qc.clj awk > output/qc.clj.awk
	diff -s qc.awk output/qc.clj.awk

test-clj-piet: qc.clj qc.piet.gif | output
	clojure qc.clj piet > output/qc.clj.piet
	diff -s qc.piet.gif output/qc.clj.piet

test-lisp-clj: qc.lisp qc.clj | output
	clisp -E iso-8859-1 qc.lisp clj > output/qc.lisp.clj
	diff -s qc.clj output/qc.lisp.clj

test-lisp-lisp: qc.lisp qc.lisp | output
	clisp -E iso-8859-1 qc.lisp > output/qc.lisp.lisp
	diff -s qc.lisp output/qc.lisp.lisp

test-lisp-rkt: qc.lisp qc.rkt | output
	clisp -E iso-8859-1 qc.lisp rkt > output/qc.lisp.rkt
	diff -s qc.rkt output/qc.lisp.rkt

test-lisp-rs: qc.lisp qc.rs | output
	clisp -E iso-8859-1 qc.lisp rs > output/qc.lisp.rs
	diff -s qc.rs output/qc.lisp.rs

test-lisp-c: qc.lisp qc.c | output
	clisp -E iso-8859-1 qc.lisp c > output/qc.lisp.c
	diff -s qc.c output/qc.lisp.c

test-lisp-cpp: qc.lisp qc.cpp | output
	clisp -E iso-8859-1 qc.lisp cpp > output/qc.lisp.cpp
	diff -s qc.cpp output/qc.lisp.cpp

test-lisp-scala: qc.lisp qc.scala | output
	clisp -E iso-8859-1 qc.lisp scala > output/qc.lisp.scala
	diff -s qc.scala output/qc.lisp.scala

test-lisp-f90: qc.lisp qc.f90 | output
	clisp -E iso-8859-1 qc.lisp f90 > output/qc.lisp.f90
	diff -s qc.f90 output/qc.lisp.f90

test-lisp-scm: qc.lisp qc.scm | output
	clisp -E iso-8859-1 qc.lisp scm > output/qc.lisp.scm
	diff -s qc.scm output/qc.lisp.scm

test-lisp-r: qc.lisp qc.r | output
	clisp -E iso-8859-1 qc.lisp r > output/qc.lisp.r
	diff -s qc.r output/qc.lisp.r

test-lisp-lua: qc.lisp qc.lua | output
	clisp -E iso-8859-1 qc.lisp lua > output/qc.lisp.lua
	diff -s qc.lua output/qc.lisp.lua

test-lisp-go: qc.lisp qc.go | output
	clisp -E iso-8859-1 qc.lisp go > output/qc.lisp.go
	diff -s qc.go output/qc.lisp.go

test-lisp-ps: qc.lisp qc.ps | output
	clisp -E iso-8859-1 qc.lisp ps > output/qc.lisp.ps
	diff -s qc.ps output/qc.lisp.ps

test-lisp-vala: qc.lisp qc.vala | output
	clisp -E iso-8859-1 qc.lisp vala > output/qc.lisp.vala
	diff -s qc.vala output/qc.lisp.vala

test-lisp-pike: qc.lisp qc.pike | output
	clisp -E iso-8859-1 qc.lisp pike > output/qc.lisp.pike
	diff -s qc.pike output/qc.lisp.pike

test-lisp-pas: qc.lisp qc.pas | output
	clisp -E iso-8859-1 qc.lisp pas > output/qc.lisp.pas
	diff -s qc.pas output/qc.lisp.pas

test-lisp-kt: qc.lisp qc.kt | output
	clisp -E iso-8859-1 qc.lisp kt > output/qc.lisp.kt
	diff -s qc.kt output/qc.lisp.kt

test-lisp-m: qc.lisp qc.m | output
	clisp -E iso-8859-1 qc.lisp m > output/qc.lisp.m
	diff -s qc.m output/qc.lisp.m

test-lisp-ml: qc.lisp qc.ml | output
	clisp -E iso-8859-1 qc.lisp ml > output/qc.lisp.ml
	diff -s qc.ml output/qc.lisp.ml

test-lisp-hs: qc.lisp qc.hs | output
	clisp -E iso-8859-1 qc.lisp hs > output/qc.lisp.hs
	diff -s qc.hs output/qc.lisp.hs

test-lisp-zig: qc.lisp qc.zig | output
	clisp -E iso-8859-1 qc.lisp zig > output/qc.lisp.zig
	diff -s qc.zig output/qc.lisp.zig

test-lisp-sml: qc.lisp qc.sml | output
	clisp -E iso-8859-1 qc.lisp sml > output/qc.lisp.sml
	diff -s qc.sml output/qc.lisp.sml

test-lisp-octave: qc.lisp qc.octave | output
	clisp -E iso-8859-1 qc.lisp octave > output/qc.lisp.octave
	diff -s qc.octave output/qc.lisp.octave

test-lisp-groovy: qc.lisp qc.groovy | output
	clisp -E iso-8859-1 qc.lisp groovy > output/qc.lisp.groovy
	diff -s qc.groovy output/qc.lisp.groovy

test-lisp-ws: qc.lisp qc.ws | output
	clisp -E iso-8859-1 qc.lisp ws > output/qc.lisp.ws
	diff -s qc.ws output/qc.lisp.ws

test-lisp-coffee: qc.lisp qc.coffee | output
	clisp -E iso-8859-1 qc.lisp coffee > output/qc.lisp.coffee
	diff -s qc.coffee output/qc.lisp.coffee

test-lisp-swift: qc.lisp qc.swift | output
	clisp -E iso-8859-1 qc.lisp swift > output/qc.lisp.swift
	diff -s qc.swift output/qc.lisp.swift

test-lisp-py: qc.lisp qc.py | output
	clisp -E iso-8859-1 qc.lisp py > output/qc.lisp.py
	diff -s qc.py output/qc.lisp.py

test-lisp-fs: qc.lisp qc.fs | output
	clisp -E iso-8859-1 qc.lisp fs > output/qc.lisp.fs
	diff -s qc.fs output/qc.lisp.fs

test-lisp-nim: qc.lisp qc.nim | output
	clisp -E iso-8859-1 qc.lisp nim > output/qc.lisp.nim
	diff -s qc.nim output/qc.lisp.nim

test-lisp-fsx: qc.lisp qc.fsx | output
	clisp -E iso-8859-1 qc.lisp fsx > output/qc.lisp.fsx
	diff -s qc.fsx output/qc.lisp.fsx

test-lisp-tcl: qc.lisp qc.tcl | output
	clisp -E iso-8859-1 qc.lisp tcl > output/qc.lisp.tcl
	diff -s qc.tcl output/qc.lisp.tcl

test-lisp-bf: qc.lisp qc.bf | output
	clisp -E iso-8859-1 qc.lisp bf > output/qc.lisp.bf
	diff -s qc.bf output/qc.lisp.bf

test-lisp-java: qc.lisp qc.java | output
	clisp -E iso-8859-1 qc.lisp java > output/qc.lisp.java
	diff -s qc.java output/qc.lisp.java

test-lisp-php: qc.lisp qc.php | output
	clisp -E iso-8859-1 qc.lisp php > output/qc.lisp.php
	diff -s qc.php output/qc.lisp.php

test-lisp-bash: qc.lisp qc.bash | output
	clisp -E iso-8859-1 qc.lisp bash > output/qc.lisp.bash
	diff -s qc.bash output/qc.lisp.bash

test-lisp-d: qc.lisp qc.d | output
	clisp -E iso-8859-1 qc.lisp d > output/qc.lisp.d
	diff -s qc.d output/qc.lisp.d

test-lisp-pl: qc.lisp qc.pl | output
	clisp -E iso-8859-1 qc.lisp pl > output/qc.lisp.pl
	diff -s qc.pl output/qc.lisp.pl

test-lisp-exs: qc.lisp qc.exs | output
	clisp -E iso-8859-1 qc.lisp exs > output/qc.lisp.exs
	diff -s qc.exs output/qc.lisp.exs

test-lisp-rb: qc.lisp qc.rb | output
	clisp -E iso-8859-1 qc.lisp rb > output/qc.lisp.rb
	diff -s qc.rb output/qc.lisp.rb

test-lisp-js: qc.lisp qc.js | output
	clisp -E iso-8859-1 qc.lisp js > output/qc.lisp.js
	diff -s qc.js output/qc.lisp.js

test-lisp-ts: qc.lisp qc.ts | output
	clisp -E iso-8859-1 qc.lisp ts > output/qc.lisp.ts
	diff -s qc.ts output/qc.lisp.ts

test-lisp-erl: qc.lisp qc.erl | output
	clisp -E iso-8859-1 qc.lisp erl > output/qc.lisp.erl
	diff -s qc.erl output/qc.lisp.erl

test-lisp-cs: qc.lisp qc.cs | output
	clisp -E iso-8859-1 qc.lisp cs > output/qc.lisp.cs
	diff -s qc.cs output/qc.lisp.cs

test-lisp-prolog: qc.lisp qc.prolog | output
	clisp -E iso-8859-1 qc.lisp prolog > output/qc.lisp.prolog
	diff -s qc.prolog output/qc.lisp.prolog

test-lisp-cr: qc.lisp qc.cr | output
	clisp -E iso-8859-1 qc.lisp cr > output/qc.lisp.cr
	diff -s qc.cr output/qc.lisp.cr

test-lisp-unl: qc.lisp qc.unl | output
	clisp -E iso-8859-1 qc.lisp unl > output/qc.lisp.unl
	diff -s qc.unl output/qc.lisp.unl

test-lisp-hx: qc.lisp qc.hx | output
	clisp -E iso-8859-1 qc.lisp hx > output/qc.lisp.hx
	diff -s qc.hx output/qc.lisp.hx

test-lisp-bef: qc.lisp qc.bef | output
	clisp -E iso-8859-1 qc.lisp bef > output/qc.lisp.bef
	diff -s qc.bef output/qc.lisp.bef

test-lisp-awk: qc.lisp qc.awk | output
	clisp -E iso-8859-1 qc.lisp awk > output/qc.lisp.awk
	diff -s qc.awk output/qc.lisp.awk

test-lisp-piet: qc.lisp qc.piet.gif | output
	clisp -E iso-8859-1 qc.lisp piet > output/qc.lisp.piet
	diff -s qc.piet.gif output/qc.lisp.piet

test-rkt-clj: qc.rkt qc.clj | output
	racket qc.rkt clj > output/qc.rkt.clj
	diff -s qc.clj output/qc.rkt.clj

test-rkt-lisp: qc.rkt qc.lisp | output
	racket qc.rkt lisp > output/qc.rkt.lisp
	diff -s qc.lisp output/qc.rkt.lisp

test-rkt-rkt: qc.rkt qc.rkt | output
	racket qc.rkt > output/qc.rkt.rkt
	diff -s qc.rkt output/qc.rkt.rkt

test-rkt-rs: qc.rkt qc.rs | output
	racket qc.rkt rs > output/qc.rkt.rs
	diff -s qc.rs output/qc.rkt.rs

test-rkt-c: qc.rkt qc.c | output
	racket qc.rkt c > output/qc.rkt.c
	diff -s qc.c output/qc.rkt.c

test-rkt-cpp: qc.rkt qc.cpp | output
	racket qc.rkt cpp > output/qc.rkt.cpp
	diff -s qc.cpp output/qc.rkt.cpp

test-rkt-scala: qc.rkt qc.scala | output
	racket qc.rkt scala > output/qc.rkt.scala
	diff -s qc.scala output/qc.rkt.scala

test-rkt-f90: qc.rkt qc.f90 | output
	racket qc.rkt f90 > output/qc.rkt.f90
	diff -s qc.f90 output/qc.rkt.f90

test-rkt-scm: qc.rkt qc.scm | output
	racket qc.rkt scm > output/qc.rkt.scm
	diff -s qc.scm output/qc.rkt.scm

test-rkt-r: qc.rkt qc.r | output
	racket qc.rkt r > output/qc.rkt.r
	diff -s qc.r output/qc.rkt.r

test-rkt-lua: qc.rkt qc.lua | output
	racket qc.rkt lua > output/qc.rkt.lua
	diff -s qc.lua output/qc.rkt.lua

test-rkt-go: qc.rkt qc.go | output
	racket qc.rkt go > output/qc.rkt.go
	diff -s qc.go output/qc.rkt.go

test-rkt-ps: qc.rkt qc.ps | output
	racket qc.rkt ps > output/qc.rkt.ps
	diff -s qc.ps output/qc.rkt.ps

test-rkt-vala: qc.rkt qc.vala | output
	racket qc.rkt vala > output/qc.rkt.vala
	diff -s qc.vala output/qc.rkt.vala

test-rkt-pike: qc.rkt qc.pike | output
	racket qc.rkt pike > output/qc.rkt.pike
	diff -s qc.pike output/qc.rkt.pike

test-rkt-pas: qc.rkt qc.pas | output
	racket qc.rkt pas > output/qc.rkt.pas
	diff -s qc.pas output/qc.rkt.pas

test-rkt-kt: qc.rkt qc.kt | output
	racket qc.rkt kt > output/qc.rkt.kt
	diff -s qc.kt output/qc.rkt.kt

test-rkt-m: qc.rkt qc.m | output
	racket qc.rkt m > output/qc.rkt.m
	diff -s qc.m output/qc.rkt.m

test-rkt-ml: qc.rkt qc.ml | output
	racket qc.rkt ml > output/qc.rkt.ml
	diff -s qc.ml output/qc.rkt.ml

test-rkt-hs: qc.rkt qc.hs | output
	racket qc.rkt hs > output/qc.rkt.hs
	diff -s qc.hs output/qc.rkt.hs

test-rkt-zig: qc.rkt qc.zig | output
	racket qc.rkt zig > output/qc.rkt.zig
	diff -s qc.zig output/qc.rkt.zig

test-rkt-sml: qc.rkt qc.sml | output
	racket qc.rkt sml > output/qc.rkt.sml
	diff -s qc.sml output/qc.rkt.sml

test-rkt-octave: qc.rkt qc.octave | output
	racket qc.rkt octave > output/qc.rkt.octave
	diff -s qc.octave output/qc.rkt.octave

test-rkt-groovy: qc.rkt qc.groovy | output
	racket qc.rkt groovy > output/qc.rkt.groovy
	diff -s qc.groovy output/qc.rkt.groovy

test-rkt-ws: qc.rkt qc.ws | output
	racket qc.rkt ws > output/qc.rkt.ws
	diff -s qc.ws output/qc.rkt.ws

test-rkt-coffee: qc.rkt qc.coffee | output
	racket qc.rkt coffee > output/qc.rkt.coffee
	diff -s qc.coffee output/qc.rkt.coffee

test-rkt-swift: qc.rkt qc.swift | output
	racket qc.rkt swift > output/qc.rkt.swift
	diff -s qc.swift output/qc.rkt.swift

test-rkt-py: qc.rkt qc.py | output
	racket qc.rkt py > output/qc.rkt.py
	diff -s qc.py output/qc.rkt.py

test-rkt-fs: qc.rkt qc.fs | output
	racket qc.rkt fs > output/qc.rkt.fs
	diff -s qc.fs output/qc.rkt.fs

test-rkt-nim: qc.rkt qc.nim | output
	racket qc.rkt nim > output/qc.rkt.nim
	diff -s qc.nim output/qc.rkt.nim

test-rkt-fsx: qc.rkt qc.fsx | output
	racket qc.rkt fsx > output/qc.rkt.fsx
	diff -s qc.fsx output/qc.rkt.fsx

test-rkt-tcl: qc.rkt qc.tcl | output
	racket qc.rkt tcl > output/qc.rkt.tcl
	diff -s qc.tcl output/qc.rkt.tcl

test-rkt-bf: qc.rkt qc.bf | output
	racket qc.rkt bf > output/qc.rkt.bf
	diff -s qc.bf output/qc.rkt.bf

test-rkt-java: qc.rkt qc.java | output
	racket qc.rkt java > output/qc.rkt.java
	diff -s qc.java output/qc.rkt.java

test-rkt-php: qc.rkt qc.php | output
	racket qc.rkt php > output/qc.rkt.php
	diff -s qc.php output/qc.rkt.php

test-rkt-bash: qc.rkt qc.bash | output
	racket qc.rkt bash > output/qc.rkt.bash
	diff -s qc.bash output/qc.rkt.bash

test-rkt-d: qc.rkt qc.d | output
	racket qc.rkt d > output/qc.rkt.d
	diff -s qc.d output/qc.rkt.d

test-rkt-pl: qc.rkt qc.pl | output
	racket qc.rkt pl > output/qc.rkt.pl
	diff -s qc.pl output/qc.rkt.pl

test-rkt-exs: qc.rkt qc.exs | output
	racket qc.rkt exs > output/qc.rkt.exs
	diff -s qc.exs output/qc.rkt.exs

test-rkt-rb: qc.rkt qc.rb | output
	racket qc.rkt rb > output/qc.rkt.rb
	diff -s qc.rb output/qc.rkt.rb

test-rkt-js: qc.rkt qc.js | output
	racket qc.rkt js > output/qc.rkt.js
	diff -s qc.js output/qc.rkt.js

test-rkt-ts: qc.rkt qc.ts | output
	racket qc.rkt ts > output/qc.rkt.ts
	diff -s qc.ts output/qc.rkt.ts

test-rkt-erl: qc.rkt qc.erl | output
	racket qc.rkt erl > output/qc.rkt.erl
	diff -s qc.erl output/qc.rkt.erl

test-rkt-cs: qc.rkt qc.cs | output
	racket qc.rkt cs > output/qc.rkt.cs
	diff -s qc.cs output/qc.rkt.cs

test-rkt-prolog: qc.rkt qc.prolog | output
	racket qc.rkt prolog > output/qc.rkt.prolog
	diff -s qc.prolog output/qc.rkt.prolog

test-rkt-cr: qc.rkt qc.cr | output
	racket qc.rkt cr > output/qc.rkt.cr
	diff -s qc.cr output/qc.rkt.cr

test-rkt-unl: qc.rkt qc.unl | output
	racket qc.rkt unl > output/qc.rkt.unl
	diff -s qc.unl output/qc.rkt.unl

test-rkt-hx: qc.rkt qc.hx | output
	racket qc.rkt hx > output/qc.rkt.hx
	diff -s qc.hx output/qc.rkt.hx

test-rkt-bef: qc.rkt qc.bef | output
	racket qc.rkt bef > output/qc.rkt.bef
	diff -s qc.bef output/qc.rkt.bef

test-rkt-awk: qc.rkt qc.awk | output
	racket qc.rkt awk > output/qc.rkt.awk
	diff -s qc.awk output/qc.rkt.awk

test-rkt-piet: qc.rkt qc.piet.gif | output
	racket qc.rkt piet > output/qc.rkt.piet
	diff -s qc.piet.gif output/qc.rkt.piet

test-rs-clj: build/qc.rs.exe qc.clj | output
	build/qc.rs.exe clj > output/qc.rs.clj
	diff -s qc.clj output/qc.rs.clj

test-rs-lisp: build/qc.rs.exe qc.lisp | output
	build/qc.rs.exe lisp > output/qc.rs.lisp
	diff -s qc.lisp output/qc.rs.lisp

test-rs-rkt: build/qc.rs.exe qc.rkt | output
	build/qc.rs.exe rkt > output/qc.rs.rkt
	diff -s qc.rkt output/qc.rs.rkt

test-rs-rs: build/qc.rs.exe qc.rs | output
	build/qc.rs.exe > output/qc.rs.rs
	diff -s qc.rs output/qc.rs.rs

test-rs-c: build/qc.rs.exe qc.c | output
	build/qc.rs.exe c > output/qc.rs.c
	diff -s qc.c output/qc.rs.c

test-rs-cpp: build/qc.rs.exe qc.cpp | output
	build/qc.rs.exe cpp > output/qc.rs.cpp
	diff -s qc.cpp output/qc.rs.cpp

test-rs-scala: build/qc.rs.exe qc.scala | output
	build/qc.rs.exe scala > output/qc.rs.scala
	diff -s qc.scala output/qc.rs.scala

test-rs-f90: build/qc.rs.exe qc.f90 | output
	build/qc.rs.exe f90 > output/qc.rs.f90
	diff -s qc.f90 output/qc.rs.f90

test-rs-scm: build/qc.rs.exe qc.scm | output
	build/qc.rs.exe scm > output/qc.rs.scm
	diff -s qc.scm output/qc.rs.scm

test-rs-r: build/qc.rs.exe qc.r | output
	build/qc.rs.exe r > output/qc.rs.r
	diff -s qc.r output/qc.rs.r

test-rs-lua: build/qc.rs.exe qc.lua | output
	build/qc.rs.exe lua > output/qc.rs.lua
	diff -s qc.lua output/qc.rs.lua

test-rs-go: build/qc.rs.exe qc.go | output
	build/qc.rs.exe go > output/qc.rs.go
	diff -s qc.go output/qc.rs.go

test-rs-ps: build/qc.rs.exe qc.ps | output
	build/qc.rs.exe ps > output/qc.rs.ps
	diff -s qc.ps output/qc.rs.ps

test-rs-vala: build/qc.rs.exe qc.vala | output
	build/qc.rs.exe vala > output/qc.rs.vala
	diff -s qc.vala output/qc.rs.vala

test-rs-pike: build/qc.rs.exe qc.pike | output
	build/qc.rs.exe pike > output/qc.rs.pike
	diff -s qc.pike output/qc.rs.pike

test-rs-pas: build/qc.rs.exe qc.pas | output
	build/qc.rs.exe pas > output/qc.rs.pas
	diff -s qc.pas output/qc.rs.pas

test-rs-kt: build/qc.rs.exe qc.kt | output
	build/qc.rs.exe kt > output/qc.rs.kt
	diff -s qc.kt output/qc.rs.kt

test-rs-m: build/qc.rs.exe qc.m | output
	build/qc.rs.exe m > output/qc.rs.m
	diff -s qc.m output/qc.rs.m

test-rs-ml: build/qc.rs.exe qc.ml | output
	build/qc.rs.exe ml > output/qc.rs.ml
	diff -s qc.ml output/qc.rs.ml

test-rs-hs: build/qc.rs.exe qc.hs | output
	build/qc.rs.exe hs > output/qc.rs.hs
	diff -s qc.hs output/qc.rs.hs

test-rs-zig: build/qc.rs.exe qc.zig | output
	build/qc.rs.exe zig > output/qc.rs.zig
	diff -s qc.zig output/qc.rs.zig

test-rs-sml: build/qc.rs.exe qc.sml | output
	build/qc.rs.exe sml > output/qc.rs.sml
	diff -s qc.sml output/qc.rs.sml

test-rs-octave: build/qc.rs.exe qc.octave | output
	build/qc.rs.exe octave > output/qc.rs.octave
	diff -s qc.octave output/qc.rs.octave

test-rs-groovy: build/qc.rs.exe qc.groovy | output
	build/qc.rs.exe groovy > output/qc.rs.groovy
	diff -s qc.groovy output/qc.rs.groovy

test-rs-ws: build/qc.rs.exe qc.ws | output
	build/qc.rs.exe ws > output/qc.rs.ws
	diff -s qc.ws output/qc.rs.ws

test-rs-coffee: build/qc.rs.exe qc.coffee | output
	build/qc.rs.exe coffee > output/qc.rs.coffee
	diff -s qc.coffee output/qc.rs.coffee

test-rs-swift: build/qc.rs.exe qc.swift | output
	build/qc.rs.exe swift > output/qc.rs.swift
	diff -s qc.swift output/qc.rs.swift

test-rs-py: build/qc.rs.exe qc.py | output
	build/qc.rs.exe py > output/qc.rs.py
	diff -s qc.py output/qc.rs.py

test-rs-fs: build/qc.rs.exe qc.fs | output
	build/qc.rs.exe fs > output/qc.rs.fs
	diff -s qc.fs output/qc.rs.fs

test-rs-nim: build/qc.rs.exe qc.nim | output
	build/qc.rs.exe nim > output/qc.rs.nim
	diff -s qc.nim output/qc.rs.nim

test-rs-fsx: build/qc.rs.exe qc.fsx | output
	build/qc.rs.exe fsx > output/qc.rs.fsx
	diff -s qc.fsx output/qc.rs.fsx

test-rs-tcl: build/qc.rs.exe qc.tcl | output
	build/qc.rs.exe tcl > output/qc.rs.tcl
	diff -s qc.tcl output/qc.rs.tcl

test-rs-bf: build/qc.rs.exe qc.bf | output
	build/qc.rs.exe bf > output/qc.rs.bf
	diff -s qc.bf output/qc.rs.bf

test-rs-java: build/qc.rs.exe qc.java | output
	build/qc.rs.exe java > output/qc.rs.java
	diff -s qc.java output/qc.rs.java

test-rs-php: build/qc.rs.exe qc.php | output
	build/qc.rs.exe php > output/qc.rs.php
	diff -s qc.php output/qc.rs.php

test-rs-bash: build/qc.rs.exe qc.bash | output
	build/qc.rs.exe bash > output/qc.rs.bash
	diff -s qc.bash output/qc.rs.bash

test-rs-d: build/qc.rs.exe qc.d | output
	build/qc.rs.exe d > output/qc.rs.d
	diff -s qc.d output/qc.rs.d

test-rs-pl: build/qc.rs.exe qc.pl | output
	build/qc.rs.exe pl > output/qc.rs.pl
	diff -s qc.pl output/qc.rs.pl

test-rs-exs: build/qc.rs.exe qc.exs | output
	build/qc.rs.exe exs > output/qc.rs.exs
	diff -s qc.exs output/qc.rs.exs

test-rs-rb: build/qc.rs.exe qc.rb | output
	build/qc.rs.exe rb > output/qc.rs.rb
	diff -s qc.rb output/qc.rs.rb

test-rs-js: build/qc.rs.exe qc.js | output
	build/qc.rs.exe js > output/qc.rs.js
	diff -s qc.js output/qc.rs.js

test-rs-ts: build/qc.rs.exe qc.ts | output
	build/qc.rs.exe ts > output/qc.rs.ts
	diff -s qc.ts output/qc.rs.ts

test-rs-erl: build/qc.rs.exe qc.erl | output
	build/qc.rs.exe erl > output/qc.rs.erl
	diff -s qc.erl output/qc.rs.erl

test-rs-cs: build/qc.rs.exe qc.cs | output
	build/qc.rs.exe cs > output/qc.rs.cs
	diff -s qc.cs output/qc.rs.cs

test-rs-prolog: build/qc.rs.exe qc.prolog | output
	build/qc.rs.exe prolog > output/qc.rs.prolog
	diff -s qc.prolog output/qc.rs.prolog

test-rs-cr: build/qc.rs.exe qc.cr | output
	build/qc.rs.exe cr > output/qc.rs.cr
	diff -s qc.cr output/qc.rs.cr

test-rs-unl: build/qc.rs.exe qc.unl | output
	build/qc.rs.exe unl > output/qc.rs.unl
	diff -s qc.unl output/qc.rs.unl

test-rs-hx: build/qc.rs.exe qc.hx | output
	build/qc.rs.exe hx > output/qc.rs.hx
	diff -s qc.hx output/qc.rs.hx

test-rs-bef: build/qc.rs.exe qc.bef | output
	build/qc.rs.exe bef > output/qc.rs.bef
	diff -s qc.bef output/qc.rs.bef

test-rs-awk: build/qc.rs.exe qc.awk | output
	build/qc.rs.exe awk > output/qc.rs.awk
	diff -s qc.awk output/qc.rs.awk

test-rs-piet: build/qc.rs.exe qc.piet.gif | output
	build/qc.rs.exe piet > output/qc.rs.piet
	diff -s qc.piet.gif output/qc.rs.piet

test-c-clj: build/qc.c.exe qc.clj | output
	build/qc.c.exe clj > output/qc.c.clj
	diff -s qc.clj output/qc.c.clj

test-c-lisp: build/qc.c.exe qc.lisp | output
	build/qc.c.exe lisp > output/qc.c.lisp
	diff -s qc.lisp output/qc.c.lisp

test-c-rkt: build/qc.c.exe qc.rkt | output
	build/qc.c.exe rkt > output/qc.c.rkt
	diff -s qc.rkt output/qc.c.rkt

test-c-rs: build/qc.c.exe qc.rs | output
	build/qc.c.exe rs > output/qc.c.rs
	diff -s qc.rs output/qc.c.rs

test-c-c: build/qc.c.exe qc.c | output
	build/qc.c.exe > output/qc.c.c
	diff -s qc.c output/qc.c.c

test-c-cpp: build/qc.c.exe qc.cpp | output
	build/qc.c.exe cpp > output/qc.c.cpp
	diff -s qc.cpp output/qc.c.cpp

test-c-scala: build/qc.c.exe qc.scala | output
	build/qc.c.exe scala > output/qc.c.scala
	diff -s qc.scala output/qc.c.scala

test-c-f90: build/qc.c.exe qc.f90 | output
	build/qc.c.exe f90 > output/qc.c.f90
	diff -s qc.f90 output/qc.c.f90

test-c-scm: build/qc.c.exe qc.scm | output
	build/qc.c.exe scm > output/qc.c.scm
	diff -s qc.scm output/qc.c.scm

test-c-r: build/qc.c.exe qc.r | output
	build/qc.c.exe r > output/qc.c.r
	diff -s qc.r output/qc.c.r

test-c-lua: build/qc.c.exe qc.lua | output
	build/qc.c.exe lua > output/qc.c.lua
	diff -s qc.lua output/qc.c.lua

test-c-go: build/qc.c.exe qc.go | output
	build/qc.c.exe go > output/qc.c.go
	diff -s qc.go output/qc.c.go

test-c-ps: build/qc.c.exe qc.ps | output
	build/qc.c.exe ps > output/qc.c.ps
	diff -s qc.ps output/qc.c.ps

test-c-vala: build/qc.c.exe qc.vala | output
	build/qc.c.exe vala > output/qc.c.vala
	diff -s qc.vala output/qc.c.vala

test-c-pike: build/qc.c.exe qc.pike | output
	build/qc.c.exe pike > output/qc.c.pike
	diff -s qc.pike output/qc.c.pike

test-c-pas: build/qc.c.exe qc.pas | output
	build/qc.c.exe pas > output/qc.c.pas
	diff -s qc.pas output/qc.c.pas

test-c-kt: build/qc.c.exe qc.kt | output
	build/qc.c.exe kt > output/qc.c.kt
	diff -s qc.kt output/qc.c.kt

test-c-m: build/qc.c.exe qc.m | output
	build/qc.c.exe m > output/qc.c.m
	diff -s qc.m output/qc.c.m

test-c-ml: build/qc.c.exe qc.ml | output
	build/qc.c.exe ml > output/qc.c.ml
	diff -s qc.ml output/qc.c.ml

test-c-hs: build/qc.c.exe qc.hs | output
	build/qc.c.exe hs > output/qc.c.hs
	diff -s qc.hs output/qc.c.hs

test-c-zig: build/qc.c.exe qc.zig | output
	build/qc.c.exe zig > output/qc.c.zig
	diff -s qc.zig output/qc.c.zig

test-c-sml: build/qc.c.exe qc.sml | output
	build/qc.c.exe sml > output/qc.c.sml
	diff -s qc.sml output/qc.c.sml

test-c-octave: build/qc.c.exe qc.octave | output
	build/qc.c.exe octave > output/qc.c.octave
	diff -s qc.octave output/qc.c.octave

test-c-groovy: build/qc.c.exe qc.groovy | output
	build/qc.c.exe groovy > output/qc.c.groovy
	diff -s qc.groovy output/qc.c.groovy

test-c-ws: build/qc.c.exe qc.ws | output
	build/qc.c.exe ws > output/qc.c.ws
	diff -s qc.ws output/qc.c.ws

test-c-coffee: build/qc.c.exe qc.coffee | output
	build/qc.c.exe coffee > output/qc.c.coffee
	diff -s qc.coffee output/qc.c.coffee

test-c-swift: build/qc.c.exe qc.swift | output
	build/qc.c.exe swift > output/qc.c.swift
	diff -s qc.swift output/qc.c.swift

test-c-py: build/qc.c.exe qc.py | output
	build/qc.c.exe py > output/qc.c.py
	diff -s qc.py output/qc.c.py

test-c-fs: build/qc.c.exe qc.fs | output
	build/qc.c.exe fs > output/qc.c.fs
	diff -s qc.fs output/qc.c.fs

test-c-nim: build/qc.c.exe qc.nim | output
	build/qc.c.exe nim > output/qc.c.nim
	diff -s qc.nim output/qc.c.nim

test-c-fsx: build/qc.c.exe qc.fsx | output
	build/qc.c.exe fsx > output/qc.c.fsx
	diff -s qc.fsx output/qc.c.fsx

test-c-tcl: build/qc.c.exe qc.tcl | output
	build/qc.c.exe tcl > output/qc.c.tcl
	diff -s qc.tcl output/qc.c.tcl

test-c-bf: build/qc.c.exe qc.bf | output
	build/qc.c.exe bf > output/qc.c.bf
	diff -s qc.bf output/qc.c.bf

test-c-java: build/qc.c.exe qc.java | output
	build/qc.c.exe java > output/qc.c.java
	diff -s qc.java output/qc.c.java

test-c-php: build/qc.c.exe qc.php | output
	build/qc.c.exe php > output/qc.c.php
	diff -s qc.php output/qc.c.php

test-c-bash: build/qc.c.exe qc.bash | output
	build/qc.c.exe bash > output/qc.c.bash
	diff -s qc.bash output/qc.c.bash

test-c-d: build/qc.c.exe qc.d | output
	build/qc.c.exe d > output/qc.c.d
	diff -s qc.d output/qc.c.d

test-c-pl: build/qc.c.exe qc.pl | output
	build/qc.c.exe pl > output/qc.c.pl
	diff -s qc.pl output/qc.c.pl

test-c-exs: build/qc.c.exe qc.exs | output
	build/qc.c.exe exs > output/qc.c.exs
	diff -s qc.exs output/qc.c.exs

test-c-rb: build/qc.c.exe qc.rb | output
	build/qc.c.exe rb > output/qc.c.rb
	diff -s qc.rb output/qc.c.rb

test-c-js: build/qc.c.exe qc.js | output
	build/qc.c.exe js > output/qc.c.js
	diff -s qc.js output/qc.c.js

test-c-ts: build/qc.c.exe qc.ts | output
	build/qc.c.exe ts > output/qc.c.ts
	diff -s qc.ts output/qc.c.ts

test-c-erl: build/qc.c.exe qc.erl | output
	build/qc.c.exe erl > output/qc.c.erl
	diff -s qc.erl output/qc.c.erl

test-c-cs: build/qc.c.exe qc.cs | output
	build/qc.c.exe cs > output/qc.c.cs
	diff -s qc.cs output/qc.c.cs

test-c-prolog: build/qc.c.exe qc.prolog | output
	build/qc.c.exe prolog > output/qc.c.prolog
	diff -s qc.prolog output/qc.c.prolog

test-c-cr: build/qc.c.exe qc.cr | output
	build/qc.c.exe cr > output/qc.c.cr
	diff -s qc.cr output/qc.c.cr

test-c-unl: build/qc.c.exe qc.unl | output
	build/qc.c.exe unl > output/qc.c.unl
	diff -s qc.unl output/qc.c.unl

test-c-hx: build/qc.c.exe qc.hx | output
	build/qc.c.exe hx > output/qc.c.hx
	diff -s qc.hx output/qc.c.hx

test-c-bef: build/qc.c.exe qc.bef | output
	build/qc.c.exe bef > output/qc.c.bef
	diff -s qc.bef output/qc.c.bef

test-c-awk: build/qc.c.exe qc.awk | output
	build/qc.c.exe awk > output/qc.c.awk
	diff -s qc.awk output/qc.c.awk

test-c-piet: build/qc.c.exe qc.piet.gif | output
	build/qc.c.exe piet > output/qc.c.piet
	diff -s qc.piet.gif output/qc.c.piet

test-cpp-clj: build/qc.cpp.exe qc.clj | output
	build/qc.cpp.exe clj > output/qc.cpp.clj
	diff -s qc.clj output/qc.cpp.clj

test-cpp-lisp: build/qc.cpp.exe qc.lisp | output
	build/qc.cpp.exe lisp > output/qc.cpp.lisp
	diff -s qc.lisp output/qc.cpp.lisp

test-cpp-rkt: build/qc.cpp.exe qc.rkt | output
	build/qc.cpp.exe rkt > output/qc.cpp.rkt
	diff -s qc.rkt output/qc.cpp.rkt

test-cpp-rs: build/qc.cpp.exe qc.rs | output
	build/qc.cpp.exe rs > output/qc.cpp.rs
	diff -s qc.rs output/qc.cpp.rs

test-cpp-c: build/qc.cpp.exe qc.c | output
	build/qc.cpp.exe c > output/qc.cpp.c
	diff -s qc.c output/qc.cpp.c

test-cpp-cpp: build/qc.cpp.exe qc.cpp | output
	build/qc.cpp.exe > output/qc.cpp.cpp
	diff -s qc.cpp output/qc.cpp.cpp

test-cpp-scala: build/qc.cpp.exe qc.scala | output
	build/qc.cpp.exe scala > output/qc.cpp.scala
	diff -s qc.scala output/qc.cpp.scala

test-cpp-f90: build/qc.cpp.exe qc.f90 | output
	build/qc.cpp.exe f90 > output/qc.cpp.f90
	diff -s qc.f90 output/qc.cpp.f90

test-cpp-scm: build/qc.cpp.exe qc.scm | output
	build/qc.cpp.exe scm > output/qc.cpp.scm
	diff -s qc.scm output/qc.cpp.scm

test-cpp-r: build/qc.cpp.exe qc.r | output
	build/qc.cpp.exe r > output/qc.cpp.r
	diff -s qc.r output/qc.cpp.r

test-cpp-lua: build/qc.cpp.exe qc.lua | output
	build/qc.cpp.exe lua > output/qc.cpp.lua
	diff -s qc.lua output/qc.cpp.lua

test-cpp-go: build/qc.cpp.exe qc.go | output
	build/qc.cpp.exe go > output/qc.cpp.go
	diff -s qc.go output/qc.cpp.go

test-cpp-ps: build/qc.cpp.exe qc.ps | output
	build/qc.cpp.exe ps > output/qc.cpp.ps
	diff -s qc.ps output/qc.cpp.ps

test-cpp-vala: build/qc.cpp.exe qc.vala | output
	build/qc.cpp.exe vala > output/qc.cpp.vala
	diff -s qc.vala output/qc.cpp.vala

test-cpp-pike: build/qc.cpp.exe qc.pike | output
	build/qc.cpp.exe pike > output/qc.cpp.pike
	diff -s qc.pike output/qc.cpp.pike

test-cpp-pas: build/qc.cpp.exe qc.pas | output
	build/qc.cpp.exe pas > output/qc.cpp.pas
	diff -s qc.pas output/qc.cpp.pas

test-cpp-kt: build/qc.cpp.exe qc.kt | output
	build/qc.cpp.exe kt > output/qc.cpp.kt
	diff -s qc.kt output/qc.cpp.kt

test-cpp-m: build/qc.cpp.exe qc.m | output
	build/qc.cpp.exe m > output/qc.cpp.m
	diff -s qc.m output/qc.cpp.m

test-cpp-ml: build/qc.cpp.exe qc.ml | output
	build/qc.cpp.exe ml > output/qc.cpp.ml
	diff -s qc.ml output/qc.cpp.ml

test-cpp-hs: build/qc.cpp.exe qc.hs | output
	build/qc.cpp.exe hs > output/qc.cpp.hs
	diff -s qc.hs output/qc.cpp.hs

test-cpp-zig: build/qc.cpp.exe qc.zig | output
	build/qc.cpp.exe zig > output/qc.cpp.zig
	diff -s qc.zig output/qc.cpp.zig

test-cpp-sml: build/qc.cpp.exe qc.sml | output
	build/qc.cpp.exe sml > output/qc.cpp.sml
	diff -s qc.sml output/qc.cpp.sml

test-cpp-octave: build/qc.cpp.exe qc.octave | output
	build/qc.cpp.exe octave > output/qc.cpp.octave
	diff -s qc.octave output/qc.cpp.octave

test-cpp-groovy: build/qc.cpp.exe qc.groovy | output
	build/qc.cpp.exe groovy > output/qc.cpp.groovy
	diff -s qc.groovy output/qc.cpp.groovy

test-cpp-ws: build/qc.cpp.exe qc.ws | output
	build/qc.cpp.exe ws > output/qc.cpp.ws
	diff -s qc.ws output/qc.cpp.ws

test-cpp-coffee: build/qc.cpp.exe qc.coffee | output
	build/qc.cpp.exe coffee > output/qc.cpp.coffee
	diff -s qc.coffee output/qc.cpp.coffee

test-cpp-swift: build/qc.cpp.exe qc.swift | output
	build/qc.cpp.exe swift > output/qc.cpp.swift
	diff -s qc.swift output/qc.cpp.swift

test-cpp-py: build/qc.cpp.exe qc.py | output
	build/qc.cpp.exe py > output/qc.cpp.py
	diff -s qc.py output/qc.cpp.py

test-cpp-fs: build/qc.cpp.exe qc.fs | output
	build/qc.cpp.exe fs > output/qc.cpp.fs
	diff -s qc.fs output/qc.cpp.fs

test-cpp-nim: build/qc.cpp.exe qc.nim | output
	build/qc.cpp.exe nim > output/qc.cpp.nim
	diff -s qc.nim output/qc.cpp.nim

test-cpp-fsx: build/qc.cpp.exe qc.fsx | output
	build/qc.cpp.exe fsx > output/qc.cpp.fsx
	diff -s qc.fsx output/qc.cpp.fsx

test-cpp-tcl: build/qc.cpp.exe qc.tcl | output
	build/qc.cpp.exe tcl > output/qc.cpp.tcl
	diff -s qc.tcl output/qc.cpp.tcl

test-cpp-bf: build/qc.cpp.exe qc.bf | output
	build/qc.cpp.exe bf > output/qc.cpp.bf
	diff -s qc.bf output/qc.cpp.bf

test-cpp-java: build/qc.cpp.exe qc.java | output
	build/qc.cpp.exe java > output/qc.cpp.java
	diff -s qc.java output/qc.cpp.java

test-cpp-php: build/qc.cpp.exe qc.php | output
	build/qc.cpp.exe php > output/qc.cpp.php
	diff -s qc.php output/qc.cpp.php

test-cpp-bash: build/qc.cpp.exe qc.bash | output
	build/qc.cpp.exe bash > output/qc.cpp.bash
	diff -s qc.bash output/qc.cpp.bash

test-cpp-d: build/qc.cpp.exe qc.d | output
	build/qc.cpp.exe d > output/qc.cpp.d
	diff -s qc.d output/qc.cpp.d

test-cpp-pl: build/qc.cpp.exe qc.pl | output
	build/qc.cpp.exe pl > output/qc.cpp.pl
	diff -s qc.pl output/qc.cpp.pl

test-cpp-exs: build/qc.cpp.exe qc.exs | output
	build/qc.cpp.exe exs > output/qc.cpp.exs
	diff -s qc.exs output/qc.cpp.exs

test-cpp-rb: build/qc.cpp.exe qc.rb | output
	build/qc.cpp.exe rb > output/qc.cpp.rb
	diff -s qc.rb output/qc.cpp.rb

test-cpp-js: build/qc.cpp.exe qc.js | output
	build/qc.cpp.exe js > output/qc.cpp.js
	diff -s qc.js output/qc.cpp.js

test-cpp-ts: build/qc.cpp.exe qc.ts | output
	build/qc.cpp.exe ts > output/qc.cpp.ts
	diff -s qc.ts output/qc.cpp.ts

test-cpp-erl: build/qc.cpp.exe qc.erl | output
	build/qc.cpp.exe erl > output/qc.cpp.erl
	diff -s qc.erl output/qc.cpp.erl

test-cpp-cs: build/qc.cpp.exe qc.cs | output
	build/qc.cpp.exe cs > output/qc.cpp.cs
	diff -s qc.cs output/qc.cpp.cs

test-cpp-prolog: build/qc.cpp.exe qc.prolog | output
	build/qc.cpp.exe prolog > output/qc.cpp.prolog
	diff -s qc.prolog output/qc.cpp.prolog

test-cpp-cr: build/qc.cpp.exe qc.cr | output
	build/qc.cpp.exe cr > output/qc.cpp.cr
	diff -s qc.cr output/qc.cpp.cr

test-cpp-unl: build/qc.cpp.exe qc.unl | output
	build/qc.cpp.exe unl > output/qc.cpp.unl
	diff -s qc.unl output/qc.cpp.unl

test-cpp-hx: build/qc.cpp.exe qc.hx | output
	build/qc.cpp.exe hx > output/qc.cpp.hx
	diff -s qc.hx output/qc.cpp.hx

test-cpp-bef: build/qc.cpp.exe qc.bef | output
	build/qc.cpp.exe bef > output/qc.cpp.bef
	diff -s qc.bef output/qc.cpp.bef

test-cpp-awk: build/qc.cpp.exe qc.awk | output
	build/qc.cpp.exe awk > output/qc.cpp.awk
	diff -s qc.awk output/qc.cpp.awk

test-cpp-piet: build/qc.cpp.exe qc.piet.gif | output
	build/qc.cpp.exe piet > output/qc.cpp.piet
	diff -s qc.piet.gif output/qc.cpp.piet

test-scala-clj: qc.scala qc.clj | output
	scala -nc qc.scala clj > output/qc.scala.clj
	diff -s qc.clj output/qc.scala.clj

test-scala-lisp: qc.scala qc.lisp | output
	scala -nc qc.scala lisp > output/qc.scala.lisp
	diff -s qc.lisp output/qc.scala.lisp

test-scala-rkt: qc.scala qc.rkt | output
	scala -nc qc.scala rkt > output/qc.scala.rkt
	diff -s qc.rkt output/qc.scala.rkt

test-scala-rs: qc.scala qc.rs | output
	scala -nc qc.scala rs > output/qc.scala.rs
	diff -s qc.rs output/qc.scala.rs

test-scala-c: qc.scala qc.c | output
	scala -nc qc.scala c > output/qc.scala.c
	diff -s qc.c output/qc.scala.c

test-scala-cpp: qc.scala qc.cpp | output
	scala -nc qc.scala cpp > output/qc.scala.cpp
	diff -s qc.cpp output/qc.scala.cpp

test-scala-scala: qc.scala qc.scala | output
	scala -nc qc.scala > output/qc.scala.scala
	diff -s qc.scala output/qc.scala.scala

test-scala-f90: qc.scala qc.f90 | output
	scala -nc qc.scala f90 > output/qc.scala.f90
	diff -s qc.f90 output/qc.scala.f90

test-scala-scm: qc.scala qc.scm | output
	scala -nc qc.scala scm > output/qc.scala.scm
	diff -s qc.scm output/qc.scala.scm

test-scala-r: qc.scala qc.r | output
	scala -nc qc.scala r > output/qc.scala.r
	diff -s qc.r output/qc.scala.r

test-scala-lua: qc.scala qc.lua | output
	scala -nc qc.scala lua > output/qc.scala.lua
	diff -s qc.lua output/qc.scala.lua

test-scala-go: qc.scala qc.go | output
	scala -nc qc.scala go > output/qc.scala.go
	diff -s qc.go output/qc.scala.go

test-scala-ps: qc.scala qc.ps | output
	scala -nc qc.scala ps > output/qc.scala.ps
	diff -s qc.ps output/qc.scala.ps

test-scala-vala: qc.scala qc.vala | output
	scala -nc qc.scala vala > output/qc.scala.vala
	diff -s qc.vala output/qc.scala.vala

test-scala-pike: qc.scala qc.pike | output
	scala -nc qc.scala pike > output/qc.scala.pike
	diff -s qc.pike output/qc.scala.pike

test-scala-pas: qc.scala qc.pas | output
	scala -nc qc.scala pas > output/qc.scala.pas
	diff -s qc.pas output/qc.scala.pas

test-scala-kt: qc.scala qc.kt | output
	scala -nc qc.scala kt > output/qc.scala.kt
	diff -s qc.kt output/qc.scala.kt

test-scala-m: qc.scala qc.m | output
	scala -nc qc.scala m > output/qc.scala.m
	diff -s qc.m output/qc.scala.m

test-scala-ml: qc.scala qc.ml | output
	scala -nc qc.scala ml > output/qc.scala.ml
	diff -s qc.ml output/qc.scala.ml

test-scala-hs: qc.scala qc.hs | output
	scala -nc qc.scala hs > output/qc.scala.hs
	diff -s qc.hs output/qc.scala.hs

test-scala-zig: qc.scala qc.zig | output
	scala -nc qc.scala zig > output/qc.scala.zig
	diff -s qc.zig output/qc.scala.zig

test-scala-sml: qc.scala qc.sml | output
	scala -nc qc.scala sml > output/qc.scala.sml
	diff -s qc.sml output/qc.scala.sml

test-scala-octave: qc.scala qc.octave | output
	scala -nc qc.scala octave > output/qc.scala.octave
	diff -s qc.octave output/qc.scala.octave

test-scala-groovy: qc.scala qc.groovy | output
	scala -nc qc.scala groovy > output/qc.scala.groovy
	diff -s qc.groovy output/qc.scala.groovy

test-scala-ws: qc.scala qc.ws | output
	scala -nc qc.scala ws > output/qc.scala.ws
	diff -s qc.ws output/qc.scala.ws

test-scala-coffee: qc.scala qc.coffee | output
	scala -nc qc.scala coffee > output/qc.scala.coffee
	diff -s qc.coffee output/qc.scala.coffee

test-scala-swift: qc.scala qc.swift | output
	scala -nc qc.scala swift > output/qc.scala.swift
	diff -s qc.swift output/qc.scala.swift

test-scala-py: qc.scala qc.py | output
	scala -nc qc.scala py > output/qc.scala.py
	diff -s qc.py output/qc.scala.py

test-scala-fs: qc.scala qc.fs | output
	scala -nc qc.scala fs > output/qc.scala.fs
	diff -s qc.fs output/qc.scala.fs

test-scala-nim: qc.scala qc.nim | output
	scala -nc qc.scala nim > output/qc.scala.nim
	diff -s qc.nim output/qc.scala.nim

test-scala-fsx: qc.scala qc.fsx | output
	scala -nc qc.scala fsx > output/qc.scala.fsx
	diff -s qc.fsx output/qc.scala.fsx

test-scala-tcl: qc.scala qc.tcl | output
	scala -nc qc.scala tcl > output/qc.scala.tcl
	diff -s qc.tcl output/qc.scala.tcl

test-scala-bf: qc.scala qc.bf | output
	scala -nc qc.scala bf > output/qc.scala.bf
	diff -s qc.bf output/qc.scala.bf

test-scala-java: qc.scala qc.java | output
	scala -nc qc.scala java > output/qc.scala.java
	diff -s qc.java output/qc.scala.java

test-scala-php: qc.scala qc.php | output
	scala -nc qc.scala php > output/qc.scala.php
	diff -s qc.php output/qc.scala.php

test-scala-bash: qc.scala qc.bash | output
	scala -nc qc.scala bash > output/qc.scala.bash
	diff -s qc.bash output/qc.scala.bash

test-scala-d: qc.scala qc.d | output
	scala -nc qc.scala d > output/qc.scala.d
	diff -s qc.d output/qc.scala.d

test-scala-pl: qc.scala qc.pl | output
	scala -nc qc.scala pl > output/qc.scala.pl
	diff -s qc.pl output/qc.scala.pl

test-scala-exs: qc.scala qc.exs | output
	scala -nc qc.scala exs > output/qc.scala.exs
	diff -s qc.exs output/qc.scala.exs

test-scala-rb: qc.scala qc.rb | output
	scala -nc qc.scala rb > output/qc.scala.rb
	diff -s qc.rb output/qc.scala.rb

test-scala-js: qc.scala qc.js | output
	scala -nc qc.scala js > output/qc.scala.js
	diff -s qc.js output/qc.scala.js

test-scala-ts: qc.scala qc.ts | output
	scala -nc qc.scala ts > output/qc.scala.ts
	diff -s qc.ts output/qc.scala.ts

test-scala-erl: qc.scala qc.erl | output
	scala -nc qc.scala erl > output/qc.scala.erl
	diff -s qc.erl output/qc.scala.erl

test-scala-cs: qc.scala qc.cs | output
	scala -nc qc.scala cs > output/qc.scala.cs
	diff -s qc.cs output/qc.scala.cs

test-scala-prolog: qc.scala qc.prolog | output
	scala -nc qc.scala prolog > output/qc.scala.prolog
	diff -s qc.prolog output/qc.scala.prolog

test-scala-cr: qc.scala qc.cr | output
	scala -nc qc.scala cr > output/qc.scala.cr
	diff -s qc.cr output/qc.scala.cr

test-scala-unl: qc.scala qc.unl | output
	scala -nc qc.scala unl > output/qc.scala.unl
	diff -s qc.unl output/qc.scala.unl

test-scala-hx: qc.scala qc.hx | output
	scala -nc qc.scala hx > output/qc.scala.hx
	diff -s qc.hx output/qc.scala.hx

test-scala-bef: qc.scala qc.bef | output
	scala -nc qc.scala bef > output/qc.scala.bef
	diff -s qc.bef output/qc.scala.bef

test-scala-awk: qc.scala qc.awk | output
	scala -nc qc.scala awk > output/qc.scala.awk
	diff -s qc.awk output/qc.scala.awk

test-scala-piet: qc.scala qc.piet.gif | output
	scala -nc qc.scala piet > output/qc.scala.piet
	diff -s qc.piet.gif output/qc.scala.piet

test-f90-clj: build/qc.f90.exe qc.clj | output
	build/qc.f90.exe clj > output/qc.f90.clj
	diff -s qc.clj output/qc.f90.clj

test-f90-lisp: build/qc.f90.exe qc.lisp | output
	build/qc.f90.exe lisp > output/qc.f90.lisp
	diff -s qc.lisp output/qc.f90.lisp

test-f90-rkt: build/qc.f90.exe qc.rkt | output
	build/qc.f90.exe rkt > output/qc.f90.rkt
	diff -s qc.rkt output/qc.f90.rkt

test-f90-rs: build/qc.f90.exe qc.rs | output
	build/qc.f90.exe rs > output/qc.f90.rs
	diff -s qc.rs output/qc.f90.rs

test-f90-c: build/qc.f90.exe qc.c | output
	build/qc.f90.exe c > output/qc.f90.c
	diff -s qc.c output/qc.f90.c

test-f90-cpp: build/qc.f90.exe qc.cpp | output
	build/qc.f90.exe cpp > output/qc.f90.cpp
	diff -s qc.cpp output/qc.f90.cpp

test-f90-scala: build/qc.f90.exe qc.scala | output
	build/qc.f90.exe scala > output/qc.f90.scala
	diff -s qc.scala output/qc.f90.scala

test-f90-f90: build/qc.f90.exe qc.f90 | output
	build/qc.f90.exe > output/qc.f90.f90
	diff -s qc.f90 output/qc.f90.f90

test-f90-scm: build/qc.f90.exe qc.scm | output
	build/qc.f90.exe scm > output/qc.f90.scm
	diff -s qc.scm output/qc.f90.scm

test-f90-r: build/qc.f90.exe qc.r | output
	build/qc.f90.exe r > output/qc.f90.r
	diff -s qc.r output/qc.f90.r

test-f90-lua: build/qc.f90.exe qc.lua | output
	build/qc.f90.exe lua > output/qc.f90.lua
	diff -s qc.lua output/qc.f90.lua

test-f90-go: build/qc.f90.exe qc.go | output
	build/qc.f90.exe go > output/qc.f90.go
	diff -s qc.go output/qc.f90.go

test-f90-ps: build/qc.f90.exe qc.ps | output
	build/qc.f90.exe ps > output/qc.f90.ps
	diff -s qc.ps output/qc.f90.ps

test-f90-vala: build/qc.f90.exe qc.vala | output
	build/qc.f90.exe vala > output/qc.f90.vala
	diff -s qc.vala output/qc.f90.vala

test-f90-pike: build/qc.f90.exe qc.pike | output
	build/qc.f90.exe pike > output/qc.f90.pike
	diff -s qc.pike output/qc.f90.pike

test-f90-pas: build/qc.f90.exe qc.pas | output
	build/qc.f90.exe pas > output/qc.f90.pas
	diff -s qc.pas output/qc.f90.pas

test-f90-kt: build/qc.f90.exe qc.kt | output
	build/qc.f90.exe kt > output/qc.f90.kt
	diff -s qc.kt output/qc.f90.kt

test-f90-m: build/qc.f90.exe qc.m | output
	build/qc.f90.exe m > output/qc.f90.m
	diff -s qc.m output/qc.f90.m

test-f90-ml: build/qc.f90.exe qc.ml | output
	build/qc.f90.exe ml > output/qc.f90.ml
	diff -s qc.ml output/qc.f90.ml

test-f90-hs: build/qc.f90.exe qc.hs | output
	build/qc.f90.exe hs > output/qc.f90.hs
	diff -s qc.hs output/qc.f90.hs

test-f90-zig: build/qc.f90.exe qc.zig | output
	build/qc.f90.exe zig > output/qc.f90.zig
	diff -s qc.zig output/qc.f90.zig

test-f90-sml: build/qc.f90.exe qc.sml | output
	build/qc.f90.exe sml > output/qc.f90.sml
	diff -s qc.sml output/qc.f90.sml

test-f90-octave: build/qc.f90.exe qc.octave | output
	build/qc.f90.exe octave > output/qc.f90.octave
	diff -s qc.octave output/qc.f90.octave

test-f90-groovy: build/qc.f90.exe qc.groovy | output
	build/qc.f90.exe groovy > output/qc.f90.groovy
	diff -s qc.groovy output/qc.f90.groovy

test-f90-ws: build/qc.f90.exe qc.ws | output
	build/qc.f90.exe ws > output/qc.f90.ws
	diff -s qc.ws output/qc.f90.ws

test-f90-coffee: build/qc.f90.exe qc.coffee | output
	build/qc.f90.exe coffee > output/qc.f90.coffee
	diff -s qc.coffee output/qc.f90.coffee

test-f90-swift: build/qc.f90.exe qc.swift | output
	build/qc.f90.exe swift > output/qc.f90.swift
	diff -s qc.swift output/qc.f90.swift

test-f90-py: build/qc.f90.exe qc.py | output
	build/qc.f90.exe py > output/qc.f90.py
	diff -s qc.py output/qc.f90.py

test-f90-fs: build/qc.f90.exe qc.fs | output
	build/qc.f90.exe fs > output/qc.f90.fs
	diff -s qc.fs output/qc.f90.fs

test-f90-nim: build/qc.f90.exe qc.nim | output
	build/qc.f90.exe nim > output/qc.f90.nim
	diff -s qc.nim output/qc.f90.nim

test-f90-fsx: build/qc.f90.exe qc.fsx | output
	build/qc.f90.exe fsx > output/qc.f90.fsx
	diff -s qc.fsx output/qc.f90.fsx

test-f90-tcl: build/qc.f90.exe qc.tcl | output
	build/qc.f90.exe tcl > output/qc.f90.tcl
	diff -s qc.tcl output/qc.f90.tcl

test-f90-bf: build/qc.f90.exe qc.bf | output
	build/qc.f90.exe bf > output/qc.f90.bf
	diff -s qc.bf output/qc.f90.bf

test-f90-java: build/qc.f90.exe qc.java | output
	build/qc.f90.exe java > output/qc.f90.java
	diff -s qc.java output/qc.f90.java

test-f90-php: build/qc.f90.exe qc.php | output
	build/qc.f90.exe php > output/qc.f90.php
	diff -s qc.php output/qc.f90.php

test-f90-bash: build/qc.f90.exe qc.bash | output
	build/qc.f90.exe bash > output/qc.f90.bash
	diff -s qc.bash output/qc.f90.bash

test-f90-d: build/qc.f90.exe qc.d | output
	build/qc.f90.exe d > output/qc.f90.d
	diff -s qc.d output/qc.f90.d

test-f90-pl: build/qc.f90.exe qc.pl | output
	build/qc.f90.exe pl > output/qc.f90.pl
	diff -s qc.pl output/qc.f90.pl

test-f90-exs: build/qc.f90.exe qc.exs | output
	build/qc.f90.exe exs > output/qc.f90.exs
	diff -s qc.exs output/qc.f90.exs

test-f90-rb: build/qc.f90.exe qc.rb | output
	build/qc.f90.exe rb > output/qc.f90.rb
	diff -s qc.rb output/qc.f90.rb

test-f90-js: build/qc.f90.exe qc.js | output
	build/qc.f90.exe js > output/qc.f90.js
	diff -s qc.js output/qc.f90.js

test-f90-ts: build/qc.f90.exe qc.ts | output
	build/qc.f90.exe ts > output/qc.f90.ts
	diff -s qc.ts output/qc.f90.ts

test-f90-erl: build/qc.f90.exe qc.erl | output
	build/qc.f90.exe erl > output/qc.f90.erl
	diff -s qc.erl output/qc.f90.erl

test-f90-cs: build/qc.f90.exe qc.cs | output
	build/qc.f90.exe cs > output/qc.f90.cs
	diff -s qc.cs output/qc.f90.cs

test-f90-prolog: build/qc.f90.exe qc.prolog | output
	build/qc.f90.exe prolog > output/qc.f90.prolog
	diff -s qc.prolog output/qc.f90.prolog

test-f90-cr: build/qc.f90.exe qc.cr | output
	build/qc.f90.exe cr > output/qc.f90.cr
	diff -s qc.cr output/qc.f90.cr

test-f90-unl: build/qc.f90.exe qc.unl | output
	build/qc.f90.exe unl > output/qc.f90.unl
	diff -s qc.unl output/qc.f90.unl

test-f90-hx: build/qc.f90.exe qc.hx | output
	build/qc.f90.exe hx > output/qc.f90.hx
	diff -s qc.hx output/qc.f90.hx

test-f90-bef: build/qc.f90.exe qc.bef | output
	build/qc.f90.exe bef > output/qc.f90.bef
	diff -s qc.bef output/qc.f90.bef

test-f90-awk: build/qc.f90.exe qc.awk | output
	build/qc.f90.exe awk > output/qc.f90.awk
	diff -s qc.awk output/qc.f90.awk

test-f90-piet: build/qc.f90.exe qc.piet.gif | output
	build/qc.f90.exe piet > output/qc.f90.piet
	diff -s qc.piet.gif output/qc.f90.piet

test-scm-clj: qc.scm qc.clj | output
	guile --no-auto-compile -s qc.scm clj > output/qc.scm.clj
	diff -s qc.clj output/qc.scm.clj

test-scm-lisp: qc.scm qc.lisp | output
	guile --no-auto-compile -s qc.scm lisp > output/qc.scm.lisp
	diff -s qc.lisp output/qc.scm.lisp

test-scm-rkt: qc.scm qc.rkt | output
	guile --no-auto-compile -s qc.scm rkt > output/qc.scm.rkt
	diff -s qc.rkt output/qc.scm.rkt

test-scm-rs: qc.scm qc.rs | output
	guile --no-auto-compile -s qc.scm rs > output/qc.scm.rs
	diff -s qc.rs output/qc.scm.rs

test-scm-c: qc.scm qc.c | output
	guile --no-auto-compile -s qc.scm c > output/qc.scm.c
	diff -s qc.c output/qc.scm.c

test-scm-cpp: qc.scm qc.cpp | output
	guile --no-auto-compile -s qc.scm cpp > output/qc.scm.cpp
	diff -s qc.cpp output/qc.scm.cpp

test-scm-scala: qc.scm qc.scala | output
	guile --no-auto-compile -s qc.scm scala > output/qc.scm.scala
	diff -s qc.scala output/qc.scm.scala

test-scm-f90: qc.scm qc.f90 | output
	guile --no-auto-compile -s qc.scm f90 > output/qc.scm.f90
	diff -s qc.f90 output/qc.scm.f90

test-scm-scm: qc.scm qc.scm | output
	guile --no-auto-compile -s qc.scm > output/qc.scm.scm
	diff -s qc.scm output/qc.scm.scm

test-scm-r: qc.scm qc.r | output
	guile --no-auto-compile -s qc.scm r > output/qc.scm.r
	diff -s qc.r output/qc.scm.r

test-scm-lua: qc.scm qc.lua | output
	guile --no-auto-compile -s qc.scm lua > output/qc.scm.lua
	diff -s qc.lua output/qc.scm.lua

test-scm-go: qc.scm qc.go | output
	guile --no-auto-compile -s qc.scm go > output/qc.scm.go
	diff -s qc.go output/qc.scm.go

test-scm-ps: qc.scm qc.ps | output
	guile --no-auto-compile -s qc.scm ps > output/qc.scm.ps
	diff -s qc.ps output/qc.scm.ps

test-scm-vala: qc.scm qc.vala | output
	guile --no-auto-compile -s qc.scm vala > output/qc.scm.vala
	diff -s qc.vala output/qc.scm.vala

test-scm-pike: qc.scm qc.pike | output
	guile --no-auto-compile -s qc.scm pike > output/qc.scm.pike
	diff -s qc.pike output/qc.scm.pike

test-scm-pas: qc.scm qc.pas | output
	guile --no-auto-compile -s qc.scm pas > output/qc.scm.pas
	diff -s qc.pas output/qc.scm.pas

test-scm-kt: qc.scm qc.kt | output
	guile --no-auto-compile -s qc.scm kt > output/qc.scm.kt
	diff -s qc.kt output/qc.scm.kt

test-scm-m: qc.scm qc.m | output
	guile --no-auto-compile -s qc.scm m > output/qc.scm.m
	diff -s qc.m output/qc.scm.m

test-scm-ml: qc.scm qc.ml | output
	guile --no-auto-compile -s qc.scm ml > output/qc.scm.ml
	diff -s qc.ml output/qc.scm.ml

test-scm-hs: qc.scm qc.hs | output
	guile --no-auto-compile -s qc.scm hs > output/qc.scm.hs
	diff -s qc.hs output/qc.scm.hs

test-scm-zig: qc.scm qc.zig | output
	guile --no-auto-compile -s qc.scm zig > output/qc.scm.zig
	diff -s qc.zig output/qc.scm.zig

test-scm-sml: qc.scm qc.sml | output
	guile --no-auto-compile -s qc.scm sml > output/qc.scm.sml
	diff -s qc.sml output/qc.scm.sml

test-scm-octave: qc.scm qc.octave | output
	guile --no-auto-compile -s qc.scm octave > output/qc.scm.octave
	diff -s qc.octave output/qc.scm.octave

test-scm-groovy: qc.scm qc.groovy | output
	guile --no-auto-compile -s qc.scm groovy > output/qc.scm.groovy
	diff -s qc.groovy output/qc.scm.groovy

test-scm-ws: qc.scm qc.ws | output
	guile --no-auto-compile -s qc.scm ws > output/qc.scm.ws
	diff -s qc.ws output/qc.scm.ws

test-scm-coffee: qc.scm qc.coffee | output
	guile --no-auto-compile -s qc.scm coffee > output/qc.scm.coffee
	diff -s qc.coffee output/qc.scm.coffee

test-scm-swift: qc.scm qc.swift | output
	guile --no-auto-compile -s qc.scm swift > output/qc.scm.swift
	diff -s qc.swift output/qc.scm.swift

test-scm-py: qc.scm qc.py | output
	guile --no-auto-compile -s qc.scm py > output/qc.scm.py
	diff -s qc.py output/qc.scm.py

test-scm-fs: qc.scm qc.fs | output
	guile --no-auto-compile -s qc.scm fs > output/qc.scm.fs
	diff -s qc.fs output/qc.scm.fs

test-scm-nim: qc.scm qc.nim | output
	guile --no-auto-compile -s qc.scm nim > output/qc.scm.nim
	diff -s qc.nim output/qc.scm.nim

test-scm-fsx: qc.scm qc.fsx | output
	guile --no-auto-compile -s qc.scm fsx > output/qc.scm.fsx
	diff -s qc.fsx output/qc.scm.fsx

test-scm-tcl: qc.scm qc.tcl | output
	guile --no-auto-compile -s qc.scm tcl > output/qc.scm.tcl
	diff -s qc.tcl output/qc.scm.tcl

test-scm-bf: qc.scm qc.bf | output
	guile --no-auto-compile -s qc.scm bf > output/qc.scm.bf
	diff -s qc.bf output/qc.scm.bf

test-scm-java: qc.scm qc.java | output
	guile --no-auto-compile -s qc.scm java > output/qc.scm.java
	diff -s qc.java output/qc.scm.java

test-scm-php: qc.scm qc.php | output
	guile --no-auto-compile -s qc.scm php > output/qc.scm.php
	diff -s qc.php output/qc.scm.php

test-scm-bash: qc.scm qc.bash | output
	guile --no-auto-compile -s qc.scm bash > output/qc.scm.bash
	diff -s qc.bash output/qc.scm.bash

test-scm-d: qc.scm qc.d | output
	guile --no-auto-compile -s qc.scm d > output/qc.scm.d
	diff -s qc.d output/qc.scm.d

test-scm-pl: qc.scm qc.pl | output
	guile --no-auto-compile -s qc.scm pl > output/qc.scm.pl
	diff -s qc.pl output/qc.scm.pl

test-scm-exs: qc.scm qc.exs | output
	guile --no-auto-compile -s qc.scm exs > output/qc.scm.exs
	diff -s qc.exs output/qc.scm.exs

test-scm-rb: qc.scm qc.rb | output
	guile --no-auto-compile -s qc.scm rb > output/qc.scm.rb
	diff -s qc.rb output/qc.scm.rb

test-scm-js: qc.scm qc.js | output
	guile --no-auto-compile -s qc.scm js > output/qc.scm.js
	diff -s qc.js output/qc.scm.js

test-scm-ts: qc.scm qc.ts | output
	guile --no-auto-compile -s qc.scm ts > output/qc.scm.ts
	diff -s qc.ts output/qc.scm.ts

test-scm-erl: qc.scm qc.erl | output
	guile --no-auto-compile -s qc.scm erl > output/qc.scm.erl
	diff -s qc.erl output/qc.scm.erl

test-scm-cs: qc.scm qc.cs | output
	guile --no-auto-compile -s qc.scm cs > output/qc.scm.cs
	diff -s qc.cs output/qc.scm.cs

test-scm-prolog: qc.scm qc.prolog | output
	guile --no-auto-compile -s qc.scm prolog > output/qc.scm.prolog
	diff -s qc.prolog output/qc.scm.prolog

test-scm-cr: qc.scm qc.cr | output
	guile --no-auto-compile -s qc.scm cr > output/qc.scm.cr
	diff -s qc.cr output/qc.scm.cr

test-scm-unl: qc.scm qc.unl | output
	guile --no-auto-compile -s qc.scm unl > output/qc.scm.unl
	diff -s qc.unl output/qc.scm.unl

test-scm-hx: qc.scm qc.hx | output
	guile --no-auto-compile -s qc.scm hx > output/qc.scm.hx
	diff -s qc.hx output/qc.scm.hx

test-scm-bef: qc.scm qc.bef | output
	guile --no-auto-compile -s qc.scm bef > output/qc.scm.bef
	diff -s qc.bef output/qc.scm.bef

test-scm-awk: qc.scm qc.awk | output
	guile --no-auto-compile -s qc.scm awk > output/qc.scm.awk
	diff -s qc.awk output/qc.scm.awk

test-scm-piet: qc.scm qc.piet.gif | output
	guile --no-auto-compile -s qc.scm piet > output/qc.scm.piet
	diff -s qc.piet.gif output/qc.scm.piet

test-r-clj: qc.r qc.clj | output
	Rscript qc.r clj > output/qc.r.clj
	diff -s qc.clj output/qc.r.clj

test-r-lisp: qc.r qc.lisp | output
	Rscript qc.r lisp > output/qc.r.lisp
	diff -s qc.lisp output/qc.r.lisp

test-r-rkt: qc.r qc.rkt | output
	Rscript qc.r rkt > output/qc.r.rkt
	diff -s qc.rkt output/qc.r.rkt

test-r-rs: qc.r qc.rs | output
	Rscript qc.r rs > output/qc.r.rs
	diff -s qc.rs output/qc.r.rs

test-r-c: qc.r qc.c | output
	Rscript qc.r c > output/qc.r.c
	diff -s qc.c output/qc.r.c

test-r-cpp: qc.r qc.cpp | output
	Rscript qc.r cpp > output/qc.r.cpp
	diff -s qc.cpp output/qc.r.cpp

test-r-scala: qc.r qc.scala | output
	Rscript qc.r scala > output/qc.r.scala
	diff -s qc.scala output/qc.r.scala

test-r-f90: qc.r qc.f90 | output
	Rscript qc.r f90 > output/qc.r.f90
	diff -s qc.f90 output/qc.r.f90

test-r-scm: qc.r qc.scm | output
	Rscript qc.r scm > output/qc.r.scm
	diff -s qc.scm output/qc.r.scm

test-r-r: qc.r qc.r | output
	Rscript qc.r > output/qc.r.r
	diff -s qc.r output/qc.r.r

test-r-lua: qc.r qc.lua | output
	Rscript qc.r lua > output/qc.r.lua
	diff -s qc.lua output/qc.r.lua

test-r-go: qc.r qc.go | output
	Rscript qc.r go > output/qc.r.go
	diff -s qc.go output/qc.r.go

test-r-ps: qc.r qc.ps | output
	Rscript qc.r ps > output/qc.r.ps
	diff -s qc.ps output/qc.r.ps

test-r-vala: qc.r qc.vala | output
	Rscript qc.r vala > output/qc.r.vala
	diff -s qc.vala output/qc.r.vala

test-r-pike: qc.r qc.pike | output
	Rscript qc.r pike > output/qc.r.pike
	diff -s qc.pike output/qc.r.pike

test-r-pas: qc.r qc.pas | output
	Rscript qc.r pas > output/qc.r.pas
	diff -s qc.pas output/qc.r.pas

test-r-kt: qc.r qc.kt | output
	Rscript qc.r kt > output/qc.r.kt
	diff -s qc.kt output/qc.r.kt

test-r-m: qc.r qc.m | output
	Rscript qc.r m > output/qc.r.m
	diff -s qc.m output/qc.r.m

test-r-ml: qc.r qc.ml | output
	Rscript qc.r ml > output/qc.r.ml
	diff -s qc.ml output/qc.r.ml

test-r-hs: qc.r qc.hs | output
	Rscript qc.r hs > output/qc.r.hs
	diff -s qc.hs output/qc.r.hs

test-r-zig: qc.r qc.zig | output
	Rscript qc.r zig > output/qc.r.zig
	diff -s qc.zig output/qc.r.zig

test-r-sml: qc.r qc.sml | output
	Rscript qc.r sml > output/qc.r.sml
	diff -s qc.sml output/qc.r.sml

test-r-octave: qc.r qc.octave | output
	Rscript qc.r octave > output/qc.r.octave
	diff -s qc.octave output/qc.r.octave

test-r-groovy: qc.r qc.groovy | output
	Rscript qc.r groovy > output/qc.r.groovy
	diff -s qc.groovy output/qc.r.groovy

test-r-ws: qc.r qc.ws | output
	Rscript qc.r ws > output/qc.r.ws
	diff -s qc.ws output/qc.r.ws

test-r-coffee: qc.r qc.coffee | output
	Rscript qc.r coffee > output/qc.r.coffee
	diff -s qc.coffee output/qc.r.coffee

test-r-swift: qc.r qc.swift | output
	Rscript qc.r swift > output/qc.r.swift
	diff -s qc.swift output/qc.r.swift

test-r-py: qc.r qc.py | output
	Rscript qc.r py > output/qc.r.py
	diff -s qc.py output/qc.r.py

test-r-fs: qc.r qc.fs | output
	Rscript qc.r fs > output/qc.r.fs
	diff -s qc.fs output/qc.r.fs

test-r-nim: qc.r qc.nim | output
	Rscript qc.r nim > output/qc.r.nim
	diff -s qc.nim output/qc.r.nim

test-r-fsx: qc.r qc.fsx | output
	Rscript qc.r fsx > output/qc.r.fsx
	diff -s qc.fsx output/qc.r.fsx

test-r-tcl: qc.r qc.tcl | output
	Rscript qc.r tcl > output/qc.r.tcl
	diff -s qc.tcl output/qc.r.tcl

test-r-bf: qc.r qc.bf | output
	Rscript qc.r bf > output/qc.r.bf
	diff -s qc.bf output/qc.r.bf

test-r-java: qc.r qc.java | output
	Rscript qc.r java > output/qc.r.java
	diff -s qc.java output/qc.r.java

test-r-php: qc.r qc.php | output
	Rscript qc.r php > output/qc.r.php
	diff -s qc.php output/qc.r.php

test-r-bash: qc.r qc.bash | output
	Rscript qc.r bash > output/qc.r.bash
	diff -s qc.bash output/qc.r.bash

test-r-d: qc.r qc.d | output
	Rscript qc.r d > output/qc.r.d
	diff -s qc.d output/qc.r.d

test-r-pl: qc.r qc.pl | output
	Rscript qc.r pl > output/qc.r.pl
	diff -s qc.pl output/qc.r.pl

test-r-exs: qc.r qc.exs | output
	Rscript qc.r exs > output/qc.r.exs
	diff -s qc.exs output/qc.r.exs

test-r-rb: qc.r qc.rb | output
	Rscript qc.r rb > output/qc.r.rb
	diff -s qc.rb output/qc.r.rb

test-r-js: qc.r qc.js | output
	Rscript qc.r js > output/qc.r.js
	diff -s qc.js output/qc.r.js

test-r-ts: qc.r qc.ts | output
	Rscript qc.r ts > output/qc.r.ts
	diff -s qc.ts output/qc.r.ts

test-r-erl: qc.r qc.erl | output
	Rscript qc.r erl > output/qc.r.erl
	diff -s qc.erl output/qc.r.erl

test-r-cs: qc.r qc.cs | output
	Rscript qc.r cs > output/qc.r.cs
	diff -s qc.cs output/qc.r.cs

test-r-prolog: qc.r qc.prolog | output
	Rscript qc.r prolog > output/qc.r.prolog
	diff -s qc.prolog output/qc.r.prolog

test-r-cr: qc.r qc.cr | output
	Rscript qc.r cr > output/qc.r.cr
	diff -s qc.cr output/qc.r.cr

test-r-unl: qc.r qc.unl | output
	Rscript qc.r unl > output/qc.r.unl
	diff -s qc.unl output/qc.r.unl

test-r-hx: qc.r qc.hx | output
	Rscript qc.r hx > output/qc.r.hx
	diff -s qc.hx output/qc.r.hx

test-r-bef: qc.r qc.bef | output
	Rscript qc.r bef > output/qc.r.bef
	diff -s qc.bef output/qc.r.bef

test-r-awk: qc.r qc.awk | output
	Rscript qc.r awk > output/qc.r.awk
	diff -s qc.awk output/qc.r.awk

test-r-piet: qc.r qc.piet.gif | output
	Rscript qc.r piet > output/qc.r.piet
	diff -s qc.piet.gif output/qc.r.piet

test-lua-clj: qc.lua qc.clj | output
	lua5.3 qc.lua clj > output/qc.lua.clj
	diff -s qc.clj output/qc.lua.clj

test-lua-lisp: qc.lua qc.lisp | output
	lua5.3 qc.lua lisp > output/qc.lua.lisp
	diff -s qc.lisp output/qc.lua.lisp

test-lua-rkt: qc.lua qc.rkt | output
	lua5.3 qc.lua rkt > output/qc.lua.rkt
	diff -s qc.rkt output/qc.lua.rkt

test-lua-rs: qc.lua qc.rs | output
	lua5.3 qc.lua rs > output/qc.lua.rs
	diff -s qc.rs output/qc.lua.rs

test-lua-c: qc.lua qc.c | output
	lua5.3 qc.lua c > output/qc.lua.c
	diff -s qc.c output/qc.lua.c

test-lua-cpp: qc.lua qc.cpp | output
	lua5.3 qc.lua cpp > output/qc.lua.cpp
	diff -s qc.cpp output/qc.lua.cpp

test-lua-scala: qc.lua qc.scala | output
	lua5.3 qc.lua scala > output/qc.lua.scala
	diff -s qc.scala output/qc.lua.scala

test-lua-f90: qc.lua qc.f90 | output
	lua5.3 qc.lua f90 > output/qc.lua.f90
	diff -s qc.f90 output/qc.lua.f90

test-lua-scm: qc.lua qc.scm | output
	lua5.3 qc.lua scm > output/qc.lua.scm
	diff -s qc.scm output/qc.lua.scm

test-lua-r: qc.lua qc.r | output
	lua5.3 qc.lua r > output/qc.lua.r
	diff -s qc.r output/qc.lua.r

test-lua-lua: qc.lua qc.lua | output
	lua5.3 qc.lua > output/qc.lua.lua
	diff -s qc.lua output/qc.lua.lua

test-lua-go: qc.lua qc.go | output
	lua5.3 qc.lua go > output/qc.lua.go
	diff -s qc.go output/qc.lua.go

test-lua-ps: qc.lua qc.ps | output
	lua5.3 qc.lua ps > output/qc.lua.ps
	diff -s qc.ps output/qc.lua.ps

test-lua-vala: qc.lua qc.vala | output
	lua5.3 qc.lua vala > output/qc.lua.vala
	diff -s qc.vala output/qc.lua.vala

test-lua-pike: qc.lua qc.pike | output
	lua5.3 qc.lua pike > output/qc.lua.pike
	diff -s qc.pike output/qc.lua.pike

test-lua-pas: qc.lua qc.pas | output
	lua5.3 qc.lua pas > output/qc.lua.pas
	diff -s qc.pas output/qc.lua.pas

test-lua-kt: qc.lua qc.kt | output
	lua5.3 qc.lua kt > output/qc.lua.kt
	diff -s qc.kt output/qc.lua.kt

test-lua-m: qc.lua qc.m | output
	lua5.3 qc.lua m > output/qc.lua.m
	diff -s qc.m output/qc.lua.m

test-lua-ml: qc.lua qc.ml | output
	lua5.3 qc.lua ml > output/qc.lua.ml
	diff -s qc.ml output/qc.lua.ml

test-lua-hs: qc.lua qc.hs | output
	lua5.3 qc.lua hs > output/qc.lua.hs
	diff -s qc.hs output/qc.lua.hs

test-lua-zig: qc.lua qc.zig | output
	lua5.3 qc.lua zig > output/qc.lua.zig
	diff -s qc.zig output/qc.lua.zig

test-lua-sml: qc.lua qc.sml | output
	lua5.3 qc.lua sml > output/qc.lua.sml
	diff -s qc.sml output/qc.lua.sml

test-lua-octave: qc.lua qc.octave | output
	lua5.3 qc.lua octave > output/qc.lua.octave
	diff -s qc.octave output/qc.lua.octave

test-lua-groovy: qc.lua qc.groovy | output
	lua5.3 qc.lua groovy > output/qc.lua.groovy
	diff -s qc.groovy output/qc.lua.groovy

test-lua-ws: qc.lua qc.ws | output
	lua5.3 qc.lua ws > output/qc.lua.ws
	diff -s qc.ws output/qc.lua.ws

test-lua-coffee: qc.lua qc.coffee | output
	lua5.3 qc.lua coffee > output/qc.lua.coffee
	diff -s qc.coffee output/qc.lua.coffee

test-lua-swift: qc.lua qc.swift | output
	lua5.3 qc.lua swift > output/qc.lua.swift
	diff -s qc.swift output/qc.lua.swift

test-lua-py: qc.lua qc.py | output
	lua5.3 qc.lua py > output/qc.lua.py
	diff -s qc.py output/qc.lua.py

test-lua-fs: qc.lua qc.fs | output
	lua5.3 qc.lua fs > output/qc.lua.fs
	diff -s qc.fs output/qc.lua.fs

test-lua-nim: qc.lua qc.nim | output
	lua5.3 qc.lua nim > output/qc.lua.nim
	diff -s qc.nim output/qc.lua.nim

test-lua-fsx: qc.lua qc.fsx | output
	lua5.3 qc.lua fsx > output/qc.lua.fsx
	diff -s qc.fsx output/qc.lua.fsx

test-lua-tcl: qc.lua qc.tcl | output
	lua5.3 qc.lua tcl > output/qc.lua.tcl
	diff -s qc.tcl output/qc.lua.tcl

test-lua-bf: qc.lua qc.bf | output
	lua5.3 qc.lua bf > output/qc.lua.bf
	diff -s qc.bf output/qc.lua.bf

test-lua-java: qc.lua qc.java | output
	lua5.3 qc.lua java > output/qc.lua.java
	diff -s qc.java output/qc.lua.java

test-lua-php: qc.lua qc.php | output
	lua5.3 qc.lua php > output/qc.lua.php
	diff -s qc.php output/qc.lua.php

test-lua-bash: qc.lua qc.bash | output
	lua5.3 qc.lua bash > output/qc.lua.bash
	diff -s qc.bash output/qc.lua.bash

test-lua-d: qc.lua qc.d | output
	lua5.3 qc.lua d > output/qc.lua.d
	diff -s qc.d output/qc.lua.d

test-lua-pl: qc.lua qc.pl | output
	lua5.3 qc.lua pl > output/qc.lua.pl
	diff -s qc.pl output/qc.lua.pl

test-lua-exs: qc.lua qc.exs | output
	lua5.3 qc.lua exs > output/qc.lua.exs
	diff -s qc.exs output/qc.lua.exs

test-lua-rb: qc.lua qc.rb | output
	lua5.3 qc.lua rb > output/qc.lua.rb
	diff -s qc.rb output/qc.lua.rb

test-lua-js: qc.lua qc.js | output
	lua5.3 qc.lua js > output/qc.lua.js
	diff -s qc.js output/qc.lua.js

test-lua-ts: qc.lua qc.ts | output
	lua5.3 qc.lua ts > output/qc.lua.ts
	diff -s qc.ts output/qc.lua.ts

test-lua-erl: qc.lua qc.erl | output
	lua5.3 qc.lua erl > output/qc.lua.erl
	diff -s qc.erl output/qc.lua.erl

test-lua-cs: qc.lua qc.cs | output
	lua5.3 qc.lua cs > output/qc.lua.cs
	diff -s qc.cs output/qc.lua.cs

test-lua-prolog: qc.lua qc.prolog | output
	lua5.3 qc.lua prolog > output/qc.lua.prolog
	diff -s qc.prolog output/qc.lua.prolog

test-lua-cr: qc.lua qc.cr | output
	lua5.3 qc.lua cr > output/qc.lua.cr
	diff -s qc.cr output/qc.lua.cr

test-lua-unl: qc.lua qc.unl | output
	lua5.3 qc.lua unl > output/qc.lua.unl
	diff -s qc.unl output/qc.lua.unl

test-lua-hx: qc.lua qc.hx | output
	lua5.3 qc.lua hx > output/qc.lua.hx
	diff -s qc.hx output/qc.lua.hx

test-lua-bef: qc.lua qc.bef | output
	lua5.3 qc.lua bef > output/qc.lua.bef
	diff -s qc.bef output/qc.lua.bef

test-lua-awk: qc.lua qc.awk | output
	lua5.3 qc.lua awk > output/qc.lua.awk
	diff -s qc.awk output/qc.lua.awk

test-lua-piet: qc.lua qc.piet.gif | output
	lua5.3 qc.lua piet > output/qc.lua.piet
	diff -s qc.piet.gif output/qc.lua.piet

test-go-clj: qc.go qc.clj | output
	go run qc.go clj > output/qc.go.clj
	diff -s qc.clj output/qc.go.clj

test-go-lisp: qc.go qc.lisp | output
	go run qc.go lisp > output/qc.go.lisp
	diff -s qc.lisp output/qc.go.lisp

test-go-rkt: qc.go qc.rkt | output
	go run qc.go rkt > output/qc.go.rkt
	diff -s qc.rkt output/qc.go.rkt

test-go-rs: qc.go qc.rs | output
	go run qc.go rs > output/qc.go.rs
	diff -s qc.rs output/qc.go.rs

test-go-c: qc.go qc.c | output
	go run qc.go c > output/qc.go.c
	diff -s qc.c output/qc.go.c

test-go-cpp: qc.go qc.cpp | output
	go run qc.go cpp > output/qc.go.cpp
	diff -s qc.cpp output/qc.go.cpp

test-go-scala: qc.go qc.scala | output
	go run qc.go scala > output/qc.go.scala
	diff -s qc.scala output/qc.go.scala

test-go-f90: qc.go qc.f90 | output
	go run qc.go f90 > output/qc.go.f90
	diff -s qc.f90 output/qc.go.f90

test-go-scm: qc.go qc.scm | output
	go run qc.go scm > output/qc.go.scm
	diff -s qc.scm output/qc.go.scm

test-go-r: qc.go qc.r | output
	go run qc.go r > output/qc.go.r
	diff -s qc.r output/qc.go.r

test-go-lua: qc.go qc.lua | output
	go run qc.go lua > output/qc.go.lua
	diff -s qc.lua output/qc.go.lua

test-go-go: qc.go qc.go | output
	go run qc.go > output/qc.go.go
	diff -s qc.go output/qc.go.go

test-go-ps: qc.go qc.ps | output
	go run qc.go ps > output/qc.go.ps
	diff -s qc.ps output/qc.go.ps

test-go-vala: qc.go qc.vala | output
	go run qc.go vala > output/qc.go.vala
	diff -s qc.vala output/qc.go.vala

test-go-pike: qc.go qc.pike | output
	go run qc.go pike > output/qc.go.pike
	diff -s qc.pike output/qc.go.pike

test-go-pas: qc.go qc.pas | output
	go run qc.go pas > output/qc.go.pas
	diff -s qc.pas output/qc.go.pas

test-go-kt: qc.go qc.kt | output
	go run qc.go kt > output/qc.go.kt
	diff -s qc.kt output/qc.go.kt

test-go-m: qc.go qc.m | output
	go run qc.go m > output/qc.go.m
	diff -s qc.m output/qc.go.m

test-go-ml: qc.go qc.ml | output
	go run qc.go ml > output/qc.go.ml
	diff -s qc.ml output/qc.go.ml

test-go-hs: qc.go qc.hs | output
	go run qc.go hs > output/qc.go.hs
	diff -s qc.hs output/qc.go.hs

test-go-zig: qc.go qc.zig | output
	go run qc.go zig > output/qc.go.zig
	diff -s qc.zig output/qc.go.zig

test-go-sml: qc.go qc.sml | output
	go run qc.go sml > output/qc.go.sml
	diff -s qc.sml output/qc.go.sml

test-go-octave: qc.go qc.octave | output
	go run qc.go octave > output/qc.go.octave
	diff -s qc.octave output/qc.go.octave

test-go-groovy: qc.go qc.groovy | output
	go run qc.go groovy > output/qc.go.groovy
	diff -s qc.groovy output/qc.go.groovy

test-go-ws: qc.go qc.ws | output
	go run qc.go ws > output/qc.go.ws
	diff -s qc.ws output/qc.go.ws

test-go-coffee: qc.go qc.coffee | output
	go run qc.go coffee > output/qc.go.coffee
	diff -s qc.coffee output/qc.go.coffee

test-go-swift: qc.go qc.swift | output
	go run qc.go swift > output/qc.go.swift
	diff -s qc.swift output/qc.go.swift

test-go-py: qc.go qc.py | output
	go run qc.go py > output/qc.go.py
	diff -s qc.py output/qc.go.py

test-go-fs: qc.go qc.fs | output
	go run qc.go fs > output/qc.go.fs
	diff -s qc.fs output/qc.go.fs

test-go-nim: qc.go qc.nim | output
	go run qc.go nim > output/qc.go.nim
	diff -s qc.nim output/qc.go.nim

test-go-fsx: qc.go qc.fsx | output
	go run qc.go fsx > output/qc.go.fsx
	diff -s qc.fsx output/qc.go.fsx

test-go-tcl: qc.go qc.tcl | output
	go run qc.go tcl > output/qc.go.tcl
	diff -s qc.tcl output/qc.go.tcl

test-go-bf: qc.go qc.bf | output
	go run qc.go bf > output/qc.go.bf
	diff -s qc.bf output/qc.go.bf

test-go-java: qc.go qc.java | output
	go run qc.go java > output/qc.go.java
	diff -s qc.java output/qc.go.java

test-go-php: qc.go qc.php | output
	go run qc.go php > output/qc.go.php
	diff -s qc.php output/qc.go.php

test-go-bash: qc.go qc.bash | output
	go run qc.go bash > output/qc.go.bash
	diff -s qc.bash output/qc.go.bash

test-go-d: qc.go qc.d | output
	go run qc.go d > output/qc.go.d
	diff -s qc.d output/qc.go.d

test-go-pl: qc.go qc.pl | output
	go run qc.go pl > output/qc.go.pl
	diff -s qc.pl output/qc.go.pl

test-go-exs: qc.go qc.exs | output
	go run qc.go exs > output/qc.go.exs
	diff -s qc.exs output/qc.go.exs

test-go-rb: qc.go qc.rb | output
	go run qc.go rb > output/qc.go.rb
	diff -s qc.rb output/qc.go.rb

test-go-js: qc.go qc.js | output
	go run qc.go js > output/qc.go.js
	diff -s qc.js output/qc.go.js

test-go-ts: qc.go qc.ts | output
	go run qc.go ts > output/qc.go.ts
	diff -s qc.ts output/qc.go.ts

test-go-erl: qc.go qc.erl | output
	go run qc.go erl > output/qc.go.erl
	diff -s qc.erl output/qc.go.erl

test-go-cs: qc.go qc.cs | output
	go run qc.go cs > output/qc.go.cs
	diff -s qc.cs output/qc.go.cs

test-go-prolog: qc.go qc.prolog | output
	go run qc.go prolog > output/qc.go.prolog
	diff -s qc.prolog output/qc.go.prolog

test-go-cr: qc.go qc.cr | output
	go run qc.go cr > output/qc.go.cr
	diff -s qc.cr output/qc.go.cr

test-go-unl: qc.go qc.unl | output
	go run qc.go unl > output/qc.go.unl
	diff -s qc.unl output/qc.go.unl

test-go-hx: qc.go qc.hx | output
	go run qc.go hx > output/qc.go.hx
	diff -s qc.hx output/qc.go.hx

test-go-bef: qc.go qc.bef | output
	go run qc.go bef > output/qc.go.bef
	diff -s qc.bef output/qc.go.bef

test-go-awk: qc.go qc.awk | output
	go run qc.go awk > output/qc.go.awk
	diff -s qc.awk output/qc.go.awk

test-go-piet: qc.go qc.piet.gif | output
	go run qc.go piet > output/qc.go.piet
	diff -s qc.piet.gif output/qc.go.piet

test-ps-clj: qc.ps qc.clj | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps clj > output/qc.ps.clj
	diff -s qc.clj output/qc.ps.clj

test-ps-lisp: qc.ps qc.lisp | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps lisp > output/qc.ps.lisp
	diff -s qc.lisp output/qc.ps.lisp

test-ps-rkt: qc.ps qc.rkt | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps rkt > output/qc.ps.rkt
	diff -s qc.rkt output/qc.ps.rkt

test-ps-rs: qc.ps qc.rs | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps rs > output/qc.ps.rs
	diff -s qc.rs output/qc.ps.rs

test-ps-c: qc.ps qc.c | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps c > output/qc.ps.c
	diff -s qc.c output/qc.ps.c

test-ps-cpp: qc.ps qc.cpp | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps cpp > output/qc.ps.cpp
	diff -s qc.cpp output/qc.ps.cpp

test-ps-scala: qc.ps qc.scala | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps scala > output/qc.ps.scala
	diff -s qc.scala output/qc.ps.scala

test-ps-f90: qc.ps qc.f90 | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps f90 > output/qc.ps.f90
	diff -s qc.f90 output/qc.ps.f90

test-ps-scm: qc.ps qc.scm | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps scm > output/qc.ps.scm
	diff -s qc.scm output/qc.ps.scm

test-ps-r: qc.ps qc.r | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps r > output/qc.ps.r
	diff -s qc.r output/qc.ps.r

test-ps-lua: qc.ps qc.lua | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps lua > output/qc.ps.lua
	diff -s qc.lua output/qc.ps.lua

test-ps-go: qc.ps qc.go | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps go > output/qc.ps.go
	diff -s qc.go output/qc.ps.go

test-ps-ps: qc.ps qc.ps | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps > output/qc.ps.ps
	diff -s qc.ps output/qc.ps.ps

test-ps-vala: qc.ps qc.vala | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps vala > output/qc.ps.vala
	diff -s qc.vala output/qc.ps.vala

test-ps-pike: qc.ps qc.pike | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps pike > output/qc.ps.pike
	diff -s qc.pike output/qc.ps.pike

test-ps-pas: qc.ps qc.pas | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps pas > output/qc.ps.pas
	diff -s qc.pas output/qc.ps.pas

test-ps-kt: qc.ps qc.kt | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps kt > output/qc.ps.kt
	diff -s qc.kt output/qc.ps.kt

test-ps-m: qc.ps qc.m | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps m > output/qc.ps.m
	diff -s qc.m output/qc.ps.m

test-ps-ml: qc.ps qc.ml | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps ml > output/qc.ps.ml
	diff -s qc.ml output/qc.ps.ml

test-ps-hs: qc.ps qc.hs | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps hs > output/qc.ps.hs
	diff -s qc.hs output/qc.ps.hs

test-ps-zig: qc.ps qc.zig | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps zig > output/qc.ps.zig
	diff -s qc.zig output/qc.ps.zig

test-ps-sml: qc.ps qc.sml | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps sml > output/qc.ps.sml
	diff -s qc.sml output/qc.ps.sml

test-ps-octave: qc.ps qc.octave | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps octave > output/qc.ps.octave
	diff -s qc.octave output/qc.ps.octave

test-ps-groovy: qc.ps qc.groovy | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps groovy > output/qc.ps.groovy
	diff -s qc.groovy output/qc.ps.groovy

test-ps-ws: qc.ps qc.ws | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps ws > output/qc.ps.ws
	diff -s qc.ws output/qc.ps.ws

test-ps-coffee: qc.ps qc.coffee | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps coffee > output/qc.ps.coffee
	diff -s qc.coffee output/qc.ps.coffee

test-ps-swift: qc.ps qc.swift | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps swift > output/qc.ps.swift
	diff -s qc.swift output/qc.ps.swift

test-ps-py: qc.ps qc.py | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps py > output/qc.ps.py
	diff -s qc.py output/qc.ps.py

test-ps-fs: qc.ps qc.fs | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps fs > output/qc.ps.fs
	diff -s qc.fs output/qc.ps.fs

test-ps-nim: qc.ps qc.nim | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps nim > output/qc.ps.nim
	diff -s qc.nim output/qc.ps.nim

test-ps-fsx: qc.ps qc.fsx | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps fsx > output/qc.ps.fsx
	diff -s qc.fsx output/qc.ps.fsx

test-ps-tcl: qc.ps qc.tcl | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps tcl > output/qc.ps.tcl
	diff -s qc.tcl output/qc.ps.tcl

test-ps-bf: qc.ps qc.bf | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps bf > output/qc.ps.bf
	diff -s qc.bf output/qc.ps.bf

test-ps-java: qc.ps qc.java | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps java > output/qc.ps.java
	diff -s qc.java output/qc.ps.java

test-ps-php: qc.ps qc.php | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps php > output/qc.ps.php
	diff -s qc.php output/qc.ps.php

test-ps-bash: qc.ps qc.bash | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps bash > output/qc.ps.bash
	diff -s qc.bash output/qc.ps.bash

test-ps-d: qc.ps qc.d | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps d > output/qc.ps.d
	diff -s qc.d output/qc.ps.d

test-ps-pl: qc.ps qc.pl | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps pl > output/qc.ps.pl
	diff -s qc.pl output/qc.ps.pl

test-ps-exs: qc.ps qc.exs | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps exs > output/qc.ps.exs
	diff -s qc.exs output/qc.ps.exs

test-ps-rb: qc.ps qc.rb | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps rb > output/qc.ps.rb
	diff -s qc.rb output/qc.ps.rb

test-ps-js: qc.ps qc.js | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps js > output/qc.ps.js
	diff -s qc.js output/qc.ps.js

test-ps-ts: qc.ps qc.ts | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps ts > output/qc.ps.ts
	diff -s qc.ts output/qc.ps.ts

test-ps-erl: qc.ps qc.erl | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps erl > output/qc.ps.erl
	diff -s qc.erl output/qc.ps.erl

test-ps-cs: qc.ps qc.cs | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps cs > output/qc.ps.cs
	diff -s qc.cs output/qc.ps.cs

test-ps-prolog: qc.ps qc.prolog | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps prolog > output/qc.ps.prolog
	diff -s qc.prolog output/qc.ps.prolog

test-ps-cr: qc.ps qc.cr | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps cr > output/qc.ps.cr
	diff -s qc.cr output/qc.ps.cr

test-ps-unl: qc.ps qc.unl | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps unl > output/qc.ps.unl
	diff -s qc.unl output/qc.ps.unl

test-ps-hx: qc.ps qc.hx | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps hx > output/qc.ps.hx
	diff -s qc.hx output/qc.ps.hx

test-ps-bef: qc.ps qc.bef | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps bef > output/qc.ps.bef
	diff -s qc.bef output/qc.ps.bef

test-ps-awk: qc.ps qc.awk | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps awk > output/qc.ps.awk
	diff -s qc.awk output/qc.ps.awk

test-ps-piet: qc.ps qc.piet.gif | output
	gs -q -dNODISPLAY -dBATCH -- qc.ps piet > output/qc.ps.piet
	diff -s qc.piet.gif output/qc.ps.piet

test-vala-clj: build/qc.vala.exe qc.clj | output
	build/qc.vala.exe clj > output/qc.vala.clj
	diff -s qc.clj output/qc.vala.clj

test-vala-lisp: build/qc.vala.exe qc.lisp | output
	build/qc.vala.exe lisp > output/qc.vala.lisp
	diff -s qc.lisp output/qc.vala.lisp

test-vala-rkt: build/qc.vala.exe qc.rkt | output
	build/qc.vala.exe rkt > output/qc.vala.rkt
	diff -s qc.rkt output/qc.vala.rkt

test-vala-rs: build/qc.vala.exe qc.rs | output
	build/qc.vala.exe rs > output/qc.vala.rs
	diff -s qc.rs output/qc.vala.rs

test-vala-c: build/qc.vala.exe qc.c | output
	build/qc.vala.exe c > output/qc.vala.c
	diff -s qc.c output/qc.vala.c

test-vala-cpp: build/qc.vala.exe qc.cpp | output
	build/qc.vala.exe cpp > output/qc.vala.cpp
	diff -s qc.cpp output/qc.vala.cpp

test-vala-scala: build/qc.vala.exe qc.scala | output
	build/qc.vala.exe scala > output/qc.vala.scala
	diff -s qc.scala output/qc.vala.scala

test-vala-f90: build/qc.vala.exe qc.f90 | output
	build/qc.vala.exe f90 > output/qc.vala.f90
	diff -s qc.f90 output/qc.vala.f90

test-vala-scm: build/qc.vala.exe qc.scm | output
	build/qc.vala.exe scm > output/qc.vala.scm
	diff -s qc.scm output/qc.vala.scm

test-vala-r: build/qc.vala.exe qc.r | output
	build/qc.vala.exe r > output/qc.vala.r
	diff -s qc.r output/qc.vala.r

test-vala-lua: build/qc.vala.exe qc.lua | output
	build/qc.vala.exe lua > output/qc.vala.lua
	diff -s qc.lua output/qc.vala.lua

test-vala-go: build/qc.vala.exe qc.go | output
	build/qc.vala.exe go > output/qc.vala.go
	diff -s qc.go output/qc.vala.go

test-vala-ps: build/qc.vala.exe qc.ps | output
	build/qc.vala.exe ps > output/qc.vala.ps
	diff -s qc.ps output/qc.vala.ps

test-vala-vala: build/qc.vala.exe qc.vala | output
	build/qc.vala.exe > output/qc.vala.vala
	diff -s qc.vala output/qc.vala.vala

test-vala-pike: build/qc.vala.exe qc.pike | output
	build/qc.vala.exe pike > output/qc.vala.pike
	diff -s qc.pike output/qc.vala.pike

test-vala-pas: build/qc.vala.exe qc.pas | output
	build/qc.vala.exe pas > output/qc.vala.pas
	diff -s qc.pas output/qc.vala.pas

test-vala-kt: build/qc.vala.exe qc.kt | output
	build/qc.vala.exe kt > output/qc.vala.kt
	diff -s qc.kt output/qc.vala.kt

test-vala-m: build/qc.vala.exe qc.m | output
	build/qc.vala.exe m > output/qc.vala.m
	diff -s qc.m output/qc.vala.m

test-vala-ml: build/qc.vala.exe qc.ml | output
	build/qc.vala.exe ml > output/qc.vala.ml
	diff -s qc.ml output/qc.vala.ml

test-vala-hs: build/qc.vala.exe qc.hs | output
	build/qc.vala.exe hs > output/qc.vala.hs
	diff -s qc.hs output/qc.vala.hs

test-vala-zig: build/qc.vala.exe qc.zig | output
	build/qc.vala.exe zig > output/qc.vala.zig
	diff -s qc.zig output/qc.vala.zig

test-vala-sml: build/qc.vala.exe qc.sml | output
	build/qc.vala.exe sml > output/qc.vala.sml
	diff -s qc.sml output/qc.vala.sml

test-vala-octave: build/qc.vala.exe qc.octave | output
	build/qc.vala.exe octave > output/qc.vala.octave
	diff -s qc.octave output/qc.vala.octave

test-vala-groovy: build/qc.vala.exe qc.groovy | output
	build/qc.vala.exe groovy > output/qc.vala.groovy
	diff -s qc.groovy output/qc.vala.groovy

test-vala-ws: build/qc.vala.exe qc.ws | output
	build/qc.vala.exe ws > output/qc.vala.ws
	diff -s qc.ws output/qc.vala.ws

test-vala-coffee: build/qc.vala.exe qc.coffee | output
	build/qc.vala.exe coffee > output/qc.vala.coffee
	diff -s qc.coffee output/qc.vala.coffee

test-vala-swift: build/qc.vala.exe qc.swift | output
	build/qc.vala.exe swift > output/qc.vala.swift
	diff -s qc.swift output/qc.vala.swift

test-vala-py: build/qc.vala.exe qc.py | output
	build/qc.vala.exe py > output/qc.vala.py
	diff -s qc.py output/qc.vala.py

test-vala-fs: build/qc.vala.exe qc.fs | output
	build/qc.vala.exe fs > output/qc.vala.fs
	diff -s qc.fs output/qc.vala.fs

test-vala-nim: build/qc.vala.exe qc.nim | output
	build/qc.vala.exe nim > output/qc.vala.nim
	diff -s qc.nim output/qc.vala.nim

test-vala-fsx: build/qc.vala.exe qc.fsx | output
	build/qc.vala.exe fsx > output/qc.vala.fsx
	diff -s qc.fsx output/qc.vala.fsx

test-vala-tcl: build/qc.vala.exe qc.tcl | output
	build/qc.vala.exe tcl > output/qc.vala.tcl
	diff -s qc.tcl output/qc.vala.tcl

test-vala-bf: build/qc.vala.exe qc.bf | output
	build/qc.vala.exe bf > output/qc.vala.bf
	diff -s qc.bf output/qc.vala.bf

test-vala-java: build/qc.vala.exe qc.java | output
	build/qc.vala.exe java > output/qc.vala.java
	diff -s qc.java output/qc.vala.java

test-vala-php: build/qc.vala.exe qc.php | output
	build/qc.vala.exe php > output/qc.vala.php
	diff -s qc.php output/qc.vala.php

test-vala-bash: build/qc.vala.exe qc.bash | output
	build/qc.vala.exe bash > output/qc.vala.bash
	diff -s qc.bash output/qc.vala.bash

test-vala-d: build/qc.vala.exe qc.d | output
	build/qc.vala.exe d > output/qc.vala.d
	diff -s qc.d output/qc.vala.d

test-vala-pl: build/qc.vala.exe qc.pl | output
	build/qc.vala.exe pl > output/qc.vala.pl
	diff -s qc.pl output/qc.vala.pl

test-vala-exs: build/qc.vala.exe qc.exs | output
	build/qc.vala.exe exs > output/qc.vala.exs
	diff -s qc.exs output/qc.vala.exs

test-vala-rb: build/qc.vala.exe qc.rb | output
	build/qc.vala.exe rb > output/qc.vala.rb
	diff -s qc.rb output/qc.vala.rb

test-vala-js: build/qc.vala.exe qc.js | output
	build/qc.vala.exe js > output/qc.vala.js
	diff -s qc.js output/qc.vala.js

test-vala-ts: build/qc.vala.exe qc.ts | output
	build/qc.vala.exe ts > output/qc.vala.ts
	diff -s qc.ts output/qc.vala.ts

test-vala-erl: build/qc.vala.exe qc.erl | output
	build/qc.vala.exe erl > output/qc.vala.erl
	diff -s qc.erl output/qc.vala.erl

test-vala-cs: build/qc.vala.exe qc.cs | output
	build/qc.vala.exe cs > output/qc.vala.cs
	diff -s qc.cs output/qc.vala.cs

test-vala-prolog: build/qc.vala.exe qc.prolog | output
	build/qc.vala.exe prolog > output/qc.vala.prolog
	diff -s qc.prolog output/qc.vala.prolog

test-vala-cr: build/qc.vala.exe qc.cr | output
	build/qc.vala.exe cr > output/qc.vala.cr
	diff -s qc.cr output/qc.vala.cr

test-vala-unl: build/qc.vala.exe qc.unl | output
	build/qc.vala.exe unl > output/qc.vala.unl
	diff -s qc.unl output/qc.vala.unl

test-vala-hx: build/qc.vala.exe qc.hx | output
	build/qc.vala.exe hx > output/qc.vala.hx
	diff -s qc.hx output/qc.vala.hx

test-vala-bef: build/qc.vala.exe qc.bef | output
	build/qc.vala.exe bef > output/qc.vala.bef
	diff -s qc.bef output/qc.vala.bef

test-vala-awk: build/qc.vala.exe qc.awk | output
	build/qc.vala.exe awk > output/qc.vala.awk
	diff -s qc.awk output/qc.vala.awk

test-vala-piet: build/qc.vala.exe qc.piet.gif | output
	build/qc.vala.exe piet > output/qc.vala.piet
	diff -s qc.piet.gif output/qc.vala.piet

test-pike-clj: qc.pike qc.clj | output
	pike qc.pike clj > output/qc.pike.clj
	diff -s qc.clj output/qc.pike.clj

test-pike-lisp: qc.pike qc.lisp | output
	pike qc.pike lisp > output/qc.pike.lisp
	diff -s qc.lisp output/qc.pike.lisp

test-pike-rkt: qc.pike qc.rkt | output
	pike qc.pike rkt > output/qc.pike.rkt
	diff -s qc.rkt output/qc.pike.rkt

test-pike-rs: qc.pike qc.rs | output
	pike qc.pike rs > output/qc.pike.rs
	diff -s qc.rs output/qc.pike.rs

test-pike-c: qc.pike qc.c | output
	pike qc.pike c > output/qc.pike.c
	diff -s qc.c output/qc.pike.c

test-pike-cpp: qc.pike qc.cpp | output
	pike qc.pike cpp > output/qc.pike.cpp
	diff -s qc.cpp output/qc.pike.cpp

test-pike-scala: qc.pike qc.scala | output
	pike qc.pike scala > output/qc.pike.scala
	diff -s qc.scala output/qc.pike.scala

test-pike-f90: qc.pike qc.f90 | output
	pike qc.pike f90 > output/qc.pike.f90
	diff -s qc.f90 output/qc.pike.f90

test-pike-scm: qc.pike qc.scm | output
	pike qc.pike scm > output/qc.pike.scm
	diff -s qc.scm output/qc.pike.scm

test-pike-r: qc.pike qc.r | output
	pike qc.pike r > output/qc.pike.r
	diff -s qc.r output/qc.pike.r

test-pike-lua: qc.pike qc.lua | output
	pike qc.pike lua > output/qc.pike.lua
	diff -s qc.lua output/qc.pike.lua

test-pike-go: qc.pike qc.go | output
	pike qc.pike go > output/qc.pike.go
	diff -s qc.go output/qc.pike.go

test-pike-ps: qc.pike qc.ps | output
	pike qc.pike ps > output/qc.pike.ps
	diff -s qc.ps output/qc.pike.ps

test-pike-vala: qc.pike qc.vala | output
	pike qc.pike vala > output/qc.pike.vala
	diff -s qc.vala output/qc.pike.vala

test-pike-pike: qc.pike qc.pike | output
	pike qc.pike > output/qc.pike.pike
	diff -s qc.pike output/qc.pike.pike

test-pike-pas: qc.pike qc.pas | output
	pike qc.pike pas > output/qc.pike.pas
	diff -s qc.pas output/qc.pike.pas

test-pike-kt: qc.pike qc.kt | output
	pike qc.pike kt > output/qc.pike.kt
	diff -s qc.kt output/qc.pike.kt

test-pike-m: qc.pike qc.m | output
	pike qc.pike m > output/qc.pike.m
	diff -s qc.m output/qc.pike.m

test-pike-ml: qc.pike qc.ml | output
	pike qc.pike ml > output/qc.pike.ml
	diff -s qc.ml output/qc.pike.ml

test-pike-hs: qc.pike qc.hs | output
	pike qc.pike hs > output/qc.pike.hs
	diff -s qc.hs output/qc.pike.hs

test-pike-zig: qc.pike qc.zig | output
	pike qc.pike zig > output/qc.pike.zig
	diff -s qc.zig output/qc.pike.zig

test-pike-sml: qc.pike qc.sml | output
	pike qc.pike sml > output/qc.pike.sml
	diff -s qc.sml output/qc.pike.sml

test-pike-octave: qc.pike qc.octave | output
	pike qc.pike octave > output/qc.pike.octave
	diff -s qc.octave output/qc.pike.octave

test-pike-groovy: qc.pike qc.groovy | output
	pike qc.pike groovy > output/qc.pike.groovy
	diff -s qc.groovy output/qc.pike.groovy

test-pike-ws: qc.pike qc.ws | output
	pike qc.pike ws > output/qc.pike.ws
	diff -s qc.ws output/qc.pike.ws

test-pike-coffee: qc.pike qc.coffee | output
	pike qc.pike coffee > output/qc.pike.coffee
	diff -s qc.coffee output/qc.pike.coffee

test-pike-swift: qc.pike qc.swift | output
	pike qc.pike swift > output/qc.pike.swift
	diff -s qc.swift output/qc.pike.swift

test-pike-py: qc.pike qc.py | output
	pike qc.pike py > output/qc.pike.py
	diff -s qc.py output/qc.pike.py

test-pike-fs: qc.pike qc.fs | output
	pike qc.pike fs > output/qc.pike.fs
	diff -s qc.fs output/qc.pike.fs

test-pike-nim: qc.pike qc.nim | output
	pike qc.pike nim > output/qc.pike.nim
	diff -s qc.nim output/qc.pike.nim

test-pike-fsx: qc.pike qc.fsx | output
	pike qc.pike fsx > output/qc.pike.fsx
	diff -s qc.fsx output/qc.pike.fsx

test-pike-tcl: qc.pike qc.tcl | output
	pike qc.pike tcl > output/qc.pike.tcl
	diff -s qc.tcl output/qc.pike.tcl

test-pike-bf: qc.pike qc.bf | output
	pike qc.pike bf > output/qc.pike.bf
	diff -s qc.bf output/qc.pike.bf

test-pike-java: qc.pike qc.java | output
	pike qc.pike java > output/qc.pike.java
	diff -s qc.java output/qc.pike.java

test-pike-php: qc.pike qc.php | output
	pike qc.pike php > output/qc.pike.php
	diff -s qc.php output/qc.pike.php

test-pike-bash: qc.pike qc.bash | output
	pike qc.pike bash > output/qc.pike.bash
	diff -s qc.bash output/qc.pike.bash

test-pike-d: qc.pike qc.d | output
	pike qc.pike d > output/qc.pike.d
	diff -s qc.d output/qc.pike.d

test-pike-pl: qc.pike qc.pl | output
	pike qc.pike pl > output/qc.pike.pl
	diff -s qc.pl output/qc.pike.pl

test-pike-exs: qc.pike qc.exs | output
	pike qc.pike exs > output/qc.pike.exs
	diff -s qc.exs output/qc.pike.exs

test-pike-rb: qc.pike qc.rb | output
	pike qc.pike rb > output/qc.pike.rb
	diff -s qc.rb output/qc.pike.rb

test-pike-js: qc.pike qc.js | output
	pike qc.pike js > output/qc.pike.js
	diff -s qc.js output/qc.pike.js

test-pike-ts: qc.pike qc.ts | output
	pike qc.pike ts > output/qc.pike.ts
	diff -s qc.ts output/qc.pike.ts

test-pike-erl: qc.pike qc.erl | output
	pike qc.pike erl > output/qc.pike.erl
	diff -s qc.erl output/qc.pike.erl

test-pike-cs: qc.pike qc.cs | output
	pike qc.pike cs > output/qc.pike.cs
	diff -s qc.cs output/qc.pike.cs

test-pike-prolog: qc.pike qc.prolog | output
	pike qc.pike prolog > output/qc.pike.prolog
	diff -s qc.prolog output/qc.pike.prolog

test-pike-cr: qc.pike qc.cr | output
	pike qc.pike cr > output/qc.pike.cr
	diff -s qc.cr output/qc.pike.cr

test-pike-unl: qc.pike qc.unl | output
	pike qc.pike unl > output/qc.pike.unl
	diff -s qc.unl output/qc.pike.unl

test-pike-hx: qc.pike qc.hx | output
	pike qc.pike hx > output/qc.pike.hx
	diff -s qc.hx output/qc.pike.hx

test-pike-bef: qc.pike qc.bef | output
	pike qc.pike bef > output/qc.pike.bef
	diff -s qc.bef output/qc.pike.bef

test-pike-awk: qc.pike qc.awk | output
	pike qc.pike awk > output/qc.pike.awk
	diff -s qc.awk output/qc.pike.awk

test-pike-piet: qc.pike qc.piet.gif | output
	pike qc.pike piet > output/qc.pike.piet
	diff -s qc.piet.gif output/qc.pike.piet

test-pas-clj: build/qc.pas.exe qc.clj | output
	build/qc.pas.exe clj > output/qc.pas.clj
	diff -s qc.clj output/qc.pas.clj

test-pas-lisp: build/qc.pas.exe qc.lisp | output
	build/qc.pas.exe lisp > output/qc.pas.lisp
	diff -s qc.lisp output/qc.pas.lisp

test-pas-rkt: build/qc.pas.exe qc.rkt | output
	build/qc.pas.exe rkt > output/qc.pas.rkt
	diff -s qc.rkt output/qc.pas.rkt

test-pas-rs: build/qc.pas.exe qc.rs | output
	build/qc.pas.exe rs > output/qc.pas.rs
	diff -s qc.rs output/qc.pas.rs

test-pas-c: build/qc.pas.exe qc.c | output
	build/qc.pas.exe c > output/qc.pas.c
	diff -s qc.c output/qc.pas.c

test-pas-cpp: build/qc.pas.exe qc.cpp | output
	build/qc.pas.exe cpp > output/qc.pas.cpp
	diff -s qc.cpp output/qc.pas.cpp

test-pas-scala: build/qc.pas.exe qc.scala | output
	build/qc.pas.exe scala > output/qc.pas.scala
	diff -s qc.scala output/qc.pas.scala

test-pas-f90: build/qc.pas.exe qc.f90 | output
	build/qc.pas.exe f90 > output/qc.pas.f90
	diff -s qc.f90 output/qc.pas.f90

test-pas-scm: build/qc.pas.exe qc.scm | output
	build/qc.pas.exe scm > output/qc.pas.scm
	diff -s qc.scm output/qc.pas.scm

test-pas-r: build/qc.pas.exe qc.r | output
	build/qc.pas.exe r > output/qc.pas.r
	diff -s qc.r output/qc.pas.r

test-pas-lua: build/qc.pas.exe qc.lua | output
	build/qc.pas.exe lua > output/qc.pas.lua
	diff -s qc.lua output/qc.pas.lua

test-pas-go: build/qc.pas.exe qc.go | output
	build/qc.pas.exe go > output/qc.pas.go
	diff -s qc.go output/qc.pas.go

test-pas-ps: build/qc.pas.exe qc.ps | output
	build/qc.pas.exe ps > output/qc.pas.ps
	diff -s qc.ps output/qc.pas.ps

test-pas-vala: build/qc.pas.exe qc.vala | output
	build/qc.pas.exe vala > output/qc.pas.vala
	diff -s qc.vala output/qc.pas.vala

test-pas-pike: build/qc.pas.exe qc.pike | output
	build/qc.pas.exe pike > output/qc.pas.pike
	diff -s qc.pike output/qc.pas.pike

test-pas-pas: build/qc.pas.exe qc.pas | output
	build/qc.pas.exe > output/qc.pas.pas
	diff -s qc.pas output/qc.pas.pas

test-pas-kt: build/qc.pas.exe qc.kt | output
	build/qc.pas.exe kt > output/qc.pas.kt
	diff -s qc.kt output/qc.pas.kt

test-pas-m: build/qc.pas.exe qc.m | output
	build/qc.pas.exe m > output/qc.pas.m
	diff -s qc.m output/qc.pas.m

test-pas-ml: build/qc.pas.exe qc.ml | output
	build/qc.pas.exe ml > output/qc.pas.ml
	diff -s qc.ml output/qc.pas.ml

test-pas-hs: build/qc.pas.exe qc.hs | output
	build/qc.pas.exe hs > output/qc.pas.hs
	diff -s qc.hs output/qc.pas.hs

test-pas-zig: build/qc.pas.exe qc.zig | output
	build/qc.pas.exe zig > output/qc.pas.zig
	diff -s qc.zig output/qc.pas.zig

test-pas-sml: build/qc.pas.exe qc.sml | output
	build/qc.pas.exe sml > output/qc.pas.sml
	diff -s qc.sml output/qc.pas.sml

test-pas-octave: build/qc.pas.exe qc.octave | output
	build/qc.pas.exe octave > output/qc.pas.octave
	diff -s qc.octave output/qc.pas.octave

test-pas-groovy: build/qc.pas.exe qc.groovy | output
	build/qc.pas.exe groovy > output/qc.pas.groovy
	diff -s qc.groovy output/qc.pas.groovy

test-pas-ws: build/qc.pas.exe qc.ws | output
	build/qc.pas.exe ws > output/qc.pas.ws
	diff -s qc.ws output/qc.pas.ws

test-pas-coffee: build/qc.pas.exe qc.coffee | output
	build/qc.pas.exe coffee > output/qc.pas.coffee
	diff -s qc.coffee output/qc.pas.coffee

test-pas-swift: build/qc.pas.exe qc.swift | output
	build/qc.pas.exe swift > output/qc.pas.swift
	diff -s qc.swift output/qc.pas.swift

test-pas-py: build/qc.pas.exe qc.py | output
	build/qc.pas.exe py > output/qc.pas.py
	diff -s qc.py output/qc.pas.py

test-pas-fs: build/qc.pas.exe qc.fs | output
	build/qc.pas.exe fs > output/qc.pas.fs
	diff -s qc.fs output/qc.pas.fs

test-pas-nim: build/qc.pas.exe qc.nim | output
	build/qc.pas.exe nim > output/qc.pas.nim
	diff -s qc.nim output/qc.pas.nim

test-pas-fsx: build/qc.pas.exe qc.fsx | output
	build/qc.pas.exe fsx > output/qc.pas.fsx
	diff -s qc.fsx output/qc.pas.fsx

test-pas-tcl: build/qc.pas.exe qc.tcl | output
	build/qc.pas.exe tcl > output/qc.pas.tcl
	diff -s qc.tcl output/qc.pas.tcl

test-pas-bf: build/qc.pas.exe qc.bf | output
	build/qc.pas.exe bf > output/qc.pas.bf
	diff -s qc.bf output/qc.pas.bf

test-pas-java: build/qc.pas.exe qc.java | output
	build/qc.pas.exe java > output/qc.pas.java
	diff -s qc.java output/qc.pas.java

test-pas-php: build/qc.pas.exe qc.php | output
	build/qc.pas.exe php > output/qc.pas.php
	diff -s qc.php output/qc.pas.php

test-pas-bash: build/qc.pas.exe qc.bash | output
	build/qc.pas.exe bash > output/qc.pas.bash
	diff -s qc.bash output/qc.pas.bash

test-pas-d: build/qc.pas.exe qc.d | output
	build/qc.pas.exe d > output/qc.pas.d
	diff -s qc.d output/qc.pas.d

test-pas-pl: build/qc.pas.exe qc.pl | output
	build/qc.pas.exe pl > output/qc.pas.pl
	diff -s qc.pl output/qc.pas.pl

test-pas-exs: build/qc.pas.exe qc.exs | output
	build/qc.pas.exe exs > output/qc.pas.exs
	diff -s qc.exs output/qc.pas.exs

test-pas-rb: build/qc.pas.exe qc.rb | output
	build/qc.pas.exe rb > output/qc.pas.rb
	diff -s qc.rb output/qc.pas.rb

test-pas-js: build/qc.pas.exe qc.js | output
	build/qc.pas.exe js > output/qc.pas.js
	diff -s qc.js output/qc.pas.js

test-pas-ts: build/qc.pas.exe qc.ts | output
	build/qc.pas.exe ts > output/qc.pas.ts
	diff -s qc.ts output/qc.pas.ts

test-pas-erl: build/qc.pas.exe qc.erl | output
	build/qc.pas.exe erl > output/qc.pas.erl
	diff -s qc.erl output/qc.pas.erl

test-pas-cs: build/qc.pas.exe qc.cs | output
	build/qc.pas.exe cs > output/qc.pas.cs
	diff -s qc.cs output/qc.pas.cs

test-pas-prolog: build/qc.pas.exe qc.prolog | output
	build/qc.pas.exe prolog > output/qc.pas.prolog
	diff -s qc.prolog output/qc.pas.prolog

test-pas-cr: build/qc.pas.exe qc.cr | output
	build/qc.pas.exe cr > output/qc.pas.cr
	diff -s qc.cr output/qc.pas.cr

test-pas-unl: build/qc.pas.exe qc.unl | output
	build/qc.pas.exe unl > output/qc.pas.unl
	diff -s qc.unl output/qc.pas.unl

test-pas-hx: build/qc.pas.exe qc.hx | output
	build/qc.pas.exe hx > output/qc.pas.hx
	diff -s qc.hx output/qc.pas.hx

test-pas-bef: build/qc.pas.exe qc.bef | output
	build/qc.pas.exe bef > output/qc.pas.bef
	diff -s qc.bef output/qc.pas.bef

test-pas-awk: build/qc.pas.exe qc.awk | output
	build/qc.pas.exe awk > output/qc.pas.awk
	diff -s qc.awk output/qc.pas.awk

test-pas-piet: build/qc.pas.exe qc.piet.gif | output
	build/qc.pas.exe piet > output/qc.pas.piet
	diff -s qc.piet.gif output/qc.pas.piet

test-kt-clj: build/qc.kt.exe.jar qc.clj | output
	java -jar build/qc.kt.exe.jar clj > output/qc.kt.clj
	diff -s qc.clj output/qc.kt.clj

test-kt-lisp: build/qc.kt.exe.jar qc.lisp | output
	java -jar build/qc.kt.exe.jar lisp > output/qc.kt.lisp
	diff -s qc.lisp output/qc.kt.lisp

test-kt-rkt: build/qc.kt.exe.jar qc.rkt | output
	java -jar build/qc.kt.exe.jar rkt > output/qc.kt.rkt
	diff -s qc.rkt output/qc.kt.rkt

test-kt-rs: build/qc.kt.exe.jar qc.rs | output
	java -jar build/qc.kt.exe.jar rs > output/qc.kt.rs
	diff -s qc.rs output/qc.kt.rs

test-kt-c: build/qc.kt.exe.jar qc.c | output
	java -jar build/qc.kt.exe.jar c > output/qc.kt.c
	diff -s qc.c output/qc.kt.c

test-kt-cpp: build/qc.kt.exe.jar qc.cpp | output
	java -jar build/qc.kt.exe.jar cpp > output/qc.kt.cpp
	diff -s qc.cpp output/qc.kt.cpp

test-kt-scala: build/qc.kt.exe.jar qc.scala | output
	java -jar build/qc.kt.exe.jar scala > output/qc.kt.scala
	diff -s qc.scala output/qc.kt.scala

test-kt-f90: build/qc.kt.exe.jar qc.f90 | output
	java -jar build/qc.kt.exe.jar f90 > output/qc.kt.f90
	diff -s qc.f90 output/qc.kt.f90

test-kt-scm: build/qc.kt.exe.jar qc.scm | output
	java -jar build/qc.kt.exe.jar scm > output/qc.kt.scm
	diff -s qc.scm output/qc.kt.scm

test-kt-r: build/qc.kt.exe.jar qc.r | output
	java -jar build/qc.kt.exe.jar r > output/qc.kt.r
	diff -s qc.r output/qc.kt.r

test-kt-lua: build/qc.kt.exe.jar qc.lua | output
	java -jar build/qc.kt.exe.jar lua > output/qc.kt.lua
	diff -s qc.lua output/qc.kt.lua

test-kt-go: build/qc.kt.exe.jar qc.go | output
	java -jar build/qc.kt.exe.jar go > output/qc.kt.go
	diff -s qc.go output/qc.kt.go

test-kt-ps: build/qc.kt.exe.jar qc.ps | output
	java -jar build/qc.kt.exe.jar ps > output/qc.kt.ps
	diff -s qc.ps output/qc.kt.ps

test-kt-vala: build/qc.kt.exe.jar qc.vala | output
	java -jar build/qc.kt.exe.jar vala > output/qc.kt.vala
	diff -s qc.vala output/qc.kt.vala

test-kt-pike: build/qc.kt.exe.jar qc.pike | output
	java -jar build/qc.kt.exe.jar pike > output/qc.kt.pike
	diff -s qc.pike output/qc.kt.pike

test-kt-pas: build/qc.kt.exe.jar qc.pas | output
	java -jar build/qc.kt.exe.jar pas > output/qc.kt.pas
	diff -s qc.pas output/qc.kt.pas

test-kt-kt: build/qc.kt.exe.jar qc.kt | output
	java -jar build/qc.kt.exe.jar > output/qc.kt.kt
	diff -s qc.kt output/qc.kt.kt

test-kt-m: build/qc.kt.exe.jar qc.m | output
	java -jar build/qc.kt.exe.jar m > output/qc.kt.m
	diff -s qc.m output/qc.kt.m

test-kt-ml: build/qc.kt.exe.jar qc.ml | output
	java -jar build/qc.kt.exe.jar ml > output/qc.kt.ml
	diff -s qc.ml output/qc.kt.ml

test-kt-hs: build/qc.kt.exe.jar qc.hs | output
	java -jar build/qc.kt.exe.jar hs > output/qc.kt.hs
	diff -s qc.hs output/qc.kt.hs

test-kt-zig: build/qc.kt.exe.jar qc.zig | output
	java -jar build/qc.kt.exe.jar zig > output/qc.kt.zig
	diff -s qc.zig output/qc.kt.zig

test-kt-sml: build/qc.kt.exe.jar qc.sml | output
	java -jar build/qc.kt.exe.jar sml > output/qc.kt.sml
	diff -s qc.sml output/qc.kt.sml

test-kt-octave: build/qc.kt.exe.jar qc.octave | output
	java -jar build/qc.kt.exe.jar octave > output/qc.kt.octave
	diff -s qc.octave output/qc.kt.octave

test-kt-groovy: build/qc.kt.exe.jar qc.groovy | output
	java -jar build/qc.kt.exe.jar groovy > output/qc.kt.groovy
	diff -s qc.groovy output/qc.kt.groovy

test-kt-ws: build/qc.kt.exe.jar qc.ws | output
	java -jar build/qc.kt.exe.jar ws > output/qc.kt.ws
	diff -s qc.ws output/qc.kt.ws

test-kt-coffee: build/qc.kt.exe.jar qc.coffee | output
	java -jar build/qc.kt.exe.jar coffee > output/qc.kt.coffee
	diff -s qc.coffee output/qc.kt.coffee

test-kt-swift: build/qc.kt.exe.jar qc.swift | output
	java -jar build/qc.kt.exe.jar swift > output/qc.kt.swift
	diff -s qc.swift output/qc.kt.swift

test-kt-py: build/qc.kt.exe.jar qc.py | output
	java -jar build/qc.kt.exe.jar py > output/qc.kt.py
	diff -s qc.py output/qc.kt.py

test-kt-fs: build/qc.kt.exe.jar qc.fs | output
	java -jar build/qc.kt.exe.jar fs > output/qc.kt.fs
	diff -s qc.fs output/qc.kt.fs

test-kt-nim: build/qc.kt.exe.jar qc.nim | output
	java -jar build/qc.kt.exe.jar nim > output/qc.kt.nim
	diff -s qc.nim output/qc.kt.nim

test-kt-fsx: build/qc.kt.exe.jar qc.fsx | output
	java -jar build/qc.kt.exe.jar fsx > output/qc.kt.fsx
	diff -s qc.fsx output/qc.kt.fsx

test-kt-tcl: build/qc.kt.exe.jar qc.tcl | output
	java -jar build/qc.kt.exe.jar tcl > output/qc.kt.tcl
	diff -s qc.tcl output/qc.kt.tcl

test-kt-bf: build/qc.kt.exe.jar qc.bf | output
	java -jar build/qc.kt.exe.jar bf > output/qc.kt.bf
	diff -s qc.bf output/qc.kt.bf

test-kt-java: build/qc.kt.exe.jar qc.java | output
	java -jar build/qc.kt.exe.jar java > output/qc.kt.java
	diff -s qc.java output/qc.kt.java

test-kt-php: build/qc.kt.exe.jar qc.php | output
	java -jar build/qc.kt.exe.jar php > output/qc.kt.php
	diff -s qc.php output/qc.kt.php

test-kt-bash: build/qc.kt.exe.jar qc.bash | output
	java -jar build/qc.kt.exe.jar bash > output/qc.kt.bash
	diff -s qc.bash output/qc.kt.bash

test-kt-d: build/qc.kt.exe.jar qc.d | output
	java -jar build/qc.kt.exe.jar d > output/qc.kt.d
	diff -s qc.d output/qc.kt.d

test-kt-pl: build/qc.kt.exe.jar qc.pl | output
	java -jar build/qc.kt.exe.jar pl > output/qc.kt.pl
	diff -s qc.pl output/qc.kt.pl

test-kt-exs: build/qc.kt.exe.jar qc.exs | output
	java -jar build/qc.kt.exe.jar exs > output/qc.kt.exs
	diff -s qc.exs output/qc.kt.exs

test-kt-rb: build/qc.kt.exe.jar qc.rb | output
	java -jar build/qc.kt.exe.jar rb > output/qc.kt.rb
	diff -s qc.rb output/qc.kt.rb

test-kt-js: build/qc.kt.exe.jar qc.js | output
	java -jar build/qc.kt.exe.jar js > output/qc.kt.js
	diff -s qc.js output/qc.kt.js

test-kt-ts: build/qc.kt.exe.jar qc.ts | output
	java -jar build/qc.kt.exe.jar ts > output/qc.kt.ts
	diff -s qc.ts output/qc.kt.ts

test-kt-erl: build/qc.kt.exe.jar qc.erl | output
	java -jar build/qc.kt.exe.jar erl > output/qc.kt.erl
	diff -s qc.erl output/qc.kt.erl

test-kt-cs: build/qc.kt.exe.jar qc.cs | output
	java -jar build/qc.kt.exe.jar cs > output/qc.kt.cs
	diff -s qc.cs output/qc.kt.cs

test-kt-prolog: build/qc.kt.exe.jar qc.prolog | output
	java -jar build/qc.kt.exe.jar prolog > output/qc.kt.prolog
	diff -s qc.prolog output/qc.kt.prolog

test-kt-cr: build/qc.kt.exe.jar qc.cr | output
	java -jar build/qc.kt.exe.jar cr > output/qc.kt.cr
	diff -s qc.cr output/qc.kt.cr

test-kt-unl: build/qc.kt.exe.jar qc.unl | output
	java -jar build/qc.kt.exe.jar unl > output/qc.kt.unl
	diff -s qc.unl output/qc.kt.unl

test-kt-hx: build/qc.kt.exe.jar qc.hx | output
	java -jar build/qc.kt.exe.jar hx > output/qc.kt.hx
	diff -s qc.hx output/qc.kt.hx

test-kt-bef: build/qc.kt.exe.jar qc.bef | output
	java -jar build/qc.kt.exe.jar bef > output/qc.kt.bef
	diff -s qc.bef output/qc.kt.bef

test-kt-awk: build/qc.kt.exe.jar qc.awk | output
	java -jar build/qc.kt.exe.jar awk > output/qc.kt.awk
	diff -s qc.awk output/qc.kt.awk

test-kt-piet: build/qc.kt.exe.jar qc.piet.gif | output
	java -jar build/qc.kt.exe.jar piet > output/qc.kt.piet
	diff -s qc.piet.gif output/qc.kt.piet

test-m-clj: build/qc.m.exe qc.clj | output
	build/qc.m.exe clj > output/qc.m.clj
	diff -s qc.clj output/qc.m.clj

test-m-lisp: build/qc.m.exe qc.lisp | output
	build/qc.m.exe lisp > output/qc.m.lisp
	diff -s qc.lisp output/qc.m.lisp

test-m-rkt: build/qc.m.exe qc.rkt | output
	build/qc.m.exe rkt > output/qc.m.rkt
	diff -s qc.rkt output/qc.m.rkt

test-m-rs: build/qc.m.exe qc.rs | output
	build/qc.m.exe rs > output/qc.m.rs
	diff -s qc.rs output/qc.m.rs

test-m-c: build/qc.m.exe qc.c | output
	build/qc.m.exe c > output/qc.m.c
	diff -s qc.c output/qc.m.c

test-m-cpp: build/qc.m.exe qc.cpp | output
	build/qc.m.exe cpp > output/qc.m.cpp
	diff -s qc.cpp output/qc.m.cpp

test-m-scala: build/qc.m.exe qc.scala | output
	build/qc.m.exe scala > output/qc.m.scala
	diff -s qc.scala output/qc.m.scala

test-m-f90: build/qc.m.exe qc.f90 | output
	build/qc.m.exe f90 > output/qc.m.f90
	diff -s qc.f90 output/qc.m.f90

test-m-scm: build/qc.m.exe qc.scm | output
	build/qc.m.exe scm > output/qc.m.scm
	diff -s qc.scm output/qc.m.scm

test-m-r: build/qc.m.exe qc.r | output
	build/qc.m.exe r > output/qc.m.r
	diff -s qc.r output/qc.m.r

test-m-lua: build/qc.m.exe qc.lua | output
	build/qc.m.exe lua > output/qc.m.lua
	diff -s qc.lua output/qc.m.lua

test-m-go: build/qc.m.exe qc.go | output
	build/qc.m.exe go > output/qc.m.go
	diff -s qc.go output/qc.m.go

test-m-ps: build/qc.m.exe qc.ps | output
	build/qc.m.exe ps > output/qc.m.ps
	diff -s qc.ps output/qc.m.ps

test-m-vala: build/qc.m.exe qc.vala | output
	build/qc.m.exe vala > output/qc.m.vala
	diff -s qc.vala output/qc.m.vala

test-m-pike: build/qc.m.exe qc.pike | output
	build/qc.m.exe pike > output/qc.m.pike
	diff -s qc.pike output/qc.m.pike

test-m-pas: build/qc.m.exe qc.pas | output
	build/qc.m.exe pas > output/qc.m.pas
	diff -s qc.pas output/qc.m.pas

test-m-kt: build/qc.m.exe qc.kt | output
	build/qc.m.exe kt > output/qc.m.kt
	diff -s qc.kt output/qc.m.kt

test-m-m: build/qc.m.exe qc.m | output
	build/qc.m.exe > output/qc.m.m
	diff -s qc.m output/qc.m.m

test-m-ml: build/qc.m.exe qc.ml | output
	build/qc.m.exe ml > output/qc.m.ml
	diff -s qc.ml output/qc.m.ml

test-m-hs: build/qc.m.exe qc.hs | output
	build/qc.m.exe hs > output/qc.m.hs
	diff -s qc.hs output/qc.m.hs

test-m-zig: build/qc.m.exe qc.zig | output
	build/qc.m.exe zig > output/qc.m.zig
	diff -s qc.zig output/qc.m.zig

test-m-sml: build/qc.m.exe qc.sml | output
	build/qc.m.exe sml > output/qc.m.sml
	diff -s qc.sml output/qc.m.sml

test-m-octave: build/qc.m.exe qc.octave | output
	build/qc.m.exe octave > output/qc.m.octave
	diff -s qc.octave output/qc.m.octave

test-m-groovy: build/qc.m.exe qc.groovy | output
	build/qc.m.exe groovy > output/qc.m.groovy
	diff -s qc.groovy output/qc.m.groovy

test-m-ws: build/qc.m.exe qc.ws | output
	build/qc.m.exe ws > output/qc.m.ws
	diff -s qc.ws output/qc.m.ws

test-m-coffee: build/qc.m.exe qc.coffee | output
	build/qc.m.exe coffee > output/qc.m.coffee
	diff -s qc.coffee output/qc.m.coffee

test-m-swift: build/qc.m.exe qc.swift | output
	build/qc.m.exe swift > output/qc.m.swift
	diff -s qc.swift output/qc.m.swift

test-m-py: build/qc.m.exe qc.py | output
	build/qc.m.exe py > output/qc.m.py
	diff -s qc.py output/qc.m.py

test-m-fs: build/qc.m.exe qc.fs | output
	build/qc.m.exe fs > output/qc.m.fs
	diff -s qc.fs output/qc.m.fs

test-m-nim: build/qc.m.exe qc.nim | output
	build/qc.m.exe nim > output/qc.m.nim
	diff -s qc.nim output/qc.m.nim

test-m-fsx: build/qc.m.exe qc.fsx | output
	build/qc.m.exe fsx > output/qc.m.fsx
	diff -s qc.fsx output/qc.m.fsx

test-m-tcl: build/qc.m.exe qc.tcl | output
	build/qc.m.exe tcl > output/qc.m.tcl
	diff -s qc.tcl output/qc.m.tcl

test-m-bf: build/qc.m.exe qc.bf | output
	build/qc.m.exe bf > output/qc.m.bf
	diff -s qc.bf output/qc.m.bf

test-m-java: build/qc.m.exe qc.java | output
	build/qc.m.exe java > output/qc.m.java
	diff -s qc.java output/qc.m.java

test-m-php: build/qc.m.exe qc.php | output
	build/qc.m.exe php > output/qc.m.php
	diff -s qc.php output/qc.m.php

test-m-bash: build/qc.m.exe qc.bash | output
	build/qc.m.exe bash > output/qc.m.bash
	diff -s qc.bash output/qc.m.bash

test-m-d: build/qc.m.exe qc.d | output
	build/qc.m.exe d > output/qc.m.d
	diff -s qc.d output/qc.m.d

test-m-pl: build/qc.m.exe qc.pl | output
	build/qc.m.exe pl > output/qc.m.pl
	diff -s qc.pl output/qc.m.pl

test-m-exs: build/qc.m.exe qc.exs | output
	build/qc.m.exe exs > output/qc.m.exs
	diff -s qc.exs output/qc.m.exs

test-m-rb: build/qc.m.exe qc.rb | output
	build/qc.m.exe rb > output/qc.m.rb
	diff -s qc.rb output/qc.m.rb

test-m-js: build/qc.m.exe qc.js | output
	build/qc.m.exe js > output/qc.m.js
	diff -s qc.js output/qc.m.js

test-m-ts: build/qc.m.exe qc.ts | output
	build/qc.m.exe ts > output/qc.m.ts
	diff -s qc.ts output/qc.m.ts

test-m-erl: build/qc.m.exe qc.erl | output
	build/qc.m.exe erl > output/qc.m.erl
	diff -s qc.erl output/qc.m.erl

test-m-cs: build/qc.m.exe qc.cs | output
	build/qc.m.exe cs > output/qc.m.cs
	diff -s qc.cs output/qc.m.cs

test-m-prolog: build/qc.m.exe qc.prolog | output
	build/qc.m.exe prolog > output/qc.m.prolog
	diff -s qc.prolog output/qc.m.prolog

test-m-cr: build/qc.m.exe qc.cr | output
	build/qc.m.exe cr > output/qc.m.cr
	diff -s qc.cr output/qc.m.cr

test-m-unl: build/qc.m.exe qc.unl | output
	build/qc.m.exe unl > output/qc.m.unl
	diff -s qc.unl output/qc.m.unl

test-m-hx: build/qc.m.exe qc.hx | output
	build/qc.m.exe hx > output/qc.m.hx
	diff -s qc.hx output/qc.m.hx

test-m-bef: build/qc.m.exe qc.bef | output
	build/qc.m.exe bef > output/qc.m.bef
	diff -s qc.bef output/qc.m.bef

test-m-awk: build/qc.m.exe qc.awk | output
	build/qc.m.exe awk > output/qc.m.awk
	diff -s qc.awk output/qc.m.awk

test-m-piet: build/qc.m.exe qc.piet.gif | output
	build/qc.m.exe piet > output/qc.m.piet
	diff -s qc.piet.gif output/qc.m.piet

test-ml-clj: qc.ml qc.clj | output
	ocaml qc.ml clj > output/qc.ml.clj
	diff -s qc.clj output/qc.ml.clj

test-ml-lisp: qc.ml qc.lisp | output
	ocaml qc.ml lisp > output/qc.ml.lisp
	diff -s qc.lisp output/qc.ml.lisp

test-ml-rkt: qc.ml qc.rkt | output
	ocaml qc.ml rkt > output/qc.ml.rkt
	diff -s qc.rkt output/qc.ml.rkt

test-ml-rs: qc.ml qc.rs | output
	ocaml qc.ml rs > output/qc.ml.rs
	diff -s qc.rs output/qc.ml.rs

test-ml-c: qc.ml qc.c | output
	ocaml qc.ml c > output/qc.ml.c
	diff -s qc.c output/qc.ml.c

test-ml-cpp: qc.ml qc.cpp | output
	ocaml qc.ml cpp > output/qc.ml.cpp
	diff -s qc.cpp output/qc.ml.cpp

test-ml-scala: qc.ml qc.scala | output
	ocaml qc.ml scala > output/qc.ml.scala
	diff -s qc.scala output/qc.ml.scala

test-ml-f90: qc.ml qc.f90 | output
	ocaml qc.ml f90 > output/qc.ml.f90
	diff -s qc.f90 output/qc.ml.f90

test-ml-scm: qc.ml qc.scm | output
	ocaml qc.ml scm > output/qc.ml.scm
	diff -s qc.scm output/qc.ml.scm

test-ml-r: qc.ml qc.r | output
	ocaml qc.ml r > output/qc.ml.r
	diff -s qc.r output/qc.ml.r

test-ml-lua: qc.ml qc.lua | output
	ocaml qc.ml lua > output/qc.ml.lua
	diff -s qc.lua output/qc.ml.lua

test-ml-go: qc.ml qc.go | output
	ocaml qc.ml go > output/qc.ml.go
	diff -s qc.go output/qc.ml.go

test-ml-ps: qc.ml qc.ps | output
	ocaml qc.ml ps > output/qc.ml.ps
	diff -s qc.ps output/qc.ml.ps

test-ml-vala: qc.ml qc.vala | output
	ocaml qc.ml vala > output/qc.ml.vala
	diff -s qc.vala output/qc.ml.vala

test-ml-pike: qc.ml qc.pike | output
	ocaml qc.ml pike > output/qc.ml.pike
	diff -s qc.pike output/qc.ml.pike

test-ml-pas: qc.ml qc.pas | output
	ocaml qc.ml pas > output/qc.ml.pas
	diff -s qc.pas output/qc.ml.pas

test-ml-kt: qc.ml qc.kt | output
	ocaml qc.ml kt > output/qc.ml.kt
	diff -s qc.kt output/qc.ml.kt

test-ml-m: qc.ml qc.m | output
	ocaml qc.ml m > output/qc.ml.m
	diff -s qc.m output/qc.ml.m

test-ml-ml: qc.ml qc.ml | output
	ocaml qc.ml > output/qc.ml.ml
	diff -s qc.ml output/qc.ml.ml

test-ml-hs: qc.ml qc.hs | output
	ocaml qc.ml hs > output/qc.ml.hs
	diff -s qc.hs output/qc.ml.hs

test-ml-zig: qc.ml qc.zig | output
	ocaml qc.ml zig > output/qc.ml.zig
	diff -s qc.zig output/qc.ml.zig

test-ml-sml: qc.ml qc.sml | output
	ocaml qc.ml sml > output/qc.ml.sml
	diff -s qc.sml output/qc.ml.sml

test-ml-octave: qc.ml qc.octave | output
	ocaml qc.ml octave > output/qc.ml.octave
	diff -s qc.octave output/qc.ml.octave

test-ml-groovy: qc.ml qc.groovy | output
	ocaml qc.ml groovy > output/qc.ml.groovy
	diff -s qc.groovy output/qc.ml.groovy

test-ml-ws: qc.ml qc.ws | output
	ocaml qc.ml ws > output/qc.ml.ws
	diff -s qc.ws output/qc.ml.ws

test-ml-coffee: qc.ml qc.coffee | output
	ocaml qc.ml coffee > output/qc.ml.coffee
	diff -s qc.coffee output/qc.ml.coffee

test-ml-swift: qc.ml qc.swift | output
	ocaml qc.ml swift > output/qc.ml.swift
	diff -s qc.swift output/qc.ml.swift

test-ml-py: qc.ml qc.py | output
	ocaml qc.ml py > output/qc.ml.py
	diff -s qc.py output/qc.ml.py

test-ml-fs: qc.ml qc.fs | output
	ocaml qc.ml fs > output/qc.ml.fs
	diff -s qc.fs output/qc.ml.fs

test-ml-nim: qc.ml qc.nim | output
	ocaml qc.ml nim > output/qc.ml.nim
	diff -s qc.nim output/qc.ml.nim

test-ml-fsx: qc.ml qc.fsx | output
	ocaml qc.ml fsx > output/qc.ml.fsx
	diff -s qc.fsx output/qc.ml.fsx

test-ml-tcl: qc.ml qc.tcl | output
	ocaml qc.ml tcl > output/qc.ml.tcl
	diff -s qc.tcl output/qc.ml.tcl

test-ml-bf: qc.ml qc.bf | output
	ocaml qc.ml bf > output/qc.ml.bf
	diff -s qc.bf output/qc.ml.bf

test-ml-java: qc.ml qc.java | output
	ocaml qc.ml java > output/qc.ml.java
	diff -s qc.java output/qc.ml.java

test-ml-php: qc.ml qc.php | output
	ocaml qc.ml php > output/qc.ml.php
	diff -s qc.php output/qc.ml.php

test-ml-bash: qc.ml qc.bash | output
	ocaml qc.ml bash > output/qc.ml.bash
	diff -s qc.bash output/qc.ml.bash

test-ml-d: qc.ml qc.d | output
	ocaml qc.ml d > output/qc.ml.d
	diff -s qc.d output/qc.ml.d

test-ml-pl: qc.ml qc.pl | output
	ocaml qc.ml pl > output/qc.ml.pl
	diff -s qc.pl output/qc.ml.pl

test-ml-exs: qc.ml qc.exs | output
	ocaml qc.ml exs > output/qc.ml.exs
	diff -s qc.exs output/qc.ml.exs

test-ml-rb: qc.ml qc.rb | output
	ocaml qc.ml rb > output/qc.ml.rb
	diff -s qc.rb output/qc.ml.rb

test-ml-js: qc.ml qc.js | output
	ocaml qc.ml js > output/qc.ml.js
	diff -s qc.js output/qc.ml.js

test-ml-ts: qc.ml qc.ts | output
	ocaml qc.ml ts > output/qc.ml.ts
	diff -s qc.ts output/qc.ml.ts

test-ml-erl: qc.ml qc.erl | output
	ocaml qc.ml erl > output/qc.ml.erl
	diff -s qc.erl output/qc.ml.erl

test-ml-cs: qc.ml qc.cs | output
	ocaml qc.ml cs > output/qc.ml.cs
	diff -s qc.cs output/qc.ml.cs

test-ml-prolog: qc.ml qc.prolog | output
	ocaml qc.ml prolog > output/qc.ml.prolog
	diff -s qc.prolog output/qc.ml.prolog

test-ml-cr: qc.ml qc.cr | output
	ocaml qc.ml cr > output/qc.ml.cr
	diff -s qc.cr output/qc.ml.cr

test-ml-unl: qc.ml qc.unl | output
	ocaml qc.ml unl > output/qc.ml.unl
	diff -s qc.unl output/qc.ml.unl

test-ml-hx: qc.ml qc.hx | output
	ocaml qc.ml hx > output/qc.ml.hx
	diff -s qc.hx output/qc.ml.hx

test-ml-bef: qc.ml qc.bef | output
	ocaml qc.ml bef > output/qc.ml.bef
	diff -s qc.bef output/qc.ml.bef

test-ml-awk: qc.ml qc.awk | output
	ocaml qc.ml awk > output/qc.ml.awk
	diff -s qc.awk output/qc.ml.awk

test-ml-piet: qc.ml qc.piet.gif | output
	ocaml qc.ml piet > output/qc.ml.piet
	diff -s qc.piet.gif output/qc.ml.piet

test-hs-clj: build/qc.hs.exe qc.clj | output
	build/qc.hs.exe clj > output/qc.hs.clj
	diff -s qc.clj output/qc.hs.clj

test-hs-lisp: build/qc.hs.exe qc.lisp | output
	build/qc.hs.exe lisp > output/qc.hs.lisp
	diff -s qc.lisp output/qc.hs.lisp

test-hs-rkt: build/qc.hs.exe qc.rkt | output
	build/qc.hs.exe rkt > output/qc.hs.rkt
	diff -s qc.rkt output/qc.hs.rkt

test-hs-rs: build/qc.hs.exe qc.rs | output
	build/qc.hs.exe rs > output/qc.hs.rs
	diff -s qc.rs output/qc.hs.rs

test-hs-c: build/qc.hs.exe qc.c | output
	build/qc.hs.exe c > output/qc.hs.c
	diff -s qc.c output/qc.hs.c

test-hs-cpp: build/qc.hs.exe qc.cpp | output
	build/qc.hs.exe cpp > output/qc.hs.cpp
	diff -s qc.cpp output/qc.hs.cpp

test-hs-scala: build/qc.hs.exe qc.scala | output
	build/qc.hs.exe scala > output/qc.hs.scala
	diff -s qc.scala output/qc.hs.scala

test-hs-f90: build/qc.hs.exe qc.f90 | output
	build/qc.hs.exe f90 > output/qc.hs.f90
	diff -s qc.f90 output/qc.hs.f90

test-hs-scm: build/qc.hs.exe qc.scm | output
	build/qc.hs.exe scm > output/qc.hs.scm
	diff -s qc.scm output/qc.hs.scm

test-hs-r: build/qc.hs.exe qc.r | output
	build/qc.hs.exe r > output/qc.hs.r
	diff -s qc.r output/qc.hs.r

test-hs-lua: build/qc.hs.exe qc.lua | output
	build/qc.hs.exe lua > output/qc.hs.lua
	diff -s qc.lua output/qc.hs.lua

test-hs-go: build/qc.hs.exe qc.go | output
	build/qc.hs.exe go > output/qc.hs.go
	diff -s qc.go output/qc.hs.go

test-hs-ps: build/qc.hs.exe qc.ps | output
	build/qc.hs.exe ps > output/qc.hs.ps
	diff -s qc.ps output/qc.hs.ps

test-hs-vala: build/qc.hs.exe qc.vala | output
	build/qc.hs.exe vala > output/qc.hs.vala
	diff -s qc.vala output/qc.hs.vala

test-hs-pike: build/qc.hs.exe qc.pike | output
	build/qc.hs.exe pike > output/qc.hs.pike
	diff -s qc.pike output/qc.hs.pike

test-hs-pas: build/qc.hs.exe qc.pas | output
	build/qc.hs.exe pas > output/qc.hs.pas
	diff -s qc.pas output/qc.hs.pas

test-hs-kt: build/qc.hs.exe qc.kt | output
	build/qc.hs.exe kt > output/qc.hs.kt
	diff -s qc.kt output/qc.hs.kt

test-hs-m: build/qc.hs.exe qc.m | output
	build/qc.hs.exe m > output/qc.hs.m
	diff -s qc.m output/qc.hs.m

test-hs-ml: build/qc.hs.exe qc.ml | output
	build/qc.hs.exe ml > output/qc.hs.ml
	diff -s qc.ml output/qc.hs.ml

test-hs-hs: build/qc.hs.exe qc.hs | output
	build/qc.hs.exe > output/qc.hs.hs
	diff -s qc.hs output/qc.hs.hs

test-hs-zig: build/qc.hs.exe qc.zig | output
	build/qc.hs.exe zig > output/qc.hs.zig
	diff -s qc.zig output/qc.hs.zig

test-hs-sml: build/qc.hs.exe qc.sml | output
	build/qc.hs.exe sml > output/qc.hs.sml
	diff -s qc.sml output/qc.hs.sml

test-hs-octave: build/qc.hs.exe qc.octave | output
	build/qc.hs.exe octave > output/qc.hs.octave
	diff -s qc.octave output/qc.hs.octave

test-hs-groovy: build/qc.hs.exe qc.groovy | output
	build/qc.hs.exe groovy > output/qc.hs.groovy
	diff -s qc.groovy output/qc.hs.groovy

test-hs-ws: build/qc.hs.exe qc.ws | output
	build/qc.hs.exe ws > output/qc.hs.ws
	diff -s qc.ws output/qc.hs.ws

test-hs-coffee: build/qc.hs.exe qc.coffee | output
	build/qc.hs.exe coffee > output/qc.hs.coffee
	diff -s qc.coffee output/qc.hs.coffee

test-hs-swift: build/qc.hs.exe qc.swift | output
	build/qc.hs.exe swift > output/qc.hs.swift
	diff -s qc.swift output/qc.hs.swift

test-hs-py: build/qc.hs.exe qc.py | output
	build/qc.hs.exe py > output/qc.hs.py
	diff -s qc.py output/qc.hs.py

test-hs-fs: build/qc.hs.exe qc.fs | output
	build/qc.hs.exe fs > output/qc.hs.fs
	diff -s qc.fs output/qc.hs.fs

test-hs-nim: build/qc.hs.exe qc.nim | output
	build/qc.hs.exe nim > output/qc.hs.nim
	diff -s qc.nim output/qc.hs.nim

test-hs-fsx: build/qc.hs.exe qc.fsx | output
	build/qc.hs.exe fsx > output/qc.hs.fsx
	diff -s qc.fsx output/qc.hs.fsx

test-hs-tcl: build/qc.hs.exe qc.tcl | output
	build/qc.hs.exe tcl > output/qc.hs.tcl
	diff -s qc.tcl output/qc.hs.tcl

test-hs-bf: build/qc.hs.exe qc.bf | output
	build/qc.hs.exe bf > output/qc.hs.bf
	diff -s qc.bf output/qc.hs.bf

test-hs-java: build/qc.hs.exe qc.java | output
	build/qc.hs.exe java > output/qc.hs.java
	diff -s qc.java output/qc.hs.java

test-hs-php: build/qc.hs.exe qc.php | output
	build/qc.hs.exe php > output/qc.hs.php
	diff -s qc.php output/qc.hs.php

test-hs-bash: build/qc.hs.exe qc.bash | output
	build/qc.hs.exe bash > output/qc.hs.bash
	diff -s qc.bash output/qc.hs.bash

test-hs-d: build/qc.hs.exe qc.d | output
	build/qc.hs.exe d > output/qc.hs.d
	diff -s qc.d output/qc.hs.d

test-hs-pl: build/qc.hs.exe qc.pl | output
	build/qc.hs.exe pl > output/qc.hs.pl
	diff -s qc.pl output/qc.hs.pl

test-hs-exs: build/qc.hs.exe qc.exs | output
	build/qc.hs.exe exs > output/qc.hs.exs
	diff -s qc.exs output/qc.hs.exs

test-hs-rb: build/qc.hs.exe qc.rb | output
	build/qc.hs.exe rb > output/qc.hs.rb
	diff -s qc.rb output/qc.hs.rb

test-hs-js: build/qc.hs.exe qc.js | output
	build/qc.hs.exe js > output/qc.hs.js
	diff -s qc.js output/qc.hs.js

test-hs-ts: build/qc.hs.exe qc.ts | output
	build/qc.hs.exe ts > output/qc.hs.ts
	diff -s qc.ts output/qc.hs.ts

test-hs-erl: build/qc.hs.exe qc.erl | output
	build/qc.hs.exe erl > output/qc.hs.erl
	diff -s qc.erl output/qc.hs.erl

test-hs-cs: build/qc.hs.exe qc.cs | output
	build/qc.hs.exe cs > output/qc.hs.cs
	diff -s qc.cs output/qc.hs.cs

test-hs-prolog: build/qc.hs.exe qc.prolog | output
	build/qc.hs.exe prolog > output/qc.hs.prolog
	diff -s qc.prolog output/qc.hs.prolog

test-hs-cr: build/qc.hs.exe qc.cr | output
	build/qc.hs.exe cr > output/qc.hs.cr
	diff -s qc.cr output/qc.hs.cr

test-hs-unl: build/qc.hs.exe qc.unl | output
	build/qc.hs.exe unl > output/qc.hs.unl
	diff -s qc.unl output/qc.hs.unl

test-hs-hx: build/qc.hs.exe qc.hx | output
	build/qc.hs.exe hx > output/qc.hs.hx
	diff -s qc.hx output/qc.hs.hx

test-hs-bef: build/qc.hs.exe qc.bef | output
	build/qc.hs.exe bef > output/qc.hs.bef
	diff -s qc.bef output/qc.hs.bef

test-hs-awk: build/qc.hs.exe qc.awk | output
	build/qc.hs.exe awk > output/qc.hs.awk
	diff -s qc.awk output/qc.hs.awk

test-hs-piet: build/qc.hs.exe qc.piet.gif | output
	build/qc.hs.exe piet > output/qc.hs.piet
	diff -s qc.piet.gif output/qc.hs.piet

test-zig-clj: build/qc.zig.exe qc.clj | output
	build/qc.zig.exe clj > output/qc.zig.clj
	diff -s qc.clj output/qc.zig.clj

test-zig-lisp: build/qc.zig.exe qc.lisp | output
	build/qc.zig.exe lisp > output/qc.zig.lisp
	diff -s qc.lisp output/qc.zig.lisp

test-zig-rkt: build/qc.zig.exe qc.rkt | output
	build/qc.zig.exe rkt > output/qc.zig.rkt
	diff -s qc.rkt output/qc.zig.rkt

test-zig-rs: build/qc.zig.exe qc.rs | output
	build/qc.zig.exe rs > output/qc.zig.rs
	diff -s qc.rs output/qc.zig.rs

test-zig-c: build/qc.zig.exe qc.c | output
	build/qc.zig.exe c > output/qc.zig.c
	diff -s qc.c output/qc.zig.c

test-zig-cpp: build/qc.zig.exe qc.cpp | output
	build/qc.zig.exe cpp > output/qc.zig.cpp
	diff -s qc.cpp output/qc.zig.cpp

test-zig-scala: build/qc.zig.exe qc.scala | output
	build/qc.zig.exe scala > output/qc.zig.scala
	diff -s qc.scala output/qc.zig.scala

test-zig-f90: build/qc.zig.exe qc.f90 | output
	build/qc.zig.exe f90 > output/qc.zig.f90
	diff -s qc.f90 output/qc.zig.f90

test-zig-scm: build/qc.zig.exe qc.scm | output
	build/qc.zig.exe scm > output/qc.zig.scm
	diff -s qc.scm output/qc.zig.scm

test-zig-r: build/qc.zig.exe qc.r | output
	build/qc.zig.exe r > output/qc.zig.r
	diff -s qc.r output/qc.zig.r

test-zig-lua: build/qc.zig.exe qc.lua | output
	build/qc.zig.exe lua > output/qc.zig.lua
	diff -s qc.lua output/qc.zig.lua

test-zig-go: build/qc.zig.exe qc.go | output
	build/qc.zig.exe go > output/qc.zig.go
	diff -s qc.go output/qc.zig.go

test-zig-ps: build/qc.zig.exe qc.ps | output
	build/qc.zig.exe ps > output/qc.zig.ps
	diff -s qc.ps output/qc.zig.ps

test-zig-vala: build/qc.zig.exe qc.vala | output
	build/qc.zig.exe vala > output/qc.zig.vala
	diff -s qc.vala output/qc.zig.vala

test-zig-pike: build/qc.zig.exe qc.pike | output
	build/qc.zig.exe pike > output/qc.zig.pike
	diff -s qc.pike output/qc.zig.pike

test-zig-pas: build/qc.zig.exe qc.pas | output
	build/qc.zig.exe pas > output/qc.zig.pas
	diff -s qc.pas output/qc.zig.pas

test-zig-kt: build/qc.zig.exe qc.kt | output
	build/qc.zig.exe kt > output/qc.zig.kt
	diff -s qc.kt output/qc.zig.kt

test-zig-m: build/qc.zig.exe qc.m | output
	build/qc.zig.exe m > output/qc.zig.m
	diff -s qc.m output/qc.zig.m

test-zig-ml: build/qc.zig.exe qc.ml | output
	build/qc.zig.exe ml > output/qc.zig.ml
	diff -s qc.ml output/qc.zig.ml

test-zig-hs: build/qc.zig.exe qc.hs | output
	build/qc.zig.exe hs > output/qc.zig.hs
	diff -s qc.hs output/qc.zig.hs

test-zig-zig: build/qc.zig.exe qc.zig | output
	build/qc.zig.exe > output/qc.zig.zig
	diff -s qc.zig output/qc.zig.zig

test-zig-sml: build/qc.zig.exe qc.sml | output
	build/qc.zig.exe sml > output/qc.zig.sml
	diff -s qc.sml output/qc.zig.sml

test-zig-octave: build/qc.zig.exe qc.octave | output
	build/qc.zig.exe octave > output/qc.zig.octave
	diff -s qc.octave output/qc.zig.octave

test-zig-groovy: build/qc.zig.exe qc.groovy | output
	build/qc.zig.exe groovy > output/qc.zig.groovy
	diff -s qc.groovy output/qc.zig.groovy

test-zig-ws: build/qc.zig.exe qc.ws | output
	build/qc.zig.exe ws > output/qc.zig.ws
	diff -s qc.ws output/qc.zig.ws

test-zig-coffee: build/qc.zig.exe qc.coffee | output
	build/qc.zig.exe coffee > output/qc.zig.coffee
	diff -s qc.coffee output/qc.zig.coffee

test-zig-swift: build/qc.zig.exe qc.swift | output
	build/qc.zig.exe swift > output/qc.zig.swift
	diff -s qc.swift output/qc.zig.swift

test-zig-py: build/qc.zig.exe qc.py | output
	build/qc.zig.exe py > output/qc.zig.py
	diff -s qc.py output/qc.zig.py

test-zig-fs: build/qc.zig.exe qc.fs | output
	build/qc.zig.exe fs > output/qc.zig.fs
	diff -s qc.fs output/qc.zig.fs

test-zig-nim: build/qc.zig.exe qc.nim | output
	build/qc.zig.exe nim > output/qc.zig.nim
	diff -s qc.nim output/qc.zig.nim

test-zig-fsx: build/qc.zig.exe qc.fsx | output
	build/qc.zig.exe fsx > output/qc.zig.fsx
	diff -s qc.fsx output/qc.zig.fsx

test-zig-tcl: build/qc.zig.exe qc.tcl | output
	build/qc.zig.exe tcl > output/qc.zig.tcl
	diff -s qc.tcl output/qc.zig.tcl

test-zig-bf: build/qc.zig.exe qc.bf | output
	build/qc.zig.exe bf > output/qc.zig.bf
	diff -s qc.bf output/qc.zig.bf

test-zig-java: build/qc.zig.exe qc.java | output
	build/qc.zig.exe java > output/qc.zig.java
	diff -s qc.java output/qc.zig.java

test-zig-php: build/qc.zig.exe qc.php | output
	build/qc.zig.exe php > output/qc.zig.php
	diff -s qc.php output/qc.zig.php

test-zig-bash: build/qc.zig.exe qc.bash | output
	build/qc.zig.exe bash > output/qc.zig.bash
	diff -s qc.bash output/qc.zig.bash

test-zig-d: build/qc.zig.exe qc.d | output
	build/qc.zig.exe d > output/qc.zig.d
	diff -s qc.d output/qc.zig.d

test-zig-pl: build/qc.zig.exe qc.pl | output
	build/qc.zig.exe pl > output/qc.zig.pl
	diff -s qc.pl output/qc.zig.pl

test-zig-exs: build/qc.zig.exe qc.exs | output
	build/qc.zig.exe exs > output/qc.zig.exs
	diff -s qc.exs output/qc.zig.exs

test-zig-rb: build/qc.zig.exe qc.rb | output
	build/qc.zig.exe rb > output/qc.zig.rb
	diff -s qc.rb output/qc.zig.rb

test-zig-js: build/qc.zig.exe qc.js | output
	build/qc.zig.exe js > output/qc.zig.js
	diff -s qc.js output/qc.zig.js

test-zig-ts: build/qc.zig.exe qc.ts | output
	build/qc.zig.exe ts > output/qc.zig.ts
	diff -s qc.ts output/qc.zig.ts

test-zig-erl: build/qc.zig.exe qc.erl | output
	build/qc.zig.exe erl > output/qc.zig.erl
	diff -s qc.erl output/qc.zig.erl

test-zig-cs: build/qc.zig.exe qc.cs | output
	build/qc.zig.exe cs > output/qc.zig.cs
	diff -s qc.cs output/qc.zig.cs

test-zig-prolog: build/qc.zig.exe qc.prolog | output
	build/qc.zig.exe prolog > output/qc.zig.prolog
	diff -s qc.prolog output/qc.zig.prolog

test-zig-cr: build/qc.zig.exe qc.cr | output
	build/qc.zig.exe cr > output/qc.zig.cr
	diff -s qc.cr output/qc.zig.cr

test-zig-unl: build/qc.zig.exe qc.unl | output
	build/qc.zig.exe unl > output/qc.zig.unl
	diff -s qc.unl output/qc.zig.unl

test-zig-hx: build/qc.zig.exe qc.hx | output
	build/qc.zig.exe hx > output/qc.zig.hx
	diff -s qc.hx output/qc.zig.hx

test-zig-bef: build/qc.zig.exe qc.bef | output
	build/qc.zig.exe bef > output/qc.zig.bef
	diff -s qc.bef output/qc.zig.bef

test-zig-awk: build/qc.zig.exe qc.awk | output
	build/qc.zig.exe awk > output/qc.zig.awk
	diff -s qc.awk output/qc.zig.awk

test-zig-piet: build/qc.zig.exe qc.piet.gif | output
	build/qc.zig.exe piet > output/qc.zig.piet
	diff -s qc.piet.gif output/qc.zig.piet

test-sml-clj: build/qc.sml.exe qc.clj | output
	build/qc.sml.exe clj > output/qc.sml.clj
	diff -s qc.clj output/qc.sml.clj

test-sml-lisp: build/qc.sml.exe qc.lisp | output
	build/qc.sml.exe lisp > output/qc.sml.lisp
	diff -s qc.lisp output/qc.sml.lisp

test-sml-rkt: build/qc.sml.exe qc.rkt | output
	build/qc.sml.exe rkt > output/qc.sml.rkt
	diff -s qc.rkt output/qc.sml.rkt

test-sml-rs: build/qc.sml.exe qc.rs | output
	build/qc.sml.exe rs > output/qc.sml.rs
	diff -s qc.rs output/qc.sml.rs

test-sml-c: build/qc.sml.exe qc.c | output
	build/qc.sml.exe c > output/qc.sml.c
	diff -s qc.c output/qc.sml.c

test-sml-cpp: build/qc.sml.exe qc.cpp | output
	build/qc.sml.exe cpp > output/qc.sml.cpp
	diff -s qc.cpp output/qc.sml.cpp

test-sml-scala: build/qc.sml.exe qc.scala | output
	build/qc.sml.exe scala > output/qc.sml.scala
	diff -s qc.scala output/qc.sml.scala

test-sml-f90: build/qc.sml.exe qc.f90 | output
	build/qc.sml.exe f90 > output/qc.sml.f90
	diff -s qc.f90 output/qc.sml.f90

test-sml-scm: build/qc.sml.exe qc.scm | output
	build/qc.sml.exe scm > output/qc.sml.scm
	diff -s qc.scm output/qc.sml.scm

test-sml-r: build/qc.sml.exe qc.r | output
	build/qc.sml.exe r > output/qc.sml.r
	diff -s qc.r output/qc.sml.r

test-sml-lua: build/qc.sml.exe qc.lua | output
	build/qc.sml.exe lua > output/qc.sml.lua
	diff -s qc.lua output/qc.sml.lua

test-sml-go: build/qc.sml.exe qc.go | output
	build/qc.sml.exe go > output/qc.sml.go
	diff -s qc.go output/qc.sml.go

test-sml-ps: build/qc.sml.exe qc.ps | output
	build/qc.sml.exe ps > output/qc.sml.ps
	diff -s qc.ps output/qc.sml.ps

test-sml-vala: build/qc.sml.exe qc.vala | output
	build/qc.sml.exe vala > output/qc.sml.vala
	diff -s qc.vala output/qc.sml.vala

test-sml-pike: build/qc.sml.exe qc.pike | output
	build/qc.sml.exe pike > output/qc.sml.pike
	diff -s qc.pike output/qc.sml.pike

test-sml-pas: build/qc.sml.exe qc.pas | output
	build/qc.sml.exe pas > output/qc.sml.pas
	diff -s qc.pas output/qc.sml.pas

test-sml-kt: build/qc.sml.exe qc.kt | output
	build/qc.sml.exe kt > output/qc.sml.kt
	diff -s qc.kt output/qc.sml.kt

test-sml-m: build/qc.sml.exe qc.m | output
	build/qc.sml.exe m > output/qc.sml.m
	diff -s qc.m output/qc.sml.m

test-sml-ml: build/qc.sml.exe qc.ml | output
	build/qc.sml.exe ml > output/qc.sml.ml
	diff -s qc.ml output/qc.sml.ml

test-sml-hs: build/qc.sml.exe qc.hs | output
	build/qc.sml.exe hs > output/qc.sml.hs
	diff -s qc.hs output/qc.sml.hs

test-sml-zig: build/qc.sml.exe qc.zig | output
	build/qc.sml.exe zig > output/qc.sml.zig
	diff -s qc.zig output/qc.sml.zig

test-sml-sml: build/qc.sml.exe qc.sml | output
	build/qc.sml.exe > output/qc.sml.sml
	diff -s qc.sml output/qc.sml.sml

test-sml-octave: build/qc.sml.exe qc.octave | output
	build/qc.sml.exe octave > output/qc.sml.octave
	diff -s qc.octave output/qc.sml.octave

test-sml-groovy: build/qc.sml.exe qc.groovy | output
	build/qc.sml.exe groovy > output/qc.sml.groovy
	diff -s qc.groovy output/qc.sml.groovy

test-sml-ws: build/qc.sml.exe qc.ws | output
	build/qc.sml.exe ws > output/qc.sml.ws
	diff -s qc.ws output/qc.sml.ws

test-sml-coffee: build/qc.sml.exe qc.coffee | output
	build/qc.sml.exe coffee > output/qc.sml.coffee
	diff -s qc.coffee output/qc.sml.coffee

test-sml-swift: build/qc.sml.exe qc.swift | output
	build/qc.sml.exe swift > output/qc.sml.swift
	diff -s qc.swift output/qc.sml.swift

test-sml-py: build/qc.sml.exe qc.py | output
	build/qc.sml.exe py > output/qc.sml.py
	diff -s qc.py output/qc.sml.py

test-sml-fs: build/qc.sml.exe qc.fs | output
	build/qc.sml.exe fs > output/qc.sml.fs
	diff -s qc.fs output/qc.sml.fs

test-sml-nim: build/qc.sml.exe qc.nim | output
	build/qc.sml.exe nim > output/qc.sml.nim
	diff -s qc.nim output/qc.sml.nim

test-sml-fsx: build/qc.sml.exe qc.fsx | output
	build/qc.sml.exe fsx > output/qc.sml.fsx
	diff -s qc.fsx output/qc.sml.fsx

test-sml-tcl: build/qc.sml.exe qc.tcl | output
	build/qc.sml.exe tcl > output/qc.sml.tcl
	diff -s qc.tcl output/qc.sml.tcl

test-sml-bf: build/qc.sml.exe qc.bf | output
	build/qc.sml.exe bf > output/qc.sml.bf
	diff -s qc.bf output/qc.sml.bf

test-sml-java: build/qc.sml.exe qc.java | output
	build/qc.sml.exe java > output/qc.sml.java
	diff -s qc.java output/qc.sml.java

test-sml-php: build/qc.sml.exe qc.php | output
	build/qc.sml.exe php > output/qc.sml.php
	diff -s qc.php output/qc.sml.php

test-sml-bash: build/qc.sml.exe qc.bash | output
	build/qc.sml.exe bash > output/qc.sml.bash
	diff -s qc.bash output/qc.sml.bash

test-sml-d: build/qc.sml.exe qc.d | output
	build/qc.sml.exe d > output/qc.sml.d
	diff -s qc.d output/qc.sml.d

test-sml-pl: build/qc.sml.exe qc.pl | output
	build/qc.sml.exe pl > output/qc.sml.pl
	diff -s qc.pl output/qc.sml.pl

test-sml-exs: build/qc.sml.exe qc.exs | output
	build/qc.sml.exe exs > output/qc.sml.exs
	diff -s qc.exs output/qc.sml.exs

test-sml-rb: build/qc.sml.exe qc.rb | output
	build/qc.sml.exe rb > output/qc.sml.rb
	diff -s qc.rb output/qc.sml.rb

test-sml-js: build/qc.sml.exe qc.js | output
	build/qc.sml.exe js > output/qc.sml.js
	diff -s qc.js output/qc.sml.js

test-sml-ts: build/qc.sml.exe qc.ts | output
	build/qc.sml.exe ts > output/qc.sml.ts
	diff -s qc.ts output/qc.sml.ts

test-sml-erl: build/qc.sml.exe qc.erl | output
	build/qc.sml.exe erl > output/qc.sml.erl
	diff -s qc.erl output/qc.sml.erl

test-sml-cs: build/qc.sml.exe qc.cs | output
	build/qc.sml.exe cs > output/qc.sml.cs
	diff -s qc.cs output/qc.sml.cs

test-sml-prolog: build/qc.sml.exe qc.prolog | output
	build/qc.sml.exe prolog > output/qc.sml.prolog
	diff -s qc.prolog output/qc.sml.prolog

test-sml-cr: build/qc.sml.exe qc.cr | output
	build/qc.sml.exe cr > output/qc.sml.cr
	diff -s qc.cr output/qc.sml.cr

test-sml-unl: build/qc.sml.exe qc.unl | output
	build/qc.sml.exe unl > output/qc.sml.unl
	diff -s qc.unl output/qc.sml.unl

test-sml-hx: build/qc.sml.exe qc.hx | output
	build/qc.sml.exe hx > output/qc.sml.hx
	diff -s qc.hx output/qc.sml.hx

test-sml-bef: build/qc.sml.exe qc.bef | output
	build/qc.sml.exe bef > output/qc.sml.bef
	diff -s qc.bef output/qc.sml.bef

test-sml-awk: build/qc.sml.exe qc.awk | output
	build/qc.sml.exe awk > output/qc.sml.awk
	diff -s qc.awk output/qc.sml.awk

test-sml-piet: build/qc.sml.exe qc.piet.gif | output
	build/qc.sml.exe piet > output/qc.sml.piet
	diff -s qc.piet.gif output/qc.sml.piet

test-octave-clj: qc.octave qc.clj | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave clj' > output/qc.octave.clj
	diff -s qc.clj output/qc.octave.clj

test-octave-lisp: qc.octave qc.lisp | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave lisp' > output/qc.octave.lisp
	diff -s qc.lisp output/qc.octave.lisp

test-octave-rkt: qc.octave qc.rkt | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave rkt' > output/qc.octave.rkt
	diff -s qc.rkt output/qc.octave.rkt

test-octave-rs: qc.octave qc.rs | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave rs' > output/qc.octave.rs
	diff -s qc.rs output/qc.octave.rs

test-octave-c: qc.octave qc.c | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave c' > output/qc.octave.c
	diff -s qc.c output/qc.octave.c

test-octave-cpp: qc.octave qc.cpp | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave cpp' > output/qc.octave.cpp
	diff -s qc.cpp output/qc.octave.cpp

test-octave-scala: qc.octave qc.scala | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave scala' > output/qc.octave.scala
	diff -s qc.scala output/qc.octave.scala

test-octave-f90: qc.octave qc.f90 | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave f90' > output/qc.octave.f90
	diff -s qc.f90 output/qc.octave.f90

test-octave-scm: qc.octave qc.scm | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave scm' > output/qc.octave.scm
	diff -s qc.scm output/qc.octave.scm

test-octave-r: qc.octave qc.r | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave r' > output/qc.octave.r
	diff -s qc.r output/qc.octave.r

test-octave-lua: qc.octave qc.lua | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave lua' > output/qc.octave.lua
	diff -s qc.lua output/qc.octave.lua

test-octave-go: qc.octave qc.go | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave go' > output/qc.octave.go
	diff -s qc.go output/qc.octave.go

test-octave-ps: qc.octave qc.ps | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave ps' > output/qc.octave.ps
	diff -s qc.ps output/qc.octave.ps

test-octave-vala: qc.octave qc.vala | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave vala' > output/qc.octave.vala
	diff -s qc.vala output/qc.octave.vala

test-octave-pike: qc.octave qc.pike | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave pike' > output/qc.octave.pike
	diff -s qc.pike output/qc.octave.pike

test-octave-pas: qc.octave qc.pas | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave pas' > output/qc.octave.pas
	diff -s qc.pas output/qc.octave.pas

test-octave-kt: qc.octave qc.kt | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave kt' > output/qc.octave.kt
	diff -s qc.kt output/qc.octave.kt

test-octave-m: qc.octave qc.m | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave m' > output/qc.octave.m
	diff -s qc.m output/qc.octave.m

test-octave-ml: qc.octave qc.ml | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave ml' > output/qc.octave.ml
	diff -s qc.ml output/qc.octave.ml

test-octave-hs: qc.octave qc.hs | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave hs' > output/qc.octave.hs
	diff -s qc.hs output/qc.octave.hs

test-octave-zig: qc.octave qc.zig | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave zig' > output/qc.octave.zig
	diff -s qc.zig output/qc.octave.zig

test-octave-sml: qc.octave qc.sml | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave sml' > output/qc.octave.sml
	diff -s qc.sml output/qc.octave.sml

test-octave-octave: qc.octave qc.octave | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave ' > output/qc.octave.octave
	diff -s qc.octave output/qc.octave.octave

test-octave-groovy: qc.octave qc.groovy | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave groovy' > output/qc.octave.groovy
	diff -s qc.groovy output/qc.octave.groovy

test-octave-ws: qc.octave qc.ws | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave ws' > output/qc.octave.ws
	diff -s qc.ws output/qc.octave.ws

test-octave-coffee: qc.octave qc.coffee | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave coffee' > output/qc.octave.coffee
	diff -s qc.coffee output/qc.octave.coffee

test-octave-swift: qc.octave qc.swift | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave swift' > output/qc.octave.swift
	diff -s qc.swift output/qc.octave.swift

test-octave-py: qc.octave qc.py | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave py' > output/qc.octave.py
	diff -s qc.py output/qc.octave.py

test-octave-fs: qc.octave qc.fs | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave fs' > output/qc.octave.fs
	diff -s qc.fs output/qc.octave.fs

test-octave-nim: qc.octave qc.nim | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave nim' > output/qc.octave.nim
	diff -s qc.nim output/qc.octave.nim

test-octave-fsx: qc.octave qc.fsx | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave fsx' > output/qc.octave.fsx
	diff -s qc.fsx output/qc.octave.fsx

test-octave-tcl: qc.octave qc.tcl | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave tcl' > output/qc.octave.tcl
	diff -s qc.tcl output/qc.octave.tcl

test-octave-bf: qc.octave qc.bf | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave bf' > output/qc.octave.bf
	diff -s qc.bf output/qc.octave.bf

test-octave-java: qc.octave qc.java | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave java' > output/qc.octave.java
	diff -s qc.java output/qc.octave.java

test-octave-php: qc.octave qc.php | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave php' > output/qc.octave.php
	diff -s qc.php output/qc.octave.php

test-octave-bash: qc.octave qc.bash | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave bash' > output/qc.octave.bash
	diff -s qc.bash output/qc.octave.bash

test-octave-d: qc.octave qc.d | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave d' > output/qc.octave.d
	diff -s qc.d output/qc.octave.d

test-octave-pl: qc.octave qc.pl | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave pl' > output/qc.octave.pl
	diff -s qc.pl output/qc.octave.pl

test-octave-exs: qc.octave qc.exs | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave exs' > output/qc.octave.exs
	diff -s qc.exs output/qc.octave.exs

test-octave-rb: qc.octave qc.rb | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave rb' > output/qc.octave.rb
	diff -s qc.rb output/qc.octave.rb

test-octave-js: qc.octave qc.js | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave js' > output/qc.octave.js
	diff -s qc.js output/qc.octave.js

test-octave-ts: qc.octave qc.ts | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave ts' > output/qc.octave.ts
	diff -s qc.ts output/qc.octave.ts

test-octave-erl: qc.octave qc.erl | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave erl' > output/qc.octave.erl
	diff -s qc.erl output/qc.octave.erl

test-octave-cs: qc.octave qc.cs | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave cs' > output/qc.octave.cs
	diff -s qc.cs output/qc.octave.cs

test-octave-prolog: qc.octave qc.prolog | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave prolog' > output/qc.octave.prolog
	diff -s qc.prolog output/qc.octave.prolog

test-octave-cr: qc.octave qc.cr | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave cr' > output/qc.octave.cr
	diff -s qc.cr output/qc.octave.cr

test-octave-unl: qc.octave qc.unl | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave unl' > output/qc.octave.unl
	diff -s qc.unl output/qc.octave.unl

test-octave-hx: qc.octave qc.hx | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave hx' > output/qc.octave.hx
	diff -s qc.hx output/qc.octave.hx

test-octave-bef: qc.octave qc.bef | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave bef' > output/qc.octave.bef
	diff -s qc.bef output/qc.octave.bef

test-octave-awk: qc.octave qc.awk | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave awk' > output/qc.octave.awk
	diff -s qc.awk output/qc.octave.awk

test-octave-piet: qc.octave qc.piet.gif | output
	sh -c 'mkdir -p build;cd build;exec octave -qf ../qc.octave piet' > output/qc.octave.piet
	diff -s qc.piet.gif output/qc.octave.piet

test-groovy-clj: qc.groovy qc.clj | output
	groovy qc.groovy clj > output/qc.groovy.clj
	diff -s qc.clj output/qc.groovy.clj

test-groovy-lisp: qc.groovy qc.lisp | output
	groovy qc.groovy lisp > output/qc.groovy.lisp
	diff -s qc.lisp output/qc.groovy.lisp

test-groovy-rkt: qc.groovy qc.rkt | output
	groovy qc.groovy rkt > output/qc.groovy.rkt
	diff -s qc.rkt output/qc.groovy.rkt

test-groovy-rs: qc.groovy qc.rs | output
	groovy qc.groovy rs > output/qc.groovy.rs
	diff -s qc.rs output/qc.groovy.rs

test-groovy-c: qc.groovy qc.c | output
	groovy qc.groovy c > output/qc.groovy.c
	diff -s qc.c output/qc.groovy.c

test-groovy-cpp: qc.groovy qc.cpp | output
	groovy qc.groovy cpp > output/qc.groovy.cpp
	diff -s qc.cpp output/qc.groovy.cpp

test-groovy-scala: qc.groovy qc.scala | output
	groovy qc.groovy scala > output/qc.groovy.scala
	diff -s qc.scala output/qc.groovy.scala

test-groovy-f90: qc.groovy qc.f90 | output
	groovy qc.groovy f90 > output/qc.groovy.f90
	diff -s qc.f90 output/qc.groovy.f90

test-groovy-scm: qc.groovy qc.scm | output
	groovy qc.groovy scm > output/qc.groovy.scm
	diff -s qc.scm output/qc.groovy.scm

test-groovy-r: qc.groovy qc.r | output
	groovy qc.groovy r > output/qc.groovy.r
	diff -s qc.r output/qc.groovy.r

test-groovy-lua: qc.groovy qc.lua | output
	groovy qc.groovy lua > output/qc.groovy.lua
	diff -s qc.lua output/qc.groovy.lua

test-groovy-go: qc.groovy qc.go | output
	groovy qc.groovy go > output/qc.groovy.go
	diff -s qc.go output/qc.groovy.go

test-groovy-ps: qc.groovy qc.ps | output
	groovy qc.groovy ps > output/qc.groovy.ps
	diff -s qc.ps output/qc.groovy.ps

test-groovy-vala: qc.groovy qc.vala | output
	groovy qc.groovy vala > output/qc.groovy.vala
	diff -s qc.vala output/qc.groovy.vala

test-groovy-pike: qc.groovy qc.pike | output
	groovy qc.groovy pike > output/qc.groovy.pike
	diff -s qc.pike output/qc.groovy.pike

test-groovy-pas: qc.groovy qc.pas | output
	groovy qc.groovy pas > output/qc.groovy.pas
	diff -s qc.pas output/qc.groovy.pas

test-groovy-kt: qc.groovy qc.kt | output
	groovy qc.groovy kt > output/qc.groovy.kt
	diff -s qc.kt output/qc.groovy.kt

test-groovy-m: qc.groovy qc.m | output
	groovy qc.groovy m > output/qc.groovy.m
	diff -s qc.m output/qc.groovy.m

test-groovy-ml: qc.groovy qc.ml | output
	groovy qc.groovy ml > output/qc.groovy.ml
	diff -s qc.ml output/qc.groovy.ml

test-groovy-hs: qc.groovy qc.hs | output
	groovy qc.groovy hs > output/qc.groovy.hs
	diff -s qc.hs output/qc.groovy.hs

test-groovy-zig: qc.groovy qc.zig | output
	groovy qc.groovy zig > output/qc.groovy.zig
	diff -s qc.zig output/qc.groovy.zig

test-groovy-sml: qc.groovy qc.sml | output
	groovy qc.groovy sml > output/qc.groovy.sml
	diff -s qc.sml output/qc.groovy.sml

test-groovy-octave: qc.groovy qc.octave | output
	groovy qc.groovy octave > output/qc.groovy.octave
	diff -s qc.octave output/qc.groovy.octave

test-groovy-groovy: qc.groovy qc.groovy | output
	groovy qc.groovy > output/qc.groovy.groovy
	diff -s qc.groovy output/qc.groovy.groovy

test-groovy-ws: qc.groovy qc.ws | output
	groovy qc.groovy ws > output/qc.groovy.ws
	diff -s qc.ws output/qc.groovy.ws

test-groovy-coffee: qc.groovy qc.coffee | output
	groovy qc.groovy coffee > output/qc.groovy.coffee
	diff -s qc.coffee output/qc.groovy.coffee

test-groovy-swift: qc.groovy qc.swift | output
	groovy qc.groovy swift > output/qc.groovy.swift
	diff -s qc.swift output/qc.groovy.swift

test-groovy-py: qc.groovy qc.py | output
	groovy qc.groovy py > output/qc.groovy.py
	diff -s qc.py output/qc.groovy.py

test-groovy-fs: qc.groovy qc.fs | output
	groovy qc.groovy fs > output/qc.groovy.fs
	diff -s qc.fs output/qc.groovy.fs

test-groovy-nim: qc.groovy qc.nim | output
	groovy qc.groovy nim > output/qc.groovy.nim
	diff -s qc.nim output/qc.groovy.nim

test-groovy-fsx: qc.groovy qc.fsx | output
	groovy qc.groovy fsx > output/qc.groovy.fsx
	diff -s qc.fsx output/qc.groovy.fsx

test-groovy-tcl: qc.groovy qc.tcl | output
	groovy qc.groovy tcl > output/qc.groovy.tcl
	diff -s qc.tcl output/qc.groovy.tcl

test-groovy-bf: qc.groovy qc.bf | output
	groovy qc.groovy bf > output/qc.groovy.bf
	diff -s qc.bf output/qc.groovy.bf

test-groovy-java: qc.groovy qc.java | output
	groovy qc.groovy java > output/qc.groovy.java
	diff -s qc.java output/qc.groovy.java

test-groovy-php: qc.groovy qc.php | output
	groovy qc.groovy php > output/qc.groovy.php
	diff -s qc.php output/qc.groovy.php

test-groovy-bash: qc.groovy qc.bash | output
	groovy qc.groovy bash > output/qc.groovy.bash
	diff -s qc.bash output/qc.groovy.bash

test-groovy-d: qc.groovy qc.d | output
	groovy qc.groovy d > output/qc.groovy.d
	diff -s qc.d output/qc.groovy.d

test-groovy-pl: qc.groovy qc.pl | output
	groovy qc.groovy pl > output/qc.groovy.pl
	diff -s qc.pl output/qc.groovy.pl

test-groovy-exs: qc.groovy qc.exs | output
	groovy qc.groovy exs > output/qc.groovy.exs
	diff -s qc.exs output/qc.groovy.exs

test-groovy-rb: qc.groovy qc.rb | output
	groovy qc.groovy rb > output/qc.groovy.rb
	diff -s qc.rb output/qc.groovy.rb

test-groovy-js: qc.groovy qc.js | output
	groovy qc.groovy js > output/qc.groovy.js
	diff -s qc.js output/qc.groovy.js

test-groovy-ts: qc.groovy qc.ts | output
	groovy qc.groovy ts > output/qc.groovy.ts
	diff -s qc.ts output/qc.groovy.ts

test-groovy-erl: qc.groovy qc.erl | output
	groovy qc.groovy erl > output/qc.groovy.erl
	diff -s qc.erl output/qc.groovy.erl

test-groovy-cs: qc.groovy qc.cs | output
	groovy qc.groovy cs > output/qc.groovy.cs
	diff -s qc.cs output/qc.groovy.cs

test-groovy-prolog: qc.groovy qc.prolog | output
	groovy qc.groovy prolog > output/qc.groovy.prolog
	diff -s qc.prolog output/qc.groovy.prolog

test-groovy-cr: qc.groovy qc.cr | output
	groovy qc.groovy cr > output/qc.groovy.cr
	diff -s qc.cr output/qc.groovy.cr

test-groovy-unl: qc.groovy qc.unl | output
	groovy qc.groovy unl > output/qc.groovy.unl
	diff -s qc.unl output/qc.groovy.unl

test-groovy-hx: qc.groovy qc.hx | output
	groovy qc.groovy hx > output/qc.groovy.hx
	diff -s qc.hx output/qc.groovy.hx

test-groovy-bef: qc.groovy qc.bef | output
	groovy qc.groovy bef > output/qc.groovy.bef
	diff -s qc.bef output/qc.groovy.bef

test-groovy-awk: qc.groovy qc.awk | output
	groovy qc.groovy awk > output/qc.groovy.awk
	diff -s qc.awk output/qc.groovy.awk

test-groovy-piet: qc.groovy qc.piet.gif | output
	groovy qc.groovy piet > output/qc.groovy.piet
	diff -s qc.piet.gif output/qc.groovy.piet

test-ws-clj: qc.ws vendor/bin/ws qc.clj | output
	echo clj | vendor/bin/ws qc.ws > output/qc.ws.clj
	diff -s qc.clj output/qc.ws.clj

test-ws-lisp: qc.ws vendor/bin/ws qc.lisp | output
	echo lisp | vendor/bin/ws qc.ws > output/qc.ws.lisp
	diff -s qc.lisp output/qc.ws.lisp

test-ws-rkt: qc.ws vendor/bin/ws qc.rkt | output
	echo rkt | vendor/bin/ws qc.ws > output/qc.ws.rkt
	diff -s qc.rkt output/qc.ws.rkt

test-ws-rs: qc.ws vendor/bin/ws qc.rs | output
	echo rs | vendor/bin/ws qc.ws > output/qc.ws.rs
	diff -s qc.rs output/qc.ws.rs

test-ws-c: qc.ws vendor/bin/ws qc.c | output
	echo c | vendor/bin/ws qc.ws > output/qc.ws.c
	diff -s qc.c output/qc.ws.c

test-ws-cpp: qc.ws vendor/bin/ws qc.cpp | output
	echo cpp | vendor/bin/ws qc.ws > output/qc.ws.cpp
	diff -s qc.cpp output/qc.ws.cpp

test-ws-scala: qc.ws vendor/bin/ws qc.scala | output
	echo scala | vendor/bin/ws qc.ws > output/qc.ws.scala
	diff -s qc.scala output/qc.ws.scala

test-ws-f90: qc.ws vendor/bin/ws qc.f90 | output
	echo f90 | vendor/bin/ws qc.ws > output/qc.ws.f90
	diff -s qc.f90 output/qc.ws.f90

test-ws-scm: qc.ws vendor/bin/ws qc.scm | output
	echo scm | vendor/bin/ws qc.ws > output/qc.ws.scm
	diff -s qc.scm output/qc.ws.scm

test-ws-r: qc.ws vendor/bin/ws qc.r | output
	echo r | vendor/bin/ws qc.ws > output/qc.ws.r
	diff -s qc.r output/qc.ws.r

test-ws-lua: qc.ws vendor/bin/ws qc.lua | output
	echo lua | vendor/bin/ws qc.ws > output/qc.ws.lua
	diff -s qc.lua output/qc.ws.lua

test-ws-go: qc.ws vendor/bin/ws qc.go | output
	echo go | vendor/bin/ws qc.ws > output/qc.ws.go
	diff -s qc.go output/qc.ws.go

test-ws-ps: qc.ws vendor/bin/ws qc.ps | output
	echo ps | vendor/bin/ws qc.ws > output/qc.ws.ps
	diff -s qc.ps output/qc.ws.ps

test-ws-vala: qc.ws vendor/bin/ws qc.vala | output
	echo vala | vendor/bin/ws qc.ws > output/qc.ws.vala
	diff -s qc.vala output/qc.ws.vala

test-ws-pike: qc.ws vendor/bin/ws qc.pike | output
	echo pike | vendor/bin/ws qc.ws > output/qc.ws.pike
	diff -s qc.pike output/qc.ws.pike

test-ws-pas: qc.ws vendor/bin/ws qc.pas | output
	echo pas | vendor/bin/ws qc.ws > output/qc.ws.pas
	diff -s qc.pas output/qc.ws.pas

test-ws-kt: qc.ws vendor/bin/ws qc.kt | output
	echo kt | vendor/bin/ws qc.ws > output/qc.ws.kt
	diff -s qc.kt output/qc.ws.kt

test-ws-m: qc.ws vendor/bin/ws qc.m | output
	echo m | vendor/bin/ws qc.ws > output/qc.ws.m
	diff -s qc.m output/qc.ws.m

test-ws-ml: qc.ws vendor/bin/ws qc.ml | output
	echo ml | vendor/bin/ws qc.ws > output/qc.ws.ml
	diff -s qc.ml output/qc.ws.ml

test-ws-hs: qc.ws vendor/bin/ws qc.hs | output
	echo hs | vendor/bin/ws qc.ws > output/qc.ws.hs
	diff -s qc.hs output/qc.ws.hs

test-ws-zig: qc.ws vendor/bin/ws qc.zig | output
	echo zig | vendor/bin/ws qc.ws > output/qc.ws.zig
	diff -s qc.zig output/qc.ws.zig

test-ws-sml: qc.ws vendor/bin/ws qc.sml | output
	echo sml | vendor/bin/ws qc.ws > output/qc.ws.sml
	diff -s qc.sml output/qc.ws.sml

test-ws-octave: qc.ws vendor/bin/ws qc.octave | output
	echo octave | vendor/bin/ws qc.ws > output/qc.ws.octave
	diff -s qc.octave output/qc.ws.octave

test-ws-groovy: qc.ws vendor/bin/ws qc.groovy | output
	echo groovy | vendor/bin/ws qc.ws > output/qc.ws.groovy
	diff -s qc.groovy output/qc.ws.groovy

test-ws-ws: qc.ws vendor/bin/ws qc.ws | output
	echo | vendor/bin/ws qc.ws > output/qc.ws.ws
	diff -s qc.ws output/qc.ws.ws

test-ws-coffee: qc.ws vendor/bin/ws qc.coffee | output
	echo coffee | vendor/bin/ws qc.ws > output/qc.ws.coffee
	diff -s qc.coffee output/qc.ws.coffee

test-ws-swift: qc.ws vendor/bin/ws qc.swift | output
	echo swift | vendor/bin/ws qc.ws > output/qc.ws.swift
	diff -s qc.swift output/qc.ws.swift

test-ws-py: qc.ws vendor/bin/ws qc.py | output
	echo py | vendor/bin/ws qc.ws > output/qc.ws.py
	diff -s qc.py output/qc.ws.py

test-ws-fs: qc.ws vendor/bin/ws qc.fs | output
	echo fs | vendor/bin/ws qc.ws > output/qc.ws.fs
	diff -s qc.fs output/qc.ws.fs

test-ws-nim: qc.ws vendor/bin/ws qc.nim | output
	echo nim | vendor/bin/ws qc.ws > output/qc.ws.nim
	diff -s qc.nim output/qc.ws.nim

test-ws-fsx: qc.ws vendor/bin/ws qc.fsx | output
	echo fsx | vendor/bin/ws qc.ws > output/qc.ws.fsx
	diff -s qc.fsx output/qc.ws.fsx

test-ws-tcl: qc.ws vendor/bin/ws qc.tcl | output
	echo tcl | vendor/bin/ws qc.ws > output/qc.ws.tcl
	diff -s qc.tcl output/qc.ws.tcl

test-ws-bf: qc.ws vendor/bin/ws qc.bf | output
	echo bf | vendor/bin/ws qc.ws > output/qc.ws.bf
	diff -s qc.bf output/qc.ws.bf

test-ws-java: qc.ws vendor/bin/ws qc.java | output
	echo java | vendor/bin/ws qc.ws > output/qc.ws.java
	diff -s qc.java output/qc.ws.java

test-ws-php: qc.ws vendor/bin/ws qc.php | output
	echo php | vendor/bin/ws qc.ws > output/qc.ws.php
	diff -s qc.php output/qc.ws.php

test-ws-bash: qc.ws vendor/bin/ws qc.bash | output
	echo bash | vendor/bin/ws qc.ws > output/qc.ws.bash
	diff -s qc.bash output/qc.ws.bash

test-ws-d: qc.ws vendor/bin/ws qc.d | output
	echo d | vendor/bin/ws qc.ws > output/qc.ws.d
	diff -s qc.d output/qc.ws.d

test-ws-pl: qc.ws vendor/bin/ws qc.pl | output
	echo pl | vendor/bin/ws qc.ws > output/qc.ws.pl
	diff -s qc.pl output/qc.ws.pl

test-ws-exs: qc.ws vendor/bin/ws qc.exs | output
	echo exs | vendor/bin/ws qc.ws > output/qc.ws.exs
	diff -s qc.exs output/qc.ws.exs

test-ws-rb: qc.ws vendor/bin/ws qc.rb | output
	echo rb | vendor/bin/ws qc.ws > output/qc.ws.rb
	diff -s qc.rb output/qc.ws.rb

test-ws-js: qc.ws vendor/bin/ws qc.js | output
	echo js | vendor/bin/ws qc.ws > output/qc.ws.js
	diff -s qc.js output/qc.ws.js

test-ws-ts: qc.ws vendor/bin/ws qc.ts | output
	echo ts | vendor/bin/ws qc.ws > output/qc.ws.ts
	diff -s qc.ts output/qc.ws.ts

test-ws-erl: qc.ws vendor/bin/ws qc.erl | output
	echo erl | vendor/bin/ws qc.ws > output/qc.ws.erl
	diff -s qc.erl output/qc.ws.erl

test-ws-cs: qc.ws vendor/bin/ws qc.cs | output
	echo cs | vendor/bin/ws qc.ws > output/qc.ws.cs
	diff -s qc.cs output/qc.ws.cs

test-ws-prolog: qc.ws vendor/bin/ws qc.prolog | output
	echo prolog | vendor/bin/ws qc.ws > output/qc.ws.prolog
	diff -s qc.prolog output/qc.ws.prolog

test-ws-cr: qc.ws vendor/bin/ws qc.cr | output
	echo cr | vendor/bin/ws qc.ws > output/qc.ws.cr
	diff -s qc.cr output/qc.ws.cr

test-ws-unl: qc.ws vendor/bin/ws qc.unl | output
	echo unl | vendor/bin/ws qc.ws > output/qc.ws.unl
	diff -s qc.unl output/qc.ws.unl

test-ws-hx: qc.ws vendor/bin/ws qc.hx | output
	echo hx | vendor/bin/ws qc.ws > output/qc.ws.hx
	diff -s qc.hx output/qc.ws.hx

test-ws-bef: qc.ws vendor/bin/ws qc.bef | output
	echo bef | vendor/bin/ws qc.ws > output/qc.ws.bef
	diff -s qc.bef output/qc.ws.bef

test-ws-awk: qc.ws vendor/bin/ws qc.awk | output
	echo awk | vendor/bin/ws qc.ws > output/qc.ws.awk
	diff -s qc.awk output/qc.ws.awk

test-ws-piet: qc.ws vendor/bin/ws qc.piet.gif | output
	echo piet | vendor/bin/ws qc.ws > output/qc.ws.piet
	diff -s qc.piet.gif output/qc.ws.piet

test-coffee-clj: qc.coffee qc.clj | output
	coffee qc.coffee clj > output/qc.coffee.clj
	diff -s qc.clj output/qc.coffee.clj

test-coffee-lisp: qc.coffee qc.lisp | output
	coffee qc.coffee lisp > output/qc.coffee.lisp
	diff -s qc.lisp output/qc.coffee.lisp

test-coffee-rkt: qc.coffee qc.rkt | output
	coffee qc.coffee rkt > output/qc.coffee.rkt
	diff -s qc.rkt output/qc.coffee.rkt

test-coffee-rs: qc.coffee qc.rs | output
	coffee qc.coffee rs > output/qc.coffee.rs
	diff -s qc.rs output/qc.coffee.rs

test-coffee-c: qc.coffee qc.c | output
	coffee qc.coffee c > output/qc.coffee.c
	diff -s qc.c output/qc.coffee.c

test-coffee-cpp: qc.coffee qc.cpp | output
	coffee qc.coffee cpp > output/qc.coffee.cpp
	diff -s qc.cpp output/qc.coffee.cpp

test-coffee-scala: qc.coffee qc.scala | output
	coffee qc.coffee scala > output/qc.coffee.scala
	diff -s qc.scala output/qc.coffee.scala

test-coffee-f90: qc.coffee qc.f90 | output
	coffee qc.coffee f90 > output/qc.coffee.f90
	diff -s qc.f90 output/qc.coffee.f90

test-coffee-scm: qc.coffee qc.scm | output
	coffee qc.coffee scm > output/qc.coffee.scm
	diff -s qc.scm output/qc.coffee.scm

test-coffee-r: qc.coffee qc.r | output
	coffee qc.coffee r > output/qc.coffee.r
	diff -s qc.r output/qc.coffee.r

test-coffee-lua: qc.coffee qc.lua | output
	coffee qc.coffee lua > output/qc.coffee.lua
	diff -s qc.lua output/qc.coffee.lua

test-coffee-go: qc.coffee qc.go | output
	coffee qc.coffee go > output/qc.coffee.go
	diff -s qc.go output/qc.coffee.go

test-coffee-ps: qc.coffee qc.ps | output
	coffee qc.coffee ps > output/qc.coffee.ps
	diff -s qc.ps output/qc.coffee.ps

test-coffee-vala: qc.coffee qc.vala | output
	coffee qc.coffee vala > output/qc.coffee.vala
	diff -s qc.vala output/qc.coffee.vala

test-coffee-pike: qc.coffee qc.pike | output
	coffee qc.coffee pike > output/qc.coffee.pike
	diff -s qc.pike output/qc.coffee.pike

test-coffee-pas: qc.coffee qc.pas | output
	coffee qc.coffee pas > output/qc.coffee.pas
	diff -s qc.pas output/qc.coffee.pas

test-coffee-kt: qc.coffee qc.kt | output
	coffee qc.coffee kt > output/qc.coffee.kt
	diff -s qc.kt output/qc.coffee.kt

test-coffee-m: qc.coffee qc.m | output
	coffee qc.coffee m > output/qc.coffee.m
	diff -s qc.m output/qc.coffee.m

test-coffee-ml: qc.coffee qc.ml | output
	coffee qc.coffee ml > output/qc.coffee.ml
	diff -s qc.ml output/qc.coffee.ml

test-coffee-hs: qc.coffee qc.hs | output
	coffee qc.coffee hs > output/qc.coffee.hs
	diff -s qc.hs output/qc.coffee.hs

test-coffee-zig: qc.coffee qc.zig | output
	coffee qc.coffee zig > output/qc.coffee.zig
	diff -s qc.zig output/qc.coffee.zig

test-coffee-sml: qc.coffee qc.sml | output
	coffee qc.coffee sml > output/qc.coffee.sml
	diff -s qc.sml output/qc.coffee.sml

test-coffee-octave: qc.coffee qc.octave | output
	coffee qc.coffee octave > output/qc.coffee.octave
	diff -s qc.octave output/qc.coffee.octave

test-coffee-groovy: qc.coffee qc.groovy | output
	coffee qc.coffee groovy > output/qc.coffee.groovy
	diff -s qc.groovy output/qc.coffee.groovy

test-coffee-ws: qc.coffee qc.ws | output
	coffee qc.coffee ws > output/qc.coffee.ws
	diff -s qc.ws output/qc.coffee.ws

test-coffee-coffee: qc.coffee qc.coffee | output
	coffee qc.coffee > output/qc.coffee.coffee
	diff -s qc.coffee output/qc.coffee.coffee

test-coffee-swift: qc.coffee qc.swift | output
	coffee qc.coffee swift > output/qc.coffee.swift
	diff -s qc.swift output/qc.coffee.swift

test-coffee-py: qc.coffee qc.py | output
	coffee qc.coffee py > output/qc.coffee.py
	diff -s qc.py output/qc.coffee.py

test-coffee-fs: qc.coffee qc.fs | output
	coffee qc.coffee fs > output/qc.coffee.fs
	diff -s qc.fs output/qc.coffee.fs

test-coffee-nim: qc.coffee qc.nim | output
	coffee qc.coffee nim > output/qc.coffee.nim
	diff -s qc.nim output/qc.coffee.nim

test-coffee-fsx: qc.coffee qc.fsx | output
	coffee qc.coffee fsx > output/qc.coffee.fsx
	diff -s qc.fsx output/qc.coffee.fsx

test-coffee-tcl: qc.coffee qc.tcl | output
	coffee qc.coffee tcl > output/qc.coffee.tcl
	diff -s qc.tcl output/qc.coffee.tcl

test-coffee-bf: qc.coffee qc.bf | output
	coffee qc.coffee bf > output/qc.coffee.bf
	diff -s qc.bf output/qc.coffee.bf

test-coffee-java: qc.coffee qc.java | output
	coffee qc.coffee java > output/qc.coffee.java
	diff -s qc.java output/qc.coffee.java

test-coffee-php: qc.coffee qc.php | output
	coffee qc.coffee php > output/qc.coffee.php
	diff -s qc.php output/qc.coffee.php

test-coffee-bash: qc.coffee qc.bash | output
	coffee qc.coffee bash > output/qc.coffee.bash
	diff -s qc.bash output/qc.coffee.bash

test-coffee-d: qc.coffee qc.d | output
	coffee qc.coffee d > output/qc.coffee.d
	diff -s qc.d output/qc.coffee.d

test-coffee-pl: qc.coffee qc.pl | output
	coffee qc.coffee pl > output/qc.coffee.pl
	diff -s qc.pl output/qc.coffee.pl

test-coffee-exs: qc.coffee qc.exs | output
	coffee qc.coffee exs > output/qc.coffee.exs
	diff -s qc.exs output/qc.coffee.exs

test-coffee-rb: qc.coffee qc.rb | output
	coffee qc.coffee rb > output/qc.coffee.rb
	diff -s qc.rb output/qc.coffee.rb

test-coffee-js: qc.coffee qc.js | output
	coffee qc.coffee js > output/qc.coffee.js
	diff -s qc.js output/qc.coffee.js

test-coffee-ts: qc.coffee qc.ts | output
	coffee qc.coffee ts > output/qc.coffee.ts
	diff -s qc.ts output/qc.coffee.ts

test-coffee-erl: qc.coffee qc.erl | output
	coffee qc.coffee erl > output/qc.coffee.erl
	diff -s qc.erl output/qc.coffee.erl

test-coffee-cs: qc.coffee qc.cs | output
	coffee qc.coffee cs > output/qc.coffee.cs
	diff -s qc.cs output/qc.coffee.cs

test-coffee-prolog: qc.coffee qc.prolog | output
	coffee qc.coffee prolog > output/qc.coffee.prolog
	diff -s qc.prolog output/qc.coffee.prolog

test-coffee-cr: qc.coffee qc.cr | output
	coffee qc.coffee cr > output/qc.coffee.cr
	diff -s qc.cr output/qc.coffee.cr

test-coffee-unl: qc.coffee qc.unl | output
	coffee qc.coffee unl > output/qc.coffee.unl
	diff -s qc.unl output/qc.coffee.unl

test-coffee-hx: qc.coffee qc.hx | output
	coffee qc.coffee hx > output/qc.coffee.hx
	diff -s qc.hx output/qc.coffee.hx

test-coffee-bef: qc.coffee qc.bef | output
	coffee qc.coffee bef > output/qc.coffee.bef
	diff -s qc.bef output/qc.coffee.bef

test-coffee-awk: qc.coffee qc.awk | output
	coffee qc.coffee awk > output/qc.coffee.awk
	diff -s qc.awk output/qc.coffee.awk

test-coffee-piet: qc.coffee qc.piet.gif | output
	coffee qc.coffee piet > output/qc.coffee.piet
	diff -s qc.piet.gif output/qc.coffee.piet

test-swift-clj: build/qc.swift.exe qc.clj | output
	build/qc.swift.exe clj > output/qc.swift.clj
	diff -s qc.clj output/qc.swift.clj

test-swift-lisp: build/qc.swift.exe qc.lisp | output
	build/qc.swift.exe lisp > output/qc.swift.lisp
	diff -s qc.lisp output/qc.swift.lisp

test-swift-rkt: build/qc.swift.exe qc.rkt | output
	build/qc.swift.exe rkt > output/qc.swift.rkt
	diff -s qc.rkt output/qc.swift.rkt

test-swift-rs: build/qc.swift.exe qc.rs | output
	build/qc.swift.exe rs > output/qc.swift.rs
	diff -s qc.rs output/qc.swift.rs

test-swift-c: build/qc.swift.exe qc.c | output
	build/qc.swift.exe c > output/qc.swift.c
	diff -s qc.c output/qc.swift.c

test-swift-cpp: build/qc.swift.exe qc.cpp | output
	build/qc.swift.exe cpp > output/qc.swift.cpp
	diff -s qc.cpp output/qc.swift.cpp

test-swift-scala: build/qc.swift.exe qc.scala | output
	build/qc.swift.exe scala > output/qc.swift.scala
	diff -s qc.scala output/qc.swift.scala

test-swift-f90: build/qc.swift.exe qc.f90 | output
	build/qc.swift.exe f90 > output/qc.swift.f90
	diff -s qc.f90 output/qc.swift.f90

test-swift-scm: build/qc.swift.exe qc.scm | output
	build/qc.swift.exe scm > output/qc.swift.scm
	diff -s qc.scm output/qc.swift.scm

test-swift-r: build/qc.swift.exe qc.r | output
	build/qc.swift.exe r > output/qc.swift.r
	diff -s qc.r output/qc.swift.r

test-swift-lua: build/qc.swift.exe qc.lua | output
	build/qc.swift.exe lua > output/qc.swift.lua
	diff -s qc.lua output/qc.swift.lua

test-swift-go: build/qc.swift.exe qc.go | output
	build/qc.swift.exe go > output/qc.swift.go
	diff -s qc.go output/qc.swift.go

test-swift-ps: build/qc.swift.exe qc.ps | output
	build/qc.swift.exe ps > output/qc.swift.ps
	diff -s qc.ps output/qc.swift.ps

test-swift-vala: build/qc.swift.exe qc.vala | output
	build/qc.swift.exe vala > output/qc.swift.vala
	diff -s qc.vala output/qc.swift.vala

test-swift-pike: build/qc.swift.exe qc.pike | output
	build/qc.swift.exe pike > output/qc.swift.pike
	diff -s qc.pike output/qc.swift.pike

test-swift-pas: build/qc.swift.exe qc.pas | output
	build/qc.swift.exe pas > output/qc.swift.pas
	diff -s qc.pas output/qc.swift.pas

test-swift-kt: build/qc.swift.exe qc.kt | output
	build/qc.swift.exe kt > output/qc.swift.kt
	diff -s qc.kt output/qc.swift.kt

test-swift-m: build/qc.swift.exe qc.m | output
	build/qc.swift.exe m > output/qc.swift.m
	diff -s qc.m output/qc.swift.m

test-swift-ml: build/qc.swift.exe qc.ml | output
	build/qc.swift.exe ml > output/qc.swift.ml
	diff -s qc.ml output/qc.swift.ml

test-swift-hs: build/qc.swift.exe qc.hs | output
	build/qc.swift.exe hs > output/qc.swift.hs
	diff -s qc.hs output/qc.swift.hs

test-swift-zig: build/qc.swift.exe qc.zig | output
	build/qc.swift.exe zig > output/qc.swift.zig
	diff -s qc.zig output/qc.swift.zig

test-swift-sml: build/qc.swift.exe qc.sml | output
	build/qc.swift.exe sml > output/qc.swift.sml
	diff -s qc.sml output/qc.swift.sml

test-swift-octave: build/qc.swift.exe qc.octave | output
	build/qc.swift.exe octave > output/qc.swift.octave
	diff -s qc.octave output/qc.swift.octave

test-swift-groovy: build/qc.swift.exe qc.groovy | output
	build/qc.swift.exe groovy > output/qc.swift.groovy
	diff -s qc.groovy output/qc.swift.groovy

test-swift-ws: build/qc.swift.exe qc.ws | output
	build/qc.swift.exe ws > output/qc.swift.ws
	diff -s qc.ws output/qc.swift.ws

test-swift-coffee: build/qc.swift.exe qc.coffee | output
	build/qc.swift.exe coffee > output/qc.swift.coffee
	diff -s qc.coffee output/qc.swift.coffee

test-swift-swift: build/qc.swift.exe qc.swift | output
	build/qc.swift.exe > output/qc.swift.swift
	diff -s qc.swift output/qc.swift.swift

test-swift-py: build/qc.swift.exe qc.py | output
	build/qc.swift.exe py > output/qc.swift.py
	diff -s qc.py output/qc.swift.py

test-swift-fs: build/qc.swift.exe qc.fs | output
	build/qc.swift.exe fs > output/qc.swift.fs
	diff -s qc.fs output/qc.swift.fs

test-swift-nim: build/qc.swift.exe qc.nim | output
	build/qc.swift.exe nim > output/qc.swift.nim
	diff -s qc.nim output/qc.swift.nim

test-swift-fsx: build/qc.swift.exe qc.fsx | output
	build/qc.swift.exe fsx > output/qc.swift.fsx
	diff -s qc.fsx output/qc.swift.fsx

test-swift-tcl: build/qc.swift.exe qc.tcl | output
	build/qc.swift.exe tcl > output/qc.swift.tcl
	diff -s qc.tcl output/qc.swift.tcl

test-swift-bf: build/qc.swift.exe qc.bf | output
	build/qc.swift.exe bf > output/qc.swift.bf
	diff -s qc.bf output/qc.swift.bf

test-swift-java: build/qc.swift.exe qc.java | output
	build/qc.swift.exe java > output/qc.swift.java
	diff -s qc.java output/qc.swift.java

test-swift-php: build/qc.swift.exe qc.php | output
	build/qc.swift.exe php > output/qc.swift.php
	diff -s qc.php output/qc.swift.php

test-swift-bash: build/qc.swift.exe qc.bash | output
	build/qc.swift.exe bash > output/qc.swift.bash
	diff -s qc.bash output/qc.swift.bash

test-swift-d: build/qc.swift.exe qc.d | output
	build/qc.swift.exe d > output/qc.swift.d
	diff -s qc.d output/qc.swift.d

test-swift-pl: build/qc.swift.exe qc.pl | output
	build/qc.swift.exe pl > output/qc.swift.pl
	diff -s qc.pl output/qc.swift.pl

test-swift-exs: build/qc.swift.exe qc.exs | output
	build/qc.swift.exe exs > output/qc.swift.exs
	diff -s qc.exs output/qc.swift.exs

test-swift-rb: build/qc.swift.exe qc.rb | output
	build/qc.swift.exe rb > output/qc.swift.rb
	diff -s qc.rb output/qc.swift.rb

test-swift-js: build/qc.swift.exe qc.js | output
	build/qc.swift.exe js > output/qc.swift.js
	diff -s qc.js output/qc.swift.js

test-swift-ts: build/qc.swift.exe qc.ts | output
	build/qc.swift.exe ts > output/qc.swift.ts
	diff -s qc.ts output/qc.swift.ts

test-swift-erl: build/qc.swift.exe qc.erl | output
	build/qc.swift.exe erl > output/qc.swift.erl
	diff -s qc.erl output/qc.swift.erl

test-swift-cs: build/qc.swift.exe qc.cs | output
	build/qc.swift.exe cs > output/qc.swift.cs
	diff -s qc.cs output/qc.swift.cs

test-swift-prolog: build/qc.swift.exe qc.prolog | output
	build/qc.swift.exe prolog > output/qc.swift.prolog
	diff -s qc.prolog output/qc.swift.prolog

test-swift-cr: build/qc.swift.exe qc.cr | output
	build/qc.swift.exe cr > output/qc.swift.cr
	diff -s qc.cr output/qc.swift.cr

test-swift-unl: build/qc.swift.exe qc.unl | output
	build/qc.swift.exe unl > output/qc.swift.unl
	diff -s qc.unl output/qc.swift.unl

test-swift-hx: build/qc.swift.exe qc.hx | output
	build/qc.swift.exe hx > output/qc.swift.hx
	diff -s qc.hx output/qc.swift.hx

test-swift-bef: build/qc.swift.exe qc.bef | output
	build/qc.swift.exe bef > output/qc.swift.bef
	diff -s qc.bef output/qc.swift.bef

test-swift-awk: build/qc.swift.exe qc.awk | output
	build/qc.swift.exe awk > output/qc.swift.awk
	diff -s qc.awk output/qc.swift.awk

test-swift-piet: build/qc.swift.exe qc.piet.gif | output
	build/qc.swift.exe piet > output/qc.swift.piet
	diff -s qc.piet.gif output/qc.swift.piet

test-py-clj: qc.py qc.clj | output
	python3 qc.py clj > output/qc.py.clj
	diff -s qc.clj output/qc.py.clj

test-py-lisp: qc.py qc.lisp | output
	python3 qc.py lisp > output/qc.py.lisp
	diff -s qc.lisp output/qc.py.lisp

test-py-rkt: qc.py qc.rkt | output
	python3 qc.py rkt > output/qc.py.rkt
	diff -s qc.rkt output/qc.py.rkt

test-py-rs: qc.py qc.rs | output
	python3 qc.py rs > output/qc.py.rs
	diff -s qc.rs output/qc.py.rs

test-py-c: qc.py qc.c | output
	python3 qc.py c > output/qc.py.c
	diff -s qc.c output/qc.py.c

test-py-cpp: qc.py qc.cpp | output
	python3 qc.py cpp > output/qc.py.cpp
	diff -s qc.cpp output/qc.py.cpp

test-py-scala: qc.py qc.scala | output
	python3 qc.py scala > output/qc.py.scala
	diff -s qc.scala output/qc.py.scala

test-py-f90: qc.py qc.f90 | output
	python3 qc.py f90 > output/qc.py.f90
	diff -s qc.f90 output/qc.py.f90

test-py-scm: qc.py qc.scm | output
	python3 qc.py scm > output/qc.py.scm
	diff -s qc.scm output/qc.py.scm

test-py-r: qc.py qc.r | output
	python3 qc.py r > output/qc.py.r
	diff -s qc.r output/qc.py.r

test-py-lua: qc.py qc.lua | output
	python3 qc.py lua > output/qc.py.lua
	diff -s qc.lua output/qc.py.lua

test-py-go: qc.py qc.go | output
	python3 qc.py go > output/qc.py.go
	diff -s qc.go output/qc.py.go

test-py-ps: qc.py qc.ps | output
	python3 qc.py ps > output/qc.py.ps
	diff -s qc.ps output/qc.py.ps

test-py-vala: qc.py qc.vala | output
	python3 qc.py vala > output/qc.py.vala
	diff -s qc.vala output/qc.py.vala

test-py-pike: qc.py qc.pike | output
	python3 qc.py pike > output/qc.py.pike
	diff -s qc.pike output/qc.py.pike

test-py-pas: qc.py qc.pas | output
	python3 qc.py pas > output/qc.py.pas
	diff -s qc.pas output/qc.py.pas

test-py-kt: qc.py qc.kt | output
	python3 qc.py kt > output/qc.py.kt
	diff -s qc.kt output/qc.py.kt

test-py-m: qc.py qc.m | output
	python3 qc.py m > output/qc.py.m
	diff -s qc.m output/qc.py.m

test-py-ml: qc.py qc.ml | output
	python3 qc.py ml > output/qc.py.ml
	diff -s qc.ml output/qc.py.ml

test-py-hs: qc.py qc.hs | output
	python3 qc.py hs > output/qc.py.hs
	diff -s qc.hs output/qc.py.hs

test-py-zig: qc.py qc.zig | output
	python3 qc.py zig > output/qc.py.zig
	diff -s qc.zig output/qc.py.zig

test-py-sml: qc.py qc.sml | output
	python3 qc.py sml > output/qc.py.sml
	diff -s qc.sml output/qc.py.sml

test-py-octave: qc.py qc.octave | output
	python3 qc.py octave > output/qc.py.octave
	diff -s qc.octave output/qc.py.octave

test-py-groovy: qc.py qc.groovy | output
	python3 qc.py groovy > output/qc.py.groovy
	diff -s qc.groovy output/qc.py.groovy

test-py-ws: qc.py qc.ws | output
	python3 qc.py ws > output/qc.py.ws
	diff -s qc.ws output/qc.py.ws

test-py-coffee: qc.py qc.coffee | output
	python3 qc.py coffee > output/qc.py.coffee
	diff -s qc.coffee output/qc.py.coffee

test-py-swift: qc.py qc.swift | output
	python3 qc.py swift > output/qc.py.swift
	diff -s qc.swift output/qc.py.swift

test-py-py: qc.py qc.py | output
	python3 qc.py > output/qc.py.py
	diff -s qc.py output/qc.py.py

test-py-fs: qc.py qc.fs | output
	python3 qc.py fs > output/qc.py.fs
	diff -s qc.fs output/qc.py.fs

test-py-nim: qc.py qc.nim | output
	python3 qc.py nim > output/qc.py.nim
	diff -s qc.nim output/qc.py.nim

test-py-fsx: qc.py qc.fsx | output
	python3 qc.py fsx > output/qc.py.fsx
	diff -s qc.fsx output/qc.py.fsx

test-py-tcl: qc.py qc.tcl | output
	python3 qc.py tcl > output/qc.py.tcl
	diff -s qc.tcl output/qc.py.tcl

test-py-bf: qc.py qc.bf | output
	python3 qc.py bf > output/qc.py.bf
	diff -s qc.bf output/qc.py.bf

test-py-java: qc.py qc.java | output
	python3 qc.py java > output/qc.py.java
	diff -s qc.java output/qc.py.java

test-py-php: qc.py qc.php | output
	python3 qc.py php > output/qc.py.php
	diff -s qc.php output/qc.py.php

test-py-bash: qc.py qc.bash | output
	python3 qc.py bash > output/qc.py.bash
	diff -s qc.bash output/qc.py.bash

test-py-d: qc.py qc.d | output
	python3 qc.py d > output/qc.py.d
	diff -s qc.d output/qc.py.d

test-py-pl: qc.py qc.pl | output
	python3 qc.py pl > output/qc.py.pl
	diff -s qc.pl output/qc.py.pl

test-py-exs: qc.py qc.exs | output
	python3 qc.py exs > output/qc.py.exs
	diff -s qc.exs output/qc.py.exs

test-py-rb: qc.py qc.rb | output
	python3 qc.py rb > output/qc.py.rb
	diff -s qc.rb output/qc.py.rb

test-py-js: qc.py qc.js | output
	python3 qc.py js > output/qc.py.js
	diff -s qc.js output/qc.py.js

test-py-ts: qc.py qc.ts | output
	python3 qc.py ts > output/qc.py.ts
	diff -s qc.ts output/qc.py.ts

test-py-erl: qc.py qc.erl | output
	python3 qc.py erl > output/qc.py.erl
	diff -s qc.erl output/qc.py.erl

test-py-cs: qc.py qc.cs | output
	python3 qc.py cs > output/qc.py.cs
	diff -s qc.cs output/qc.py.cs

test-py-prolog: qc.py qc.prolog | output
	python3 qc.py prolog > output/qc.py.prolog
	diff -s qc.prolog output/qc.py.prolog

test-py-cr: qc.py qc.cr | output
	python3 qc.py cr > output/qc.py.cr
	diff -s qc.cr output/qc.py.cr

test-py-unl: qc.py qc.unl | output
	python3 qc.py unl > output/qc.py.unl
	diff -s qc.unl output/qc.py.unl

test-py-hx: qc.py qc.hx | output
	python3 qc.py hx > output/qc.py.hx
	diff -s qc.hx output/qc.py.hx

test-py-bef: qc.py qc.bef | output
	python3 qc.py bef > output/qc.py.bef
	diff -s qc.bef output/qc.py.bef

test-py-awk: qc.py qc.awk | output
	python3 qc.py awk > output/qc.py.awk
	diff -s qc.awk output/qc.py.awk

test-py-piet: qc.py qc.piet.gif | output
	python3 qc.py piet > output/qc.py.piet
	diff -s qc.piet.gif output/qc.py.piet

test-fs-clj: qc.fs qc.clj | output
	gforth qc.fs clj > output/qc.fs.clj
	diff -s qc.clj output/qc.fs.clj

test-fs-lisp: qc.fs qc.lisp | output
	gforth qc.fs lisp > output/qc.fs.lisp
	diff -s qc.lisp output/qc.fs.lisp

test-fs-rkt: qc.fs qc.rkt | output
	gforth qc.fs rkt > output/qc.fs.rkt
	diff -s qc.rkt output/qc.fs.rkt

test-fs-rs: qc.fs qc.rs | output
	gforth qc.fs rs > output/qc.fs.rs
	diff -s qc.rs output/qc.fs.rs

test-fs-c: qc.fs qc.c | output
	gforth qc.fs c > output/qc.fs.c
	diff -s qc.c output/qc.fs.c

test-fs-cpp: qc.fs qc.cpp | output
	gforth qc.fs cpp > output/qc.fs.cpp
	diff -s qc.cpp output/qc.fs.cpp

test-fs-scala: qc.fs qc.scala | output
	gforth qc.fs scala > output/qc.fs.scala
	diff -s qc.scala output/qc.fs.scala

test-fs-f90: qc.fs qc.f90 | output
	gforth qc.fs f90 > output/qc.fs.f90
	diff -s qc.f90 output/qc.fs.f90

test-fs-scm: qc.fs qc.scm | output
	gforth qc.fs scm > output/qc.fs.scm
	diff -s qc.scm output/qc.fs.scm

test-fs-r: qc.fs qc.r | output
	gforth qc.fs r > output/qc.fs.r
	diff -s qc.r output/qc.fs.r

test-fs-lua: qc.fs qc.lua | output
	gforth qc.fs lua > output/qc.fs.lua
	diff -s qc.lua output/qc.fs.lua

test-fs-go: qc.fs qc.go | output
	gforth qc.fs go > output/qc.fs.go
	diff -s qc.go output/qc.fs.go

test-fs-ps: qc.fs qc.ps | output
	gforth qc.fs ps > output/qc.fs.ps
	diff -s qc.ps output/qc.fs.ps

test-fs-vala: qc.fs qc.vala | output
	gforth qc.fs vala > output/qc.fs.vala
	diff -s qc.vala output/qc.fs.vala

test-fs-pike: qc.fs qc.pike | output
	gforth qc.fs pike > output/qc.fs.pike
	diff -s qc.pike output/qc.fs.pike

test-fs-pas: qc.fs qc.pas | output
	gforth qc.fs pas > output/qc.fs.pas
	diff -s qc.pas output/qc.fs.pas

test-fs-kt: qc.fs qc.kt | output
	gforth qc.fs kt > output/qc.fs.kt
	diff -s qc.kt output/qc.fs.kt

test-fs-m: qc.fs qc.m | output
	gforth qc.fs m > output/qc.fs.m
	diff -s qc.m output/qc.fs.m

test-fs-ml: qc.fs qc.ml | output
	gforth qc.fs ml > output/qc.fs.ml
	diff -s qc.ml output/qc.fs.ml

test-fs-hs: qc.fs qc.hs | output
	gforth qc.fs hs > output/qc.fs.hs
	diff -s qc.hs output/qc.fs.hs

test-fs-zig: qc.fs qc.zig | output
	gforth qc.fs zig > output/qc.fs.zig
	diff -s qc.zig output/qc.fs.zig

test-fs-sml: qc.fs qc.sml | output
	gforth qc.fs sml > output/qc.fs.sml
	diff -s qc.sml output/qc.fs.sml

test-fs-octave: qc.fs qc.octave | output
	gforth qc.fs octave > output/qc.fs.octave
	diff -s qc.octave output/qc.fs.octave

test-fs-groovy: qc.fs qc.groovy | output
	gforth qc.fs groovy > output/qc.fs.groovy
	diff -s qc.groovy output/qc.fs.groovy

test-fs-ws: qc.fs qc.ws | output
	gforth qc.fs ws > output/qc.fs.ws
	diff -s qc.ws output/qc.fs.ws

test-fs-coffee: qc.fs qc.coffee | output
	gforth qc.fs coffee > output/qc.fs.coffee
	diff -s qc.coffee output/qc.fs.coffee

test-fs-swift: qc.fs qc.swift | output
	gforth qc.fs swift > output/qc.fs.swift
	diff -s qc.swift output/qc.fs.swift

test-fs-py: qc.fs qc.py | output
	gforth qc.fs py > output/qc.fs.py
	diff -s qc.py output/qc.fs.py

test-fs-fs: qc.fs qc.fs | output
	gforth qc.fs > output/qc.fs.fs
	diff -s qc.fs output/qc.fs.fs

test-fs-nim: qc.fs qc.nim | output
	gforth qc.fs nim > output/qc.fs.nim
	diff -s qc.nim output/qc.fs.nim

test-fs-fsx: qc.fs qc.fsx | output
	gforth qc.fs fsx > output/qc.fs.fsx
	diff -s qc.fsx output/qc.fs.fsx

test-fs-tcl: qc.fs qc.tcl | output
	gforth qc.fs tcl > output/qc.fs.tcl
	diff -s qc.tcl output/qc.fs.tcl

test-fs-bf: qc.fs qc.bf | output
	gforth qc.fs bf > output/qc.fs.bf
	diff -s qc.bf output/qc.fs.bf

test-fs-java: qc.fs qc.java | output
	gforth qc.fs java > output/qc.fs.java
	diff -s qc.java output/qc.fs.java

test-fs-php: qc.fs qc.php | output
	gforth qc.fs php > output/qc.fs.php
	diff -s qc.php output/qc.fs.php

test-fs-bash: qc.fs qc.bash | output
	gforth qc.fs bash > output/qc.fs.bash
	diff -s qc.bash output/qc.fs.bash

test-fs-d: qc.fs qc.d | output
	gforth qc.fs d > output/qc.fs.d
	diff -s qc.d output/qc.fs.d

test-fs-pl: qc.fs qc.pl | output
	gforth qc.fs pl > output/qc.fs.pl
	diff -s qc.pl output/qc.fs.pl

test-fs-exs: qc.fs qc.exs | output
	gforth qc.fs exs > output/qc.fs.exs
	diff -s qc.exs output/qc.fs.exs

test-fs-rb: qc.fs qc.rb | output
	gforth qc.fs rb > output/qc.fs.rb
	diff -s qc.rb output/qc.fs.rb

test-fs-js: qc.fs qc.js | output
	gforth qc.fs js > output/qc.fs.js
	diff -s qc.js output/qc.fs.js

test-fs-ts: qc.fs qc.ts | output
	gforth qc.fs ts > output/qc.fs.ts
	diff -s qc.ts output/qc.fs.ts

test-fs-erl: qc.fs qc.erl | output
	gforth qc.fs erl > output/qc.fs.erl
	diff -s qc.erl output/qc.fs.erl

test-fs-cs: qc.fs qc.cs | output
	gforth qc.fs cs > output/qc.fs.cs
	diff -s qc.cs output/qc.fs.cs

test-fs-prolog: qc.fs qc.prolog | output
	gforth qc.fs prolog > output/qc.fs.prolog
	diff -s qc.prolog output/qc.fs.prolog

test-fs-cr: qc.fs qc.cr | output
	gforth qc.fs cr > output/qc.fs.cr
	diff -s qc.cr output/qc.fs.cr

test-fs-unl: qc.fs qc.unl | output
	gforth qc.fs unl > output/qc.fs.unl
	diff -s qc.unl output/qc.fs.unl

test-fs-hx: qc.fs qc.hx | output
	gforth qc.fs hx > output/qc.fs.hx
	diff -s qc.hx output/qc.fs.hx

test-fs-bef: qc.fs qc.bef | output
	gforth qc.fs bef > output/qc.fs.bef
	diff -s qc.bef output/qc.fs.bef

test-fs-awk: qc.fs qc.awk | output
	gforth qc.fs awk > output/qc.fs.awk
	diff -s qc.awk output/qc.fs.awk

test-fs-piet: qc.fs qc.piet.gif | output
	gforth qc.fs piet > output/qc.fs.piet
	diff -s qc.piet.gif output/qc.fs.piet

test-nim-clj: build/qc.nim.exe qc.clj | output
	build/qc.nim.exe clj > output/qc.nim.clj
	diff -s qc.clj output/qc.nim.clj

test-nim-lisp: build/qc.nim.exe qc.lisp | output
	build/qc.nim.exe lisp > output/qc.nim.lisp
	diff -s qc.lisp output/qc.nim.lisp

test-nim-rkt: build/qc.nim.exe qc.rkt | output
	build/qc.nim.exe rkt > output/qc.nim.rkt
	diff -s qc.rkt output/qc.nim.rkt

test-nim-rs: build/qc.nim.exe qc.rs | output
	build/qc.nim.exe rs > output/qc.nim.rs
	diff -s qc.rs output/qc.nim.rs

test-nim-c: build/qc.nim.exe qc.c | output
	build/qc.nim.exe c > output/qc.nim.c
	diff -s qc.c output/qc.nim.c

test-nim-cpp: build/qc.nim.exe qc.cpp | output
	build/qc.nim.exe cpp > output/qc.nim.cpp
	diff -s qc.cpp output/qc.nim.cpp

test-nim-scala: build/qc.nim.exe qc.scala | output
	build/qc.nim.exe scala > output/qc.nim.scala
	diff -s qc.scala output/qc.nim.scala

test-nim-f90: build/qc.nim.exe qc.f90 | output
	build/qc.nim.exe f90 > output/qc.nim.f90
	diff -s qc.f90 output/qc.nim.f90

test-nim-scm: build/qc.nim.exe qc.scm | output
	build/qc.nim.exe scm > output/qc.nim.scm
	diff -s qc.scm output/qc.nim.scm

test-nim-r: build/qc.nim.exe qc.r | output
	build/qc.nim.exe r > output/qc.nim.r
	diff -s qc.r output/qc.nim.r

test-nim-lua: build/qc.nim.exe qc.lua | output
	build/qc.nim.exe lua > output/qc.nim.lua
	diff -s qc.lua output/qc.nim.lua

test-nim-go: build/qc.nim.exe qc.go | output
	build/qc.nim.exe go > output/qc.nim.go
	diff -s qc.go output/qc.nim.go

test-nim-ps: build/qc.nim.exe qc.ps | output
	build/qc.nim.exe ps > output/qc.nim.ps
	diff -s qc.ps output/qc.nim.ps

test-nim-vala: build/qc.nim.exe qc.vala | output
	build/qc.nim.exe vala > output/qc.nim.vala
	diff -s qc.vala output/qc.nim.vala

test-nim-pike: build/qc.nim.exe qc.pike | output
	build/qc.nim.exe pike > output/qc.nim.pike
	diff -s qc.pike output/qc.nim.pike

test-nim-pas: build/qc.nim.exe qc.pas | output
	build/qc.nim.exe pas > output/qc.nim.pas
	diff -s qc.pas output/qc.nim.pas

test-nim-kt: build/qc.nim.exe qc.kt | output
	build/qc.nim.exe kt > output/qc.nim.kt
	diff -s qc.kt output/qc.nim.kt

test-nim-m: build/qc.nim.exe qc.m | output
	build/qc.nim.exe m > output/qc.nim.m
	diff -s qc.m output/qc.nim.m

test-nim-ml: build/qc.nim.exe qc.ml | output
	build/qc.nim.exe ml > output/qc.nim.ml
	diff -s qc.ml output/qc.nim.ml

test-nim-hs: build/qc.nim.exe qc.hs | output
	build/qc.nim.exe hs > output/qc.nim.hs
	diff -s qc.hs output/qc.nim.hs

test-nim-zig: build/qc.nim.exe qc.zig | output
	build/qc.nim.exe zig > output/qc.nim.zig
	diff -s qc.zig output/qc.nim.zig

test-nim-sml: build/qc.nim.exe qc.sml | output
	build/qc.nim.exe sml > output/qc.nim.sml
	diff -s qc.sml output/qc.nim.sml

test-nim-octave: build/qc.nim.exe qc.octave | output
	build/qc.nim.exe octave > output/qc.nim.octave
	diff -s qc.octave output/qc.nim.octave

test-nim-groovy: build/qc.nim.exe qc.groovy | output
	build/qc.nim.exe groovy > output/qc.nim.groovy
	diff -s qc.groovy output/qc.nim.groovy

test-nim-ws: build/qc.nim.exe qc.ws | output
	build/qc.nim.exe ws > output/qc.nim.ws
	diff -s qc.ws output/qc.nim.ws

test-nim-coffee: build/qc.nim.exe qc.coffee | output
	build/qc.nim.exe coffee > output/qc.nim.coffee
	diff -s qc.coffee output/qc.nim.coffee

test-nim-swift: build/qc.nim.exe qc.swift | output
	build/qc.nim.exe swift > output/qc.nim.swift
	diff -s qc.swift output/qc.nim.swift

test-nim-py: build/qc.nim.exe qc.py | output
	build/qc.nim.exe py > output/qc.nim.py
	diff -s qc.py output/qc.nim.py

test-nim-fs: build/qc.nim.exe qc.fs | output
	build/qc.nim.exe fs > output/qc.nim.fs
	diff -s qc.fs output/qc.nim.fs

test-nim-nim: build/qc.nim.exe qc.nim | output
	build/qc.nim.exe > output/qc.nim.nim
	diff -s qc.nim output/qc.nim.nim

test-nim-fsx: build/qc.nim.exe qc.fsx | output
	build/qc.nim.exe fsx > output/qc.nim.fsx
	diff -s qc.fsx output/qc.nim.fsx

test-nim-tcl: build/qc.nim.exe qc.tcl | output
	build/qc.nim.exe tcl > output/qc.nim.tcl
	diff -s qc.tcl output/qc.nim.tcl

test-nim-bf: build/qc.nim.exe qc.bf | output
	build/qc.nim.exe bf > output/qc.nim.bf
	diff -s qc.bf output/qc.nim.bf

test-nim-java: build/qc.nim.exe qc.java | output
	build/qc.nim.exe java > output/qc.nim.java
	diff -s qc.java output/qc.nim.java

test-nim-php: build/qc.nim.exe qc.php | output
	build/qc.nim.exe php > output/qc.nim.php
	diff -s qc.php output/qc.nim.php

test-nim-bash: build/qc.nim.exe qc.bash | output
	build/qc.nim.exe bash > output/qc.nim.bash
	diff -s qc.bash output/qc.nim.bash

test-nim-d: build/qc.nim.exe qc.d | output
	build/qc.nim.exe d > output/qc.nim.d
	diff -s qc.d output/qc.nim.d

test-nim-pl: build/qc.nim.exe qc.pl | output
	build/qc.nim.exe pl > output/qc.nim.pl
	diff -s qc.pl output/qc.nim.pl

test-nim-exs: build/qc.nim.exe qc.exs | output
	build/qc.nim.exe exs > output/qc.nim.exs
	diff -s qc.exs output/qc.nim.exs

test-nim-rb: build/qc.nim.exe qc.rb | output
	build/qc.nim.exe rb > output/qc.nim.rb
	diff -s qc.rb output/qc.nim.rb

test-nim-js: build/qc.nim.exe qc.js | output
	build/qc.nim.exe js > output/qc.nim.js
	diff -s qc.js output/qc.nim.js

test-nim-ts: build/qc.nim.exe qc.ts | output
	build/qc.nim.exe ts > output/qc.nim.ts
	diff -s qc.ts output/qc.nim.ts

test-nim-erl: build/qc.nim.exe qc.erl | output
	build/qc.nim.exe erl > output/qc.nim.erl
	diff -s qc.erl output/qc.nim.erl

test-nim-cs: build/qc.nim.exe qc.cs | output
	build/qc.nim.exe cs > output/qc.nim.cs
	diff -s qc.cs output/qc.nim.cs

test-nim-prolog: build/qc.nim.exe qc.prolog | output
	build/qc.nim.exe prolog > output/qc.nim.prolog
	diff -s qc.prolog output/qc.nim.prolog

test-nim-cr: build/qc.nim.exe qc.cr | output
	build/qc.nim.exe cr > output/qc.nim.cr
	diff -s qc.cr output/qc.nim.cr

test-nim-unl: build/qc.nim.exe qc.unl | output
	build/qc.nim.exe unl > output/qc.nim.unl
	diff -s qc.unl output/qc.nim.unl

test-nim-hx: build/qc.nim.exe qc.hx | output
	build/qc.nim.exe hx > output/qc.nim.hx
	diff -s qc.hx output/qc.nim.hx

test-nim-bef: build/qc.nim.exe qc.bef | output
	build/qc.nim.exe bef > output/qc.nim.bef
	diff -s qc.bef output/qc.nim.bef

test-nim-awk: build/qc.nim.exe qc.awk | output
	build/qc.nim.exe awk > output/qc.nim.awk
	diff -s qc.awk output/qc.nim.awk

test-nim-piet: build/qc.nim.exe qc.piet.gif | output
	build/qc.nim.exe piet > output/qc.nim.piet
	diff -s qc.piet.gif output/qc.nim.piet

test-fsx-clj: qc.fsx qc.clj | output
	dotnet fsi qc.fsx clj > output/qc.fsx.clj
	diff -s qc.clj output/qc.fsx.clj

test-fsx-lisp: qc.fsx qc.lisp | output
	dotnet fsi qc.fsx lisp > output/qc.fsx.lisp
	diff -s qc.lisp output/qc.fsx.lisp

test-fsx-rkt: qc.fsx qc.rkt | output
	dotnet fsi qc.fsx rkt > output/qc.fsx.rkt
	diff -s qc.rkt output/qc.fsx.rkt

test-fsx-rs: qc.fsx qc.rs | output
	dotnet fsi qc.fsx rs > output/qc.fsx.rs
	diff -s qc.rs output/qc.fsx.rs

test-fsx-c: qc.fsx qc.c | output
	dotnet fsi qc.fsx c > output/qc.fsx.c
	diff -s qc.c output/qc.fsx.c

test-fsx-cpp: qc.fsx qc.cpp | output
	dotnet fsi qc.fsx cpp > output/qc.fsx.cpp
	diff -s qc.cpp output/qc.fsx.cpp

test-fsx-scala: qc.fsx qc.scala | output
	dotnet fsi qc.fsx scala > output/qc.fsx.scala
	diff -s qc.scala output/qc.fsx.scala

test-fsx-f90: qc.fsx qc.f90 | output
	dotnet fsi qc.fsx f90 > output/qc.fsx.f90
	diff -s qc.f90 output/qc.fsx.f90

test-fsx-scm: qc.fsx qc.scm | output
	dotnet fsi qc.fsx scm > output/qc.fsx.scm
	diff -s qc.scm output/qc.fsx.scm

test-fsx-r: qc.fsx qc.r | output
	dotnet fsi qc.fsx r > output/qc.fsx.r
	diff -s qc.r output/qc.fsx.r

test-fsx-lua: qc.fsx qc.lua | output
	dotnet fsi qc.fsx lua > output/qc.fsx.lua
	diff -s qc.lua output/qc.fsx.lua

test-fsx-go: qc.fsx qc.go | output
	dotnet fsi qc.fsx go > output/qc.fsx.go
	diff -s qc.go output/qc.fsx.go

test-fsx-ps: qc.fsx qc.ps | output
	dotnet fsi qc.fsx ps > output/qc.fsx.ps
	diff -s qc.ps output/qc.fsx.ps

test-fsx-vala: qc.fsx qc.vala | output
	dotnet fsi qc.fsx vala > output/qc.fsx.vala
	diff -s qc.vala output/qc.fsx.vala

test-fsx-pike: qc.fsx qc.pike | output
	dotnet fsi qc.fsx pike > output/qc.fsx.pike
	diff -s qc.pike output/qc.fsx.pike

test-fsx-pas: qc.fsx qc.pas | output
	dotnet fsi qc.fsx pas > output/qc.fsx.pas
	diff -s qc.pas output/qc.fsx.pas

test-fsx-kt: qc.fsx qc.kt | output
	dotnet fsi qc.fsx kt > output/qc.fsx.kt
	diff -s qc.kt output/qc.fsx.kt

test-fsx-m: qc.fsx qc.m | output
	dotnet fsi qc.fsx m > output/qc.fsx.m
	diff -s qc.m output/qc.fsx.m

test-fsx-ml: qc.fsx qc.ml | output
	dotnet fsi qc.fsx ml > output/qc.fsx.ml
	diff -s qc.ml output/qc.fsx.ml

test-fsx-hs: qc.fsx qc.hs | output
	dotnet fsi qc.fsx hs > output/qc.fsx.hs
	diff -s qc.hs output/qc.fsx.hs

test-fsx-zig: qc.fsx qc.zig | output
	dotnet fsi qc.fsx zig > output/qc.fsx.zig
	diff -s qc.zig output/qc.fsx.zig

test-fsx-sml: qc.fsx qc.sml | output
	dotnet fsi qc.fsx sml > output/qc.fsx.sml
	diff -s qc.sml output/qc.fsx.sml

test-fsx-octave: qc.fsx qc.octave | output
	dotnet fsi qc.fsx octave > output/qc.fsx.octave
	diff -s qc.octave output/qc.fsx.octave

test-fsx-groovy: qc.fsx qc.groovy | output
	dotnet fsi qc.fsx groovy > output/qc.fsx.groovy
	diff -s qc.groovy output/qc.fsx.groovy

test-fsx-ws: qc.fsx qc.ws | output
	dotnet fsi qc.fsx ws > output/qc.fsx.ws
	diff -s qc.ws output/qc.fsx.ws

test-fsx-coffee: qc.fsx qc.coffee | output
	dotnet fsi qc.fsx coffee > output/qc.fsx.coffee
	diff -s qc.coffee output/qc.fsx.coffee

test-fsx-swift: qc.fsx qc.swift | output
	dotnet fsi qc.fsx swift > output/qc.fsx.swift
	diff -s qc.swift output/qc.fsx.swift

test-fsx-py: qc.fsx qc.py | output
	dotnet fsi qc.fsx py > output/qc.fsx.py
	diff -s qc.py output/qc.fsx.py

test-fsx-fs: qc.fsx qc.fs | output
	dotnet fsi qc.fsx fs > output/qc.fsx.fs
	diff -s qc.fs output/qc.fsx.fs

test-fsx-nim: qc.fsx qc.nim | output
	dotnet fsi qc.fsx nim > output/qc.fsx.nim
	diff -s qc.nim output/qc.fsx.nim

test-fsx-fsx: qc.fsx qc.fsx | output
	dotnet fsi qc.fsx > output/qc.fsx.fsx
	diff -s qc.fsx output/qc.fsx.fsx

test-fsx-tcl: qc.fsx qc.tcl | output
	dotnet fsi qc.fsx tcl > output/qc.fsx.tcl
	diff -s qc.tcl output/qc.fsx.tcl

test-fsx-bf: qc.fsx qc.bf | output
	dotnet fsi qc.fsx bf > output/qc.fsx.bf
	diff -s qc.bf output/qc.fsx.bf

test-fsx-java: qc.fsx qc.java | output
	dotnet fsi qc.fsx java > output/qc.fsx.java
	diff -s qc.java output/qc.fsx.java

test-fsx-php: qc.fsx qc.php | output
	dotnet fsi qc.fsx php > output/qc.fsx.php
	diff -s qc.php output/qc.fsx.php

test-fsx-bash: qc.fsx qc.bash | output
	dotnet fsi qc.fsx bash > output/qc.fsx.bash
	diff -s qc.bash output/qc.fsx.bash

test-fsx-d: qc.fsx qc.d | output
	dotnet fsi qc.fsx d > output/qc.fsx.d
	diff -s qc.d output/qc.fsx.d

test-fsx-pl: qc.fsx qc.pl | output
	dotnet fsi qc.fsx pl > output/qc.fsx.pl
	diff -s qc.pl output/qc.fsx.pl

test-fsx-exs: qc.fsx qc.exs | output
	dotnet fsi qc.fsx exs > output/qc.fsx.exs
	diff -s qc.exs output/qc.fsx.exs

test-fsx-rb: qc.fsx qc.rb | output
	dotnet fsi qc.fsx rb > output/qc.fsx.rb
	diff -s qc.rb output/qc.fsx.rb

test-fsx-js: qc.fsx qc.js | output
	dotnet fsi qc.fsx js > output/qc.fsx.js
	diff -s qc.js output/qc.fsx.js

test-fsx-ts: qc.fsx qc.ts | output
	dotnet fsi qc.fsx ts > output/qc.fsx.ts
	diff -s qc.ts output/qc.fsx.ts

test-fsx-erl: qc.fsx qc.erl | output
	dotnet fsi qc.fsx erl > output/qc.fsx.erl
	diff -s qc.erl output/qc.fsx.erl

test-fsx-cs: qc.fsx qc.cs | output
	dotnet fsi qc.fsx cs > output/qc.fsx.cs
	diff -s qc.cs output/qc.fsx.cs

test-fsx-prolog: qc.fsx qc.prolog | output
	dotnet fsi qc.fsx prolog > output/qc.fsx.prolog
	diff -s qc.prolog output/qc.fsx.prolog

test-fsx-cr: qc.fsx qc.cr | output
	dotnet fsi qc.fsx cr > output/qc.fsx.cr
	diff -s qc.cr output/qc.fsx.cr

test-fsx-unl: qc.fsx qc.unl | output
	dotnet fsi qc.fsx unl > output/qc.fsx.unl
	diff -s qc.unl output/qc.fsx.unl

test-fsx-hx: qc.fsx qc.hx | output
	dotnet fsi qc.fsx hx > output/qc.fsx.hx
	diff -s qc.hx output/qc.fsx.hx

test-fsx-bef: qc.fsx qc.bef | output
	dotnet fsi qc.fsx bef > output/qc.fsx.bef
	diff -s qc.bef output/qc.fsx.bef

test-fsx-awk: qc.fsx qc.awk | output
	dotnet fsi qc.fsx awk > output/qc.fsx.awk
	diff -s qc.awk output/qc.fsx.awk

test-fsx-piet: qc.fsx qc.piet.gif | output
	dotnet fsi qc.fsx piet > output/qc.fsx.piet
	diff -s qc.piet.gif output/qc.fsx.piet

test-tcl-clj: qc.tcl qc.clj | output
	tclsh qc.tcl clj > output/qc.tcl.clj
	diff -s qc.clj output/qc.tcl.clj

test-tcl-lisp: qc.tcl qc.lisp | output
	tclsh qc.tcl lisp > output/qc.tcl.lisp
	diff -s qc.lisp output/qc.tcl.lisp

test-tcl-rkt: qc.tcl qc.rkt | output
	tclsh qc.tcl rkt > output/qc.tcl.rkt
	diff -s qc.rkt output/qc.tcl.rkt

test-tcl-rs: qc.tcl qc.rs | output
	tclsh qc.tcl rs > output/qc.tcl.rs
	diff -s qc.rs output/qc.tcl.rs

test-tcl-c: qc.tcl qc.c | output
	tclsh qc.tcl c > output/qc.tcl.c
	diff -s qc.c output/qc.tcl.c

test-tcl-cpp: qc.tcl qc.cpp | output
	tclsh qc.tcl cpp > output/qc.tcl.cpp
	diff -s qc.cpp output/qc.tcl.cpp

test-tcl-scala: qc.tcl qc.scala | output
	tclsh qc.tcl scala > output/qc.tcl.scala
	diff -s qc.scala output/qc.tcl.scala

test-tcl-f90: qc.tcl qc.f90 | output
	tclsh qc.tcl f90 > output/qc.tcl.f90
	diff -s qc.f90 output/qc.tcl.f90

test-tcl-scm: qc.tcl qc.scm | output
	tclsh qc.tcl scm > output/qc.tcl.scm
	diff -s qc.scm output/qc.tcl.scm

test-tcl-r: qc.tcl qc.r | output
	tclsh qc.tcl r > output/qc.tcl.r
	diff -s qc.r output/qc.tcl.r

test-tcl-lua: qc.tcl qc.lua | output
	tclsh qc.tcl lua > output/qc.tcl.lua
	diff -s qc.lua output/qc.tcl.lua

test-tcl-go: qc.tcl qc.go | output
	tclsh qc.tcl go > output/qc.tcl.go
	diff -s qc.go output/qc.tcl.go

test-tcl-ps: qc.tcl qc.ps | output
	tclsh qc.tcl ps > output/qc.tcl.ps
	diff -s qc.ps output/qc.tcl.ps

test-tcl-vala: qc.tcl qc.vala | output
	tclsh qc.tcl vala > output/qc.tcl.vala
	diff -s qc.vala output/qc.tcl.vala

test-tcl-pike: qc.tcl qc.pike | output
	tclsh qc.tcl pike > output/qc.tcl.pike
	diff -s qc.pike output/qc.tcl.pike

test-tcl-pas: qc.tcl qc.pas | output
	tclsh qc.tcl pas > output/qc.tcl.pas
	diff -s qc.pas output/qc.tcl.pas

test-tcl-kt: qc.tcl qc.kt | output
	tclsh qc.tcl kt > output/qc.tcl.kt
	diff -s qc.kt output/qc.tcl.kt

test-tcl-m: qc.tcl qc.m | output
	tclsh qc.tcl m > output/qc.tcl.m
	diff -s qc.m output/qc.tcl.m

test-tcl-ml: qc.tcl qc.ml | output
	tclsh qc.tcl ml > output/qc.tcl.ml
	diff -s qc.ml output/qc.tcl.ml

test-tcl-hs: qc.tcl qc.hs | output
	tclsh qc.tcl hs > output/qc.tcl.hs
	diff -s qc.hs output/qc.tcl.hs

test-tcl-zig: qc.tcl qc.zig | output
	tclsh qc.tcl zig > output/qc.tcl.zig
	diff -s qc.zig output/qc.tcl.zig

test-tcl-sml: qc.tcl qc.sml | output
	tclsh qc.tcl sml > output/qc.tcl.sml
	diff -s qc.sml output/qc.tcl.sml

test-tcl-octave: qc.tcl qc.octave | output
	tclsh qc.tcl octave > output/qc.tcl.octave
	diff -s qc.octave output/qc.tcl.octave

test-tcl-groovy: qc.tcl qc.groovy | output
	tclsh qc.tcl groovy > output/qc.tcl.groovy
	diff -s qc.groovy output/qc.tcl.groovy

test-tcl-ws: qc.tcl qc.ws | output
	tclsh qc.tcl ws > output/qc.tcl.ws
	diff -s qc.ws output/qc.tcl.ws

test-tcl-coffee: qc.tcl qc.coffee | output
	tclsh qc.tcl coffee > output/qc.tcl.coffee
	diff -s qc.coffee output/qc.tcl.coffee

test-tcl-swift: qc.tcl qc.swift | output
	tclsh qc.tcl swift > output/qc.tcl.swift
	diff -s qc.swift output/qc.tcl.swift

test-tcl-py: qc.tcl qc.py | output
	tclsh qc.tcl py > output/qc.tcl.py
	diff -s qc.py output/qc.tcl.py

test-tcl-fs: qc.tcl qc.fs | output
	tclsh qc.tcl fs > output/qc.tcl.fs
	diff -s qc.fs output/qc.tcl.fs

test-tcl-nim: qc.tcl qc.nim | output
	tclsh qc.tcl nim > output/qc.tcl.nim
	diff -s qc.nim output/qc.tcl.nim

test-tcl-fsx: qc.tcl qc.fsx | output
	tclsh qc.tcl fsx > output/qc.tcl.fsx
	diff -s qc.fsx output/qc.tcl.fsx

test-tcl-tcl: qc.tcl qc.tcl | output
	tclsh qc.tcl > output/qc.tcl.tcl
	diff -s qc.tcl output/qc.tcl.tcl

test-tcl-bf: qc.tcl qc.bf | output
	tclsh qc.tcl bf > output/qc.tcl.bf
	diff -s qc.bf output/qc.tcl.bf

test-tcl-java: qc.tcl qc.java | output
	tclsh qc.tcl java > output/qc.tcl.java
	diff -s qc.java output/qc.tcl.java

test-tcl-php: qc.tcl qc.php | output
	tclsh qc.tcl php > output/qc.tcl.php
	diff -s qc.php output/qc.tcl.php

test-tcl-bash: qc.tcl qc.bash | output
	tclsh qc.tcl bash > output/qc.tcl.bash
	diff -s qc.bash output/qc.tcl.bash

test-tcl-d: qc.tcl qc.d | output
	tclsh qc.tcl d > output/qc.tcl.d
	diff -s qc.d output/qc.tcl.d

test-tcl-pl: qc.tcl qc.pl | output
	tclsh qc.tcl pl > output/qc.tcl.pl
	diff -s qc.pl output/qc.tcl.pl

test-tcl-exs: qc.tcl qc.exs | output
	tclsh qc.tcl exs > output/qc.tcl.exs
	diff -s qc.exs output/qc.tcl.exs

test-tcl-rb: qc.tcl qc.rb | output
	tclsh qc.tcl rb > output/qc.tcl.rb
	diff -s qc.rb output/qc.tcl.rb

test-tcl-js: qc.tcl qc.js | output
	tclsh qc.tcl js > output/qc.tcl.js
	diff -s qc.js output/qc.tcl.js

test-tcl-ts: qc.tcl qc.ts | output
	tclsh qc.tcl ts > output/qc.tcl.ts
	diff -s qc.ts output/qc.tcl.ts

test-tcl-erl: qc.tcl qc.erl | output
	tclsh qc.tcl erl > output/qc.tcl.erl
	diff -s qc.erl output/qc.tcl.erl

test-tcl-cs: qc.tcl qc.cs | output
	tclsh qc.tcl cs > output/qc.tcl.cs
	diff -s qc.cs output/qc.tcl.cs

test-tcl-prolog: qc.tcl qc.prolog | output
	tclsh qc.tcl prolog > output/qc.tcl.prolog
	diff -s qc.prolog output/qc.tcl.prolog

test-tcl-cr: qc.tcl qc.cr | output
	tclsh qc.tcl cr > output/qc.tcl.cr
	diff -s qc.cr output/qc.tcl.cr

test-tcl-unl: qc.tcl qc.unl | output
	tclsh qc.tcl unl > output/qc.tcl.unl
	diff -s qc.unl output/qc.tcl.unl

test-tcl-hx: qc.tcl qc.hx | output
	tclsh qc.tcl hx > output/qc.tcl.hx
	diff -s qc.hx output/qc.tcl.hx

test-tcl-bef: qc.tcl qc.bef | output
	tclsh qc.tcl bef > output/qc.tcl.bef
	diff -s qc.bef output/qc.tcl.bef

test-tcl-awk: qc.tcl qc.awk | output
	tclsh qc.tcl awk > output/qc.tcl.awk
	diff -s qc.awk output/qc.tcl.awk

test-tcl-piet: qc.tcl qc.piet.gif | output
	tclsh qc.tcl piet > output/qc.tcl.piet
	diff -s qc.piet.gif output/qc.tcl.piet

test-bf-clj: qc.bf vendor/bin/bf qc.clj | output
	echo clj | vendor/bin/bf qc.bf > output/qc.bf.clj
	diff -s qc.clj output/qc.bf.clj

test-bf-lisp: qc.bf vendor/bin/bf qc.lisp | output
	echo lisp | vendor/bin/bf qc.bf > output/qc.bf.lisp
	diff -s qc.lisp output/qc.bf.lisp

test-bf-rkt: qc.bf vendor/bin/bf qc.rkt | output
	echo rkt | vendor/bin/bf qc.bf > output/qc.bf.rkt
	diff -s qc.rkt output/qc.bf.rkt

test-bf-rs: qc.bf vendor/bin/bf qc.rs | output
	echo rs | vendor/bin/bf qc.bf > output/qc.bf.rs
	diff -s qc.rs output/qc.bf.rs

test-bf-c: qc.bf vendor/bin/bf qc.c | output
	echo c | vendor/bin/bf qc.bf > output/qc.bf.c
	diff -s qc.c output/qc.bf.c

test-bf-cpp: qc.bf vendor/bin/bf qc.cpp | output
	echo cpp | vendor/bin/bf qc.bf > output/qc.bf.cpp
	diff -s qc.cpp output/qc.bf.cpp

test-bf-scala: qc.bf vendor/bin/bf qc.scala | output
	echo scala | vendor/bin/bf qc.bf > output/qc.bf.scala
	diff -s qc.scala output/qc.bf.scala

test-bf-f90: qc.bf vendor/bin/bf qc.f90 | output
	echo f90 | vendor/bin/bf qc.bf > output/qc.bf.f90
	diff -s qc.f90 output/qc.bf.f90

test-bf-scm: qc.bf vendor/bin/bf qc.scm | output
	echo scm | vendor/bin/bf qc.bf > output/qc.bf.scm
	diff -s qc.scm output/qc.bf.scm

test-bf-r: qc.bf vendor/bin/bf qc.r | output
	echo r | vendor/bin/bf qc.bf > output/qc.bf.r
	diff -s qc.r output/qc.bf.r

test-bf-lua: qc.bf vendor/bin/bf qc.lua | output
	echo lua | vendor/bin/bf qc.bf > output/qc.bf.lua
	diff -s qc.lua output/qc.bf.lua

test-bf-go: qc.bf vendor/bin/bf qc.go | output
	echo go | vendor/bin/bf qc.bf > output/qc.bf.go
	diff -s qc.go output/qc.bf.go

test-bf-ps: qc.bf vendor/bin/bf qc.ps | output
	echo ps | vendor/bin/bf qc.bf > output/qc.bf.ps
	diff -s qc.ps output/qc.bf.ps

test-bf-vala: qc.bf vendor/bin/bf qc.vala | output
	echo vala | vendor/bin/bf qc.bf > output/qc.bf.vala
	diff -s qc.vala output/qc.bf.vala

test-bf-pike: qc.bf vendor/bin/bf qc.pike | output
	echo pike | vendor/bin/bf qc.bf > output/qc.bf.pike
	diff -s qc.pike output/qc.bf.pike

test-bf-pas: qc.bf vendor/bin/bf qc.pas | output
	echo pas | vendor/bin/bf qc.bf > output/qc.bf.pas
	diff -s qc.pas output/qc.bf.pas

test-bf-kt: qc.bf vendor/bin/bf qc.kt | output
	echo kt | vendor/bin/bf qc.bf > output/qc.bf.kt
	diff -s qc.kt output/qc.bf.kt

test-bf-m: qc.bf vendor/bin/bf qc.m | output
	echo m | vendor/bin/bf qc.bf > output/qc.bf.m
	diff -s qc.m output/qc.bf.m

test-bf-ml: qc.bf vendor/bin/bf qc.ml | output
	echo ml | vendor/bin/bf qc.bf > output/qc.bf.ml
	diff -s qc.ml output/qc.bf.ml

test-bf-hs: qc.bf vendor/bin/bf qc.hs | output
	echo hs | vendor/bin/bf qc.bf > output/qc.bf.hs
	diff -s qc.hs output/qc.bf.hs

test-bf-zig: qc.bf vendor/bin/bf qc.zig | output
	echo zig | vendor/bin/bf qc.bf > output/qc.bf.zig
	diff -s qc.zig output/qc.bf.zig

test-bf-sml: qc.bf vendor/bin/bf qc.sml | output
	echo sml | vendor/bin/bf qc.bf > output/qc.bf.sml
	diff -s qc.sml output/qc.bf.sml

test-bf-octave: qc.bf vendor/bin/bf qc.octave | output
	echo octave | vendor/bin/bf qc.bf > output/qc.bf.octave
	diff -s qc.octave output/qc.bf.octave

test-bf-groovy: qc.bf vendor/bin/bf qc.groovy | output
	echo groovy | vendor/bin/bf qc.bf > output/qc.bf.groovy
	diff -s qc.groovy output/qc.bf.groovy

test-bf-ws: qc.bf vendor/bin/bf qc.ws | output
	echo ws | vendor/bin/bf qc.bf > output/qc.bf.ws
	diff -s qc.ws output/qc.bf.ws

test-bf-coffee: qc.bf vendor/bin/bf qc.coffee | output
	echo coffee | vendor/bin/bf qc.bf > output/qc.bf.coffee
	diff -s qc.coffee output/qc.bf.coffee

test-bf-swift: qc.bf vendor/bin/bf qc.swift | output
	echo swift | vendor/bin/bf qc.bf > output/qc.bf.swift
	diff -s qc.swift output/qc.bf.swift

test-bf-py: qc.bf vendor/bin/bf qc.py | output
	echo py | vendor/bin/bf qc.bf > output/qc.bf.py
	diff -s qc.py output/qc.bf.py

test-bf-fs: qc.bf vendor/bin/bf qc.fs | output
	echo fs | vendor/bin/bf qc.bf > output/qc.bf.fs
	diff -s qc.fs output/qc.bf.fs

test-bf-nim: qc.bf vendor/bin/bf qc.nim | output
	echo nim | vendor/bin/bf qc.bf > output/qc.bf.nim
	diff -s qc.nim output/qc.bf.nim

test-bf-fsx: qc.bf vendor/bin/bf qc.fsx | output
	echo fsx | vendor/bin/bf qc.bf > output/qc.bf.fsx
	diff -s qc.fsx output/qc.bf.fsx

test-bf-tcl: qc.bf vendor/bin/bf qc.tcl | output
	echo tcl | vendor/bin/bf qc.bf > output/qc.bf.tcl
	diff -s qc.tcl output/qc.bf.tcl

test-bf-bf: qc.bf vendor/bin/bf qc.bf | output
	echo | vendor/bin/bf qc.bf > output/qc.bf.bf
	diff -s qc.bf output/qc.bf.bf

test-bf-java: qc.bf vendor/bin/bf qc.java | output
	echo java | vendor/bin/bf qc.bf > output/qc.bf.java
	diff -s qc.java output/qc.bf.java

test-bf-php: qc.bf vendor/bin/bf qc.php | output
	echo php | vendor/bin/bf qc.bf > output/qc.bf.php
	diff -s qc.php output/qc.bf.php

test-bf-bash: qc.bf vendor/bin/bf qc.bash | output
	echo bash | vendor/bin/bf qc.bf > output/qc.bf.bash
	diff -s qc.bash output/qc.bf.bash

test-bf-d: qc.bf vendor/bin/bf qc.d | output
	echo d | vendor/bin/bf qc.bf > output/qc.bf.d
	diff -s qc.d output/qc.bf.d

test-bf-pl: qc.bf vendor/bin/bf qc.pl | output
	echo pl | vendor/bin/bf qc.bf > output/qc.bf.pl
	diff -s qc.pl output/qc.bf.pl

test-bf-exs: qc.bf vendor/bin/bf qc.exs | output
	echo exs | vendor/bin/bf qc.bf > output/qc.bf.exs
	diff -s qc.exs output/qc.bf.exs

test-bf-rb: qc.bf vendor/bin/bf qc.rb | output
	echo rb | vendor/bin/bf qc.bf > output/qc.bf.rb
	diff -s qc.rb output/qc.bf.rb

test-bf-js: qc.bf vendor/bin/bf qc.js | output
	echo js | vendor/bin/bf qc.bf > output/qc.bf.js
	diff -s qc.js output/qc.bf.js

test-bf-ts: qc.bf vendor/bin/bf qc.ts | output
	echo ts | vendor/bin/bf qc.bf > output/qc.bf.ts
	diff -s qc.ts output/qc.bf.ts

test-bf-erl: qc.bf vendor/bin/bf qc.erl | output
	echo erl | vendor/bin/bf qc.bf > output/qc.bf.erl
	diff -s qc.erl output/qc.bf.erl

test-bf-cs: qc.bf vendor/bin/bf qc.cs | output
	echo cs | vendor/bin/bf qc.bf > output/qc.bf.cs
	diff -s qc.cs output/qc.bf.cs

test-bf-prolog: qc.bf vendor/bin/bf qc.prolog | output
	echo prolog | vendor/bin/bf qc.bf > output/qc.bf.prolog
	diff -s qc.prolog output/qc.bf.prolog

test-bf-cr: qc.bf vendor/bin/bf qc.cr | output
	echo cr | vendor/bin/bf qc.bf > output/qc.bf.cr
	diff -s qc.cr output/qc.bf.cr

test-bf-unl: qc.bf vendor/bin/bf qc.unl | output
	echo unl | vendor/bin/bf qc.bf > output/qc.bf.unl
	diff -s qc.unl output/qc.bf.unl

test-bf-hx: qc.bf vendor/bin/bf qc.hx | output
	echo hx | vendor/bin/bf qc.bf > output/qc.bf.hx
	diff -s qc.hx output/qc.bf.hx

test-bf-bef: qc.bf vendor/bin/bf qc.bef | output
	echo bef | vendor/bin/bf qc.bf > output/qc.bf.bef
	diff -s qc.bef output/qc.bf.bef

test-bf-awk: qc.bf vendor/bin/bf qc.awk | output
	echo awk | vendor/bin/bf qc.bf > output/qc.bf.awk
	diff -s qc.awk output/qc.bf.awk

test-bf-piet: qc.bf vendor/bin/bf qc.piet.gif | output
	echo piet | vendor/bin/bf qc.bf > output/qc.bf.piet
	diff -s qc.piet.gif output/qc.bf.piet

test-java-clj: build/qc.class qc.clj | output
	java -cp build qc clj > output/qc.java.clj
	diff -s qc.clj output/qc.java.clj

test-java-lisp: build/qc.class qc.lisp | output
	java -cp build qc lisp > output/qc.java.lisp
	diff -s qc.lisp output/qc.java.lisp

test-java-rkt: build/qc.class qc.rkt | output
	java -cp build qc rkt > output/qc.java.rkt
	diff -s qc.rkt output/qc.java.rkt

test-java-rs: build/qc.class qc.rs | output
	java -cp build qc rs > output/qc.java.rs
	diff -s qc.rs output/qc.java.rs

test-java-c: build/qc.class qc.c | output
	java -cp build qc c > output/qc.java.c
	diff -s qc.c output/qc.java.c

test-java-cpp: build/qc.class qc.cpp | output
	java -cp build qc cpp > output/qc.java.cpp
	diff -s qc.cpp output/qc.java.cpp

test-java-scala: build/qc.class qc.scala | output
	java -cp build qc scala > output/qc.java.scala
	diff -s qc.scala output/qc.java.scala

test-java-f90: build/qc.class qc.f90 | output
	java -cp build qc f90 > output/qc.java.f90
	diff -s qc.f90 output/qc.java.f90

test-java-scm: build/qc.class qc.scm | output
	java -cp build qc scm > output/qc.java.scm
	diff -s qc.scm output/qc.java.scm

test-java-r: build/qc.class qc.r | output
	java -cp build qc r > output/qc.java.r
	diff -s qc.r output/qc.java.r

test-java-lua: build/qc.class qc.lua | output
	java -cp build qc lua > output/qc.java.lua
	diff -s qc.lua output/qc.java.lua

test-java-go: build/qc.class qc.go | output
	java -cp build qc go > output/qc.java.go
	diff -s qc.go output/qc.java.go

test-java-ps: build/qc.class qc.ps | output
	java -cp build qc ps > output/qc.java.ps
	diff -s qc.ps output/qc.java.ps

test-java-vala: build/qc.class qc.vala | output
	java -cp build qc vala > output/qc.java.vala
	diff -s qc.vala output/qc.java.vala

test-java-pike: build/qc.class qc.pike | output
	java -cp build qc pike > output/qc.java.pike
	diff -s qc.pike output/qc.java.pike

test-java-pas: build/qc.class qc.pas | output
	java -cp build qc pas > output/qc.java.pas
	diff -s qc.pas output/qc.java.pas

test-java-kt: build/qc.class qc.kt | output
	java -cp build qc kt > output/qc.java.kt
	diff -s qc.kt output/qc.java.kt

test-java-m: build/qc.class qc.m | output
	java -cp build qc m > output/qc.java.m
	diff -s qc.m output/qc.java.m

test-java-ml: build/qc.class qc.ml | output
	java -cp build qc ml > output/qc.java.ml
	diff -s qc.ml output/qc.java.ml

test-java-hs: build/qc.class qc.hs | output
	java -cp build qc hs > output/qc.java.hs
	diff -s qc.hs output/qc.java.hs

test-java-zig: build/qc.class qc.zig | output
	java -cp build qc zig > output/qc.java.zig
	diff -s qc.zig output/qc.java.zig

test-java-sml: build/qc.class qc.sml | output
	java -cp build qc sml > output/qc.java.sml
	diff -s qc.sml output/qc.java.sml

test-java-octave: build/qc.class qc.octave | output
	java -cp build qc octave > output/qc.java.octave
	diff -s qc.octave output/qc.java.octave

test-java-groovy: build/qc.class qc.groovy | output
	java -cp build qc groovy > output/qc.java.groovy
	diff -s qc.groovy output/qc.java.groovy

test-java-ws: build/qc.class qc.ws | output
	java -cp build qc ws > output/qc.java.ws
	diff -s qc.ws output/qc.java.ws

test-java-coffee: build/qc.class qc.coffee | output
	java -cp build qc coffee > output/qc.java.coffee
	diff -s qc.coffee output/qc.java.coffee

test-java-swift: build/qc.class qc.swift | output
	java -cp build qc swift > output/qc.java.swift
	diff -s qc.swift output/qc.java.swift

test-java-py: build/qc.class qc.py | output
	java -cp build qc py > output/qc.java.py
	diff -s qc.py output/qc.java.py

test-java-fs: build/qc.class qc.fs | output
	java -cp build qc fs > output/qc.java.fs
	diff -s qc.fs output/qc.java.fs

test-java-nim: build/qc.class qc.nim | output
	java -cp build qc nim > output/qc.java.nim
	diff -s qc.nim output/qc.java.nim

test-java-fsx: build/qc.class qc.fsx | output
	java -cp build qc fsx > output/qc.java.fsx
	diff -s qc.fsx output/qc.java.fsx

test-java-tcl: build/qc.class qc.tcl | output
	java -cp build qc tcl > output/qc.java.tcl
	diff -s qc.tcl output/qc.java.tcl

test-java-bf: build/qc.class qc.bf | output
	java -cp build qc bf > output/qc.java.bf
	diff -s qc.bf output/qc.java.bf

test-java-java: build/qc.class qc.java | output
	java -cp build qc > output/qc.java.java
	diff -s qc.java output/qc.java.java

test-java-php: build/qc.class qc.php | output
	java -cp build qc php > output/qc.java.php
	diff -s qc.php output/qc.java.php

test-java-bash: build/qc.class qc.bash | output
	java -cp build qc bash > output/qc.java.bash
	diff -s qc.bash output/qc.java.bash

test-java-d: build/qc.class qc.d | output
	java -cp build qc d > output/qc.java.d
	diff -s qc.d output/qc.java.d

test-java-pl: build/qc.class qc.pl | output
	java -cp build qc pl > output/qc.java.pl
	diff -s qc.pl output/qc.java.pl

test-java-exs: build/qc.class qc.exs | output
	java -cp build qc exs > output/qc.java.exs
	diff -s qc.exs output/qc.java.exs

test-java-rb: build/qc.class qc.rb | output
	java -cp build qc rb > output/qc.java.rb
	diff -s qc.rb output/qc.java.rb

test-java-js: build/qc.class qc.js | output
	java -cp build qc js > output/qc.java.js
	diff -s qc.js output/qc.java.js

test-java-ts: build/qc.class qc.ts | output
	java -cp build qc ts > output/qc.java.ts
	diff -s qc.ts output/qc.java.ts

test-java-erl: build/qc.class qc.erl | output
	java -cp build qc erl > output/qc.java.erl
	diff -s qc.erl output/qc.java.erl

test-java-cs: build/qc.class qc.cs | output
	java -cp build qc cs > output/qc.java.cs
	diff -s qc.cs output/qc.java.cs

test-java-prolog: build/qc.class qc.prolog | output
	java -cp build qc prolog > output/qc.java.prolog
	diff -s qc.prolog output/qc.java.prolog

test-java-cr: build/qc.class qc.cr | output
	java -cp build qc cr > output/qc.java.cr
	diff -s qc.cr output/qc.java.cr

test-java-unl: build/qc.class qc.unl | output
	java -cp build qc unl > output/qc.java.unl
	diff -s qc.unl output/qc.java.unl

test-java-hx: build/qc.class qc.hx | output
	java -cp build qc hx > output/qc.java.hx
	diff -s qc.hx output/qc.java.hx

test-java-bef: build/qc.class qc.bef | output
	java -cp build qc bef > output/qc.java.bef
	diff -s qc.bef output/qc.java.bef

test-java-awk: build/qc.class qc.awk | output
	java -cp build qc awk > output/qc.java.awk
	diff -s qc.awk output/qc.java.awk

test-java-piet: build/qc.class qc.piet.gif | output
	java -cp build qc piet > output/qc.java.piet
	diff -s qc.piet.gif output/qc.java.piet

test-php-clj: qc.php qc.clj | output
	php qc.php clj > output/qc.php.clj
	diff -s qc.clj output/qc.php.clj

test-php-lisp: qc.php qc.lisp | output
	php qc.php lisp > output/qc.php.lisp
	diff -s qc.lisp output/qc.php.lisp

test-php-rkt: qc.php qc.rkt | output
	php qc.php rkt > output/qc.php.rkt
	diff -s qc.rkt output/qc.php.rkt

test-php-rs: qc.php qc.rs | output
	php qc.php rs > output/qc.php.rs
	diff -s qc.rs output/qc.php.rs

test-php-c: qc.php qc.c | output
	php qc.php c > output/qc.php.c
	diff -s qc.c output/qc.php.c

test-php-cpp: qc.php qc.cpp | output
	php qc.php cpp > output/qc.php.cpp
	diff -s qc.cpp output/qc.php.cpp

test-php-scala: qc.php qc.scala | output
	php qc.php scala > output/qc.php.scala
	diff -s qc.scala output/qc.php.scala

test-php-f90: qc.php qc.f90 | output
	php qc.php f90 > output/qc.php.f90
	diff -s qc.f90 output/qc.php.f90

test-php-scm: qc.php qc.scm | output
	php qc.php scm > output/qc.php.scm
	diff -s qc.scm output/qc.php.scm

test-php-r: qc.php qc.r | output
	php qc.php r > output/qc.php.r
	diff -s qc.r output/qc.php.r

test-php-lua: qc.php qc.lua | output
	php qc.php lua > output/qc.php.lua
	diff -s qc.lua output/qc.php.lua

test-php-go: qc.php qc.go | output
	php qc.php go > output/qc.php.go
	diff -s qc.go output/qc.php.go

test-php-ps: qc.php qc.ps | output
	php qc.php ps > output/qc.php.ps
	diff -s qc.ps output/qc.php.ps

test-php-vala: qc.php qc.vala | output
	php qc.php vala > output/qc.php.vala
	diff -s qc.vala output/qc.php.vala

test-php-pike: qc.php qc.pike | output
	php qc.php pike > output/qc.php.pike
	diff -s qc.pike output/qc.php.pike

test-php-pas: qc.php qc.pas | output
	php qc.php pas > output/qc.php.pas
	diff -s qc.pas output/qc.php.pas

test-php-kt: qc.php qc.kt | output
	php qc.php kt > output/qc.php.kt
	diff -s qc.kt output/qc.php.kt

test-php-m: qc.php qc.m | output
	php qc.php m > output/qc.php.m
	diff -s qc.m output/qc.php.m

test-php-ml: qc.php qc.ml | output
	php qc.php ml > output/qc.php.ml
	diff -s qc.ml output/qc.php.ml

test-php-hs: qc.php qc.hs | output
	php qc.php hs > output/qc.php.hs
	diff -s qc.hs output/qc.php.hs

test-php-zig: qc.php qc.zig | output
	php qc.php zig > output/qc.php.zig
	diff -s qc.zig output/qc.php.zig

test-php-sml: qc.php qc.sml | output
	php qc.php sml > output/qc.php.sml
	diff -s qc.sml output/qc.php.sml

test-php-octave: qc.php qc.octave | output
	php qc.php octave > output/qc.php.octave
	diff -s qc.octave output/qc.php.octave

test-php-groovy: qc.php qc.groovy | output
	php qc.php groovy > output/qc.php.groovy
	diff -s qc.groovy output/qc.php.groovy

test-php-ws: qc.php qc.ws | output
	php qc.php ws > output/qc.php.ws
	diff -s qc.ws output/qc.php.ws

test-php-coffee: qc.php qc.coffee | output
	php qc.php coffee > output/qc.php.coffee
	diff -s qc.coffee output/qc.php.coffee

test-php-swift: qc.php qc.swift | output
	php qc.php swift > output/qc.php.swift
	diff -s qc.swift output/qc.php.swift

test-php-py: qc.php qc.py | output
	php qc.php py > output/qc.php.py
	diff -s qc.py output/qc.php.py

test-php-fs: qc.php qc.fs | output
	php qc.php fs > output/qc.php.fs
	diff -s qc.fs output/qc.php.fs

test-php-nim: qc.php qc.nim | output
	php qc.php nim > output/qc.php.nim
	diff -s qc.nim output/qc.php.nim

test-php-fsx: qc.php qc.fsx | output
	php qc.php fsx > output/qc.php.fsx
	diff -s qc.fsx output/qc.php.fsx

test-php-tcl: qc.php qc.tcl | output
	php qc.php tcl > output/qc.php.tcl
	diff -s qc.tcl output/qc.php.tcl

test-php-bf: qc.php qc.bf | output
	php qc.php bf > output/qc.php.bf
	diff -s qc.bf output/qc.php.bf

test-php-java: qc.php qc.java | output
	php qc.php java > output/qc.php.java
	diff -s qc.java output/qc.php.java

test-php-php: qc.php qc.php | output
	php qc.php > output/qc.php.php
	diff -s qc.php output/qc.php.php

test-php-bash: qc.php qc.bash | output
	php qc.php bash > output/qc.php.bash
	diff -s qc.bash output/qc.php.bash

test-php-d: qc.php qc.d | output
	php qc.php d > output/qc.php.d
	diff -s qc.d output/qc.php.d

test-php-pl: qc.php qc.pl | output
	php qc.php pl > output/qc.php.pl
	diff -s qc.pl output/qc.php.pl

test-php-exs: qc.php qc.exs | output
	php qc.php exs > output/qc.php.exs
	diff -s qc.exs output/qc.php.exs

test-php-rb: qc.php qc.rb | output
	php qc.php rb > output/qc.php.rb
	diff -s qc.rb output/qc.php.rb

test-php-js: qc.php qc.js | output
	php qc.php js > output/qc.php.js
	diff -s qc.js output/qc.php.js

test-php-ts: qc.php qc.ts | output
	php qc.php ts > output/qc.php.ts
	diff -s qc.ts output/qc.php.ts

test-php-erl: qc.php qc.erl | output
	php qc.php erl > output/qc.php.erl
	diff -s qc.erl output/qc.php.erl

test-php-cs: qc.php qc.cs | output
	php qc.php cs > output/qc.php.cs
	diff -s qc.cs output/qc.php.cs

test-php-prolog: qc.php qc.prolog | output
	php qc.php prolog > output/qc.php.prolog
	diff -s qc.prolog output/qc.php.prolog

test-php-cr: qc.php qc.cr | output
	php qc.php cr > output/qc.php.cr
	diff -s qc.cr output/qc.php.cr

test-php-unl: qc.php qc.unl | output
	php qc.php unl > output/qc.php.unl
	diff -s qc.unl output/qc.php.unl

test-php-hx: qc.php qc.hx | output
	php qc.php hx > output/qc.php.hx
	diff -s qc.hx output/qc.php.hx

test-php-bef: qc.php qc.bef | output
	php qc.php bef > output/qc.php.bef
	diff -s qc.bef output/qc.php.bef

test-php-awk: qc.php qc.awk | output
	php qc.php awk > output/qc.php.awk
	diff -s qc.awk output/qc.php.awk

test-php-piet: qc.php qc.piet.gif | output
	php qc.php piet > output/qc.php.piet
	diff -s qc.piet.gif output/qc.php.piet

test-bash-clj: qc.bash qc.clj | output
	bash qc.bash clj > output/qc.bash.clj
	diff -s qc.clj output/qc.bash.clj

test-bash-lisp: qc.bash qc.lisp | output
	bash qc.bash lisp > output/qc.bash.lisp
	diff -s qc.lisp output/qc.bash.lisp

test-bash-rkt: qc.bash qc.rkt | output
	bash qc.bash rkt > output/qc.bash.rkt
	diff -s qc.rkt output/qc.bash.rkt

test-bash-rs: qc.bash qc.rs | output
	bash qc.bash rs > output/qc.bash.rs
	diff -s qc.rs output/qc.bash.rs

test-bash-c: qc.bash qc.c | output
	bash qc.bash c > output/qc.bash.c
	diff -s qc.c output/qc.bash.c

test-bash-cpp: qc.bash qc.cpp | output
	bash qc.bash cpp > output/qc.bash.cpp
	diff -s qc.cpp output/qc.bash.cpp

test-bash-scala: qc.bash qc.scala | output
	bash qc.bash scala > output/qc.bash.scala
	diff -s qc.scala output/qc.bash.scala

test-bash-f90: qc.bash qc.f90 | output
	bash qc.bash f90 > output/qc.bash.f90
	diff -s qc.f90 output/qc.bash.f90

test-bash-scm: qc.bash qc.scm | output
	bash qc.bash scm > output/qc.bash.scm
	diff -s qc.scm output/qc.bash.scm

test-bash-r: qc.bash qc.r | output
	bash qc.bash r > output/qc.bash.r
	diff -s qc.r output/qc.bash.r

test-bash-lua: qc.bash qc.lua | output
	bash qc.bash lua > output/qc.bash.lua
	diff -s qc.lua output/qc.bash.lua

test-bash-go: qc.bash qc.go | output
	bash qc.bash go > output/qc.bash.go
	diff -s qc.go output/qc.bash.go

test-bash-ps: qc.bash qc.ps | output
	bash qc.bash ps > output/qc.bash.ps
	diff -s qc.ps output/qc.bash.ps

test-bash-vala: qc.bash qc.vala | output
	bash qc.bash vala > output/qc.bash.vala
	diff -s qc.vala output/qc.bash.vala

test-bash-pike: qc.bash qc.pike | output
	bash qc.bash pike > output/qc.bash.pike
	diff -s qc.pike output/qc.bash.pike

test-bash-pas: qc.bash qc.pas | output
	bash qc.bash pas > output/qc.bash.pas
	diff -s qc.pas output/qc.bash.pas

test-bash-kt: qc.bash qc.kt | output
	bash qc.bash kt > output/qc.bash.kt
	diff -s qc.kt output/qc.bash.kt

test-bash-m: qc.bash qc.m | output
	bash qc.bash m > output/qc.bash.m
	diff -s qc.m output/qc.bash.m

test-bash-ml: qc.bash qc.ml | output
	bash qc.bash ml > output/qc.bash.ml
	diff -s qc.ml output/qc.bash.ml

test-bash-hs: qc.bash qc.hs | output
	bash qc.bash hs > output/qc.bash.hs
	diff -s qc.hs output/qc.bash.hs

test-bash-zig: qc.bash qc.zig | output
	bash qc.bash zig > output/qc.bash.zig
	diff -s qc.zig output/qc.bash.zig

test-bash-sml: qc.bash qc.sml | output
	bash qc.bash sml > output/qc.bash.sml
	diff -s qc.sml output/qc.bash.sml

test-bash-octave: qc.bash qc.octave | output
	bash qc.bash octave > output/qc.bash.octave
	diff -s qc.octave output/qc.bash.octave

test-bash-groovy: qc.bash qc.groovy | output
	bash qc.bash groovy > output/qc.bash.groovy
	diff -s qc.groovy output/qc.bash.groovy

test-bash-ws: qc.bash qc.ws | output
	bash qc.bash ws > output/qc.bash.ws
	diff -s qc.ws output/qc.bash.ws

test-bash-coffee: qc.bash qc.coffee | output
	bash qc.bash coffee > output/qc.bash.coffee
	diff -s qc.coffee output/qc.bash.coffee

test-bash-swift: qc.bash qc.swift | output
	bash qc.bash swift > output/qc.bash.swift
	diff -s qc.swift output/qc.bash.swift

test-bash-py: qc.bash qc.py | output
	bash qc.bash py > output/qc.bash.py
	diff -s qc.py output/qc.bash.py

test-bash-fs: qc.bash qc.fs | output
	bash qc.bash fs > output/qc.bash.fs
	diff -s qc.fs output/qc.bash.fs

test-bash-nim: qc.bash qc.nim | output
	bash qc.bash nim > output/qc.bash.nim
	diff -s qc.nim output/qc.bash.nim

test-bash-fsx: qc.bash qc.fsx | output
	bash qc.bash fsx > output/qc.bash.fsx
	diff -s qc.fsx output/qc.bash.fsx

test-bash-tcl: qc.bash qc.tcl | output
	bash qc.bash tcl > output/qc.bash.tcl
	diff -s qc.tcl output/qc.bash.tcl

test-bash-bf: qc.bash qc.bf | output
	bash qc.bash bf > output/qc.bash.bf
	diff -s qc.bf output/qc.bash.bf

test-bash-java: qc.bash qc.java | output
	bash qc.bash java > output/qc.bash.java
	diff -s qc.java output/qc.bash.java

test-bash-php: qc.bash qc.php | output
	bash qc.bash php > output/qc.bash.php
	diff -s qc.php output/qc.bash.php

test-bash-bash: qc.bash qc.bash | output
	bash qc.bash > output/qc.bash.bash
	diff -s qc.bash output/qc.bash.bash

test-bash-d: qc.bash qc.d | output
	bash qc.bash d > output/qc.bash.d
	diff -s qc.d output/qc.bash.d

test-bash-pl: qc.bash qc.pl | output
	bash qc.bash pl > output/qc.bash.pl
	diff -s qc.pl output/qc.bash.pl

test-bash-exs: qc.bash qc.exs | output
	bash qc.bash exs > output/qc.bash.exs
	diff -s qc.exs output/qc.bash.exs

test-bash-rb: qc.bash qc.rb | output
	bash qc.bash rb > output/qc.bash.rb
	diff -s qc.rb output/qc.bash.rb

test-bash-js: qc.bash qc.js | output
	bash qc.bash js > output/qc.bash.js
	diff -s qc.js output/qc.bash.js

test-bash-ts: qc.bash qc.ts | output
	bash qc.bash ts > output/qc.bash.ts
	diff -s qc.ts output/qc.bash.ts

test-bash-erl: qc.bash qc.erl | output
	bash qc.bash erl > output/qc.bash.erl
	diff -s qc.erl output/qc.bash.erl

test-bash-cs: qc.bash qc.cs | output
	bash qc.bash cs > output/qc.bash.cs
	diff -s qc.cs output/qc.bash.cs

test-bash-prolog: qc.bash qc.prolog | output
	bash qc.bash prolog > output/qc.bash.prolog
	diff -s qc.prolog output/qc.bash.prolog

test-bash-cr: qc.bash qc.cr | output
	bash qc.bash cr > output/qc.bash.cr
	diff -s qc.cr output/qc.bash.cr

test-bash-unl: qc.bash qc.unl | output
	bash qc.bash unl > output/qc.bash.unl
	diff -s qc.unl output/qc.bash.unl

test-bash-hx: qc.bash qc.hx | output
	bash qc.bash hx > output/qc.bash.hx
	diff -s qc.hx output/qc.bash.hx

test-bash-bef: qc.bash qc.bef | output
	bash qc.bash bef > output/qc.bash.bef
	diff -s qc.bef output/qc.bash.bef

test-bash-awk: qc.bash qc.awk | output
	bash qc.bash awk > output/qc.bash.awk
	diff -s qc.awk output/qc.bash.awk

test-bash-piet: qc.bash qc.piet.gif | output
	bash qc.bash piet > output/qc.bash.piet
	diff -s qc.piet.gif output/qc.bash.piet

test-d-clj: build/qc.d.exe qc.clj | output
	build/qc.d.exe clj > output/qc.d.clj
	diff -s qc.clj output/qc.d.clj

test-d-lisp: build/qc.d.exe qc.lisp | output
	build/qc.d.exe lisp > output/qc.d.lisp
	diff -s qc.lisp output/qc.d.lisp

test-d-rkt: build/qc.d.exe qc.rkt | output
	build/qc.d.exe rkt > output/qc.d.rkt
	diff -s qc.rkt output/qc.d.rkt

test-d-rs: build/qc.d.exe qc.rs | output
	build/qc.d.exe rs > output/qc.d.rs
	diff -s qc.rs output/qc.d.rs

test-d-c: build/qc.d.exe qc.c | output
	build/qc.d.exe c > output/qc.d.c
	diff -s qc.c output/qc.d.c

test-d-cpp: build/qc.d.exe qc.cpp | output
	build/qc.d.exe cpp > output/qc.d.cpp
	diff -s qc.cpp output/qc.d.cpp

test-d-scala: build/qc.d.exe qc.scala | output
	build/qc.d.exe scala > output/qc.d.scala
	diff -s qc.scala output/qc.d.scala

test-d-f90: build/qc.d.exe qc.f90 | output
	build/qc.d.exe f90 > output/qc.d.f90
	diff -s qc.f90 output/qc.d.f90

test-d-scm: build/qc.d.exe qc.scm | output
	build/qc.d.exe scm > output/qc.d.scm
	diff -s qc.scm output/qc.d.scm

test-d-r: build/qc.d.exe qc.r | output
	build/qc.d.exe r > output/qc.d.r
	diff -s qc.r output/qc.d.r

test-d-lua: build/qc.d.exe qc.lua | output
	build/qc.d.exe lua > output/qc.d.lua
	diff -s qc.lua output/qc.d.lua

test-d-go: build/qc.d.exe qc.go | output
	build/qc.d.exe go > output/qc.d.go
	diff -s qc.go output/qc.d.go

test-d-ps: build/qc.d.exe qc.ps | output
	build/qc.d.exe ps > output/qc.d.ps
	diff -s qc.ps output/qc.d.ps

test-d-vala: build/qc.d.exe qc.vala | output
	build/qc.d.exe vala > output/qc.d.vala
	diff -s qc.vala output/qc.d.vala

test-d-pike: build/qc.d.exe qc.pike | output
	build/qc.d.exe pike > output/qc.d.pike
	diff -s qc.pike output/qc.d.pike

test-d-pas: build/qc.d.exe qc.pas | output
	build/qc.d.exe pas > output/qc.d.pas
	diff -s qc.pas output/qc.d.pas

test-d-kt: build/qc.d.exe qc.kt | output
	build/qc.d.exe kt > output/qc.d.kt
	diff -s qc.kt output/qc.d.kt

test-d-m: build/qc.d.exe qc.m | output
	build/qc.d.exe m > output/qc.d.m
	diff -s qc.m output/qc.d.m

test-d-ml: build/qc.d.exe qc.ml | output
	build/qc.d.exe ml > output/qc.d.ml
	diff -s qc.ml output/qc.d.ml

test-d-hs: build/qc.d.exe qc.hs | output
	build/qc.d.exe hs > output/qc.d.hs
	diff -s qc.hs output/qc.d.hs

test-d-zig: build/qc.d.exe qc.zig | output
	build/qc.d.exe zig > output/qc.d.zig
	diff -s qc.zig output/qc.d.zig

test-d-sml: build/qc.d.exe qc.sml | output
	build/qc.d.exe sml > output/qc.d.sml
	diff -s qc.sml output/qc.d.sml

test-d-octave: build/qc.d.exe qc.octave | output
	build/qc.d.exe octave > output/qc.d.octave
	diff -s qc.octave output/qc.d.octave

test-d-groovy: build/qc.d.exe qc.groovy | output
	build/qc.d.exe groovy > output/qc.d.groovy
	diff -s qc.groovy output/qc.d.groovy

test-d-ws: build/qc.d.exe qc.ws | output
	build/qc.d.exe ws > output/qc.d.ws
	diff -s qc.ws output/qc.d.ws

test-d-coffee: build/qc.d.exe qc.coffee | output
	build/qc.d.exe coffee > output/qc.d.coffee
	diff -s qc.coffee output/qc.d.coffee

test-d-swift: build/qc.d.exe qc.swift | output
	build/qc.d.exe swift > output/qc.d.swift
	diff -s qc.swift output/qc.d.swift

test-d-py: build/qc.d.exe qc.py | output
	build/qc.d.exe py > output/qc.d.py
	diff -s qc.py output/qc.d.py

test-d-fs: build/qc.d.exe qc.fs | output
	build/qc.d.exe fs > output/qc.d.fs
	diff -s qc.fs output/qc.d.fs

test-d-nim: build/qc.d.exe qc.nim | output
	build/qc.d.exe nim > output/qc.d.nim
	diff -s qc.nim output/qc.d.nim

test-d-fsx: build/qc.d.exe qc.fsx | output
	build/qc.d.exe fsx > output/qc.d.fsx
	diff -s qc.fsx output/qc.d.fsx

test-d-tcl: build/qc.d.exe qc.tcl | output
	build/qc.d.exe tcl > output/qc.d.tcl
	diff -s qc.tcl output/qc.d.tcl

test-d-bf: build/qc.d.exe qc.bf | output
	build/qc.d.exe bf > output/qc.d.bf
	diff -s qc.bf output/qc.d.bf

test-d-java: build/qc.d.exe qc.java | output
	build/qc.d.exe java > output/qc.d.java
	diff -s qc.java output/qc.d.java

test-d-php: build/qc.d.exe qc.php | output
	build/qc.d.exe php > output/qc.d.php
	diff -s qc.php output/qc.d.php

test-d-bash: build/qc.d.exe qc.bash | output
	build/qc.d.exe bash > output/qc.d.bash
	diff -s qc.bash output/qc.d.bash

test-d-d: build/qc.d.exe qc.d | output
	build/qc.d.exe > output/qc.d.d
	diff -s qc.d output/qc.d.d

test-d-pl: build/qc.d.exe qc.pl | output
	build/qc.d.exe pl > output/qc.d.pl
	diff -s qc.pl output/qc.d.pl

test-d-exs: build/qc.d.exe qc.exs | output
	build/qc.d.exe exs > output/qc.d.exs
	diff -s qc.exs output/qc.d.exs

test-d-rb: build/qc.d.exe qc.rb | output
	build/qc.d.exe rb > output/qc.d.rb
	diff -s qc.rb output/qc.d.rb

test-d-js: build/qc.d.exe qc.js | output
	build/qc.d.exe js > output/qc.d.js
	diff -s qc.js output/qc.d.js

test-d-ts: build/qc.d.exe qc.ts | output
	build/qc.d.exe ts > output/qc.d.ts
	diff -s qc.ts output/qc.d.ts

test-d-erl: build/qc.d.exe qc.erl | output
	build/qc.d.exe erl > output/qc.d.erl
	diff -s qc.erl output/qc.d.erl

test-d-cs: build/qc.d.exe qc.cs | output
	build/qc.d.exe cs > output/qc.d.cs
	diff -s qc.cs output/qc.d.cs

test-d-prolog: build/qc.d.exe qc.prolog | output
	build/qc.d.exe prolog > output/qc.d.prolog
	diff -s qc.prolog output/qc.d.prolog

test-d-cr: build/qc.d.exe qc.cr | output
	build/qc.d.exe cr > output/qc.d.cr
	diff -s qc.cr output/qc.d.cr

test-d-unl: build/qc.d.exe qc.unl | output
	build/qc.d.exe unl > output/qc.d.unl
	diff -s qc.unl output/qc.d.unl

test-d-hx: build/qc.d.exe qc.hx | output
	build/qc.d.exe hx > output/qc.d.hx
	diff -s qc.hx output/qc.d.hx

test-d-bef: build/qc.d.exe qc.bef | output
	build/qc.d.exe bef > output/qc.d.bef
	diff -s qc.bef output/qc.d.bef

test-d-awk: build/qc.d.exe qc.awk | output
	build/qc.d.exe awk > output/qc.d.awk
	diff -s qc.awk output/qc.d.awk

test-d-piet: build/qc.d.exe qc.piet.gif | output
	build/qc.d.exe piet > output/qc.d.piet
	diff -s qc.piet.gif output/qc.d.piet

test-pl-clj: qc.pl qc.clj | output
	perl qc.pl clj > output/qc.pl.clj
	diff -s qc.clj output/qc.pl.clj

test-pl-lisp: qc.pl qc.lisp | output
	perl qc.pl lisp > output/qc.pl.lisp
	diff -s qc.lisp output/qc.pl.lisp

test-pl-rkt: qc.pl qc.rkt | output
	perl qc.pl rkt > output/qc.pl.rkt
	diff -s qc.rkt output/qc.pl.rkt

test-pl-rs: qc.pl qc.rs | output
	perl qc.pl rs > output/qc.pl.rs
	diff -s qc.rs output/qc.pl.rs

test-pl-c: qc.pl qc.c | output
	perl qc.pl c > output/qc.pl.c
	diff -s qc.c output/qc.pl.c

test-pl-cpp: qc.pl qc.cpp | output
	perl qc.pl cpp > output/qc.pl.cpp
	diff -s qc.cpp output/qc.pl.cpp

test-pl-scala: qc.pl qc.scala | output
	perl qc.pl scala > output/qc.pl.scala
	diff -s qc.scala output/qc.pl.scala

test-pl-f90: qc.pl qc.f90 | output
	perl qc.pl f90 > output/qc.pl.f90
	diff -s qc.f90 output/qc.pl.f90

test-pl-scm: qc.pl qc.scm | output
	perl qc.pl scm > output/qc.pl.scm
	diff -s qc.scm output/qc.pl.scm

test-pl-r: qc.pl qc.r | output
	perl qc.pl r > output/qc.pl.r
	diff -s qc.r output/qc.pl.r

test-pl-lua: qc.pl qc.lua | output
	perl qc.pl lua > output/qc.pl.lua
	diff -s qc.lua output/qc.pl.lua

test-pl-go: qc.pl qc.go | output
	perl qc.pl go > output/qc.pl.go
	diff -s qc.go output/qc.pl.go

test-pl-ps: qc.pl qc.ps | output
	perl qc.pl ps > output/qc.pl.ps
	diff -s qc.ps output/qc.pl.ps

test-pl-vala: qc.pl qc.vala | output
	perl qc.pl vala > output/qc.pl.vala
	diff -s qc.vala output/qc.pl.vala

test-pl-pike: qc.pl qc.pike | output
	perl qc.pl pike > output/qc.pl.pike
	diff -s qc.pike output/qc.pl.pike

test-pl-pas: qc.pl qc.pas | output
	perl qc.pl pas > output/qc.pl.pas
	diff -s qc.pas output/qc.pl.pas

test-pl-kt: qc.pl qc.kt | output
	perl qc.pl kt > output/qc.pl.kt
	diff -s qc.kt output/qc.pl.kt

test-pl-m: qc.pl qc.m | output
	perl qc.pl m > output/qc.pl.m
	diff -s qc.m output/qc.pl.m

test-pl-ml: qc.pl qc.ml | output
	perl qc.pl ml > output/qc.pl.ml
	diff -s qc.ml output/qc.pl.ml

test-pl-hs: qc.pl qc.hs | output
	perl qc.pl hs > output/qc.pl.hs
	diff -s qc.hs output/qc.pl.hs

test-pl-zig: qc.pl qc.zig | output
	perl qc.pl zig > output/qc.pl.zig
	diff -s qc.zig output/qc.pl.zig

test-pl-sml: qc.pl qc.sml | output
	perl qc.pl sml > output/qc.pl.sml
	diff -s qc.sml output/qc.pl.sml

test-pl-octave: qc.pl qc.octave | output
	perl qc.pl octave > output/qc.pl.octave
	diff -s qc.octave output/qc.pl.octave

test-pl-groovy: qc.pl qc.groovy | output
	perl qc.pl groovy > output/qc.pl.groovy
	diff -s qc.groovy output/qc.pl.groovy

test-pl-ws: qc.pl qc.ws | output
	perl qc.pl ws > output/qc.pl.ws
	diff -s qc.ws output/qc.pl.ws

test-pl-coffee: qc.pl qc.coffee | output
	perl qc.pl coffee > output/qc.pl.coffee
	diff -s qc.coffee output/qc.pl.coffee

test-pl-swift: qc.pl qc.swift | output
	perl qc.pl swift > output/qc.pl.swift
	diff -s qc.swift output/qc.pl.swift

test-pl-py: qc.pl qc.py | output
	perl qc.pl py > output/qc.pl.py
	diff -s qc.py output/qc.pl.py

test-pl-fs: qc.pl qc.fs | output
	perl qc.pl fs > output/qc.pl.fs
	diff -s qc.fs output/qc.pl.fs

test-pl-nim: qc.pl qc.nim | output
	perl qc.pl nim > output/qc.pl.nim
	diff -s qc.nim output/qc.pl.nim

test-pl-fsx: qc.pl qc.fsx | output
	perl qc.pl fsx > output/qc.pl.fsx
	diff -s qc.fsx output/qc.pl.fsx

test-pl-tcl: qc.pl qc.tcl | output
	perl qc.pl tcl > output/qc.pl.tcl
	diff -s qc.tcl output/qc.pl.tcl

test-pl-bf: qc.pl qc.bf | output
	perl qc.pl bf > output/qc.pl.bf
	diff -s qc.bf output/qc.pl.bf

test-pl-java: qc.pl qc.java | output
	perl qc.pl java > output/qc.pl.java
	diff -s qc.java output/qc.pl.java

test-pl-php: qc.pl qc.php | output
	perl qc.pl php > output/qc.pl.php
	diff -s qc.php output/qc.pl.php

test-pl-bash: qc.pl qc.bash | output
	perl qc.pl bash > output/qc.pl.bash
	diff -s qc.bash output/qc.pl.bash

test-pl-d: qc.pl qc.d | output
	perl qc.pl d > output/qc.pl.d
	diff -s qc.d output/qc.pl.d

test-pl-pl: qc.pl qc.pl | output
	perl qc.pl > output/qc.pl.pl
	diff -s qc.pl output/qc.pl.pl

test-pl-exs: qc.pl qc.exs | output
	perl qc.pl exs > output/qc.pl.exs
	diff -s qc.exs output/qc.pl.exs

test-pl-rb: qc.pl qc.rb | output
	perl qc.pl rb > output/qc.pl.rb
	diff -s qc.rb output/qc.pl.rb

test-pl-js: qc.pl qc.js | output
	perl qc.pl js > output/qc.pl.js
	diff -s qc.js output/qc.pl.js

test-pl-ts: qc.pl qc.ts | output
	perl qc.pl ts > output/qc.pl.ts
	diff -s qc.ts output/qc.pl.ts

test-pl-erl: qc.pl qc.erl | output
	perl qc.pl erl > output/qc.pl.erl
	diff -s qc.erl output/qc.pl.erl

test-pl-cs: qc.pl qc.cs | output
	perl qc.pl cs > output/qc.pl.cs
	diff -s qc.cs output/qc.pl.cs

test-pl-prolog: qc.pl qc.prolog | output
	perl qc.pl prolog > output/qc.pl.prolog
	diff -s qc.prolog output/qc.pl.prolog

test-pl-cr: qc.pl qc.cr | output
	perl qc.pl cr > output/qc.pl.cr
	diff -s qc.cr output/qc.pl.cr

test-pl-unl: qc.pl qc.unl | output
	perl qc.pl unl > output/qc.pl.unl
	diff -s qc.unl output/qc.pl.unl

test-pl-hx: qc.pl qc.hx | output
	perl qc.pl hx > output/qc.pl.hx
	diff -s qc.hx output/qc.pl.hx

test-pl-bef: qc.pl qc.bef | output
	perl qc.pl bef > output/qc.pl.bef
	diff -s qc.bef output/qc.pl.bef

test-pl-awk: qc.pl qc.awk | output
	perl qc.pl awk > output/qc.pl.awk
	diff -s qc.awk output/qc.pl.awk

test-pl-piet: qc.pl qc.piet.gif | output
	perl qc.pl piet > output/qc.pl.piet
	diff -s qc.piet.gif output/qc.pl.piet

test-exs-clj: qc.exs qc.clj | output
	elixir qc.exs clj > output/qc.exs.clj
	diff -s qc.clj output/qc.exs.clj

test-exs-lisp: qc.exs qc.lisp | output
	elixir qc.exs lisp > output/qc.exs.lisp
	diff -s qc.lisp output/qc.exs.lisp

test-exs-rkt: qc.exs qc.rkt | output
	elixir qc.exs rkt > output/qc.exs.rkt
	diff -s qc.rkt output/qc.exs.rkt

test-exs-rs: qc.exs qc.rs | output
	elixir qc.exs rs > output/qc.exs.rs
	diff -s qc.rs output/qc.exs.rs

test-exs-c: qc.exs qc.c | output
	elixir qc.exs c > output/qc.exs.c
	diff -s qc.c output/qc.exs.c

test-exs-cpp: qc.exs qc.cpp | output
	elixir qc.exs cpp > output/qc.exs.cpp
	diff -s qc.cpp output/qc.exs.cpp

test-exs-scala: qc.exs qc.scala | output
	elixir qc.exs scala > output/qc.exs.scala
	diff -s qc.scala output/qc.exs.scala

test-exs-f90: qc.exs qc.f90 | output
	elixir qc.exs f90 > output/qc.exs.f90
	diff -s qc.f90 output/qc.exs.f90

test-exs-scm: qc.exs qc.scm | output
	elixir qc.exs scm > output/qc.exs.scm
	diff -s qc.scm output/qc.exs.scm

test-exs-r: qc.exs qc.r | output
	elixir qc.exs r > output/qc.exs.r
	diff -s qc.r output/qc.exs.r

test-exs-lua: qc.exs qc.lua | output
	elixir qc.exs lua > output/qc.exs.lua
	diff -s qc.lua output/qc.exs.lua

test-exs-go: qc.exs qc.go | output
	elixir qc.exs go > output/qc.exs.go
	diff -s qc.go output/qc.exs.go

test-exs-ps: qc.exs qc.ps | output
	elixir qc.exs ps > output/qc.exs.ps
	diff -s qc.ps output/qc.exs.ps

test-exs-vala: qc.exs qc.vala | output
	elixir qc.exs vala > output/qc.exs.vala
	diff -s qc.vala output/qc.exs.vala

test-exs-pike: qc.exs qc.pike | output
	elixir qc.exs pike > output/qc.exs.pike
	diff -s qc.pike output/qc.exs.pike

test-exs-pas: qc.exs qc.pas | output
	elixir qc.exs pas > output/qc.exs.pas
	diff -s qc.pas output/qc.exs.pas

test-exs-kt: qc.exs qc.kt | output
	elixir qc.exs kt > output/qc.exs.kt
	diff -s qc.kt output/qc.exs.kt

test-exs-m: qc.exs qc.m | output
	elixir qc.exs m > output/qc.exs.m
	diff -s qc.m output/qc.exs.m

test-exs-ml: qc.exs qc.ml | output
	elixir qc.exs ml > output/qc.exs.ml
	diff -s qc.ml output/qc.exs.ml

test-exs-hs: qc.exs qc.hs | output
	elixir qc.exs hs > output/qc.exs.hs
	diff -s qc.hs output/qc.exs.hs

test-exs-zig: qc.exs qc.zig | output
	elixir qc.exs zig > output/qc.exs.zig
	diff -s qc.zig output/qc.exs.zig

test-exs-sml: qc.exs qc.sml | output
	elixir qc.exs sml > output/qc.exs.sml
	diff -s qc.sml output/qc.exs.sml

test-exs-octave: qc.exs qc.octave | output
	elixir qc.exs octave > output/qc.exs.octave
	diff -s qc.octave output/qc.exs.octave

test-exs-groovy: qc.exs qc.groovy | output
	elixir qc.exs groovy > output/qc.exs.groovy
	diff -s qc.groovy output/qc.exs.groovy

test-exs-ws: qc.exs qc.ws | output
	elixir qc.exs ws > output/qc.exs.ws
	diff -s qc.ws output/qc.exs.ws

test-exs-coffee: qc.exs qc.coffee | output
	elixir qc.exs coffee > output/qc.exs.coffee
	diff -s qc.coffee output/qc.exs.coffee

test-exs-swift: qc.exs qc.swift | output
	elixir qc.exs swift > output/qc.exs.swift
	diff -s qc.swift output/qc.exs.swift

test-exs-py: qc.exs qc.py | output
	elixir qc.exs py > output/qc.exs.py
	diff -s qc.py output/qc.exs.py

test-exs-fs: qc.exs qc.fs | output
	elixir qc.exs fs > output/qc.exs.fs
	diff -s qc.fs output/qc.exs.fs

test-exs-nim: qc.exs qc.nim | output
	elixir qc.exs nim > output/qc.exs.nim
	diff -s qc.nim output/qc.exs.nim

test-exs-fsx: qc.exs qc.fsx | output
	elixir qc.exs fsx > output/qc.exs.fsx
	diff -s qc.fsx output/qc.exs.fsx

test-exs-tcl: qc.exs qc.tcl | output
	elixir qc.exs tcl > output/qc.exs.tcl
	diff -s qc.tcl output/qc.exs.tcl

test-exs-bf: qc.exs qc.bf | output
	elixir qc.exs bf > output/qc.exs.bf
	diff -s qc.bf output/qc.exs.bf

test-exs-java: qc.exs qc.java | output
	elixir qc.exs java > output/qc.exs.java
	diff -s qc.java output/qc.exs.java

test-exs-php: qc.exs qc.php | output
	elixir qc.exs php > output/qc.exs.php
	diff -s qc.php output/qc.exs.php

test-exs-bash: qc.exs qc.bash | output
	elixir qc.exs bash > output/qc.exs.bash
	diff -s qc.bash output/qc.exs.bash

test-exs-d: qc.exs qc.d | output
	elixir qc.exs d > output/qc.exs.d
	diff -s qc.d output/qc.exs.d

test-exs-pl: qc.exs qc.pl | output
	elixir qc.exs pl > output/qc.exs.pl
	diff -s qc.pl output/qc.exs.pl

test-exs-exs: qc.exs qc.exs | output
	elixir qc.exs > output/qc.exs.exs
	diff -s qc.exs output/qc.exs.exs

test-exs-rb: qc.exs qc.rb | output
	elixir qc.exs rb > output/qc.exs.rb
	diff -s qc.rb output/qc.exs.rb

test-exs-js: qc.exs qc.js | output
	elixir qc.exs js > output/qc.exs.js
	diff -s qc.js output/qc.exs.js

test-exs-ts: qc.exs qc.ts | output
	elixir qc.exs ts > output/qc.exs.ts
	diff -s qc.ts output/qc.exs.ts

test-exs-erl: qc.exs qc.erl | output
	elixir qc.exs erl > output/qc.exs.erl
	diff -s qc.erl output/qc.exs.erl

test-exs-cs: qc.exs qc.cs | output
	elixir qc.exs cs > output/qc.exs.cs
	diff -s qc.cs output/qc.exs.cs

test-exs-prolog: qc.exs qc.prolog | output
	elixir qc.exs prolog > output/qc.exs.prolog
	diff -s qc.prolog output/qc.exs.prolog

test-exs-cr: qc.exs qc.cr | output
	elixir qc.exs cr > output/qc.exs.cr
	diff -s qc.cr output/qc.exs.cr

test-exs-unl: qc.exs qc.unl | output
	elixir qc.exs unl > output/qc.exs.unl
	diff -s qc.unl output/qc.exs.unl

test-exs-hx: qc.exs qc.hx | output
	elixir qc.exs hx > output/qc.exs.hx
	diff -s qc.hx output/qc.exs.hx

test-exs-bef: qc.exs qc.bef | output
	elixir qc.exs bef > output/qc.exs.bef
	diff -s qc.bef output/qc.exs.bef

test-exs-awk: qc.exs qc.awk | output
	elixir qc.exs awk > output/qc.exs.awk
	diff -s qc.awk output/qc.exs.awk

test-exs-piet: qc.exs qc.piet.gif | output
	elixir qc.exs piet > output/qc.exs.piet
	diff -s qc.piet.gif output/qc.exs.piet

test-rb-clj: qc.rb qc.clj | output
	ruby qc.rb clj > output/qc.rb.clj
	diff -s qc.clj output/qc.rb.clj

test-rb-lisp: qc.rb qc.lisp | output
	ruby qc.rb lisp > output/qc.rb.lisp
	diff -s qc.lisp output/qc.rb.lisp

test-rb-rkt: qc.rb qc.rkt | output
	ruby qc.rb rkt > output/qc.rb.rkt
	diff -s qc.rkt output/qc.rb.rkt

test-rb-rs: qc.rb qc.rs | output
	ruby qc.rb rs > output/qc.rb.rs
	diff -s qc.rs output/qc.rb.rs

test-rb-c: qc.rb qc.c | output
	ruby qc.rb c > output/qc.rb.c
	diff -s qc.c output/qc.rb.c

test-rb-cpp: qc.rb qc.cpp | output
	ruby qc.rb cpp > output/qc.rb.cpp
	diff -s qc.cpp output/qc.rb.cpp

test-rb-scala: qc.rb qc.scala | output
	ruby qc.rb scala > output/qc.rb.scala
	diff -s qc.scala output/qc.rb.scala

test-rb-f90: qc.rb qc.f90 | output
	ruby qc.rb f90 > output/qc.rb.f90
	diff -s qc.f90 output/qc.rb.f90

test-rb-scm: qc.rb qc.scm | output
	ruby qc.rb scm > output/qc.rb.scm
	diff -s qc.scm output/qc.rb.scm

test-rb-r: qc.rb qc.r | output
	ruby qc.rb r > output/qc.rb.r
	diff -s qc.r output/qc.rb.r

test-rb-lua: qc.rb qc.lua | output
	ruby qc.rb lua > output/qc.rb.lua
	diff -s qc.lua output/qc.rb.lua

test-rb-go: qc.rb qc.go | output
	ruby qc.rb go > output/qc.rb.go
	diff -s qc.go output/qc.rb.go

test-rb-ps: qc.rb qc.ps | output
	ruby qc.rb ps > output/qc.rb.ps
	diff -s qc.ps output/qc.rb.ps

test-rb-vala: qc.rb qc.vala | output
	ruby qc.rb vala > output/qc.rb.vala
	diff -s qc.vala output/qc.rb.vala

test-rb-pike: qc.rb qc.pike | output
	ruby qc.rb pike > output/qc.rb.pike
	diff -s qc.pike output/qc.rb.pike

test-rb-pas: qc.rb qc.pas | output
	ruby qc.rb pas > output/qc.rb.pas
	diff -s qc.pas output/qc.rb.pas

test-rb-kt: qc.rb qc.kt | output
	ruby qc.rb kt > output/qc.rb.kt
	diff -s qc.kt output/qc.rb.kt

test-rb-m: qc.rb qc.m | output
	ruby qc.rb m > output/qc.rb.m
	diff -s qc.m output/qc.rb.m

test-rb-ml: qc.rb qc.ml | output
	ruby qc.rb ml > output/qc.rb.ml
	diff -s qc.ml output/qc.rb.ml

test-rb-hs: qc.rb qc.hs | output
	ruby qc.rb hs > output/qc.rb.hs
	diff -s qc.hs output/qc.rb.hs

test-rb-zig: qc.rb qc.zig | output
	ruby qc.rb zig > output/qc.rb.zig
	diff -s qc.zig output/qc.rb.zig

test-rb-sml: qc.rb qc.sml | output
	ruby qc.rb sml > output/qc.rb.sml
	diff -s qc.sml output/qc.rb.sml

test-rb-octave: qc.rb qc.octave | output
	ruby qc.rb octave > output/qc.rb.octave
	diff -s qc.octave output/qc.rb.octave

test-rb-groovy: qc.rb qc.groovy | output
	ruby qc.rb groovy > output/qc.rb.groovy
	diff -s qc.groovy output/qc.rb.groovy

test-rb-ws: qc.rb qc.ws | output
	ruby qc.rb ws > output/qc.rb.ws
	diff -s qc.ws output/qc.rb.ws

test-rb-coffee: qc.rb qc.coffee | output
	ruby qc.rb coffee > output/qc.rb.coffee
	diff -s qc.coffee output/qc.rb.coffee

test-rb-swift: qc.rb qc.swift | output
	ruby qc.rb swift > output/qc.rb.swift
	diff -s qc.swift output/qc.rb.swift

test-rb-py: qc.rb qc.py | output
	ruby qc.rb py > output/qc.rb.py
	diff -s qc.py output/qc.rb.py

test-rb-fs: qc.rb qc.fs | output
	ruby qc.rb fs > output/qc.rb.fs
	diff -s qc.fs output/qc.rb.fs

test-rb-nim: qc.rb qc.nim | output
	ruby qc.rb nim > output/qc.rb.nim
	diff -s qc.nim output/qc.rb.nim

test-rb-fsx: qc.rb qc.fsx | output
	ruby qc.rb fsx > output/qc.rb.fsx
	diff -s qc.fsx output/qc.rb.fsx

test-rb-tcl: qc.rb qc.tcl | output
	ruby qc.rb tcl > output/qc.rb.tcl
	diff -s qc.tcl output/qc.rb.tcl

test-rb-bf: qc.rb qc.bf | output
	ruby qc.rb bf > output/qc.rb.bf
	diff -s qc.bf output/qc.rb.bf

test-rb-java: qc.rb qc.java | output
	ruby qc.rb java > output/qc.rb.java
	diff -s qc.java output/qc.rb.java

test-rb-php: qc.rb qc.php | output
	ruby qc.rb php > output/qc.rb.php
	diff -s qc.php output/qc.rb.php

test-rb-bash: qc.rb qc.bash | output
	ruby qc.rb bash > output/qc.rb.bash
	diff -s qc.bash output/qc.rb.bash

test-rb-d: qc.rb qc.d | output
	ruby qc.rb d > output/qc.rb.d
	diff -s qc.d output/qc.rb.d

test-rb-pl: qc.rb qc.pl | output
	ruby qc.rb pl > output/qc.rb.pl
	diff -s qc.pl output/qc.rb.pl

test-rb-exs: qc.rb qc.exs | output
	ruby qc.rb exs > output/qc.rb.exs
	diff -s qc.exs output/qc.rb.exs

test-rb-rb: qc.rb qc.rb | output
	ruby qc.rb > output/qc.rb.rb
	diff -s qc.rb output/qc.rb.rb

test-rb-js: qc.rb qc.js | output
	ruby qc.rb js > output/qc.rb.js
	diff -s qc.js output/qc.rb.js

test-rb-ts: qc.rb qc.ts | output
	ruby qc.rb ts > output/qc.rb.ts
	diff -s qc.ts output/qc.rb.ts

test-rb-erl: qc.rb qc.erl | output
	ruby qc.rb erl > output/qc.rb.erl
	diff -s qc.erl output/qc.rb.erl

test-rb-cs: qc.rb qc.cs | output
	ruby qc.rb cs > output/qc.rb.cs
	diff -s qc.cs output/qc.rb.cs

test-rb-prolog: qc.rb qc.prolog | output
	ruby qc.rb prolog > output/qc.rb.prolog
	diff -s qc.prolog output/qc.rb.prolog

test-rb-cr: qc.rb qc.cr | output
	ruby qc.rb cr > output/qc.rb.cr
	diff -s qc.cr output/qc.rb.cr

test-rb-unl: qc.rb qc.unl | output
	ruby qc.rb unl > output/qc.rb.unl
	diff -s qc.unl output/qc.rb.unl

test-rb-hx: qc.rb qc.hx | output
	ruby qc.rb hx > output/qc.rb.hx
	diff -s qc.hx output/qc.rb.hx

test-rb-bef: qc.rb qc.bef | output
	ruby qc.rb bef > output/qc.rb.bef
	diff -s qc.bef output/qc.rb.bef

test-rb-awk: qc.rb qc.awk | output
	ruby qc.rb awk > output/qc.rb.awk
	diff -s qc.awk output/qc.rb.awk

test-rb-piet: qc.rb qc.piet.gif | output
	ruby qc.rb piet > output/qc.rb.piet
	diff -s qc.piet.gif output/qc.rb.piet

test-js-clj: qc.js qc.clj | output
	node qc.js clj > output/qc.js.clj
	diff -s qc.clj output/qc.js.clj

test-js-lisp: qc.js qc.lisp | output
	node qc.js lisp > output/qc.js.lisp
	diff -s qc.lisp output/qc.js.lisp

test-js-rkt: qc.js qc.rkt | output
	node qc.js rkt > output/qc.js.rkt
	diff -s qc.rkt output/qc.js.rkt

test-js-rs: qc.js qc.rs | output
	node qc.js rs > output/qc.js.rs
	diff -s qc.rs output/qc.js.rs

test-js-c: qc.js qc.c | output
	node qc.js c > output/qc.js.c
	diff -s qc.c output/qc.js.c

test-js-cpp: qc.js qc.cpp | output
	node qc.js cpp > output/qc.js.cpp
	diff -s qc.cpp output/qc.js.cpp

test-js-scala: qc.js qc.scala | output
	node qc.js scala > output/qc.js.scala
	diff -s qc.scala output/qc.js.scala

test-js-f90: qc.js qc.f90 | output
	node qc.js f90 > output/qc.js.f90
	diff -s qc.f90 output/qc.js.f90

test-js-scm: qc.js qc.scm | output
	node qc.js scm > output/qc.js.scm
	diff -s qc.scm output/qc.js.scm

test-js-r: qc.js qc.r | output
	node qc.js r > output/qc.js.r
	diff -s qc.r output/qc.js.r

test-js-lua: qc.js qc.lua | output
	node qc.js lua > output/qc.js.lua
	diff -s qc.lua output/qc.js.lua

test-js-go: qc.js qc.go | output
	node qc.js go > output/qc.js.go
	diff -s qc.go output/qc.js.go

test-js-ps: qc.js qc.ps | output
	node qc.js ps > output/qc.js.ps
	diff -s qc.ps output/qc.js.ps

test-js-vala: qc.js qc.vala | output
	node qc.js vala > output/qc.js.vala
	diff -s qc.vala output/qc.js.vala

test-js-pike: qc.js qc.pike | output
	node qc.js pike > output/qc.js.pike
	diff -s qc.pike output/qc.js.pike

test-js-pas: qc.js qc.pas | output
	node qc.js pas > output/qc.js.pas
	diff -s qc.pas output/qc.js.pas

test-js-kt: qc.js qc.kt | output
	node qc.js kt > output/qc.js.kt
	diff -s qc.kt output/qc.js.kt

test-js-m: qc.js qc.m | output
	node qc.js m > output/qc.js.m
	diff -s qc.m output/qc.js.m

test-js-ml: qc.js qc.ml | output
	node qc.js ml > output/qc.js.ml
	diff -s qc.ml output/qc.js.ml

test-js-hs: qc.js qc.hs | output
	node qc.js hs > output/qc.js.hs
	diff -s qc.hs output/qc.js.hs

test-js-zig: qc.js qc.zig | output
	node qc.js zig > output/qc.js.zig
	diff -s qc.zig output/qc.js.zig

test-js-sml: qc.js qc.sml | output
	node qc.js sml > output/qc.js.sml
	diff -s qc.sml output/qc.js.sml

test-js-octave: qc.js qc.octave | output
	node qc.js octave > output/qc.js.octave
	diff -s qc.octave output/qc.js.octave

test-js-groovy: qc.js qc.groovy | output
	node qc.js groovy > output/qc.js.groovy
	diff -s qc.groovy output/qc.js.groovy

test-js-ws: qc.js qc.ws | output
	node qc.js ws > output/qc.js.ws
	diff -s qc.ws output/qc.js.ws

test-js-coffee: qc.js qc.coffee | output
	node qc.js coffee > output/qc.js.coffee
	diff -s qc.coffee output/qc.js.coffee

test-js-swift: qc.js qc.swift | output
	node qc.js swift > output/qc.js.swift
	diff -s qc.swift output/qc.js.swift

test-js-py: qc.js qc.py | output
	node qc.js py > output/qc.js.py
	diff -s qc.py output/qc.js.py

test-js-fs: qc.js qc.fs | output
	node qc.js fs > output/qc.js.fs
	diff -s qc.fs output/qc.js.fs

test-js-nim: qc.js qc.nim | output
	node qc.js nim > output/qc.js.nim
	diff -s qc.nim output/qc.js.nim

test-js-fsx: qc.js qc.fsx | output
	node qc.js fsx > output/qc.js.fsx
	diff -s qc.fsx output/qc.js.fsx

test-js-tcl: qc.js qc.tcl | output
	node qc.js tcl > output/qc.js.tcl
	diff -s qc.tcl output/qc.js.tcl

test-js-bf: qc.js qc.bf | output
	node qc.js bf > output/qc.js.bf
	diff -s qc.bf output/qc.js.bf

test-js-java: qc.js qc.java | output
	node qc.js java > output/qc.js.java
	diff -s qc.java output/qc.js.java

test-js-php: qc.js qc.php | output
	node qc.js php > output/qc.js.php
	diff -s qc.php output/qc.js.php

test-js-bash: qc.js qc.bash | output
	node qc.js bash > output/qc.js.bash
	diff -s qc.bash output/qc.js.bash

test-js-d: qc.js qc.d | output
	node qc.js d > output/qc.js.d
	diff -s qc.d output/qc.js.d

test-js-pl: qc.js qc.pl | output
	node qc.js pl > output/qc.js.pl
	diff -s qc.pl output/qc.js.pl

test-js-exs: qc.js qc.exs | output
	node qc.js exs > output/qc.js.exs
	diff -s qc.exs output/qc.js.exs

test-js-rb: qc.js qc.rb | output
	node qc.js rb > output/qc.js.rb
	diff -s qc.rb output/qc.js.rb

test-js-js: qc.js qc.js | output
	node qc.js > output/qc.js.js
	diff -s qc.js output/qc.js.js

test-js-ts: qc.js qc.ts | output
	node qc.js ts > output/qc.js.ts
	diff -s qc.ts output/qc.js.ts

test-js-erl: qc.js qc.erl | output
	node qc.js erl > output/qc.js.erl
	diff -s qc.erl output/qc.js.erl

test-js-cs: qc.js qc.cs | output
	node qc.js cs > output/qc.js.cs
	diff -s qc.cs output/qc.js.cs

test-js-prolog: qc.js qc.prolog | output
	node qc.js prolog > output/qc.js.prolog
	diff -s qc.prolog output/qc.js.prolog

test-js-cr: qc.js qc.cr | output
	node qc.js cr > output/qc.js.cr
	diff -s qc.cr output/qc.js.cr

test-js-unl: qc.js qc.unl | output
	node qc.js unl > output/qc.js.unl
	diff -s qc.unl output/qc.js.unl

test-js-hx: qc.js qc.hx | output
	node qc.js hx > output/qc.js.hx
	diff -s qc.hx output/qc.js.hx

test-js-bef: qc.js qc.bef | output
	node qc.js bef > output/qc.js.bef
	diff -s qc.bef output/qc.js.bef

test-js-awk: qc.js qc.awk | output
	node qc.js awk > output/qc.js.awk
	diff -s qc.awk output/qc.js.awk

test-js-piet: qc.js qc.piet.gif | output
	node qc.js piet > output/qc.js.piet
	diff -s qc.piet.gif output/qc.js.piet

test-ts-clj: build/qc.ts.exe.js qc.clj | output
	node build/qc.ts.exe.js clj > output/qc.ts.clj
	diff -s qc.clj output/qc.ts.clj

test-ts-lisp: build/qc.ts.exe.js qc.lisp | output
	node build/qc.ts.exe.js lisp > output/qc.ts.lisp
	diff -s qc.lisp output/qc.ts.lisp

test-ts-rkt: build/qc.ts.exe.js qc.rkt | output
	node build/qc.ts.exe.js rkt > output/qc.ts.rkt
	diff -s qc.rkt output/qc.ts.rkt

test-ts-rs: build/qc.ts.exe.js qc.rs | output
	node build/qc.ts.exe.js rs > output/qc.ts.rs
	diff -s qc.rs output/qc.ts.rs

test-ts-c: build/qc.ts.exe.js qc.c | output
	node build/qc.ts.exe.js c > output/qc.ts.c
	diff -s qc.c output/qc.ts.c

test-ts-cpp: build/qc.ts.exe.js qc.cpp | output
	node build/qc.ts.exe.js cpp > output/qc.ts.cpp
	diff -s qc.cpp output/qc.ts.cpp

test-ts-scala: build/qc.ts.exe.js qc.scala | output
	node build/qc.ts.exe.js scala > output/qc.ts.scala
	diff -s qc.scala output/qc.ts.scala

test-ts-f90: build/qc.ts.exe.js qc.f90 | output
	node build/qc.ts.exe.js f90 > output/qc.ts.f90
	diff -s qc.f90 output/qc.ts.f90

test-ts-scm: build/qc.ts.exe.js qc.scm | output
	node build/qc.ts.exe.js scm > output/qc.ts.scm
	diff -s qc.scm output/qc.ts.scm

test-ts-r: build/qc.ts.exe.js qc.r | output
	node build/qc.ts.exe.js r > output/qc.ts.r
	diff -s qc.r output/qc.ts.r

test-ts-lua: build/qc.ts.exe.js qc.lua | output
	node build/qc.ts.exe.js lua > output/qc.ts.lua
	diff -s qc.lua output/qc.ts.lua

test-ts-go: build/qc.ts.exe.js qc.go | output
	node build/qc.ts.exe.js go > output/qc.ts.go
	diff -s qc.go output/qc.ts.go

test-ts-ps: build/qc.ts.exe.js qc.ps | output
	node build/qc.ts.exe.js ps > output/qc.ts.ps
	diff -s qc.ps output/qc.ts.ps

test-ts-vala: build/qc.ts.exe.js qc.vala | output
	node build/qc.ts.exe.js vala > output/qc.ts.vala
	diff -s qc.vala output/qc.ts.vala

test-ts-pike: build/qc.ts.exe.js qc.pike | output
	node build/qc.ts.exe.js pike > output/qc.ts.pike
	diff -s qc.pike output/qc.ts.pike

test-ts-pas: build/qc.ts.exe.js qc.pas | output
	node build/qc.ts.exe.js pas > output/qc.ts.pas
	diff -s qc.pas output/qc.ts.pas

test-ts-kt: build/qc.ts.exe.js qc.kt | output
	node build/qc.ts.exe.js kt > output/qc.ts.kt
	diff -s qc.kt output/qc.ts.kt

test-ts-m: build/qc.ts.exe.js qc.m | output
	node build/qc.ts.exe.js m > output/qc.ts.m
	diff -s qc.m output/qc.ts.m

test-ts-ml: build/qc.ts.exe.js qc.ml | output
	node build/qc.ts.exe.js ml > output/qc.ts.ml
	diff -s qc.ml output/qc.ts.ml

test-ts-hs: build/qc.ts.exe.js qc.hs | output
	node build/qc.ts.exe.js hs > output/qc.ts.hs
	diff -s qc.hs output/qc.ts.hs

test-ts-zig: build/qc.ts.exe.js qc.zig | output
	node build/qc.ts.exe.js zig > output/qc.ts.zig
	diff -s qc.zig output/qc.ts.zig

test-ts-sml: build/qc.ts.exe.js qc.sml | output
	node build/qc.ts.exe.js sml > output/qc.ts.sml
	diff -s qc.sml output/qc.ts.sml

test-ts-octave: build/qc.ts.exe.js qc.octave | output
	node build/qc.ts.exe.js octave > output/qc.ts.octave
	diff -s qc.octave output/qc.ts.octave

test-ts-groovy: build/qc.ts.exe.js qc.groovy | output
	node build/qc.ts.exe.js groovy > output/qc.ts.groovy
	diff -s qc.groovy output/qc.ts.groovy

test-ts-ws: build/qc.ts.exe.js qc.ws | output
	node build/qc.ts.exe.js ws > output/qc.ts.ws
	diff -s qc.ws output/qc.ts.ws

test-ts-coffee: build/qc.ts.exe.js qc.coffee | output
	node build/qc.ts.exe.js coffee > output/qc.ts.coffee
	diff -s qc.coffee output/qc.ts.coffee

test-ts-swift: build/qc.ts.exe.js qc.swift | output
	node build/qc.ts.exe.js swift > output/qc.ts.swift
	diff -s qc.swift output/qc.ts.swift

test-ts-py: build/qc.ts.exe.js qc.py | output
	node build/qc.ts.exe.js py > output/qc.ts.py
	diff -s qc.py output/qc.ts.py

test-ts-fs: build/qc.ts.exe.js qc.fs | output
	node build/qc.ts.exe.js fs > output/qc.ts.fs
	diff -s qc.fs output/qc.ts.fs

test-ts-nim: build/qc.ts.exe.js qc.nim | output
	node build/qc.ts.exe.js nim > output/qc.ts.nim
	diff -s qc.nim output/qc.ts.nim

test-ts-fsx: build/qc.ts.exe.js qc.fsx | output
	node build/qc.ts.exe.js fsx > output/qc.ts.fsx
	diff -s qc.fsx output/qc.ts.fsx

test-ts-tcl: build/qc.ts.exe.js qc.tcl | output
	node build/qc.ts.exe.js tcl > output/qc.ts.tcl
	diff -s qc.tcl output/qc.ts.tcl

test-ts-bf: build/qc.ts.exe.js qc.bf | output
	node build/qc.ts.exe.js bf > output/qc.ts.bf
	diff -s qc.bf output/qc.ts.bf

test-ts-java: build/qc.ts.exe.js qc.java | output
	node build/qc.ts.exe.js java > output/qc.ts.java
	diff -s qc.java output/qc.ts.java

test-ts-php: build/qc.ts.exe.js qc.php | output
	node build/qc.ts.exe.js php > output/qc.ts.php
	diff -s qc.php output/qc.ts.php

test-ts-bash: build/qc.ts.exe.js qc.bash | output
	node build/qc.ts.exe.js bash > output/qc.ts.bash
	diff -s qc.bash output/qc.ts.bash

test-ts-d: build/qc.ts.exe.js qc.d | output
	node build/qc.ts.exe.js d > output/qc.ts.d
	diff -s qc.d output/qc.ts.d

test-ts-pl: build/qc.ts.exe.js qc.pl | output
	node build/qc.ts.exe.js pl > output/qc.ts.pl
	diff -s qc.pl output/qc.ts.pl

test-ts-exs: build/qc.ts.exe.js qc.exs | output
	node build/qc.ts.exe.js exs > output/qc.ts.exs
	diff -s qc.exs output/qc.ts.exs

test-ts-rb: build/qc.ts.exe.js qc.rb | output
	node build/qc.ts.exe.js rb > output/qc.ts.rb
	diff -s qc.rb output/qc.ts.rb

test-ts-js: build/qc.ts.exe.js qc.js | output
	node build/qc.ts.exe.js js > output/qc.ts.js
	diff -s qc.js output/qc.ts.js

test-ts-ts: build/qc.ts.exe.js qc.ts | output
	node build/qc.ts.exe.js > output/qc.ts.ts
	diff -s qc.ts output/qc.ts.ts

test-ts-erl: build/qc.ts.exe.js qc.erl | output
	node build/qc.ts.exe.js erl > output/qc.ts.erl
	diff -s qc.erl output/qc.ts.erl

test-ts-cs: build/qc.ts.exe.js qc.cs | output
	node build/qc.ts.exe.js cs > output/qc.ts.cs
	diff -s qc.cs output/qc.ts.cs

test-ts-prolog: build/qc.ts.exe.js qc.prolog | output
	node build/qc.ts.exe.js prolog > output/qc.ts.prolog
	diff -s qc.prolog output/qc.ts.prolog

test-ts-cr: build/qc.ts.exe.js qc.cr | output
	node build/qc.ts.exe.js cr > output/qc.ts.cr
	diff -s qc.cr output/qc.ts.cr

test-ts-unl: build/qc.ts.exe.js qc.unl | output
	node build/qc.ts.exe.js unl > output/qc.ts.unl
	diff -s qc.unl output/qc.ts.unl

test-ts-hx: build/qc.ts.exe.js qc.hx | output
	node build/qc.ts.exe.js hx > output/qc.ts.hx
	diff -s qc.hx output/qc.ts.hx

test-ts-bef: build/qc.ts.exe.js qc.bef | output
	node build/qc.ts.exe.js bef > output/qc.ts.bef
	diff -s qc.bef output/qc.ts.bef

test-ts-awk: build/qc.ts.exe.js qc.awk | output
	node build/qc.ts.exe.js awk > output/qc.ts.awk
	diff -s qc.awk output/qc.ts.awk

test-ts-piet: build/qc.ts.exe.js qc.piet.gif | output
	node build/qc.ts.exe.js piet > output/qc.ts.piet
	diff -s qc.piet.gif output/qc.ts.piet

test-erl-clj: qc.erl qc.clj | output
	escript qc.erl clj > output/qc.erl.clj
	diff -s qc.clj output/qc.erl.clj

test-erl-lisp: qc.erl qc.lisp | output
	escript qc.erl lisp > output/qc.erl.lisp
	diff -s qc.lisp output/qc.erl.lisp

test-erl-rkt: qc.erl qc.rkt | output
	escript qc.erl rkt > output/qc.erl.rkt
	diff -s qc.rkt output/qc.erl.rkt

test-erl-rs: qc.erl qc.rs | output
	escript qc.erl rs > output/qc.erl.rs
	diff -s qc.rs output/qc.erl.rs

test-erl-c: qc.erl qc.c | output
	escript qc.erl c > output/qc.erl.c
	diff -s qc.c output/qc.erl.c

test-erl-cpp: qc.erl qc.cpp | output
	escript qc.erl cpp > output/qc.erl.cpp
	diff -s qc.cpp output/qc.erl.cpp

test-erl-scala: qc.erl qc.scala | output
	escript qc.erl scala > output/qc.erl.scala
	diff -s qc.scala output/qc.erl.scala

test-erl-f90: qc.erl qc.f90 | output
	escript qc.erl f90 > output/qc.erl.f90
	diff -s qc.f90 output/qc.erl.f90

test-erl-scm: qc.erl qc.scm | output
	escript qc.erl scm > output/qc.erl.scm
	diff -s qc.scm output/qc.erl.scm

test-erl-r: qc.erl qc.r | output
	escript qc.erl r > output/qc.erl.r
	diff -s qc.r output/qc.erl.r

test-erl-lua: qc.erl qc.lua | output
	escript qc.erl lua > output/qc.erl.lua
	diff -s qc.lua output/qc.erl.lua

test-erl-go: qc.erl qc.go | output
	escript qc.erl go > output/qc.erl.go
	diff -s qc.go output/qc.erl.go

test-erl-ps: qc.erl qc.ps | output
	escript qc.erl ps > output/qc.erl.ps
	diff -s qc.ps output/qc.erl.ps

test-erl-vala: qc.erl qc.vala | output
	escript qc.erl vala > output/qc.erl.vala
	diff -s qc.vala output/qc.erl.vala

test-erl-pike: qc.erl qc.pike | output
	escript qc.erl pike > output/qc.erl.pike
	diff -s qc.pike output/qc.erl.pike

test-erl-pas: qc.erl qc.pas | output
	escript qc.erl pas > output/qc.erl.pas
	diff -s qc.pas output/qc.erl.pas

test-erl-kt: qc.erl qc.kt | output
	escript qc.erl kt > output/qc.erl.kt
	diff -s qc.kt output/qc.erl.kt

test-erl-m: qc.erl qc.m | output
	escript qc.erl m > output/qc.erl.m
	diff -s qc.m output/qc.erl.m

test-erl-ml: qc.erl qc.ml | output
	escript qc.erl ml > output/qc.erl.ml
	diff -s qc.ml output/qc.erl.ml

test-erl-hs: qc.erl qc.hs | output
	escript qc.erl hs > output/qc.erl.hs
	diff -s qc.hs output/qc.erl.hs

test-erl-zig: qc.erl qc.zig | output
	escript qc.erl zig > output/qc.erl.zig
	diff -s qc.zig output/qc.erl.zig

test-erl-sml: qc.erl qc.sml | output
	escript qc.erl sml > output/qc.erl.sml
	diff -s qc.sml output/qc.erl.sml

test-erl-octave: qc.erl qc.octave | output
	escript qc.erl octave > output/qc.erl.octave
	diff -s qc.octave output/qc.erl.octave

test-erl-groovy: qc.erl qc.groovy | output
	escript qc.erl groovy > output/qc.erl.groovy
	diff -s qc.groovy output/qc.erl.groovy

test-erl-ws: qc.erl qc.ws | output
	escript qc.erl ws > output/qc.erl.ws
	diff -s qc.ws output/qc.erl.ws

test-erl-coffee: qc.erl qc.coffee | output
	escript qc.erl coffee > output/qc.erl.coffee
	diff -s qc.coffee output/qc.erl.coffee

test-erl-swift: qc.erl qc.swift | output
	escript qc.erl swift > output/qc.erl.swift
	diff -s qc.swift output/qc.erl.swift

test-erl-py: qc.erl qc.py | output
	escript qc.erl py > output/qc.erl.py
	diff -s qc.py output/qc.erl.py

test-erl-fs: qc.erl qc.fs | output
	escript qc.erl fs > output/qc.erl.fs
	diff -s qc.fs output/qc.erl.fs

test-erl-nim: qc.erl qc.nim | output
	escript qc.erl nim > output/qc.erl.nim
	diff -s qc.nim output/qc.erl.nim

test-erl-fsx: qc.erl qc.fsx | output
	escript qc.erl fsx > output/qc.erl.fsx
	diff -s qc.fsx output/qc.erl.fsx

test-erl-tcl: qc.erl qc.tcl | output
	escript qc.erl tcl > output/qc.erl.tcl
	diff -s qc.tcl output/qc.erl.tcl

test-erl-bf: qc.erl qc.bf | output
	escript qc.erl bf > output/qc.erl.bf
	diff -s qc.bf output/qc.erl.bf

test-erl-java: qc.erl qc.java | output
	escript qc.erl java > output/qc.erl.java
	diff -s qc.java output/qc.erl.java

test-erl-php: qc.erl qc.php | output
	escript qc.erl php > output/qc.erl.php
	diff -s qc.php output/qc.erl.php

test-erl-bash: qc.erl qc.bash | output
	escript qc.erl bash > output/qc.erl.bash
	diff -s qc.bash output/qc.erl.bash

test-erl-d: qc.erl qc.d | output
	escript qc.erl d > output/qc.erl.d
	diff -s qc.d output/qc.erl.d

test-erl-pl: qc.erl qc.pl | output
	escript qc.erl pl > output/qc.erl.pl
	diff -s qc.pl output/qc.erl.pl

test-erl-exs: qc.erl qc.exs | output
	escript qc.erl exs > output/qc.erl.exs
	diff -s qc.exs output/qc.erl.exs

test-erl-rb: qc.erl qc.rb | output
	escript qc.erl rb > output/qc.erl.rb
	diff -s qc.rb output/qc.erl.rb

test-erl-js: qc.erl qc.js | output
	escript qc.erl js > output/qc.erl.js
	diff -s qc.js output/qc.erl.js

test-erl-ts: qc.erl qc.ts | output
	escript qc.erl ts > output/qc.erl.ts
	diff -s qc.ts output/qc.erl.ts

test-erl-erl: qc.erl qc.erl | output
	escript qc.erl > output/qc.erl.erl
	diff -s qc.erl output/qc.erl.erl

test-erl-cs: qc.erl qc.cs | output
	escript qc.erl cs > output/qc.erl.cs
	diff -s qc.cs output/qc.erl.cs

test-erl-prolog: qc.erl qc.prolog | output
	escript qc.erl prolog > output/qc.erl.prolog
	diff -s qc.prolog output/qc.erl.prolog

test-erl-cr: qc.erl qc.cr | output
	escript qc.erl cr > output/qc.erl.cr
	diff -s qc.cr output/qc.erl.cr

test-erl-unl: qc.erl qc.unl | output
	escript qc.erl unl > output/qc.erl.unl
	diff -s qc.unl output/qc.erl.unl

test-erl-hx: qc.erl qc.hx | output
	escript qc.erl hx > output/qc.erl.hx
	diff -s qc.hx output/qc.erl.hx

test-erl-bef: qc.erl qc.bef | output
	escript qc.erl bef > output/qc.erl.bef
	diff -s qc.bef output/qc.erl.bef

test-erl-awk: qc.erl qc.awk | output
	escript qc.erl awk > output/qc.erl.awk
	diff -s qc.awk output/qc.erl.awk

test-erl-piet: qc.erl qc.piet.gif | output
	escript qc.erl piet > output/qc.erl.piet
	diff -s qc.piet.gif output/qc.erl.piet

test-cs-clj: build/qc.cs.exe.exe qc.clj | output
	mono build/qc.cs.exe.exe clj > output/qc.cs.clj
	diff -s qc.clj output/qc.cs.clj

test-cs-lisp: build/qc.cs.exe.exe qc.lisp | output
	mono build/qc.cs.exe.exe lisp > output/qc.cs.lisp
	diff -s qc.lisp output/qc.cs.lisp

test-cs-rkt: build/qc.cs.exe.exe qc.rkt | output
	mono build/qc.cs.exe.exe rkt > output/qc.cs.rkt
	diff -s qc.rkt output/qc.cs.rkt

test-cs-rs: build/qc.cs.exe.exe qc.rs | output
	mono build/qc.cs.exe.exe rs > output/qc.cs.rs
	diff -s qc.rs output/qc.cs.rs

test-cs-c: build/qc.cs.exe.exe qc.c | output
	mono build/qc.cs.exe.exe c > output/qc.cs.c
	diff -s qc.c output/qc.cs.c

test-cs-cpp: build/qc.cs.exe.exe qc.cpp | output
	mono build/qc.cs.exe.exe cpp > output/qc.cs.cpp
	diff -s qc.cpp output/qc.cs.cpp

test-cs-scala: build/qc.cs.exe.exe qc.scala | output
	mono build/qc.cs.exe.exe scala > output/qc.cs.scala
	diff -s qc.scala output/qc.cs.scala

test-cs-f90: build/qc.cs.exe.exe qc.f90 | output
	mono build/qc.cs.exe.exe f90 > output/qc.cs.f90
	diff -s qc.f90 output/qc.cs.f90

test-cs-scm: build/qc.cs.exe.exe qc.scm | output
	mono build/qc.cs.exe.exe scm > output/qc.cs.scm
	diff -s qc.scm output/qc.cs.scm

test-cs-r: build/qc.cs.exe.exe qc.r | output
	mono build/qc.cs.exe.exe r > output/qc.cs.r
	diff -s qc.r output/qc.cs.r

test-cs-lua: build/qc.cs.exe.exe qc.lua | output
	mono build/qc.cs.exe.exe lua > output/qc.cs.lua
	diff -s qc.lua output/qc.cs.lua

test-cs-go: build/qc.cs.exe.exe qc.go | output
	mono build/qc.cs.exe.exe go > output/qc.cs.go
	diff -s qc.go output/qc.cs.go

test-cs-ps: build/qc.cs.exe.exe qc.ps | output
	mono build/qc.cs.exe.exe ps > output/qc.cs.ps
	diff -s qc.ps output/qc.cs.ps

test-cs-vala: build/qc.cs.exe.exe qc.vala | output
	mono build/qc.cs.exe.exe vala > output/qc.cs.vala
	diff -s qc.vala output/qc.cs.vala

test-cs-pike: build/qc.cs.exe.exe qc.pike | output
	mono build/qc.cs.exe.exe pike > output/qc.cs.pike
	diff -s qc.pike output/qc.cs.pike

test-cs-pas: build/qc.cs.exe.exe qc.pas | output
	mono build/qc.cs.exe.exe pas > output/qc.cs.pas
	diff -s qc.pas output/qc.cs.pas

test-cs-kt: build/qc.cs.exe.exe qc.kt | output
	mono build/qc.cs.exe.exe kt > output/qc.cs.kt
	diff -s qc.kt output/qc.cs.kt

test-cs-m: build/qc.cs.exe.exe qc.m | output
	mono build/qc.cs.exe.exe m > output/qc.cs.m
	diff -s qc.m output/qc.cs.m

test-cs-ml: build/qc.cs.exe.exe qc.ml | output
	mono build/qc.cs.exe.exe ml > output/qc.cs.ml
	diff -s qc.ml output/qc.cs.ml

test-cs-hs: build/qc.cs.exe.exe qc.hs | output
	mono build/qc.cs.exe.exe hs > output/qc.cs.hs
	diff -s qc.hs output/qc.cs.hs

test-cs-zig: build/qc.cs.exe.exe qc.zig | output
	mono build/qc.cs.exe.exe zig > output/qc.cs.zig
	diff -s qc.zig output/qc.cs.zig

test-cs-sml: build/qc.cs.exe.exe qc.sml | output
	mono build/qc.cs.exe.exe sml > output/qc.cs.sml
	diff -s qc.sml output/qc.cs.sml

test-cs-octave: build/qc.cs.exe.exe qc.octave | output
	mono build/qc.cs.exe.exe octave > output/qc.cs.octave
	diff -s qc.octave output/qc.cs.octave

test-cs-groovy: build/qc.cs.exe.exe qc.groovy | output
	mono build/qc.cs.exe.exe groovy > output/qc.cs.groovy
	diff -s qc.groovy output/qc.cs.groovy

test-cs-ws: build/qc.cs.exe.exe qc.ws | output
	mono build/qc.cs.exe.exe ws > output/qc.cs.ws
	diff -s qc.ws output/qc.cs.ws

test-cs-coffee: build/qc.cs.exe.exe qc.coffee | output
	mono build/qc.cs.exe.exe coffee > output/qc.cs.coffee
	diff -s qc.coffee output/qc.cs.coffee

test-cs-swift: build/qc.cs.exe.exe qc.swift | output
	mono build/qc.cs.exe.exe swift > output/qc.cs.swift
	diff -s qc.swift output/qc.cs.swift

test-cs-py: build/qc.cs.exe.exe qc.py | output
	mono build/qc.cs.exe.exe py > output/qc.cs.py
	diff -s qc.py output/qc.cs.py

test-cs-fs: build/qc.cs.exe.exe qc.fs | output
	mono build/qc.cs.exe.exe fs > output/qc.cs.fs
	diff -s qc.fs output/qc.cs.fs

test-cs-nim: build/qc.cs.exe.exe qc.nim | output
	mono build/qc.cs.exe.exe nim > output/qc.cs.nim
	diff -s qc.nim output/qc.cs.nim

test-cs-fsx: build/qc.cs.exe.exe qc.fsx | output
	mono build/qc.cs.exe.exe fsx > output/qc.cs.fsx
	diff -s qc.fsx output/qc.cs.fsx

test-cs-tcl: build/qc.cs.exe.exe qc.tcl | output
	mono build/qc.cs.exe.exe tcl > output/qc.cs.tcl
	diff -s qc.tcl output/qc.cs.tcl

test-cs-bf: build/qc.cs.exe.exe qc.bf | output
	mono build/qc.cs.exe.exe bf > output/qc.cs.bf
	diff -s qc.bf output/qc.cs.bf

test-cs-java: build/qc.cs.exe.exe qc.java | output
	mono build/qc.cs.exe.exe java > output/qc.cs.java
	diff -s qc.java output/qc.cs.java

test-cs-php: build/qc.cs.exe.exe qc.php | output
	mono build/qc.cs.exe.exe php > output/qc.cs.php
	diff -s qc.php output/qc.cs.php

test-cs-bash: build/qc.cs.exe.exe qc.bash | output
	mono build/qc.cs.exe.exe bash > output/qc.cs.bash
	diff -s qc.bash output/qc.cs.bash

test-cs-d: build/qc.cs.exe.exe qc.d | output
	mono build/qc.cs.exe.exe d > output/qc.cs.d
	diff -s qc.d output/qc.cs.d

test-cs-pl: build/qc.cs.exe.exe qc.pl | output
	mono build/qc.cs.exe.exe pl > output/qc.cs.pl
	diff -s qc.pl output/qc.cs.pl

test-cs-exs: build/qc.cs.exe.exe qc.exs | output
	mono build/qc.cs.exe.exe exs > output/qc.cs.exs
	diff -s qc.exs output/qc.cs.exs

test-cs-rb: build/qc.cs.exe.exe qc.rb | output
	mono build/qc.cs.exe.exe rb > output/qc.cs.rb
	diff -s qc.rb output/qc.cs.rb

test-cs-js: build/qc.cs.exe.exe qc.js | output
	mono build/qc.cs.exe.exe js > output/qc.cs.js
	diff -s qc.js output/qc.cs.js

test-cs-ts: build/qc.cs.exe.exe qc.ts | output
	mono build/qc.cs.exe.exe ts > output/qc.cs.ts
	diff -s qc.ts output/qc.cs.ts

test-cs-erl: build/qc.cs.exe.exe qc.erl | output
	mono build/qc.cs.exe.exe erl > output/qc.cs.erl
	diff -s qc.erl output/qc.cs.erl

test-cs-cs: build/qc.cs.exe.exe qc.cs | output
	mono build/qc.cs.exe.exe > output/qc.cs.cs
	diff -s qc.cs output/qc.cs.cs

test-cs-prolog: build/qc.cs.exe.exe qc.prolog | output
	mono build/qc.cs.exe.exe prolog > output/qc.cs.prolog
	diff -s qc.prolog output/qc.cs.prolog

test-cs-cr: build/qc.cs.exe.exe qc.cr | output
	mono build/qc.cs.exe.exe cr > output/qc.cs.cr
	diff -s qc.cr output/qc.cs.cr

test-cs-unl: build/qc.cs.exe.exe qc.unl | output
	mono build/qc.cs.exe.exe unl > output/qc.cs.unl
	diff -s qc.unl output/qc.cs.unl

test-cs-hx: build/qc.cs.exe.exe qc.hx | output
	mono build/qc.cs.exe.exe hx > output/qc.cs.hx
	diff -s qc.hx output/qc.cs.hx

test-cs-bef: build/qc.cs.exe.exe qc.bef | output
	mono build/qc.cs.exe.exe bef > output/qc.cs.bef
	diff -s qc.bef output/qc.cs.bef

test-cs-awk: build/qc.cs.exe.exe qc.awk | output
	mono build/qc.cs.exe.exe awk > output/qc.cs.awk
	diff -s qc.awk output/qc.cs.awk

test-cs-piet: build/qc.cs.exe.exe qc.piet.gif | output
	mono build/qc.cs.exe.exe piet > output/qc.cs.piet
	diff -s qc.piet.gif output/qc.cs.piet

test-prolog-clj: qc.prolog qc.clj | output
	swipl --no-threads -O qc.prolog clj > output/qc.prolog.clj
	diff -s qc.clj output/qc.prolog.clj

test-prolog-lisp: qc.prolog qc.lisp | output
	swipl --no-threads -O qc.prolog lisp > output/qc.prolog.lisp
	diff -s qc.lisp output/qc.prolog.lisp

test-prolog-rkt: qc.prolog qc.rkt | output
	swipl --no-threads -O qc.prolog rkt > output/qc.prolog.rkt
	diff -s qc.rkt output/qc.prolog.rkt

test-prolog-rs: qc.prolog qc.rs | output
	swipl --no-threads -O qc.prolog rs > output/qc.prolog.rs
	diff -s qc.rs output/qc.prolog.rs

test-prolog-c: qc.prolog qc.c | output
	swipl --no-threads -O qc.prolog c > output/qc.prolog.c
	diff -s qc.c output/qc.prolog.c

test-prolog-cpp: qc.prolog qc.cpp | output
	swipl --no-threads -O qc.prolog cpp > output/qc.prolog.cpp
	diff -s qc.cpp output/qc.prolog.cpp

test-prolog-scala: qc.prolog qc.scala | output
	swipl --no-threads -O qc.prolog scala > output/qc.prolog.scala
	diff -s qc.scala output/qc.prolog.scala

test-prolog-f90: qc.prolog qc.f90 | output
	swipl --no-threads -O qc.prolog f90 > output/qc.prolog.f90
	diff -s qc.f90 output/qc.prolog.f90

test-prolog-scm: qc.prolog qc.scm | output
	swipl --no-threads -O qc.prolog scm > output/qc.prolog.scm
	diff -s qc.scm output/qc.prolog.scm

test-prolog-r: qc.prolog qc.r | output
	swipl --no-threads -O qc.prolog r > output/qc.prolog.r
	diff -s qc.r output/qc.prolog.r

test-prolog-lua: qc.prolog qc.lua | output
	swipl --no-threads -O qc.prolog lua > output/qc.prolog.lua
	diff -s qc.lua output/qc.prolog.lua

test-prolog-go: qc.prolog qc.go | output
	swipl --no-threads -O qc.prolog go > output/qc.prolog.go
	diff -s qc.go output/qc.prolog.go

test-prolog-ps: qc.prolog qc.ps | output
	swipl --no-threads -O qc.prolog ps > output/qc.prolog.ps
	diff -s qc.ps output/qc.prolog.ps

test-prolog-vala: qc.prolog qc.vala | output
	swipl --no-threads -O qc.prolog vala > output/qc.prolog.vala
	diff -s qc.vala output/qc.prolog.vala

test-prolog-pike: qc.prolog qc.pike | output
	swipl --no-threads -O qc.prolog pike > output/qc.prolog.pike
	diff -s qc.pike output/qc.prolog.pike

test-prolog-pas: qc.prolog qc.pas | output
	swipl --no-threads -O qc.prolog pas > output/qc.prolog.pas
	diff -s qc.pas output/qc.prolog.pas

test-prolog-kt: qc.prolog qc.kt | output
	swipl --no-threads -O qc.prolog kt > output/qc.prolog.kt
	diff -s qc.kt output/qc.prolog.kt

test-prolog-m: qc.prolog qc.m | output
	swipl --no-threads -O qc.prolog m > output/qc.prolog.m
	diff -s qc.m output/qc.prolog.m

test-prolog-ml: qc.prolog qc.ml | output
	swipl --no-threads -O qc.prolog ml > output/qc.prolog.ml
	diff -s qc.ml output/qc.prolog.ml

test-prolog-hs: qc.prolog qc.hs | output
	swipl --no-threads -O qc.prolog hs > output/qc.prolog.hs
	diff -s qc.hs output/qc.prolog.hs

test-prolog-zig: qc.prolog qc.zig | output
	swipl --no-threads -O qc.prolog zig > output/qc.prolog.zig
	diff -s qc.zig output/qc.prolog.zig

test-prolog-sml: qc.prolog qc.sml | output
	swipl --no-threads -O qc.prolog sml > output/qc.prolog.sml
	diff -s qc.sml output/qc.prolog.sml

test-prolog-octave: qc.prolog qc.octave | output
	swipl --no-threads -O qc.prolog octave > output/qc.prolog.octave
	diff -s qc.octave output/qc.prolog.octave

test-prolog-groovy: qc.prolog qc.groovy | output
	swipl --no-threads -O qc.prolog groovy > output/qc.prolog.groovy
	diff -s qc.groovy output/qc.prolog.groovy

test-prolog-ws: qc.prolog qc.ws | output
	swipl --no-threads -O qc.prolog ws > output/qc.prolog.ws
	diff -s qc.ws output/qc.prolog.ws

test-prolog-coffee: qc.prolog qc.coffee | output
	swipl --no-threads -O qc.prolog coffee > output/qc.prolog.coffee
	diff -s qc.coffee output/qc.prolog.coffee

test-prolog-swift: qc.prolog qc.swift | output
	swipl --no-threads -O qc.prolog swift > output/qc.prolog.swift
	diff -s qc.swift output/qc.prolog.swift

test-prolog-py: qc.prolog qc.py | output
	swipl --no-threads -O qc.prolog py > output/qc.prolog.py
	diff -s qc.py output/qc.prolog.py

test-prolog-fs: qc.prolog qc.fs | output
	swipl --no-threads -O qc.prolog fs > output/qc.prolog.fs
	diff -s qc.fs output/qc.prolog.fs

test-prolog-nim: qc.prolog qc.nim | output
	swipl --no-threads -O qc.prolog nim > output/qc.prolog.nim
	diff -s qc.nim output/qc.prolog.nim

test-prolog-fsx: qc.prolog qc.fsx | output
	swipl --no-threads -O qc.prolog fsx > output/qc.prolog.fsx
	diff -s qc.fsx output/qc.prolog.fsx

test-prolog-tcl: qc.prolog qc.tcl | output
	swipl --no-threads -O qc.prolog tcl > output/qc.prolog.tcl
	diff -s qc.tcl output/qc.prolog.tcl

test-prolog-bf: qc.prolog qc.bf | output
	swipl --no-threads -O qc.prolog bf > output/qc.prolog.bf
	diff -s qc.bf output/qc.prolog.bf

test-prolog-java: qc.prolog qc.java | output
	swipl --no-threads -O qc.prolog java > output/qc.prolog.java
	diff -s qc.java output/qc.prolog.java

test-prolog-php: qc.prolog qc.php | output
	swipl --no-threads -O qc.prolog php > output/qc.prolog.php
	diff -s qc.php output/qc.prolog.php

test-prolog-bash: qc.prolog qc.bash | output
	swipl --no-threads -O qc.prolog bash > output/qc.prolog.bash
	diff -s qc.bash output/qc.prolog.bash

test-prolog-d: qc.prolog qc.d | output
	swipl --no-threads -O qc.prolog d > output/qc.prolog.d
	diff -s qc.d output/qc.prolog.d

test-prolog-pl: qc.prolog qc.pl | output
	swipl --no-threads -O qc.prolog pl > output/qc.prolog.pl
	diff -s qc.pl output/qc.prolog.pl

test-prolog-exs: qc.prolog qc.exs | output
	swipl --no-threads -O qc.prolog exs > output/qc.prolog.exs
	diff -s qc.exs output/qc.prolog.exs

test-prolog-rb: qc.prolog qc.rb | output
	swipl --no-threads -O qc.prolog rb > output/qc.prolog.rb
	diff -s qc.rb output/qc.prolog.rb

test-prolog-js: qc.prolog qc.js | output
	swipl --no-threads -O qc.prolog js > output/qc.prolog.js
	diff -s qc.js output/qc.prolog.js

test-prolog-ts: qc.prolog qc.ts | output
	swipl --no-threads -O qc.prolog ts > output/qc.prolog.ts
	diff -s qc.ts output/qc.prolog.ts

test-prolog-erl: qc.prolog qc.erl | output
	swipl --no-threads -O qc.prolog erl > output/qc.prolog.erl
	diff -s qc.erl output/qc.prolog.erl

test-prolog-cs: qc.prolog qc.cs | output
	swipl --no-threads -O qc.prolog cs > output/qc.prolog.cs
	diff -s qc.cs output/qc.prolog.cs

test-prolog-prolog: qc.prolog qc.prolog | output
	swipl --no-threads -O qc.prolog > output/qc.prolog.prolog
	diff -s qc.prolog output/qc.prolog.prolog

test-prolog-cr: qc.prolog qc.cr | output
	swipl --no-threads -O qc.prolog cr > output/qc.prolog.cr
	diff -s qc.cr output/qc.prolog.cr

test-prolog-unl: qc.prolog qc.unl | output
	swipl --no-threads -O qc.prolog unl > output/qc.prolog.unl
	diff -s qc.unl output/qc.prolog.unl

test-prolog-hx: qc.prolog qc.hx | output
	swipl --no-threads -O qc.prolog hx > output/qc.prolog.hx
	diff -s qc.hx output/qc.prolog.hx

test-prolog-bef: qc.prolog qc.bef | output
	swipl --no-threads -O qc.prolog bef > output/qc.prolog.bef
	diff -s qc.bef output/qc.prolog.bef

test-prolog-awk: qc.prolog qc.awk | output
	swipl --no-threads -O qc.prolog awk > output/qc.prolog.awk
	diff -s qc.awk output/qc.prolog.awk

test-prolog-piet: qc.prolog qc.piet.gif | output
	swipl --no-threads -O qc.prolog piet > output/qc.prolog.piet
	diff -s qc.piet.gif output/qc.prolog.piet

test-cr-clj: build/qc.cr.exe qc.clj | output
	build/qc.cr.exe clj > output/qc.cr.clj
	diff -s qc.clj output/qc.cr.clj

test-cr-lisp: build/qc.cr.exe qc.lisp | output
	build/qc.cr.exe lisp > output/qc.cr.lisp
	diff -s qc.lisp output/qc.cr.lisp

test-cr-rkt: build/qc.cr.exe qc.rkt | output
	build/qc.cr.exe rkt > output/qc.cr.rkt
	diff -s qc.rkt output/qc.cr.rkt

test-cr-rs: build/qc.cr.exe qc.rs | output
	build/qc.cr.exe rs > output/qc.cr.rs
	diff -s qc.rs output/qc.cr.rs

test-cr-c: build/qc.cr.exe qc.c | output
	build/qc.cr.exe c > output/qc.cr.c
	diff -s qc.c output/qc.cr.c

test-cr-cpp: build/qc.cr.exe qc.cpp | output
	build/qc.cr.exe cpp > output/qc.cr.cpp
	diff -s qc.cpp output/qc.cr.cpp

test-cr-scala: build/qc.cr.exe qc.scala | output
	build/qc.cr.exe scala > output/qc.cr.scala
	diff -s qc.scala output/qc.cr.scala

test-cr-f90: build/qc.cr.exe qc.f90 | output
	build/qc.cr.exe f90 > output/qc.cr.f90
	diff -s qc.f90 output/qc.cr.f90

test-cr-scm: build/qc.cr.exe qc.scm | output
	build/qc.cr.exe scm > output/qc.cr.scm
	diff -s qc.scm output/qc.cr.scm

test-cr-r: build/qc.cr.exe qc.r | output
	build/qc.cr.exe r > output/qc.cr.r
	diff -s qc.r output/qc.cr.r

test-cr-lua: build/qc.cr.exe qc.lua | output
	build/qc.cr.exe lua > output/qc.cr.lua
	diff -s qc.lua output/qc.cr.lua

test-cr-go: build/qc.cr.exe qc.go | output
	build/qc.cr.exe go > output/qc.cr.go
	diff -s qc.go output/qc.cr.go

test-cr-ps: build/qc.cr.exe qc.ps | output
	build/qc.cr.exe ps > output/qc.cr.ps
	diff -s qc.ps output/qc.cr.ps

test-cr-vala: build/qc.cr.exe qc.vala | output
	build/qc.cr.exe vala > output/qc.cr.vala
	diff -s qc.vala output/qc.cr.vala

test-cr-pike: build/qc.cr.exe qc.pike | output
	build/qc.cr.exe pike > output/qc.cr.pike
	diff -s qc.pike output/qc.cr.pike

test-cr-pas: build/qc.cr.exe qc.pas | output
	build/qc.cr.exe pas > output/qc.cr.pas
	diff -s qc.pas output/qc.cr.pas

test-cr-kt: build/qc.cr.exe qc.kt | output
	build/qc.cr.exe kt > output/qc.cr.kt
	diff -s qc.kt output/qc.cr.kt

test-cr-m: build/qc.cr.exe qc.m | output
	build/qc.cr.exe m > output/qc.cr.m
	diff -s qc.m output/qc.cr.m

test-cr-ml: build/qc.cr.exe qc.ml | output
	build/qc.cr.exe ml > output/qc.cr.ml
	diff -s qc.ml output/qc.cr.ml

test-cr-hs: build/qc.cr.exe qc.hs | output
	build/qc.cr.exe hs > output/qc.cr.hs
	diff -s qc.hs output/qc.cr.hs

test-cr-zig: build/qc.cr.exe qc.zig | output
	build/qc.cr.exe zig > output/qc.cr.zig
	diff -s qc.zig output/qc.cr.zig

test-cr-sml: build/qc.cr.exe qc.sml | output
	build/qc.cr.exe sml > output/qc.cr.sml
	diff -s qc.sml output/qc.cr.sml

test-cr-octave: build/qc.cr.exe qc.octave | output
	build/qc.cr.exe octave > output/qc.cr.octave
	diff -s qc.octave output/qc.cr.octave

test-cr-groovy: build/qc.cr.exe qc.groovy | output
	build/qc.cr.exe groovy > output/qc.cr.groovy
	diff -s qc.groovy output/qc.cr.groovy

test-cr-ws: build/qc.cr.exe qc.ws | output
	build/qc.cr.exe ws > output/qc.cr.ws
	diff -s qc.ws output/qc.cr.ws

test-cr-coffee: build/qc.cr.exe qc.coffee | output
	build/qc.cr.exe coffee > output/qc.cr.coffee
	diff -s qc.coffee output/qc.cr.coffee

test-cr-swift: build/qc.cr.exe qc.swift | output
	build/qc.cr.exe swift > output/qc.cr.swift
	diff -s qc.swift output/qc.cr.swift

test-cr-py: build/qc.cr.exe qc.py | output
	build/qc.cr.exe py > output/qc.cr.py
	diff -s qc.py output/qc.cr.py

test-cr-fs: build/qc.cr.exe qc.fs | output
	build/qc.cr.exe fs > output/qc.cr.fs
	diff -s qc.fs output/qc.cr.fs

test-cr-nim: build/qc.cr.exe qc.nim | output
	build/qc.cr.exe nim > output/qc.cr.nim
	diff -s qc.nim output/qc.cr.nim

test-cr-fsx: build/qc.cr.exe qc.fsx | output
	build/qc.cr.exe fsx > output/qc.cr.fsx
	diff -s qc.fsx output/qc.cr.fsx

test-cr-tcl: build/qc.cr.exe qc.tcl | output
	build/qc.cr.exe tcl > output/qc.cr.tcl
	diff -s qc.tcl output/qc.cr.tcl

test-cr-bf: build/qc.cr.exe qc.bf | output
	build/qc.cr.exe bf > output/qc.cr.bf
	diff -s qc.bf output/qc.cr.bf

test-cr-java: build/qc.cr.exe qc.java | output
	build/qc.cr.exe java > output/qc.cr.java
	diff -s qc.java output/qc.cr.java

test-cr-php: build/qc.cr.exe qc.php | output
	build/qc.cr.exe php > output/qc.cr.php
	diff -s qc.php output/qc.cr.php

test-cr-bash: build/qc.cr.exe qc.bash | output
	build/qc.cr.exe bash > output/qc.cr.bash
	diff -s qc.bash output/qc.cr.bash

test-cr-d: build/qc.cr.exe qc.d | output
	build/qc.cr.exe d > output/qc.cr.d
	diff -s qc.d output/qc.cr.d

test-cr-pl: build/qc.cr.exe qc.pl | output
	build/qc.cr.exe pl > output/qc.cr.pl
	diff -s qc.pl output/qc.cr.pl

test-cr-exs: build/qc.cr.exe qc.exs | output
	build/qc.cr.exe exs > output/qc.cr.exs
	diff -s qc.exs output/qc.cr.exs

test-cr-rb: build/qc.cr.exe qc.rb | output
	build/qc.cr.exe rb > output/qc.cr.rb
	diff -s qc.rb output/qc.cr.rb

test-cr-js: build/qc.cr.exe qc.js | output
	build/qc.cr.exe js > output/qc.cr.js
	diff -s qc.js output/qc.cr.js

test-cr-ts: build/qc.cr.exe qc.ts | output
	build/qc.cr.exe ts > output/qc.cr.ts
	diff -s qc.ts output/qc.cr.ts

test-cr-erl: build/qc.cr.exe qc.erl | output
	build/qc.cr.exe erl > output/qc.cr.erl
	diff -s qc.erl output/qc.cr.erl

test-cr-cs: build/qc.cr.exe qc.cs | output
	build/qc.cr.exe cs > output/qc.cr.cs
	diff -s qc.cs output/qc.cr.cs

test-cr-prolog: build/qc.cr.exe qc.prolog | output
	build/qc.cr.exe prolog > output/qc.cr.prolog
	diff -s qc.prolog output/qc.cr.prolog

test-cr-cr: build/qc.cr.exe qc.cr | output
	build/qc.cr.exe > output/qc.cr.cr
	diff -s qc.cr output/qc.cr.cr

test-cr-unl: build/qc.cr.exe qc.unl | output
	build/qc.cr.exe unl > output/qc.cr.unl
	diff -s qc.unl output/qc.cr.unl

test-cr-hx: build/qc.cr.exe qc.hx | output
	build/qc.cr.exe hx > output/qc.cr.hx
	diff -s qc.hx output/qc.cr.hx

test-cr-bef: build/qc.cr.exe qc.bef | output
	build/qc.cr.exe bef > output/qc.cr.bef
	diff -s qc.bef output/qc.cr.bef

test-cr-awk: build/qc.cr.exe qc.awk | output
	build/qc.cr.exe awk > output/qc.cr.awk
	diff -s qc.awk output/qc.cr.awk

test-cr-piet: build/qc.cr.exe qc.piet.gif | output
	build/qc.cr.exe piet > output/qc.cr.piet
	diff -s qc.piet.gif output/qc.cr.piet

test-unl-clj: qc.unl vendor/bin/unl qc.clj | output
	echo clj | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.clj
	diff -s qc.clj output/qc.unl.clj

test-unl-lisp: qc.unl vendor/bin/unl qc.lisp | output
	echo lisp | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.lisp
	diff -s qc.lisp output/qc.unl.lisp

test-unl-rkt: qc.unl vendor/bin/unl qc.rkt | output
	echo rkt | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.rkt
	diff -s qc.rkt output/qc.unl.rkt

test-unl-rs: qc.unl vendor/bin/unl qc.rs | output
	echo rs | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.rs
	diff -s qc.rs output/qc.unl.rs

test-unl-c: qc.unl vendor/bin/unl qc.c | output
	echo c | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.c
	diff -s qc.c output/qc.unl.c

test-unl-cpp: qc.unl vendor/bin/unl qc.cpp | output
	echo cpp | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.cpp
	diff -s qc.cpp output/qc.unl.cpp

test-unl-scala: qc.unl vendor/bin/unl qc.scala | output
	echo scala | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.scala
	diff -s qc.scala output/qc.unl.scala

test-unl-f90: qc.unl vendor/bin/unl qc.f90 | output
	echo f90 | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.f90
	diff -s qc.f90 output/qc.unl.f90

test-unl-scm: qc.unl vendor/bin/unl qc.scm | output
	echo scm | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.scm
	diff -s qc.scm output/qc.unl.scm

test-unl-r: qc.unl vendor/bin/unl qc.r | output
	echo r | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.r
	diff -s qc.r output/qc.unl.r

test-unl-lua: qc.unl vendor/bin/unl qc.lua | output
	echo lua | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.lua
	diff -s qc.lua output/qc.unl.lua

test-unl-go: qc.unl vendor/bin/unl qc.go | output
	echo go | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.go
	diff -s qc.go output/qc.unl.go

test-unl-ps: qc.unl vendor/bin/unl qc.ps | output
	echo ps | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.ps
	diff -s qc.ps output/qc.unl.ps

test-unl-vala: qc.unl vendor/bin/unl qc.vala | output
	echo vala | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.vala
	diff -s qc.vala output/qc.unl.vala

test-unl-pike: qc.unl vendor/bin/unl qc.pike | output
	echo pike | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.pike
	diff -s qc.pike output/qc.unl.pike

test-unl-pas: qc.unl vendor/bin/unl qc.pas | output
	echo pas | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.pas
	diff -s qc.pas output/qc.unl.pas

test-unl-kt: qc.unl vendor/bin/unl qc.kt | output
	echo kt | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.kt
	diff -s qc.kt output/qc.unl.kt

test-unl-m: qc.unl vendor/bin/unl qc.m | output
	echo m | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.m
	diff -s qc.m output/qc.unl.m

test-unl-ml: qc.unl vendor/bin/unl qc.ml | output
	echo ml | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.ml
	diff -s qc.ml output/qc.unl.ml

test-unl-hs: qc.unl vendor/bin/unl qc.hs | output
	echo hs | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.hs
	diff -s qc.hs output/qc.unl.hs

test-unl-zig: qc.unl vendor/bin/unl qc.zig | output
	echo zig | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.zig
	diff -s qc.zig output/qc.unl.zig

test-unl-sml: qc.unl vendor/bin/unl qc.sml | output
	echo sml | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.sml
	diff -s qc.sml output/qc.unl.sml

test-unl-octave: qc.unl vendor/bin/unl qc.octave | output
	echo octave | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.octave
	diff -s qc.octave output/qc.unl.octave

test-unl-groovy: qc.unl vendor/bin/unl qc.groovy | output
	echo groovy | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.groovy
	diff -s qc.groovy output/qc.unl.groovy

test-unl-ws: qc.unl vendor/bin/unl qc.ws | output
	echo ws | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.ws
	diff -s qc.ws output/qc.unl.ws

test-unl-coffee: qc.unl vendor/bin/unl qc.coffee | output
	echo coffee | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.coffee
	diff -s qc.coffee output/qc.unl.coffee

test-unl-swift: qc.unl vendor/bin/unl qc.swift | output
	echo swift | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.swift
	diff -s qc.swift output/qc.unl.swift

test-unl-py: qc.unl vendor/bin/unl qc.py | output
	echo py | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.py
	diff -s qc.py output/qc.unl.py

test-unl-fs: qc.unl vendor/bin/unl qc.fs | output
	echo fs | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.fs
	diff -s qc.fs output/qc.unl.fs

test-unl-nim: qc.unl vendor/bin/unl qc.nim | output
	echo nim | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.nim
	diff -s qc.nim output/qc.unl.nim

test-unl-fsx: qc.unl vendor/bin/unl qc.fsx | output
	echo fsx | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.fsx
	diff -s qc.fsx output/qc.unl.fsx

test-unl-tcl: qc.unl vendor/bin/unl qc.tcl | output
	echo tcl | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.tcl
	diff -s qc.tcl output/qc.unl.tcl

test-unl-bf: qc.unl vendor/bin/unl qc.bf | output
	echo bf | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.bf
	diff -s qc.bf output/qc.unl.bf

test-unl-java: qc.unl vendor/bin/unl qc.java | output
	echo java | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.java
	diff -s qc.java output/qc.unl.java

test-unl-php: qc.unl vendor/bin/unl qc.php | output
	echo php | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.php
	diff -s qc.php output/qc.unl.php

test-unl-bash: qc.unl vendor/bin/unl qc.bash | output
	echo bash | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.bash
	diff -s qc.bash output/qc.unl.bash

test-unl-d: qc.unl vendor/bin/unl qc.d | output
	echo d | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.d
	diff -s qc.d output/qc.unl.d

test-unl-pl: qc.unl vendor/bin/unl qc.pl | output
	echo pl | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.pl
	diff -s qc.pl output/qc.unl.pl

test-unl-exs: qc.unl vendor/bin/unl qc.exs | output
	echo exs | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.exs
	diff -s qc.exs output/qc.unl.exs

test-unl-rb: qc.unl vendor/bin/unl qc.rb | output
	echo rb | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.rb
	diff -s qc.rb output/qc.unl.rb

test-unl-js: qc.unl vendor/bin/unl qc.js | output
	echo js | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.js
	diff -s qc.js output/qc.unl.js

test-unl-ts: qc.unl vendor/bin/unl qc.ts | output
	echo ts | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.ts
	diff -s qc.ts output/qc.unl.ts

test-unl-erl: qc.unl vendor/bin/unl qc.erl | output
	echo erl | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.erl
	diff -s qc.erl output/qc.unl.erl

test-unl-cs: qc.unl vendor/bin/unl qc.cs | output
	echo cs | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.cs
	diff -s qc.cs output/qc.unl.cs

test-unl-prolog: qc.unl vendor/bin/unl qc.prolog | output
	echo prolog | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.prolog
	diff -s qc.prolog output/qc.unl.prolog

test-unl-cr: qc.unl vendor/bin/unl qc.cr | output
	echo cr | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.cr
	diff -s qc.cr output/qc.unl.cr

test-unl-unl: qc.unl vendor/bin/unl qc.unl | output
	echo | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.unl
	diff -s qc.unl output/qc.unl.unl

test-unl-hx: qc.unl vendor/bin/unl qc.hx | output
	echo hx | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.hx
	diff -s qc.hx output/qc.unl.hx

test-unl-bef: qc.unl vendor/bin/unl qc.bef | output
	echo bef | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.bef
	diff -s qc.bef output/qc.unl.bef

test-unl-awk: qc.unl vendor/bin/unl qc.awk | output
	echo awk | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.awk
	diff -s qc.awk output/qc.unl.awk

test-unl-piet: qc.unl vendor/bin/unl qc.piet.gif | output
	echo piet | vendor/bin/unl -h 40000000 qc.unl > output/qc.unl.piet
	diff -s qc.piet.gif output/qc.unl.piet

test-hx-clj: build/qc.hx.exe.n qc.clj | output
	neko build/qc.hx.exe.n clj > output/qc.hx.clj
	diff -s qc.clj output/qc.hx.clj

test-hx-lisp: build/qc.hx.exe.n qc.lisp | output
	neko build/qc.hx.exe.n lisp > output/qc.hx.lisp
	diff -s qc.lisp output/qc.hx.lisp

test-hx-rkt: build/qc.hx.exe.n qc.rkt | output
	neko build/qc.hx.exe.n rkt > output/qc.hx.rkt
	diff -s qc.rkt output/qc.hx.rkt

test-hx-rs: build/qc.hx.exe.n qc.rs | output
	neko build/qc.hx.exe.n rs > output/qc.hx.rs
	diff -s qc.rs output/qc.hx.rs

test-hx-c: build/qc.hx.exe.n qc.c | output
	neko build/qc.hx.exe.n c > output/qc.hx.c
	diff -s qc.c output/qc.hx.c

test-hx-cpp: build/qc.hx.exe.n qc.cpp | output
	neko build/qc.hx.exe.n cpp > output/qc.hx.cpp
	diff -s qc.cpp output/qc.hx.cpp

test-hx-scala: build/qc.hx.exe.n qc.scala | output
	neko build/qc.hx.exe.n scala > output/qc.hx.scala
	diff -s qc.scala output/qc.hx.scala

test-hx-f90: build/qc.hx.exe.n qc.f90 | output
	neko build/qc.hx.exe.n f90 > output/qc.hx.f90
	diff -s qc.f90 output/qc.hx.f90

test-hx-scm: build/qc.hx.exe.n qc.scm | output
	neko build/qc.hx.exe.n scm > output/qc.hx.scm
	diff -s qc.scm output/qc.hx.scm

test-hx-r: build/qc.hx.exe.n qc.r | output
	neko build/qc.hx.exe.n r > output/qc.hx.r
	diff -s qc.r output/qc.hx.r

test-hx-lua: build/qc.hx.exe.n qc.lua | output
	neko build/qc.hx.exe.n lua > output/qc.hx.lua
	diff -s qc.lua output/qc.hx.lua

test-hx-go: build/qc.hx.exe.n qc.go | output
	neko build/qc.hx.exe.n go > output/qc.hx.go
	diff -s qc.go output/qc.hx.go

test-hx-ps: build/qc.hx.exe.n qc.ps | output
	neko build/qc.hx.exe.n ps > output/qc.hx.ps
	diff -s qc.ps output/qc.hx.ps

test-hx-vala: build/qc.hx.exe.n qc.vala | output
	neko build/qc.hx.exe.n vala > output/qc.hx.vala
	diff -s qc.vala output/qc.hx.vala

test-hx-pike: build/qc.hx.exe.n qc.pike | output
	neko build/qc.hx.exe.n pike > output/qc.hx.pike
	diff -s qc.pike output/qc.hx.pike

test-hx-pas: build/qc.hx.exe.n qc.pas | output
	neko build/qc.hx.exe.n pas > output/qc.hx.pas
	diff -s qc.pas output/qc.hx.pas

test-hx-kt: build/qc.hx.exe.n qc.kt | output
	neko build/qc.hx.exe.n kt > output/qc.hx.kt
	diff -s qc.kt output/qc.hx.kt

test-hx-m: build/qc.hx.exe.n qc.m | output
	neko build/qc.hx.exe.n m > output/qc.hx.m
	diff -s qc.m output/qc.hx.m

test-hx-ml: build/qc.hx.exe.n qc.ml | output
	neko build/qc.hx.exe.n ml > output/qc.hx.ml
	diff -s qc.ml output/qc.hx.ml

test-hx-hs: build/qc.hx.exe.n qc.hs | output
	neko build/qc.hx.exe.n hs > output/qc.hx.hs
	diff -s qc.hs output/qc.hx.hs

test-hx-zig: build/qc.hx.exe.n qc.zig | output
	neko build/qc.hx.exe.n zig > output/qc.hx.zig
	diff -s qc.zig output/qc.hx.zig

test-hx-sml: build/qc.hx.exe.n qc.sml | output
	neko build/qc.hx.exe.n sml > output/qc.hx.sml
	diff -s qc.sml output/qc.hx.sml

test-hx-octave: build/qc.hx.exe.n qc.octave | output
	neko build/qc.hx.exe.n octave > output/qc.hx.octave
	diff -s qc.octave output/qc.hx.octave

test-hx-groovy: build/qc.hx.exe.n qc.groovy | output
	neko build/qc.hx.exe.n groovy > output/qc.hx.groovy
	diff -s qc.groovy output/qc.hx.groovy

test-hx-ws: build/qc.hx.exe.n qc.ws | output
	neko build/qc.hx.exe.n ws > output/qc.hx.ws
	diff -s qc.ws output/qc.hx.ws

test-hx-coffee: build/qc.hx.exe.n qc.coffee | output
	neko build/qc.hx.exe.n coffee > output/qc.hx.coffee
	diff -s qc.coffee output/qc.hx.coffee

test-hx-swift: build/qc.hx.exe.n qc.swift | output
	neko build/qc.hx.exe.n swift > output/qc.hx.swift
	diff -s qc.swift output/qc.hx.swift

test-hx-py: build/qc.hx.exe.n qc.py | output
	neko build/qc.hx.exe.n py > output/qc.hx.py
	diff -s qc.py output/qc.hx.py

test-hx-fs: build/qc.hx.exe.n qc.fs | output
	neko build/qc.hx.exe.n fs > output/qc.hx.fs
	diff -s qc.fs output/qc.hx.fs

test-hx-nim: build/qc.hx.exe.n qc.nim | output
	neko build/qc.hx.exe.n nim > output/qc.hx.nim
	diff -s qc.nim output/qc.hx.nim

test-hx-fsx: build/qc.hx.exe.n qc.fsx | output
	neko build/qc.hx.exe.n fsx > output/qc.hx.fsx
	diff -s qc.fsx output/qc.hx.fsx

test-hx-tcl: build/qc.hx.exe.n qc.tcl | output
	neko build/qc.hx.exe.n tcl > output/qc.hx.tcl
	diff -s qc.tcl output/qc.hx.tcl

test-hx-bf: build/qc.hx.exe.n qc.bf | output
	neko build/qc.hx.exe.n bf > output/qc.hx.bf
	diff -s qc.bf output/qc.hx.bf

test-hx-java: build/qc.hx.exe.n qc.java | output
	neko build/qc.hx.exe.n java > output/qc.hx.java
	diff -s qc.java output/qc.hx.java

test-hx-php: build/qc.hx.exe.n qc.php | output
	neko build/qc.hx.exe.n php > output/qc.hx.php
	diff -s qc.php output/qc.hx.php

test-hx-bash: build/qc.hx.exe.n qc.bash | output
	neko build/qc.hx.exe.n bash > output/qc.hx.bash
	diff -s qc.bash output/qc.hx.bash

test-hx-d: build/qc.hx.exe.n qc.d | output
	neko build/qc.hx.exe.n d > output/qc.hx.d
	diff -s qc.d output/qc.hx.d

test-hx-pl: build/qc.hx.exe.n qc.pl | output
	neko build/qc.hx.exe.n pl > output/qc.hx.pl
	diff -s qc.pl output/qc.hx.pl

test-hx-exs: build/qc.hx.exe.n qc.exs | output
	neko build/qc.hx.exe.n exs > output/qc.hx.exs
	diff -s qc.exs output/qc.hx.exs

test-hx-rb: build/qc.hx.exe.n qc.rb | output
	neko build/qc.hx.exe.n rb > output/qc.hx.rb
	diff -s qc.rb output/qc.hx.rb

test-hx-js: build/qc.hx.exe.n qc.js | output
	neko build/qc.hx.exe.n js > output/qc.hx.js
	diff -s qc.js output/qc.hx.js

test-hx-ts: build/qc.hx.exe.n qc.ts | output
	neko build/qc.hx.exe.n ts > output/qc.hx.ts
	diff -s qc.ts output/qc.hx.ts

test-hx-erl: build/qc.hx.exe.n qc.erl | output
	neko build/qc.hx.exe.n erl > output/qc.hx.erl
	diff -s qc.erl output/qc.hx.erl

test-hx-cs: build/qc.hx.exe.n qc.cs | output
	neko build/qc.hx.exe.n cs > output/qc.hx.cs
	diff -s qc.cs output/qc.hx.cs

test-hx-prolog: build/qc.hx.exe.n qc.prolog | output
	neko build/qc.hx.exe.n prolog > output/qc.hx.prolog
	diff -s qc.prolog output/qc.hx.prolog

test-hx-cr: build/qc.hx.exe.n qc.cr | output
	neko build/qc.hx.exe.n cr > output/qc.hx.cr
	diff -s qc.cr output/qc.hx.cr

test-hx-unl: build/qc.hx.exe.n qc.unl | output
	neko build/qc.hx.exe.n unl > output/qc.hx.unl
	diff -s qc.unl output/qc.hx.unl

test-hx-hx: build/qc.hx.exe.n qc.hx | output
	neko build/qc.hx.exe.n > output/qc.hx.hx
	diff -s qc.hx output/qc.hx.hx

test-hx-bef: build/qc.hx.exe.n qc.bef | output
	neko build/qc.hx.exe.n bef > output/qc.hx.bef
	diff -s qc.bef output/qc.hx.bef

test-hx-awk: build/qc.hx.exe.n qc.awk | output
	neko build/qc.hx.exe.n awk > output/qc.hx.awk
	diff -s qc.awk output/qc.hx.awk

test-hx-piet: build/qc.hx.exe.n qc.piet.gif | output
	neko build/qc.hx.exe.n piet > output/qc.hx.piet
	diff -s qc.piet.gif output/qc.hx.piet

test-bef-clj: qc.bef vendor/bin/bef qc.clj | output
	echo clj | vendor/bin/bef qc.bef > output/qc.bef.clj
	diff -s qc.clj output/qc.bef.clj

test-bef-lisp: qc.bef vendor/bin/bef qc.lisp | output
	echo lisp | vendor/bin/bef qc.bef > output/qc.bef.lisp
	diff -s qc.lisp output/qc.bef.lisp

test-bef-rkt: qc.bef vendor/bin/bef qc.rkt | output
	echo rkt | vendor/bin/bef qc.bef > output/qc.bef.rkt
	diff -s qc.rkt output/qc.bef.rkt

test-bef-rs: qc.bef vendor/bin/bef qc.rs | output
	echo rs | vendor/bin/bef qc.bef > output/qc.bef.rs
	diff -s qc.rs output/qc.bef.rs

test-bef-c: qc.bef vendor/bin/bef qc.c | output
	echo c | vendor/bin/bef qc.bef > output/qc.bef.c
	diff -s qc.c output/qc.bef.c

test-bef-cpp: qc.bef vendor/bin/bef qc.cpp | output
	echo cpp | vendor/bin/bef qc.bef > output/qc.bef.cpp
	diff -s qc.cpp output/qc.bef.cpp

test-bef-scala: qc.bef vendor/bin/bef qc.scala | output
	echo scala | vendor/bin/bef qc.bef > output/qc.bef.scala
	diff -s qc.scala output/qc.bef.scala

test-bef-f90: qc.bef vendor/bin/bef qc.f90 | output
	echo f90 | vendor/bin/bef qc.bef > output/qc.bef.f90
	diff -s qc.f90 output/qc.bef.f90

test-bef-scm: qc.bef vendor/bin/bef qc.scm | output
	echo scm | vendor/bin/bef qc.bef > output/qc.bef.scm
	diff -s qc.scm output/qc.bef.scm

test-bef-r: qc.bef vendor/bin/bef qc.r | output
	echo r | vendor/bin/bef qc.bef > output/qc.bef.r
	diff -s qc.r output/qc.bef.r

test-bef-lua: qc.bef vendor/bin/bef qc.lua | output
	echo lua | vendor/bin/bef qc.bef > output/qc.bef.lua
	diff -s qc.lua output/qc.bef.lua

test-bef-go: qc.bef vendor/bin/bef qc.go | output
	echo go | vendor/bin/bef qc.bef > output/qc.bef.go
	diff -s qc.go output/qc.bef.go

test-bef-ps: qc.bef vendor/bin/bef qc.ps | output
	echo ps | vendor/bin/bef qc.bef > output/qc.bef.ps
	diff -s qc.ps output/qc.bef.ps

test-bef-vala: qc.bef vendor/bin/bef qc.vala | output
	echo vala | vendor/bin/bef qc.bef > output/qc.bef.vala
	diff -s qc.vala output/qc.bef.vala

test-bef-pike: qc.bef vendor/bin/bef qc.pike | output
	echo pike | vendor/bin/bef qc.bef > output/qc.bef.pike
	diff -s qc.pike output/qc.bef.pike

test-bef-pas: qc.bef vendor/bin/bef qc.pas | output
	echo pas | vendor/bin/bef qc.bef > output/qc.bef.pas
	diff -s qc.pas output/qc.bef.pas

test-bef-kt: qc.bef vendor/bin/bef qc.kt | output
	echo kt | vendor/bin/bef qc.bef > output/qc.bef.kt
	diff -s qc.kt output/qc.bef.kt

test-bef-m: qc.bef vendor/bin/bef qc.m | output
	echo m | vendor/bin/bef qc.bef > output/qc.bef.m
	diff -s qc.m output/qc.bef.m

test-bef-ml: qc.bef vendor/bin/bef qc.ml | output
	echo ml | vendor/bin/bef qc.bef > output/qc.bef.ml
	diff -s qc.ml output/qc.bef.ml

test-bef-hs: qc.bef vendor/bin/bef qc.hs | output
	echo hs | vendor/bin/bef qc.bef > output/qc.bef.hs
	diff -s qc.hs output/qc.bef.hs

test-bef-zig: qc.bef vendor/bin/bef qc.zig | output
	echo zig | vendor/bin/bef qc.bef > output/qc.bef.zig
	diff -s qc.zig output/qc.bef.zig

test-bef-sml: qc.bef vendor/bin/bef qc.sml | output
	echo sml | vendor/bin/bef qc.bef > output/qc.bef.sml
	diff -s qc.sml output/qc.bef.sml

test-bef-octave: qc.bef vendor/bin/bef qc.octave | output
	echo octave | vendor/bin/bef qc.bef > output/qc.bef.octave
	diff -s qc.octave output/qc.bef.octave

test-bef-groovy: qc.bef vendor/bin/bef qc.groovy | output
	echo groovy | vendor/bin/bef qc.bef > output/qc.bef.groovy
	diff -s qc.groovy output/qc.bef.groovy

test-bef-ws: qc.bef vendor/bin/bef qc.ws | output
	echo ws | vendor/bin/bef qc.bef > output/qc.bef.ws
	diff -s qc.ws output/qc.bef.ws

test-bef-coffee: qc.bef vendor/bin/bef qc.coffee | output
	echo coffee | vendor/bin/bef qc.bef > output/qc.bef.coffee
	diff -s qc.coffee output/qc.bef.coffee

test-bef-swift: qc.bef vendor/bin/bef qc.swift | output
	echo swift | vendor/bin/bef qc.bef > output/qc.bef.swift
	diff -s qc.swift output/qc.bef.swift

test-bef-py: qc.bef vendor/bin/bef qc.py | output
	echo py | vendor/bin/bef qc.bef > output/qc.bef.py
	diff -s qc.py output/qc.bef.py

test-bef-fs: qc.bef vendor/bin/bef qc.fs | output
	echo fs | vendor/bin/bef qc.bef > output/qc.bef.fs
	diff -s qc.fs output/qc.bef.fs

test-bef-nim: qc.bef vendor/bin/bef qc.nim | output
	echo nim | vendor/bin/bef qc.bef > output/qc.bef.nim
	diff -s qc.nim output/qc.bef.nim

test-bef-fsx: qc.bef vendor/bin/bef qc.fsx | output
	echo fsx | vendor/bin/bef qc.bef > output/qc.bef.fsx
	diff -s qc.fsx output/qc.bef.fsx

test-bef-tcl: qc.bef vendor/bin/bef qc.tcl | output
	echo tcl | vendor/bin/bef qc.bef > output/qc.bef.tcl
	diff -s qc.tcl output/qc.bef.tcl

test-bef-bf: qc.bef vendor/bin/bef qc.bf | output
	echo bf | vendor/bin/bef qc.bef > output/qc.bef.bf
	diff -s qc.bf output/qc.bef.bf

test-bef-java: qc.bef vendor/bin/bef qc.java | output
	echo java | vendor/bin/bef qc.bef > output/qc.bef.java
	diff -s qc.java output/qc.bef.java

test-bef-php: qc.bef vendor/bin/bef qc.php | output
	echo php | vendor/bin/bef qc.bef > output/qc.bef.php
	diff -s qc.php output/qc.bef.php

test-bef-bash: qc.bef vendor/bin/bef qc.bash | output
	echo bash | vendor/bin/bef qc.bef > output/qc.bef.bash
	diff -s qc.bash output/qc.bef.bash

test-bef-d: qc.bef vendor/bin/bef qc.d | output
	echo d | vendor/bin/bef qc.bef > output/qc.bef.d
	diff -s qc.d output/qc.bef.d

test-bef-pl: qc.bef vendor/bin/bef qc.pl | output
	echo pl | vendor/bin/bef qc.bef > output/qc.bef.pl
	diff -s qc.pl output/qc.bef.pl

test-bef-exs: qc.bef vendor/bin/bef qc.exs | output
	echo exs | vendor/bin/bef qc.bef > output/qc.bef.exs
	diff -s qc.exs output/qc.bef.exs

test-bef-rb: qc.bef vendor/bin/bef qc.rb | output
	echo rb | vendor/bin/bef qc.bef > output/qc.bef.rb
	diff -s qc.rb output/qc.bef.rb

test-bef-js: qc.bef vendor/bin/bef qc.js | output
	echo js | vendor/bin/bef qc.bef > output/qc.bef.js
	diff -s qc.js output/qc.bef.js

test-bef-ts: qc.bef vendor/bin/bef qc.ts | output
	echo ts | vendor/bin/bef qc.bef > output/qc.bef.ts
	diff -s qc.ts output/qc.bef.ts

test-bef-erl: qc.bef vendor/bin/bef qc.erl | output
	echo erl | vendor/bin/bef qc.bef > output/qc.bef.erl
	diff -s qc.erl output/qc.bef.erl

test-bef-cs: qc.bef vendor/bin/bef qc.cs | output
	echo cs | vendor/bin/bef qc.bef > output/qc.bef.cs
	diff -s qc.cs output/qc.bef.cs

test-bef-prolog: qc.bef vendor/bin/bef qc.prolog | output
	echo prolog | vendor/bin/bef qc.bef > output/qc.bef.prolog
	diff -s qc.prolog output/qc.bef.prolog

test-bef-cr: qc.bef vendor/bin/bef qc.cr | output
	echo cr | vendor/bin/bef qc.bef > output/qc.bef.cr
	diff -s qc.cr output/qc.bef.cr

test-bef-unl: qc.bef vendor/bin/bef qc.unl | output
	echo unl | vendor/bin/bef qc.bef > output/qc.bef.unl
	diff -s qc.unl output/qc.bef.unl

test-bef-hx: qc.bef vendor/bin/bef qc.hx | output
	echo hx | vendor/bin/bef qc.bef > output/qc.bef.hx
	diff -s qc.hx output/qc.bef.hx

test-bef-bef: qc.bef vendor/bin/bef qc.bef | output
	echo | vendor/bin/bef qc.bef > output/qc.bef.bef
	diff -s qc.bef output/qc.bef.bef

test-bef-awk: qc.bef vendor/bin/bef qc.awk | output
	echo awk | vendor/bin/bef qc.bef > output/qc.bef.awk
	diff -s qc.awk output/qc.bef.awk

test-bef-piet: qc.bef vendor/bin/bef qc.piet.gif | output
	echo piet | vendor/bin/bef qc.bef > output/qc.bef.piet
	diff -s qc.piet.gif output/qc.bef.piet

test-awk-clj: qc.awk qc.clj | output
	env LC_ALL=C awk -f qc.awk clj > output/qc.awk.clj
	diff -s qc.clj output/qc.awk.clj

test-awk-lisp: qc.awk qc.lisp | output
	env LC_ALL=C awk -f qc.awk lisp > output/qc.awk.lisp
	diff -s qc.lisp output/qc.awk.lisp

test-awk-rkt: qc.awk qc.rkt | output
	env LC_ALL=C awk -f qc.awk rkt > output/qc.awk.rkt
	diff -s qc.rkt output/qc.awk.rkt

test-awk-rs: qc.awk qc.rs | output
	env LC_ALL=C awk -f qc.awk rs > output/qc.awk.rs
	diff -s qc.rs output/qc.awk.rs

test-awk-c: qc.awk qc.c | output
	env LC_ALL=C awk -f qc.awk c > output/qc.awk.c
	diff -s qc.c output/qc.awk.c

test-awk-cpp: qc.awk qc.cpp | output
	env LC_ALL=C awk -f qc.awk cpp > output/qc.awk.cpp
	diff -s qc.cpp output/qc.awk.cpp

test-awk-scala: qc.awk qc.scala | output
	env LC_ALL=C awk -f qc.awk scala > output/qc.awk.scala
	diff -s qc.scala output/qc.awk.scala

test-awk-f90: qc.awk qc.f90 | output
	env LC_ALL=C awk -f qc.awk f90 > output/qc.awk.f90
	diff -s qc.f90 output/qc.awk.f90

test-awk-scm: qc.awk qc.scm | output
	env LC_ALL=C awk -f qc.awk scm > output/qc.awk.scm
	diff -s qc.scm output/qc.awk.scm

test-awk-r: qc.awk qc.r | output
	env LC_ALL=C awk -f qc.awk r > output/qc.awk.r
	diff -s qc.r output/qc.awk.r

test-awk-lua: qc.awk qc.lua | output
	env LC_ALL=C awk -f qc.awk lua > output/qc.awk.lua
	diff -s qc.lua output/qc.awk.lua

test-awk-go: qc.awk qc.go | output
	env LC_ALL=C awk -f qc.awk go > output/qc.awk.go
	diff -s qc.go output/qc.awk.go

test-awk-ps: qc.awk qc.ps | output
	env LC_ALL=C awk -f qc.awk ps > output/qc.awk.ps
	diff -s qc.ps output/qc.awk.ps

test-awk-vala: qc.awk qc.vala | output
	env LC_ALL=C awk -f qc.awk vala > output/qc.awk.vala
	diff -s qc.vala output/qc.awk.vala

test-awk-pike: qc.awk qc.pike | output
	env LC_ALL=C awk -f qc.awk pike > output/qc.awk.pike
	diff -s qc.pike output/qc.awk.pike

test-awk-pas: qc.awk qc.pas | output
	env LC_ALL=C awk -f qc.awk pas > output/qc.awk.pas
	diff -s qc.pas output/qc.awk.pas

test-awk-kt: qc.awk qc.kt | output
	env LC_ALL=C awk -f qc.awk kt > output/qc.awk.kt
	diff -s qc.kt output/qc.awk.kt

test-awk-m: qc.awk qc.m | output
	env LC_ALL=C awk -f qc.awk m > output/qc.awk.m
	diff -s qc.m output/qc.awk.m

test-awk-ml: qc.awk qc.ml | output
	env LC_ALL=C awk -f qc.awk ml > output/qc.awk.ml
	diff -s qc.ml output/qc.awk.ml

test-awk-hs: qc.awk qc.hs | output
	env LC_ALL=C awk -f qc.awk hs > output/qc.awk.hs
	diff -s qc.hs output/qc.awk.hs

test-awk-zig: qc.awk qc.zig | output
	env LC_ALL=C awk -f qc.awk zig > output/qc.awk.zig
	diff -s qc.zig output/qc.awk.zig

test-awk-sml: qc.awk qc.sml | output
	env LC_ALL=C awk -f qc.awk sml > output/qc.awk.sml
	diff -s qc.sml output/qc.awk.sml

test-awk-octave: qc.awk qc.octave | output
	env LC_ALL=C awk -f qc.awk octave > output/qc.awk.octave
	diff -s qc.octave output/qc.awk.octave

test-awk-groovy: qc.awk qc.groovy | output
	env LC_ALL=C awk -f qc.awk groovy > output/qc.awk.groovy
	diff -s qc.groovy output/qc.awk.groovy

test-awk-ws: qc.awk qc.ws | output
	env LC_ALL=C awk -f qc.awk ws > output/qc.awk.ws
	diff -s qc.ws output/qc.awk.ws

test-awk-coffee: qc.awk qc.coffee | output
	env LC_ALL=C awk -f qc.awk coffee > output/qc.awk.coffee
	diff -s qc.coffee output/qc.awk.coffee

test-awk-swift: qc.awk qc.swift | output
	env LC_ALL=C awk -f qc.awk swift > output/qc.awk.swift
	diff -s qc.swift output/qc.awk.swift

test-awk-py: qc.awk qc.py | output
	env LC_ALL=C awk -f qc.awk py > output/qc.awk.py
	diff -s qc.py output/qc.awk.py

test-awk-fs: qc.awk qc.fs | output
	env LC_ALL=C awk -f qc.awk fs > output/qc.awk.fs
	diff -s qc.fs output/qc.awk.fs

test-awk-nim: qc.awk qc.nim | output
	env LC_ALL=C awk -f qc.awk nim > output/qc.awk.nim
	diff -s qc.nim output/qc.awk.nim

test-awk-fsx: qc.awk qc.fsx | output
	env LC_ALL=C awk -f qc.awk fsx > output/qc.awk.fsx
	diff -s qc.fsx output/qc.awk.fsx

test-awk-tcl: qc.awk qc.tcl | output
	env LC_ALL=C awk -f qc.awk tcl > output/qc.awk.tcl
	diff -s qc.tcl output/qc.awk.tcl

test-awk-bf: qc.awk qc.bf | output
	env LC_ALL=C awk -f qc.awk bf > output/qc.awk.bf
	diff -s qc.bf output/qc.awk.bf

test-awk-java: qc.awk qc.java | output
	env LC_ALL=C awk -f qc.awk java > output/qc.awk.java
	diff -s qc.java output/qc.awk.java

test-awk-php: qc.awk qc.php | output
	env LC_ALL=C awk -f qc.awk php > output/qc.awk.php
	diff -s qc.php output/qc.awk.php

test-awk-bash: qc.awk qc.bash | output
	env LC_ALL=C awk -f qc.awk bash > output/qc.awk.bash
	diff -s qc.bash output/qc.awk.bash

test-awk-d: qc.awk qc.d | output
	env LC_ALL=C awk -f qc.awk d > output/qc.awk.d
	diff -s qc.d output/qc.awk.d

test-awk-pl: qc.awk qc.pl | output
	env LC_ALL=C awk -f qc.awk pl > output/qc.awk.pl
	diff -s qc.pl output/qc.awk.pl

test-awk-exs: qc.awk qc.exs | output
	env LC_ALL=C awk -f qc.awk exs > output/qc.awk.exs
	diff -s qc.exs output/qc.awk.exs

test-awk-rb: qc.awk qc.rb | output
	env LC_ALL=C awk -f qc.awk rb > output/qc.awk.rb
	diff -s qc.rb output/qc.awk.rb

test-awk-js: qc.awk qc.js | output
	env LC_ALL=C awk -f qc.awk js > output/qc.awk.js
	diff -s qc.js output/qc.awk.js

test-awk-ts: qc.awk qc.ts | output
	env LC_ALL=C awk -f qc.awk ts > output/qc.awk.ts
	diff -s qc.ts output/qc.awk.ts

test-awk-erl: qc.awk qc.erl | output
	env LC_ALL=C awk -f qc.awk erl > output/qc.awk.erl
	diff -s qc.erl output/qc.awk.erl

test-awk-cs: qc.awk qc.cs | output
	env LC_ALL=C awk -f qc.awk cs > output/qc.awk.cs
	diff -s qc.cs output/qc.awk.cs

test-awk-prolog: qc.awk qc.prolog | output
	env LC_ALL=C awk -f qc.awk prolog > output/qc.awk.prolog
	diff -s qc.prolog output/qc.awk.prolog

test-awk-cr: qc.awk qc.cr | output
	env LC_ALL=C awk -f qc.awk cr > output/qc.awk.cr
	diff -s qc.cr output/qc.awk.cr

test-awk-unl: qc.awk qc.unl | output
	env LC_ALL=C awk -f qc.awk unl > output/qc.awk.unl
	diff -s qc.unl output/qc.awk.unl

test-awk-hx: qc.awk qc.hx | output
	env LC_ALL=C awk -f qc.awk hx > output/qc.awk.hx
	diff -s qc.hx output/qc.awk.hx

test-awk-bef: qc.awk qc.bef | output
	env LC_ALL=C awk -f qc.awk bef > output/qc.awk.bef
	diff -s qc.bef output/qc.awk.bef

test-awk-awk: qc.awk qc.awk | output
	env LC_ALL=C awk -f qc.awk > output/qc.awk.awk
	diff -s qc.awk output/qc.awk.awk

test-awk-piet: qc.awk qc.piet.gif | output
	env LC_ALL=C awk -f qc.awk piet > output/qc.awk.piet
	diff -s qc.piet.gif output/qc.awk.piet

test-piet-clj: qc.piet.gif vendor/bin/piet qc.clj | output
	echo clj | vendor/bin/piet qc.piet.gif > output/qc.piet.clj
	diff -s qc.clj output/qc.piet.clj

test-piet-lisp: qc.piet.gif vendor/bin/piet qc.lisp | output
	echo lisp | vendor/bin/piet qc.piet.gif > output/qc.piet.lisp
	diff -s qc.lisp output/qc.piet.lisp

test-piet-rkt: qc.piet.gif vendor/bin/piet qc.rkt | output
	echo rkt | vendor/bin/piet qc.piet.gif > output/qc.piet.rkt
	diff -s qc.rkt output/qc.piet.rkt

test-piet-rs: qc.piet.gif vendor/bin/piet qc.rs | output
	echo rs | vendor/bin/piet qc.piet.gif > output/qc.piet.rs
	diff -s qc.rs output/qc.piet.rs

test-piet-c: qc.piet.gif vendor/bin/piet qc.c | output
	echo c | vendor/bin/piet qc.piet.gif > output/qc.piet.c
	diff -s qc.c output/qc.piet.c

test-piet-cpp: qc.piet.gif vendor/bin/piet qc.cpp | output
	echo cpp | vendor/bin/piet qc.piet.gif > output/qc.piet.cpp
	diff -s qc.cpp output/qc.piet.cpp

test-piet-scala: qc.piet.gif vendor/bin/piet qc.scala | output
	echo scala | vendor/bin/piet qc.piet.gif > output/qc.piet.scala
	diff -s qc.scala output/qc.piet.scala

test-piet-f90: qc.piet.gif vendor/bin/piet qc.f90 | output
	echo f90 | vendor/bin/piet qc.piet.gif > output/qc.piet.f90
	diff -s qc.f90 output/qc.piet.f90

test-piet-scm: qc.piet.gif vendor/bin/piet qc.scm | output
	echo scm | vendor/bin/piet qc.piet.gif > output/qc.piet.scm
	diff -s qc.scm output/qc.piet.scm

test-piet-r: qc.piet.gif vendor/bin/piet qc.r | output
	echo r | vendor/bin/piet qc.piet.gif > output/qc.piet.r
	diff -s qc.r output/qc.piet.r

test-piet-lua: qc.piet.gif vendor/bin/piet qc.lua | output
	echo lua | vendor/bin/piet qc.piet.gif > output/qc.piet.lua
	diff -s qc.lua output/qc.piet.lua

test-piet-go: qc.piet.gif vendor/bin/piet qc.go | output
	echo go | vendor/bin/piet qc.piet.gif > output/qc.piet.go
	diff -s qc.go output/qc.piet.go

test-piet-ps: qc.piet.gif vendor/bin/piet qc.ps | output
	echo ps | vendor/bin/piet qc.piet.gif > output/qc.piet.ps
	diff -s qc.ps output/qc.piet.ps

test-piet-vala: qc.piet.gif vendor/bin/piet qc.vala | output
	echo vala | vendor/bin/piet qc.piet.gif > output/qc.piet.vala
	diff -s qc.vala output/qc.piet.vala

test-piet-pike: qc.piet.gif vendor/bin/piet qc.pike | output
	echo pike | vendor/bin/piet qc.piet.gif > output/qc.piet.pike
	diff -s qc.pike output/qc.piet.pike

test-piet-pas: qc.piet.gif vendor/bin/piet qc.pas | output
	echo pas | vendor/bin/piet qc.piet.gif > output/qc.piet.pas
	diff -s qc.pas output/qc.piet.pas

test-piet-kt: qc.piet.gif vendor/bin/piet qc.kt | output
	echo kt | vendor/bin/piet qc.piet.gif > output/qc.piet.kt
	diff -s qc.kt output/qc.piet.kt

test-piet-m: qc.piet.gif vendor/bin/piet qc.m | output
	echo m | vendor/bin/piet qc.piet.gif > output/qc.piet.m
	diff -s qc.m output/qc.piet.m

test-piet-ml: qc.piet.gif vendor/bin/piet qc.ml | output
	echo ml | vendor/bin/piet qc.piet.gif > output/qc.piet.ml
	diff -s qc.ml output/qc.piet.ml

test-piet-hs: qc.piet.gif vendor/bin/piet qc.hs | output
	echo hs | vendor/bin/piet qc.piet.gif > output/qc.piet.hs
	diff -s qc.hs output/qc.piet.hs

test-piet-zig: qc.piet.gif vendor/bin/piet qc.zig | output
	echo zig | vendor/bin/piet qc.piet.gif > output/qc.piet.zig
	diff -s qc.zig output/qc.piet.zig

test-piet-sml: qc.piet.gif vendor/bin/piet qc.sml | output
	echo sml | vendor/bin/piet qc.piet.gif > output/qc.piet.sml
	diff -s qc.sml output/qc.piet.sml

test-piet-octave: qc.piet.gif vendor/bin/piet qc.octave | output
	echo octave | vendor/bin/piet qc.piet.gif > output/qc.piet.octave
	diff -s qc.octave output/qc.piet.octave

test-piet-groovy: qc.piet.gif vendor/bin/piet qc.groovy | output
	echo groovy | vendor/bin/piet qc.piet.gif > output/qc.piet.groovy
	diff -s qc.groovy output/qc.piet.groovy

test-piet-ws: qc.piet.gif vendor/bin/piet qc.ws | output
	echo ws | vendor/bin/piet qc.piet.gif > output/qc.piet.ws
	diff -s qc.ws output/qc.piet.ws

test-piet-coffee: qc.piet.gif vendor/bin/piet qc.coffee | output
	echo coffee | vendor/bin/piet qc.piet.gif > output/qc.piet.coffee
	diff -s qc.coffee output/qc.piet.coffee

test-piet-swift: qc.piet.gif vendor/bin/piet qc.swift | output
	echo swift | vendor/bin/piet qc.piet.gif > output/qc.piet.swift
	diff -s qc.swift output/qc.piet.swift

test-piet-py: qc.piet.gif vendor/bin/piet qc.py | output
	echo py | vendor/bin/piet qc.piet.gif > output/qc.piet.py
	diff -s qc.py output/qc.piet.py

test-piet-fs: qc.piet.gif vendor/bin/piet qc.fs | output
	echo fs | vendor/bin/piet qc.piet.gif > output/qc.piet.fs
	diff -s qc.fs output/qc.piet.fs

test-piet-nim: qc.piet.gif vendor/bin/piet qc.nim | output
	echo nim | vendor/bin/piet qc.piet.gif > output/qc.piet.nim
	diff -s qc.nim output/qc.piet.nim

test-piet-fsx: qc.piet.gif vendor/bin/piet qc.fsx | output
	echo fsx | vendor/bin/piet qc.piet.gif > output/qc.piet.fsx
	diff -s qc.fsx output/qc.piet.fsx

test-piet-tcl: qc.piet.gif vendor/bin/piet qc.tcl | output
	echo tcl | vendor/bin/piet qc.piet.gif > output/qc.piet.tcl
	diff -s qc.tcl output/qc.piet.tcl

test-piet-bf: qc.piet.gif vendor/bin/piet qc.bf | output
	echo bf | vendor/bin/piet qc.piet.gif > output/qc.piet.bf
	diff -s qc.bf output/qc.piet.bf

test-piet-java: qc.piet.gif vendor/bin/piet qc.java | output
	echo java | vendor/bin/piet qc.piet.gif > output/qc.piet.java
	diff -s qc.java output/qc.piet.java

test-piet-php: qc.piet.gif vendor/bin/piet qc.php | output
	echo php | vendor/bin/piet qc.piet.gif > output/qc.piet.php
	diff -s qc.php output/qc.piet.php

test-piet-bash: qc.piet.gif vendor/bin/piet qc.bash | output
	echo bash | vendor/bin/piet qc.piet.gif > output/qc.piet.bash
	diff -s qc.bash output/qc.piet.bash

test-piet-d: qc.piet.gif vendor/bin/piet qc.d | output
	echo d | vendor/bin/piet qc.piet.gif > output/qc.piet.d
	diff -s qc.d output/qc.piet.d

test-piet-pl: qc.piet.gif vendor/bin/piet qc.pl | output
	echo pl | vendor/bin/piet qc.piet.gif > output/qc.piet.pl
	diff -s qc.pl output/qc.piet.pl

test-piet-exs: qc.piet.gif vendor/bin/piet qc.exs | output
	echo exs | vendor/bin/piet qc.piet.gif > output/qc.piet.exs
	diff -s qc.exs output/qc.piet.exs

test-piet-rb: qc.piet.gif vendor/bin/piet qc.rb | output
	echo rb | vendor/bin/piet qc.piet.gif > output/qc.piet.rb
	diff -s qc.rb output/qc.piet.rb

test-piet-js: qc.piet.gif vendor/bin/piet qc.js | output
	echo js | vendor/bin/piet qc.piet.gif > output/qc.piet.js
	diff -s qc.js output/qc.piet.js

test-piet-ts: qc.piet.gif vendor/bin/piet qc.ts | output
	echo ts | vendor/bin/piet qc.piet.gif > output/qc.piet.ts
	diff -s qc.ts output/qc.piet.ts

test-piet-erl: qc.piet.gif vendor/bin/piet qc.erl | output
	echo erl | vendor/bin/piet qc.piet.gif > output/qc.piet.erl
	diff -s qc.erl output/qc.piet.erl

test-piet-cs: qc.piet.gif vendor/bin/piet qc.cs | output
	echo cs | vendor/bin/piet qc.piet.gif > output/qc.piet.cs
	diff -s qc.cs output/qc.piet.cs

test-piet-prolog: qc.piet.gif vendor/bin/piet qc.prolog | output
	echo prolog | vendor/bin/piet qc.piet.gif > output/qc.piet.prolog
	diff -s qc.prolog output/qc.piet.prolog

test-piet-cr: qc.piet.gif vendor/bin/piet qc.cr | output
	echo cr | vendor/bin/piet qc.piet.gif > output/qc.piet.cr
	diff -s qc.cr output/qc.piet.cr

test-piet-unl: qc.piet.gif vendor/bin/piet qc.unl | output
	echo unl | vendor/bin/piet qc.piet.gif > output/qc.piet.unl
	diff -s qc.unl output/qc.piet.unl

test-piet-hx: qc.piet.gif vendor/bin/piet qc.hx | output
	echo hx | vendor/bin/piet qc.piet.gif > output/qc.piet.hx
	diff -s qc.hx output/qc.piet.hx

test-piet-bef: qc.piet.gif vendor/bin/piet qc.bef | output
	echo bef | vendor/bin/piet qc.piet.gif > output/qc.piet.bef
	diff -s qc.bef output/qc.piet.bef

test-piet-awk: qc.piet.gif vendor/bin/piet qc.awk | output
	echo awk | vendor/bin/piet qc.piet.gif > output/qc.piet.awk
	diff -s qc.awk output/qc.piet.awk

test-piet-piet: qc.piet.gif vendor/bin/piet qc.piet.gif | output
	echo | vendor/bin/piet qc.piet.gif > output/qc.piet.piet
	diff -s qc.piet.gif output/qc.piet.piet


test: test-clj-rb test-lisp-rb test-rkt-rb test-rs-rb test-c-rb test-cpp-rb test-scala-rb test-f90-rb \
  test-scm-rb test-r-rb test-lua-rb test-go-rb test-ps-rb test-vala-rb test-pike-rb test-pas-rb \
  test-kt-rb test-m-rb test-ml-rb test-hs-rb test-zig-rb test-sml-rb test-octave-rb test-groovy-rb \
  test-ws-rb test-coffee-rb test-swift-rb test-py-rb test-fs-rb test-nim-rb test-fsx-rb test-tcl-rb \
  test-bf-rb test-java-rb test-php-rb test-bash-rb test-d-rb test-pl-rb test-exs-rb test-rb-rb \
  test-js-rb test-ts-rb test-erl-rb test-cs-rb test-prolog-rb test-cr-rb test-unl-rb test-hx-rb \
  test-bef-rb test-awk-rb test-piet-rb

test-all: test-clj-clj test-clj-lisp test-clj-rkt test-clj-rs test-clj-c test-clj-cpp test-clj-scala test-clj-f90 \
  test-clj-scm test-clj-r test-clj-lua test-clj-go test-clj-ps test-clj-vala test-clj-pike test-clj-pas \
  test-clj-kt test-clj-m test-clj-ml test-clj-hs test-clj-zig test-clj-sml test-clj-octave test-clj-groovy \
  test-clj-ws test-clj-coffee test-clj-swift test-clj-py test-clj-fs test-clj-nim test-clj-fsx test-clj-tcl \
  test-clj-bf test-clj-java test-clj-php test-clj-bash test-clj-d test-clj-pl test-clj-exs test-clj-rb \
  test-clj-js test-clj-ts test-clj-erl test-clj-cs test-clj-prolog test-clj-cr test-clj-unl test-clj-hx \
  test-clj-bef test-clj-awk test-clj-piet test-lisp-clj test-lisp-lisp test-lisp-rkt test-lisp-rs test-lisp-c \
  test-lisp-cpp test-lisp-scala test-lisp-f90 test-lisp-scm test-lisp-r test-lisp-lua test-lisp-go test-lisp-ps \
  test-lisp-vala test-lisp-pike test-lisp-pas test-lisp-kt test-lisp-m test-lisp-ml test-lisp-hs test-lisp-zig \
  test-lisp-sml test-lisp-octave test-lisp-groovy test-lisp-ws test-lisp-coffee test-lisp-swift test-lisp-py test-lisp-fs \
  test-lisp-nim test-lisp-fsx test-lisp-tcl test-lisp-bf test-lisp-java test-lisp-php test-lisp-bash test-lisp-d \
  test-lisp-pl test-lisp-exs test-lisp-rb test-lisp-js test-lisp-ts test-lisp-erl test-lisp-cs test-lisp-prolog \
  test-lisp-cr test-lisp-unl test-lisp-hx test-lisp-bef test-lisp-awk test-lisp-piet test-rkt-clj test-rkt-lisp \
  test-rkt-rkt test-rkt-rs test-rkt-c test-rkt-cpp test-rkt-scala test-rkt-f90 test-rkt-scm test-rkt-r \
  test-rkt-lua test-rkt-go test-rkt-ps test-rkt-vala test-rkt-pike test-rkt-pas test-rkt-kt test-rkt-m \
  test-rkt-ml test-rkt-hs test-rkt-zig test-rkt-sml test-rkt-octave test-rkt-groovy test-rkt-ws test-rkt-coffee \
  test-rkt-swift test-rkt-py test-rkt-fs test-rkt-nim test-rkt-fsx test-rkt-tcl test-rkt-bf test-rkt-java \
  test-rkt-php test-rkt-bash test-rkt-d test-rkt-pl test-rkt-exs test-rkt-rb test-rkt-js test-rkt-ts \
  test-rkt-erl test-rkt-cs test-rkt-prolog test-rkt-cr test-rkt-unl test-rkt-hx test-rkt-bef test-rkt-awk \
  test-rkt-piet test-rs-clj test-rs-lisp test-rs-rkt test-rs-rs test-rs-c test-rs-cpp test-rs-scala \
  test-rs-f90 test-rs-scm test-rs-r test-rs-lua test-rs-go test-rs-ps test-rs-vala test-rs-pike \
  test-rs-pas test-rs-kt test-rs-m test-rs-ml test-rs-hs test-rs-zig test-rs-sml test-rs-octave \
  test-rs-groovy test-rs-ws test-rs-coffee test-rs-swift test-rs-py test-rs-fs test-rs-nim test-rs-fsx \
  test-rs-tcl test-rs-bf test-rs-java test-rs-php test-rs-bash test-rs-d test-rs-pl test-rs-exs \
  test-rs-rb test-rs-js test-rs-ts test-rs-erl test-rs-cs test-rs-prolog test-rs-cr test-rs-unl \
  test-rs-hx test-rs-bef test-rs-awk test-rs-piet test-c-clj test-c-lisp test-c-rkt test-c-rs \
  test-c-c test-c-cpp test-c-scala test-c-f90 test-c-scm test-c-r test-c-lua test-c-go \
  test-c-ps test-c-vala test-c-pike test-c-pas test-c-kt test-c-m test-c-ml test-c-hs \
  test-c-zig test-c-sml test-c-octave test-c-groovy test-c-ws test-c-coffee test-c-swift test-c-py \
  test-c-fs test-c-nim test-c-fsx test-c-tcl test-c-bf test-c-java test-c-php test-c-bash \
  test-c-d test-c-pl test-c-exs test-c-rb test-c-js test-c-ts test-c-erl test-c-cs \
  test-c-prolog test-c-cr test-c-unl test-c-hx test-c-bef test-c-awk test-c-piet test-cpp-clj \
  test-cpp-lisp test-cpp-rkt test-cpp-rs test-cpp-c test-cpp-cpp test-cpp-scala test-cpp-f90 test-cpp-scm \
  test-cpp-r test-cpp-lua test-cpp-go test-cpp-ps test-cpp-vala test-cpp-pike test-cpp-pas test-cpp-kt \
  test-cpp-m test-cpp-ml test-cpp-hs test-cpp-zig test-cpp-sml test-cpp-octave test-cpp-groovy test-cpp-ws \
  test-cpp-coffee test-cpp-swift test-cpp-py test-cpp-fs test-cpp-nim test-cpp-fsx test-cpp-tcl test-cpp-bf \
  test-cpp-java test-cpp-php test-cpp-bash test-cpp-d test-cpp-pl test-cpp-exs test-cpp-rb test-cpp-js \
  test-cpp-ts test-cpp-erl test-cpp-cs test-cpp-prolog test-cpp-cr test-cpp-unl test-cpp-hx test-cpp-bef \
  test-cpp-awk test-cpp-piet test-scala-clj test-scala-lisp test-scala-rkt test-scala-rs test-scala-c test-scala-cpp \
  test-scala-scala test-scala-f90 test-scala-scm test-scala-r test-scala-lua test-scala-go test-scala-ps test-scala-vala \
  test-scala-pike test-scala-pas test-scala-kt test-scala-m test-scala-ml test-scala-hs test-scala-zig test-scala-sml \
  test-scala-octave test-scala-groovy test-scala-ws test-scala-coffee test-scala-swift test-scala-py test-scala-fs test-scala-nim \
  test-scala-fsx test-scala-tcl test-scala-bf test-scala-java test-scala-php test-scala-bash test-scala-d test-scala-pl \
  test-scala-exs test-scala-rb test-scala-js test-scala-ts test-scala-erl test-scala-cs test-scala-prolog test-scala-cr \
  test-scala-unl test-scala-hx test-scala-bef test-scala-awk test-scala-piet test-f90-clj test-f90-lisp test-f90-rkt \
  test-f90-rs test-f90-c test-f90-cpp test-f90-scala test-f90-f90 test-f90-scm test-f90-r test-f90-lua \
  test-f90-go test-f90-ps test-f90-vala test-f90-pike test-f90-pas test-f90-kt test-f90-m test-f90-ml \
  test-f90-hs test-f90-zig test-f90-sml test-f90-octave test-f90-groovy test-f90-ws test-f90-coffee test-f90-swift \
  test-f90-py test-f90-fs test-f90-nim test-f90-fsx test-f90-tcl test-f90-bf test-f90-java test-f90-php \
  test-f90-bash test-f90-d test-f90-pl test-f90-exs test-f90-rb test-f90-js test-f90-ts test-f90-erl \
  test-f90-cs test-f90-prolog test-f90-cr test-f90-unl test-f90-hx test-f90-bef test-f90-awk test-f90-piet \
  test-scm-clj test-scm-lisp test-scm-rkt test-scm-rs test-scm-c test-scm-cpp test-scm-scala test-scm-f90 \
  test-scm-scm test-scm-r test-scm-lua test-scm-go test-scm-ps test-scm-vala test-scm-pike test-scm-pas \
  test-scm-kt test-scm-m test-scm-ml test-scm-hs test-scm-zig test-scm-sml test-scm-octave test-scm-groovy \
  test-scm-ws test-scm-coffee test-scm-swift test-scm-py test-scm-fs test-scm-nim test-scm-fsx test-scm-tcl \
  test-scm-bf test-scm-java test-scm-php test-scm-bash test-scm-d test-scm-pl test-scm-exs test-scm-rb \
  test-scm-js test-scm-ts test-scm-erl test-scm-cs test-scm-prolog test-scm-cr test-scm-unl test-scm-hx \
  test-scm-bef test-scm-awk test-scm-piet test-r-clj test-r-lisp test-r-rkt test-r-rs test-r-c \
  test-r-cpp test-r-scala test-r-f90 test-r-scm test-r-r test-r-lua test-r-go test-r-ps \
  test-r-vala test-r-pike test-r-pas test-r-kt test-r-m test-r-ml test-r-hs test-r-zig \
  test-r-sml test-r-octave test-r-groovy test-r-ws test-r-coffee test-r-swift test-r-py test-r-fs \
  test-r-nim test-r-fsx test-r-tcl test-r-bf test-r-java test-r-php test-r-bash test-r-d \
  test-r-pl test-r-exs test-r-rb test-r-js test-r-ts test-r-erl test-r-cs test-r-prolog \
  test-r-cr test-r-unl test-r-hx test-r-bef test-r-awk test-r-piet test-lua-clj test-lua-lisp \
  test-lua-rkt test-lua-rs test-lua-c test-lua-cpp test-lua-scala test-lua-f90 test-lua-scm test-lua-r \
  test-lua-lua test-lua-go test-lua-ps test-lua-vala test-lua-pike test-lua-pas test-lua-kt test-lua-m \
  test-lua-ml test-lua-hs test-lua-zig test-lua-sml test-lua-octave test-lua-groovy test-lua-ws test-lua-coffee \
  test-lua-swift test-lua-py test-lua-fs test-lua-nim test-lua-fsx test-lua-tcl test-lua-bf test-lua-java \
  test-lua-php test-lua-bash test-lua-d test-lua-pl test-lua-exs test-lua-rb test-lua-js test-lua-ts \
  test-lua-erl test-lua-cs test-lua-prolog test-lua-cr test-lua-unl test-lua-hx test-lua-bef test-lua-awk \
  test-lua-piet test-go-clj test-go-lisp test-go-rkt test-go-rs test-go-c test-go-cpp test-go-scala \
  test-go-f90 test-go-scm test-go-r test-go-lua test-go-go test-go-ps test-go-vala test-go-pike \
  test-go-pas test-go-kt test-go-m test-go-ml test-go-hs test-go-zig test-go-sml test-go-octave \
  test-go-groovy test-go-ws test-go-coffee test-go-swift test-go-py test-go-fs test-go-nim test-go-fsx \
  test-go-tcl test-go-bf test-go-java test-go-php test-go-bash test-go-d test-go-pl test-go-exs \
  test-go-rb test-go-js test-go-ts test-go-erl test-go-cs test-go-prolog test-go-cr test-go-unl \
  test-go-hx test-go-bef test-go-awk test-go-piet test-ps-clj test-ps-lisp test-ps-rkt test-ps-rs \
  test-ps-c test-ps-cpp test-ps-scala test-ps-f90 test-ps-scm test-ps-r test-ps-lua test-ps-go \
  test-ps-ps test-ps-vala test-ps-pike test-ps-pas test-ps-kt test-ps-m test-ps-ml test-ps-hs \
  test-ps-zig test-ps-sml test-ps-octave test-ps-groovy test-ps-ws test-ps-coffee test-ps-swift test-ps-py \
  test-ps-fs test-ps-nim test-ps-fsx test-ps-tcl test-ps-bf test-ps-java test-ps-php test-ps-bash \
  test-ps-d test-ps-pl test-ps-exs test-ps-rb test-ps-js test-ps-ts test-ps-erl test-ps-cs \
  test-ps-prolog test-ps-cr test-ps-unl test-ps-hx test-ps-bef test-ps-awk test-ps-piet test-vala-clj \
  test-vala-lisp test-vala-rkt test-vala-rs test-vala-c test-vala-cpp test-vala-scala test-vala-f90 test-vala-scm \
  test-vala-r test-vala-lua test-vala-go test-vala-ps test-vala-vala test-vala-pike test-vala-pas test-vala-kt \
  test-vala-m test-vala-ml test-vala-hs test-vala-zig test-vala-sml test-vala-octave test-vala-groovy test-vala-ws \
  test-vala-coffee test-vala-swift test-vala-py test-vala-fs test-vala-nim test-vala-fsx test-vala-tcl test-vala-bf \
  test-vala-java test-vala-php test-vala-bash test-vala-d test-vala-pl test-vala-exs test-vala-rb test-vala-js \
  test-vala-ts test-vala-erl test-vala-cs test-vala-prolog test-vala-cr test-vala-unl test-vala-hx test-vala-bef \
  test-vala-awk test-vala-piet test-pike-clj test-pike-lisp test-pike-rkt test-pike-rs test-pike-c test-pike-cpp \
  test-pike-scala test-pike-f90 test-pike-scm test-pike-r test-pike-lua test-pike-go test-pike-ps test-pike-vala \
  test-pike-pike test-pike-pas test-pike-kt test-pike-m test-pike-ml test-pike-hs test-pike-zig test-pike-sml \
  test-pike-octave test-pike-groovy test-pike-ws test-pike-coffee test-pike-swift test-pike-py test-pike-fs test-pike-nim \
  test-pike-fsx test-pike-tcl test-pike-bf test-pike-java test-pike-php test-pike-bash test-pike-d test-pike-pl \
  test-pike-exs test-pike-rb test-pike-js test-pike-ts test-pike-erl test-pike-cs test-pike-prolog test-pike-cr \
  test-pike-unl test-pike-hx test-pike-bef test-pike-awk test-pike-piet test-pas-clj test-pas-lisp test-pas-rkt \
  test-pas-rs test-pas-c test-pas-cpp test-pas-scala test-pas-f90 test-pas-scm test-pas-r test-pas-lua \
  test-pas-go test-pas-ps test-pas-vala test-pas-pike test-pas-pas test-pas-kt test-pas-m test-pas-ml \
  test-pas-hs test-pas-zig test-pas-sml test-pas-octave test-pas-groovy test-pas-ws test-pas-coffee test-pas-swift \
  test-pas-py test-pas-fs test-pas-nim test-pas-fsx test-pas-tcl test-pas-bf test-pas-java test-pas-php \
  test-pas-bash test-pas-d test-pas-pl test-pas-exs test-pas-rb test-pas-js test-pas-ts test-pas-erl \
  test-pas-cs test-pas-prolog test-pas-cr test-pas-unl test-pas-hx test-pas-bef test-pas-awk test-pas-piet \
  test-kt-clj test-kt-lisp test-kt-rkt test-kt-rs test-kt-c test-kt-cpp test-kt-scala test-kt-f90 \
  test-kt-scm test-kt-r test-kt-lua test-kt-go test-kt-ps test-kt-vala test-kt-pike test-kt-pas \
  test-kt-kt test-kt-m test-kt-ml test-kt-hs test-kt-zig test-kt-sml test-kt-octave test-kt-groovy \
  test-kt-ws test-kt-coffee test-kt-swift test-kt-py test-kt-fs test-kt-nim test-kt-fsx test-kt-tcl \
  test-kt-bf test-kt-java test-kt-php test-kt-bash test-kt-d test-kt-pl test-kt-exs test-kt-rb \
  test-kt-js test-kt-ts test-kt-erl test-kt-cs test-kt-prolog test-kt-cr test-kt-unl test-kt-hx \
  test-kt-bef test-kt-awk test-kt-piet test-m-clj test-m-lisp test-m-rkt test-m-rs test-m-c \
  test-m-cpp test-m-scala test-m-f90 test-m-scm test-m-r test-m-lua test-m-go test-m-ps \
  test-m-vala test-m-pike test-m-pas test-m-kt test-m-m test-m-ml test-m-hs test-m-zig \
  test-m-sml test-m-octave test-m-groovy test-m-ws test-m-coffee test-m-swift test-m-py test-m-fs \
  test-m-nim test-m-fsx test-m-tcl test-m-bf test-m-java test-m-php test-m-bash test-m-d \
  test-m-pl test-m-exs test-m-rb test-m-js test-m-ts test-m-erl test-m-cs test-m-prolog \
  test-m-cr test-m-unl test-m-hx test-m-bef test-m-awk test-m-piet test-ml-clj test-ml-lisp \
  test-ml-rkt test-ml-rs test-ml-c test-ml-cpp test-ml-scala test-ml-f90 test-ml-scm test-ml-r \
  test-ml-lua test-ml-go test-ml-ps test-ml-vala test-ml-pike test-ml-pas test-ml-kt test-ml-m \
  test-ml-ml test-ml-hs test-ml-zig test-ml-sml test-ml-octave test-ml-groovy test-ml-ws test-ml-coffee \
  test-ml-swift test-ml-py test-ml-fs test-ml-nim test-ml-fsx test-ml-tcl test-ml-bf test-ml-java \
  test-ml-php test-ml-bash test-ml-d test-ml-pl test-ml-exs test-ml-rb test-ml-js test-ml-ts \
  test-ml-erl test-ml-cs test-ml-prolog test-ml-cr test-ml-unl test-ml-hx test-ml-bef test-ml-awk \
  test-ml-piet test-hs-clj test-hs-lisp test-hs-rkt test-hs-rs test-hs-c test-hs-cpp test-hs-scala \
  test-hs-f90 test-hs-scm test-hs-r test-hs-lua test-hs-go test-hs-ps test-hs-vala test-hs-pike \
  test-hs-pas test-hs-kt test-hs-m test-hs-ml test-hs-hs test-hs-zig test-hs-sml test-hs-octave \
  test-hs-groovy test-hs-ws test-hs-coffee test-hs-swift test-hs-py test-hs-fs test-hs-nim test-hs-fsx \
  test-hs-tcl test-hs-bf test-hs-java test-hs-php test-hs-bash test-hs-d test-hs-pl test-hs-exs \
  test-hs-rb test-hs-js test-hs-ts test-hs-erl test-hs-cs test-hs-prolog test-hs-cr test-hs-unl \
  test-hs-hx test-hs-bef test-hs-awk test-hs-piet test-zig-clj test-zig-lisp test-zig-rkt test-zig-rs \
  test-zig-c test-zig-cpp test-zig-scala test-zig-f90 test-zig-scm test-zig-r test-zig-lua test-zig-go \
  test-zig-ps test-zig-vala test-zig-pike test-zig-pas test-zig-kt test-zig-m test-zig-ml test-zig-hs \
  test-zig-zig test-zig-sml test-zig-octave test-zig-groovy test-zig-ws test-zig-coffee test-zig-swift test-zig-py \
  test-zig-fs test-zig-nim test-zig-fsx test-zig-tcl test-zig-bf test-zig-java test-zig-php test-zig-bash \
  test-zig-d test-zig-pl test-zig-exs test-zig-rb test-zig-js test-zig-ts test-zig-erl test-zig-cs \
  test-zig-prolog test-zig-cr test-zig-unl test-zig-hx test-zig-bef test-zig-awk test-zig-piet test-sml-clj \
  test-sml-lisp test-sml-rkt test-sml-rs test-sml-c test-sml-cpp test-sml-scala test-sml-f90 test-sml-scm \
  test-sml-r test-sml-lua test-sml-go test-sml-ps test-sml-vala test-sml-pike test-sml-pas test-sml-kt \
  test-sml-m test-sml-ml test-sml-hs test-sml-zig test-sml-sml test-sml-octave test-sml-groovy test-sml-ws \
  test-sml-coffee test-sml-swift test-sml-py test-sml-fs test-sml-nim test-sml-fsx test-sml-tcl test-sml-bf \
  test-sml-java test-sml-php test-sml-bash test-sml-d test-sml-pl test-sml-exs test-sml-rb test-sml-js \
  test-sml-ts test-sml-erl test-sml-cs test-sml-prolog test-sml-cr test-sml-unl test-sml-hx test-sml-bef \
  test-sml-awk test-sml-piet test-octave-clj test-octave-lisp test-octave-rkt test-octave-rs test-octave-c test-octave-cpp \
  test-octave-scala test-octave-f90 test-octave-scm test-octave-r test-octave-lua test-octave-go test-octave-ps test-octave-vala \
  test-octave-pike test-octave-pas test-octave-kt test-octave-m test-octave-ml test-octave-hs test-octave-zig test-octave-sml \
  test-octave-octave test-octave-groovy test-octave-ws test-octave-coffee test-octave-swift test-octave-py test-octave-fs test-octave-nim \
  test-octave-fsx test-octave-tcl test-octave-bf test-octave-java test-octave-php test-octave-bash test-octave-d test-octave-pl \
  test-octave-exs test-octave-rb test-octave-js test-octave-ts test-octave-erl test-octave-cs test-octave-prolog test-octave-cr \
  test-octave-unl test-octave-hx test-octave-bef test-octave-awk test-octave-piet test-groovy-clj test-groovy-lisp test-groovy-rkt \
  test-groovy-rs test-groovy-c test-groovy-cpp test-groovy-scala test-groovy-f90 test-groovy-scm test-groovy-r test-groovy-lua \
  test-groovy-go test-groovy-ps test-groovy-vala test-groovy-pike test-groovy-pas test-groovy-kt test-groovy-m test-groovy-ml \
  test-groovy-hs test-groovy-zig test-groovy-sml test-groovy-octave test-groovy-groovy test-groovy-ws test-groovy-coffee test-groovy-swift \
  test-groovy-py test-groovy-fs test-groovy-nim test-groovy-fsx test-groovy-tcl test-groovy-bf test-groovy-java test-groovy-php \
  test-groovy-bash test-groovy-d test-groovy-pl test-groovy-exs test-groovy-rb test-groovy-js test-groovy-ts test-groovy-erl \
  test-groovy-cs test-groovy-prolog test-groovy-cr test-groovy-unl test-groovy-hx test-groovy-bef test-groovy-awk test-groovy-piet \
  test-ws-clj test-ws-lisp test-ws-rkt test-ws-rs test-ws-c test-ws-cpp test-ws-scala test-ws-f90 \
  test-ws-scm test-ws-r test-ws-lua test-ws-go test-ws-ps test-ws-vala test-ws-pike test-ws-pas \
  test-ws-kt test-ws-m test-ws-ml test-ws-hs test-ws-zig test-ws-sml test-ws-octave test-ws-groovy \
  test-ws-ws test-ws-coffee test-ws-swift test-ws-py test-ws-fs test-ws-nim test-ws-fsx test-ws-tcl \
  test-ws-bf test-ws-java test-ws-php test-ws-bash test-ws-d test-ws-pl test-ws-exs test-ws-rb \
  test-ws-js test-ws-ts test-ws-erl test-ws-cs test-ws-prolog test-ws-cr test-ws-unl test-ws-hx \
  test-ws-bef test-ws-awk test-ws-piet test-coffee-clj test-coffee-lisp test-coffee-rkt test-coffee-rs test-coffee-c \
  test-coffee-cpp test-coffee-scala test-coffee-f90 test-coffee-scm test-coffee-r test-coffee-lua test-coffee-go test-coffee-ps \
  test-coffee-vala test-coffee-pike test-coffee-pas test-coffee-kt test-coffee-m test-coffee-ml test-coffee-hs test-coffee-zig \
  test-coffee-sml test-coffee-octave test-coffee-groovy test-coffee-ws test-coffee-coffee test-coffee-swift test-coffee-py test-coffee-fs \
  test-coffee-nim test-coffee-fsx test-coffee-tcl test-coffee-bf test-coffee-java test-coffee-php test-coffee-bash test-coffee-d \
  test-coffee-pl test-coffee-exs test-coffee-rb test-coffee-js test-coffee-ts test-coffee-erl test-coffee-cs test-coffee-prolog \
  test-coffee-cr test-coffee-unl test-coffee-hx test-coffee-bef test-coffee-awk test-coffee-piet test-swift-clj test-swift-lisp \
  test-swift-rkt test-swift-rs test-swift-c test-swift-cpp test-swift-scala test-swift-f90 test-swift-scm test-swift-r \
  test-swift-lua test-swift-go test-swift-ps test-swift-vala test-swift-pike test-swift-pas test-swift-kt test-swift-m \
  test-swift-ml test-swift-hs test-swift-zig test-swift-sml test-swift-octave test-swift-groovy test-swift-ws test-swift-coffee \
  test-swift-swift test-swift-py test-swift-fs test-swift-nim test-swift-fsx test-swift-tcl test-swift-bf test-swift-java \
  test-swift-php test-swift-bash test-swift-d test-swift-pl test-swift-exs test-swift-rb test-swift-js test-swift-ts \
  test-swift-erl test-swift-cs test-swift-prolog test-swift-cr test-swift-unl test-swift-hx test-swift-bef test-swift-awk \
  test-swift-piet test-py-clj test-py-lisp test-py-rkt test-py-rs test-py-c test-py-cpp test-py-scala \
  test-py-f90 test-py-scm test-py-r test-py-lua test-py-go test-py-ps test-py-vala test-py-pike \
  test-py-pas test-py-kt test-py-m test-py-ml test-py-hs test-py-zig test-py-sml test-py-octave \
  test-py-groovy test-py-ws test-py-coffee test-py-swift test-py-py test-py-fs test-py-nim test-py-fsx \
  test-py-tcl test-py-bf test-py-java test-py-php test-py-bash test-py-d test-py-pl test-py-exs \
  test-py-rb test-py-js test-py-ts test-py-erl test-py-cs test-py-prolog test-py-cr test-py-unl \
  test-py-hx test-py-bef test-py-awk test-py-piet test-fs-clj test-fs-lisp test-fs-rkt test-fs-rs \
  test-fs-c test-fs-cpp test-fs-scala test-fs-f90 test-fs-scm test-fs-r test-fs-lua test-fs-go \
  test-fs-ps test-fs-vala test-fs-pike test-fs-pas test-fs-kt test-fs-m test-fs-ml test-fs-hs \
  test-fs-zig test-fs-sml test-fs-octave test-fs-groovy test-fs-ws test-fs-coffee test-fs-swift test-fs-py \
  test-fs-fs test-fs-nim test-fs-fsx test-fs-tcl test-fs-bf test-fs-java test-fs-php test-fs-bash \
  test-fs-d test-fs-pl test-fs-exs test-fs-rb test-fs-js test-fs-ts test-fs-erl test-fs-cs \
  test-fs-prolog test-fs-cr test-fs-unl test-fs-hx test-fs-bef test-fs-awk test-fs-piet test-nim-clj \
  test-nim-lisp test-nim-rkt test-nim-rs test-nim-c test-nim-cpp test-nim-scala test-nim-f90 test-nim-scm \
  test-nim-r test-nim-lua test-nim-go test-nim-ps test-nim-vala test-nim-pike test-nim-pas test-nim-kt \
  test-nim-m test-nim-ml test-nim-hs test-nim-zig test-nim-sml test-nim-octave test-nim-groovy test-nim-ws \
  test-nim-coffee test-nim-swift test-nim-py test-nim-fs test-nim-nim test-nim-fsx test-nim-tcl test-nim-bf \
  test-nim-java test-nim-php test-nim-bash test-nim-d test-nim-pl test-nim-exs test-nim-rb test-nim-js \
  test-nim-ts test-nim-erl test-nim-cs test-nim-prolog test-nim-cr test-nim-unl test-nim-hx test-nim-bef \
  test-nim-awk test-nim-piet test-fsx-clj test-fsx-lisp test-fsx-rkt test-fsx-rs test-fsx-c test-fsx-cpp \
  test-fsx-scala test-fsx-f90 test-fsx-scm test-fsx-r test-fsx-lua test-fsx-go test-fsx-ps test-fsx-vala \
  test-fsx-pike test-fsx-pas test-fsx-kt test-fsx-m test-fsx-ml test-fsx-hs test-fsx-zig test-fsx-sml \
  test-fsx-octave test-fsx-groovy test-fsx-ws test-fsx-coffee test-fsx-swift test-fsx-py test-fsx-fs test-fsx-nim \
  test-fsx-fsx test-fsx-tcl test-fsx-bf test-fsx-java test-fsx-php test-fsx-bash test-fsx-d test-fsx-pl \
  test-fsx-exs test-fsx-rb test-fsx-js test-fsx-ts test-fsx-erl test-fsx-cs test-fsx-prolog test-fsx-cr \
  test-fsx-unl test-fsx-hx test-fsx-bef test-fsx-awk test-fsx-piet test-tcl-clj test-tcl-lisp test-tcl-rkt \
  test-tcl-rs test-tcl-c test-tcl-cpp test-tcl-scala test-tcl-f90 test-tcl-scm test-tcl-r test-tcl-lua \
  test-tcl-go test-tcl-ps test-tcl-vala test-tcl-pike test-tcl-pas test-tcl-kt test-tcl-m test-tcl-ml \
  test-tcl-hs test-tcl-zig test-tcl-sml test-tcl-octave test-tcl-groovy test-tcl-ws test-tcl-coffee test-tcl-swift \
  test-tcl-py test-tcl-fs test-tcl-nim test-tcl-fsx test-tcl-tcl test-tcl-bf test-tcl-java test-tcl-php \
  test-tcl-bash test-tcl-d test-tcl-pl test-tcl-exs test-tcl-rb test-tcl-js test-tcl-ts test-tcl-erl \
  test-tcl-cs test-tcl-prolog test-tcl-cr test-tcl-unl test-tcl-hx test-tcl-bef test-tcl-awk test-tcl-piet \
  test-bf-clj test-bf-lisp test-bf-rkt test-bf-rs test-bf-c test-bf-cpp test-bf-scala test-bf-f90 \
  test-bf-scm test-bf-r test-bf-lua test-bf-go test-bf-ps test-bf-vala test-bf-pike test-bf-pas \
  test-bf-kt test-bf-m test-bf-ml test-bf-hs test-bf-zig test-bf-sml test-bf-octave test-bf-groovy \
  test-bf-ws test-bf-coffee test-bf-swift test-bf-py test-bf-fs test-bf-nim test-bf-fsx test-bf-tcl \
  test-bf-bf test-bf-java test-bf-php test-bf-bash test-bf-d test-bf-pl test-bf-exs test-bf-rb \
  test-bf-js test-bf-ts test-bf-erl test-bf-cs test-bf-prolog test-bf-cr test-bf-unl test-bf-hx \
  test-bf-bef test-bf-awk test-bf-piet test-java-clj test-java-lisp test-java-rkt test-java-rs test-java-c \
  test-java-cpp test-java-scala test-java-f90 test-java-scm test-java-r test-java-lua test-java-go test-java-ps \
  test-java-vala test-java-pike test-java-pas test-java-kt test-java-m test-java-ml test-java-hs test-java-zig \
  test-java-sml test-java-octave test-java-groovy test-java-ws test-java-coffee test-java-swift test-java-py test-java-fs \
  test-java-nim test-java-fsx test-java-tcl test-java-bf test-java-java test-java-php test-java-bash test-java-d \
  test-java-pl test-java-exs test-java-rb test-java-js test-java-ts test-java-erl test-java-cs test-java-prolog \
  test-java-cr test-java-unl test-java-hx test-java-bef test-java-awk test-java-piet test-php-clj test-php-lisp \
  test-php-rkt test-php-rs test-php-c test-php-cpp test-php-scala test-php-f90 test-php-scm test-php-r \
  test-php-lua test-php-go test-php-ps test-php-vala test-php-pike test-php-pas test-php-kt test-php-m \
  test-php-ml test-php-hs test-php-zig test-php-sml test-php-octave test-php-groovy test-php-ws test-php-coffee \
  test-php-swift test-php-py test-php-fs test-php-nim test-php-fsx test-php-tcl test-php-bf test-php-java \
  test-php-php test-php-bash test-php-d test-php-pl test-php-exs test-php-rb test-php-js test-php-ts \
  test-php-erl test-php-cs test-php-prolog test-php-cr test-php-unl test-php-hx test-php-bef test-php-awk \
  test-php-piet test-bash-clj test-bash-lisp test-bash-rkt test-bash-rs test-bash-c test-bash-cpp test-bash-scala \
  test-bash-f90 test-bash-scm test-bash-r test-bash-lua test-bash-go test-bash-ps test-bash-vala test-bash-pike \
  test-bash-pas test-bash-kt test-bash-m test-bash-ml test-bash-hs test-bash-zig test-bash-sml test-bash-octave \
  test-bash-groovy test-bash-ws test-bash-coffee test-bash-swift test-bash-py test-bash-fs test-bash-nim test-bash-fsx \
  test-bash-tcl test-bash-bf test-bash-java test-bash-php test-bash-bash test-bash-d test-bash-pl test-bash-exs \
  test-bash-rb test-bash-js test-bash-ts test-bash-erl test-bash-cs test-bash-prolog test-bash-cr test-bash-unl \
  test-bash-hx test-bash-bef test-bash-awk test-bash-piet test-d-clj test-d-lisp test-d-rkt test-d-rs \
  test-d-c test-d-cpp test-d-scala test-d-f90 test-d-scm test-d-r test-d-lua test-d-go \
  test-d-ps test-d-vala test-d-pike test-d-pas test-d-kt test-d-m test-d-ml test-d-hs \
  test-d-zig test-d-sml test-d-octave test-d-groovy test-d-ws test-d-coffee test-d-swift test-d-py \
  test-d-fs test-d-nim test-d-fsx test-d-tcl test-d-bf test-d-java test-d-php test-d-bash \
  test-d-d test-d-pl test-d-exs test-d-rb test-d-js test-d-ts test-d-erl test-d-cs \
  test-d-prolog test-d-cr test-d-unl test-d-hx test-d-bef test-d-awk test-d-piet test-pl-clj \
  test-pl-lisp test-pl-rkt test-pl-rs test-pl-c test-pl-cpp test-pl-scala test-pl-f90 test-pl-scm \
  test-pl-r test-pl-lua test-pl-go test-pl-ps test-pl-vala test-pl-pike test-pl-pas test-pl-kt \
  test-pl-m test-pl-ml test-pl-hs test-pl-zig test-pl-sml test-pl-octave test-pl-groovy test-pl-ws \
  test-pl-coffee test-pl-swift test-pl-py test-pl-fs test-pl-nim test-pl-fsx test-pl-tcl test-pl-bf \
  test-pl-java test-pl-php test-pl-bash test-pl-d test-pl-pl test-pl-exs test-pl-rb test-pl-js \
  test-pl-ts test-pl-erl test-pl-cs test-pl-prolog test-pl-cr test-pl-unl test-pl-hx test-pl-bef \
  test-pl-awk test-pl-piet test-exs-clj test-exs-lisp test-exs-rkt test-exs-rs test-exs-c test-exs-cpp \
  test-exs-scala test-exs-f90 test-exs-scm test-exs-r test-exs-lua test-exs-go test-exs-ps test-exs-vala \
  test-exs-pike test-exs-pas test-exs-kt test-exs-m test-exs-ml test-exs-hs test-exs-zig test-exs-sml \
  test-exs-octave test-exs-groovy test-exs-ws test-exs-coffee test-exs-swift test-exs-py test-exs-fs test-exs-nim \
  test-exs-fsx test-exs-tcl test-exs-bf test-exs-java test-exs-php test-exs-bash test-exs-d test-exs-pl \
  test-exs-exs test-exs-rb test-exs-js test-exs-ts test-exs-erl test-exs-cs test-exs-prolog test-exs-cr \
  test-exs-unl test-exs-hx test-exs-bef test-exs-awk test-exs-piet test-rb-clj test-rb-lisp test-rb-rkt \
  test-rb-rs test-rb-c test-rb-cpp test-rb-scala test-rb-f90 test-rb-scm test-rb-r test-rb-lua \
  test-rb-go test-rb-ps test-rb-vala test-rb-pike test-rb-pas test-rb-kt test-rb-m test-rb-ml \
  test-rb-hs test-rb-zig test-rb-sml test-rb-octave test-rb-groovy test-rb-ws test-rb-coffee test-rb-swift \
  test-rb-py test-rb-fs test-rb-nim test-rb-fsx test-rb-tcl test-rb-bf test-rb-java test-rb-php \
  test-rb-bash test-rb-d test-rb-pl test-rb-exs test-rb-rb test-rb-js test-rb-ts test-rb-erl \
  test-rb-cs test-rb-prolog test-rb-cr test-rb-unl test-rb-hx test-rb-bef test-rb-awk test-rb-piet \
  test-js-clj test-js-lisp test-js-rkt test-js-rs test-js-c test-js-cpp test-js-scala test-js-f90 \
  test-js-scm test-js-r test-js-lua test-js-go test-js-ps test-js-vala test-js-pike test-js-pas \
  test-js-kt test-js-m test-js-ml test-js-hs test-js-zig test-js-sml test-js-octave test-js-groovy \
  test-js-ws test-js-coffee test-js-swift test-js-py test-js-fs test-js-nim test-js-fsx test-js-tcl \
  test-js-bf test-js-java test-js-php test-js-bash test-js-d test-js-pl test-js-exs test-js-rb \
  test-js-js test-js-ts test-js-erl test-js-cs test-js-prolog test-js-cr test-js-unl test-js-hx \
  test-js-bef test-js-awk test-js-piet test-ts-clj test-ts-lisp test-ts-rkt test-ts-rs test-ts-c \
  test-ts-cpp test-ts-scala test-ts-f90 test-ts-scm test-ts-r test-ts-lua test-ts-go test-ts-ps \
  test-ts-vala test-ts-pike test-ts-pas test-ts-kt test-ts-m test-ts-ml test-ts-hs test-ts-zig \
  test-ts-sml test-ts-octave test-ts-groovy test-ts-ws test-ts-coffee test-ts-swift test-ts-py test-ts-fs \
  test-ts-nim test-ts-fsx test-ts-tcl test-ts-bf test-ts-java test-ts-php test-ts-bash test-ts-d \
  test-ts-pl test-ts-exs test-ts-rb test-ts-js test-ts-ts test-ts-erl test-ts-cs test-ts-prolog \
  test-ts-cr test-ts-unl test-ts-hx test-ts-bef test-ts-awk test-ts-piet test-erl-clj test-erl-lisp \
  test-erl-rkt test-erl-rs test-erl-c test-erl-cpp test-erl-scala test-erl-f90 test-erl-scm test-erl-r \
  test-erl-lua test-erl-go test-erl-ps test-erl-vala test-erl-pike test-erl-pas test-erl-kt test-erl-m \
  test-erl-ml test-erl-hs test-erl-zig test-erl-sml test-erl-octave test-erl-groovy test-erl-ws test-erl-coffee \
  test-erl-swift test-erl-py test-erl-fs test-erl-nim test-erl-fsx test-erl-tcl test-erl-bf test-erl-java \
  test-erl-php test-erl-bash test-erl-d test-erl-pl test-erl-exs test-erl-rb test-erl-js test-erl-ts \
  test-erl-erl test-erl-cs test-erl-prolog test-erl-cr test-erl-unl test-erl-hx test-erl-bef test-erl-awk \
  test-erl-piet test-cs-clj test-cs-lisp test-cs-rkt test-cs-rs test-cs-c test-cs-cpp test-cs-scala \
  test-cs-f90 test-cs-scm test-cs-r test-cs-lua test-cs-go test-cs-ps test-cs-vala test-cs-pike \
  test-cs-pas test-cs-kt test-cs-m test-cs-ml test-cs-hs test-cs-zig test-cs-sml test-cs-octave \
  test-cs-groovy test-cs-ws test-cs-coffee test-cs-swift test-cs-py test-cs-fs test-cs-nim test-cs-fsx \
  test-cs-tcl test-cs-bf test-cs-java test-cs-php test-cs-bash test-cs-d test-cs-pl test-cs-exs \
  test-cs-rb test-cs-js test-cs-ts test-cs-erl test-cs-cs test-cs-prolog test-cs-cr test-cs-unl \
  test-cs-hx test-cs-bef test-cs-awk test-cs-piet test-prolog-clj test-prolog-lisp test-prolog-rkt test-prolog-rs \
  test-prolog-c test-prolog-cpp test-prolog-scala test-prolog-f90 test-prolog-scm test-prolog-r test-prolog-lua test-prolog-go \
  test-prolog-ps test-prolog-vala test-prolog-pike test-prolog-pas test-prolog-kt test-prolog-m test-prolog-ml test-prolog-hs \
  test-prolog-zig test-prolog-sml test-prolog-octave test-prolog-groovy test-prolog-ws test-prolog-coffee test-prolog-swift test-prolog-py \
  test-prolog-fs test-prolog-nim test-prolog-fsx test-prolog-tcl test-prolog-bf test-prolog-java test-prolog-php test-prolog-bash \
  test-prolog-d test-prolog-pl test-prolog-exs test-prolog-rb test-prolog-js test-prolog-ts test-prolog-erl test-prolog-cs \
  test-prolog-prolog test-prolog-cr test-prolog-unl test-prolog-hx test-prolog-bef test-prolog-awk test-prolog-piet test-cr-clj \
  test-cr-lisp test-cr-rkt test-cr-rs test-cr-c test-cr-cpp test-cr-scala test-cr-f90 test-cr-scm \
  test-cr-r test-cr-lua test-cr-go test-cr-ps test-cr-vala test-cr-pike test-cr-pas test-cr-kt \
  test-cr-m test-cr-ml test-cr-hs test-cr-zig test-cr-sml test-cr-octave test-cr-groovy test-cr-ws \
  test-cr-coffee test-cr-swift test-cr-py test-cr-fs test-cr-nim test-cr-fsx test-cr-tcl test-cr-bf \
  test-cr-java test-cr-php test-cr-bash test-cr-d test-cr-pl test-cr-exs test-cr-rb test-cr-js \
  test-cr-ts test-cr-erl test-cr-cs test-cr-prolog test-cr-cr test-cr-unl test-cr-hx test-cr-bef \
  test-cr-awk test-cr-piet test-unl-clj test-unl-lisp test-unl-rkt test-unl-rs test-unl-c test-unl-cpp \
  test-unl-scala test-unl-f90 test-unl-scm test-unl-r test-unl-lua test-unl-go test-unl-ps test-unl-vala \
  test-unl-pike test-unl-pas test-unl-kt test-unl-m test-unl-ml test-unl-hs test-unl-zig test-unl-sml \
  test-unl-octave test-unl-groovy test-unl-ws test-unl-coffee test-unl-swift test-unl-py test-unl-fs test-unl-nim \
  test-unl-fsx test-unl-tcl test-unl-bf test-unl-java test-unl-php test-unl-bash test-unl-d test-unl-pl \
  test-unl-exs test-unl-rb test-unl-js test-unl-ts test-unl-erl test-unl-cs test-unl-prolog test-unl-cr \
  test-unl-unl test-unl-hx test-unl-bef test-unl-awk test-unl-piet test-hx-clj test-hx-lisp test-hx-rkt \
  test-hx-rs test-hx-c test-hx-cpp test-hx-scala test-hx-f90 test-hx-scm test-hx-r test-hx-lua \
  test-hx-go test-hx-ps test-hx-vala test-hx-pike test-hx-pas test-hx-kt test-hx-m test-hx-ml \
  test-hx-hs test-hx-zig test-hx-sml test-hx-octave test-hx-groovy test-hx-ws test-hx-coffee test-hx-swift \
  test-hx-py test-hx-fs test-hx-nim test-hx-fsx test-hx-tcl test-hx-bf test-hx-java test-hx-php \
  test-hx-bash test-hx-d test-hx-pl test-hx-exs test-hx-rb test-hx-js test-hx-ts test-hx-erl \
  test-hx-cs test-hx-prolog test-hx-cr test-hx-unl test-hx-hx test-hx-bef test-hx-awk test-hx-piet \
  test-bef-clj test-bef-lisp test-bef-rkt test-bef-rs test-bef-c test-bef-cpp test-bef-scala test-bef-f90 \
  test-bef-scm test-bef-r test-bef-lua test-bef-go test-bef-ps test-bef-vala test-bef-pike test-bef-pas \
  test-bef-kt test-bef-m test-bef-ml test-bef-hs test-bef-zig test-bef-sml test-bef-octave test-bef-groovy \
  test-bef-ws test-bef-coffee test-bef-swift test-bef-py test-bef-fs test-bef-nim test-bef-fsx test-bef-tcl \
  test-bef-bf test-bef-java test-bef-php test-bef-bash test-bef-d test-bef-pl test-bef-exs test-bef-rb \
  test-bef-js test-bef-ts test-bef-erl test-bef-cs test-bef-prolog test-bef-cr test-bef-unl test-bef-hx \
  test-bef-bef test-bef-awk test-bef-piet test-awk-clj test-awk-lisp test-awk-rkt test-awk-rs test-awk-c \
  test-awk-cpp test-awk-scala test-awk-f90 test-awk-scm test-awk-r test-awk-lua test-awk-go test-awk-ps \
  test-awk-vala test-awk-pike test-awk-pas test-awk-kt test-awk-m test-awk-ml test-awk-hs test-awk-zig \
  test-awk-sml test-awk-octave test-awk-groovy test-awk-ws test-awk-coffee test-awk-swift test-awk-py test-awk-fs \
  test-awk-nim test-awk-fsx test-awk-tcl test-awk-bf test-awk-java test-awk-php test-awk-bash test-awk-d \
  test-awk-pl test-awk-exs test-awk-rb test-awk-js test-awk-ts test-awk-erl test-awk-cs test-awk-prolog \
  test-awk-cr test-awk-unl test-awk-hx test-awk-bef test-awk-awk test-awk-piet test-piet-clj test-piet-lisp \
  test-piet-rkt test-piet-rs test-piet-c test-piet-cpp test-piet-scala test-piet-f90 test-piet-scm test-piet-r \
  test-piet-lua test-piet-go test-piet-ps test-piet-vala test-piet-pike test-piet-pas test-piet-kt test-piet-m \
  test-piet-ml test-piet-hs test-piet-zig test-piet-sml test-piet-octave test-piet-groovy test-piet-ws test-piet-coffee \
  test-piet-swift test-piet-py test-piet-fs test-piet-nim test-piet-fsx test-piet-tcl test-piet-bf test-piet-java \
  test-piet-php test-piet-bash test-piet-d test-piet-pl test-piet-exs test-piet-rb test-piet-js test-piet-ts \
  test-piet-erl test-piet-cs test-piet-prolog test-piet-cr test-piet-unl test-piet-hx test-piet-bef test-piet-awk \
  test-piet-piet

clean:
	rm -f qc.clj qc.lisp qc.rkt qc.rs qc.c qc.cpp qc.scala qc.f90 \
  qc.scm qc.r qc.lua qc.go qc.ps qc.vala qc.pike qc.pas \
  qc.kt qc.m qc.ml qc.hs qc.zig qc.sml qc.octave qc.groovy \
  qc.ws qc.coffee qc.swift qc.py qc.fs qc.nim qc.fsx qc.tcl \
  qc.bf qc.java qc.php qc.bash qc.d qc.pl qc.exs qc.js \
  qc.ts qc.erl qc.cs qc.prolog qc.cr qc.unl qc.hx qc.bef \
  qc.awk qc.piet.gif
	rm -rf build output

.PHONY: all members test test-all clean test-clj-clj test-clj-lisp test-clj-rkt \
  test-clj-rs test-clj-c test-clj-cpp test-clj-scala test-clj-f90 test-clj-scm test-clj-r test-clj-lua \
  test-clj-go test-clj-ps test-clj-vala test-clj-pike test-clj-pas test-clj-kt test-clj-m test-clj-ml \
  test-clj-hs test-clj-zig test-clj-sml test-clj-octave test-clj-groovy test-clj-ws test-clj-coffee test-clj-swift \
  test-clj-py test-clj-fs test-clj-nim test-clj-fsx test-clj-tcl test-clj-bf test-clj-java test-clj-php \
  test-clj-bash test-clj-d test-clj-pl test-clj-exs test-clj-rb test-clj-js test-clj-ts test-clj-erl \
  test-clj-cs test-clj-prolog test-clj-cr test-clj-unl test-clj-hx test-clj-bef test-clj-awk test-clj-piet \
  test-lisp-clj test-lisp-lisp test-lisp-rkt test-lisp-rs test-lisp-c test-lisp-cpp test-lisp-scala test-lisp-f90 \
  test-lisp-scm test-lisp-r test-lisp-lua test-lisp-go test-lisp-ps test-lisp-vala test-lisp-pike test-lisp-pas \
  test-lisp-kt test-lisp-m test-lisp-ml test-lisp-hs test-lisp-zig test-lisp-sml test-lisp-octave test-lisp-groovy \
  test-lisp-ws test-lisp-coffee test-lisp-swift test-lisp-py test-lisp-fs test-lisp-nim test-lisp-fsx test-lisp-tcl \
  test-lisp-bf test-lisp-java test-lisp-php test-lisp-bash test-lisp-d test-lisp-pl test-lisp-exs test-lisp-rb \
  test-lisp-js test-lisp-ts test-lisp-erl test-lisp-cs test-lisp-prolog test-lisp-cr test-lisp-unl test-lisp-hx \
  test-lisp-bef test-lisp-awk test-lisp-piet test-rkt-clj test-rkt-lisp test-rkt-rkt test-rkt-rs test-rkt-c \
  test-rkt-cpp test-rkt-scala test-rkt-f90 test-rkt-scm test-rkt-r test-rkt-lua test-rkt-go test-rkt-ps \
  test-rkt-vala test-rkt-pike test-rkt-pas test-rkt-kt test-rkt-m test-rkt-ml test-rkt-hs test-rkt-zig \
  test-rkt-sml test-rkt-octave test-rkt-groovy test-rkt-ws test-rkt-coffee test-rkt-swift test-rkt-py test-rkt-fs \
  test-rkt-nim test-rkt-fsx test-rkt-tcl test-rkt-bf test-rkt-java test-rkt-php test-rkt-bash test-rkt-d \
  test-rkt-pl test-rkt-exs test-rkt-rb test-rkt-js test-rkt-ts test-rkt-erl test-rkt-cs test-rkt-prolog \
  test-rkt-cr test-rkt-unl test-rkt-hx test-rkt-bef test-rkt-awk test-rkt-piet test-rs-clj test-rs-lisp \
  test-rs-rkt test-rs-rs test-rs-c test-rs-cpp test-rs-scala test-rs-f90 test-rs-scm test-rs-r \
  test-rs-lua test-rs-go test-rs-ps test-rs-vala test-rs-pike test-rs-pas test-rs-kt test-rs-m \
  test-rs-ml test-rs-hs test-rs-zig test-rs-sml test-rs-octave test-rs-groovy test-rs-ws test-rs-coffee \
  test-rs-swift test-rs-py test-rs-fs test-rs-nim test-rs-fsx test-rs-tcl test-rs-bf test-rs-java \
  test-rs-php test-rs-bash test-rs-d test-rs-pl test-rs-exs test-rs-rb test-rs-js test-rs-ts \
  test-rs-erl test-rs-cs test-rs-prolog test-rs-cr test-rs-unl test-rs-hx test-rs-bef test-rs-awk \
  test-rs-piet test-c-clj test-c-lisp test-c-rkt test-c-rs test-c-c test-c-cpp test-c-scala \
  test-c-f90 test-c-scm test-c-r test-c-lua test-c-go test-c-ps test-c-vala test-c-pike \
  test-c-pas test-c-kt test-c-m test-c-ml test-c-hs test-c-zig test-c-sml test-c-octave \
  test-c-groovy test-c-ws test-c-coffee test-c-swift test-c-py test-c-fs test-c-nim test-c-fsx \
  test-c-tcl test-c-bf test-c-java test-c-php test-c-bash test-c-d test-c-pl test-c-exs \
  test-c-rb test-c-js test-c-ts test-c-erl test-c-cs test-c-prolog test-c-cr test-c-unl \
  test-c-hx test-c-bef test-c-awk test-c-piet test-cpp-clj test-cpp-lisp test-cpp-rkt test-cpp-rs \
  test-cpp-c test-cpp-cpp test-cpp-scala test-cpp-f90 test-cpp-scm test-cpp-r test-cpp-lua test-cpp-go \
  test-cpp-ps test-cpp-vala test-cpp-pike test-cpp-pas test-cpp-kt test-cpp-m test-cpp-ml test-cpp-hs \
  test-cpp-zig test-cpp-sml test-cpp-octave test-cpp-groovy test-cpp-ws test-cpp-coffee test-cpp-swift test-cpp-py \
  test-cpp-fs test-cpp-nim test-cpp-fsx test-cpp-tcl test-cpp-bf test-cpp-java test-cpp-php test-cpp-bash \
  test-cpp-d test-cpp-pl test-cpp-exs test-cpp-rb test-cpp-js test-cpp-ts test-cpp-erl test-cpp-cs \
  test-cpp-prolog test-cpp-cr test-cpp-unl test-cpp-hx test-cpp-bef test-cpp-awk test-cpp-piet test-scala-clj \
  test-scala-lisp test-scala-rkt test-scala-rs test-scala-c test-scala-cpp test-scala-scala test-scala-f90 test-scala-scm \
  test-scala-r test-scala-lua test-scala-go test-scala-ps test-scala-vala test-scala-pike test-scala-pas test-scala-kt \
  test-scala-m test-scala-ml test-scala-hs test-scala-zig test-scala-sml test-scala-octave test-scala-groovy test-scala-ws \
  test-scala-coffee test-scala-swift test-scala-py test-scala-fs test-scala-nim test-scala-fsx test-scala-tcl test-scala-bf \
  test-scala-java test-scala-php test-scala-bash test-scala-d test-scala-pl test-scala-exs test-scala-rb test-scala-js \
  test-scala-ts test-scala-erl test-scala-cs test-scala-prolog test-scala-cr test-scala-unl test-scala-hx test-scala-bef \
  test-scala-awk test-scala-piet test-f90-clj test-f90-lisp test-f90-rkt test-f90-rs test-f90-c test-f90-cpp \
  test-f90-scala test-f90-f90 test-f90-scm test-f90-r test-f90-lua test-f90-go test-f90-ps test-f90-vala \
  test-f90-pike test-f90-pas test-f90-kt test-f90-m test-f90-ml test-f90-hs test-f90-zig test-f90-sml \
  test-f90-octave test-f90-groovy test-f90-ws test-f90-coffee test-f90-swift test-f90-py test-f90-fs test-f90-nim \
  test-f90-fsx test-f90-tcl test-f90-bf test-f90-java test-f90-php test-f90-bash test-f90-d test-f90-pl \
  test-f90-exs test-f90-rb test-f90-js test-f90-ts test-f90-erl test-f90-cs test-f90-prolog test-f90-cr \
  test-f90-unl test-f90-hx test-f90-bef test-f90-awk test-f90-piet test-scm-clj test-scm-lisp test-scm-rkt \
  test-scm-rs test-scm-c test-scm-cpp test-scm-scala test-scm-f90 test-scm-scm test-scm-r test-scm-lua \
  test-scm-go test-scm-ps test-scm-vala test-scm-pike test-scm-pas test-scm-kt test-scm-m test-scm-ml \
  test-scm-hs test-scm-zig test-scm-sml test-scm-octave test-scm-groovy test-scm-ws test-scm-coffee test-scm-swift \
  test-scm-py test-scm-fs test-scm-nim test-scm-fsx test-scm-tcl test-scm-bf test-scm-java test-scm-php \
  test-scm-bash test-scm-d test-scm-pl test-scm-exs test-scm-rb test-scm-js test-scm-ts test-scm-erl \
  test-scm-cs test-scm-prolog test-scm-cr test-scm-unl test-scm-hx test-scm-bef test-scm-awk test-scm-piet \
  test-r-clj test-r-lisp test-r-rkt test-r-rs test-r-c test-r-cpp test-r-scala test-r-f90 \
  test-r-scm test-r-r test-r-lua test-r-go test-r-ps test-r-vala test-r-pike test-r-pas \
  test-r-kt test-r-m test-r-ml test-r-hs test-r-zig test-r-sml test-r-octave test-r-groovy \
  test-r-ws test-r-coffee test-r-swift test-r-py test-r-fs test-r-nim test-r-fsx test-r-tcl \
  test-r-bf test-r-java test-r-php test-r-bash test-r-d test-r-pl test-r-exs test-r-rb \
  test-r-js test-r-ts test-r-erl test-r-cs test-r-prolog test-r-cr test-r-unl test-r-hx \
  test-r-bef test-r-awk test-r-piet test-lua-clj test-lua-lisp test-lua-rkt test-lua-rs test-lua-c \
  test-lua-cpp test-lua-scala test-lua-f90 test-lua-scm test-lua-r test-lua-lua test-lua-go test-lua-ps \
  test-lua-vala test-lua-pike test-lua-pas test-lua-kt test-lua-m test-lua-ml test-lua-hs test-lua-zig \
  test-lua-sml test-lua-octave test-lua-groovy test-lua-ws test-lua-coffee test-lua-swift test-lua-py test-lua-fs \
  test-lua-nim test-lua-fsx test-lua-tcl test-lua-bf test-lua-java test-lua-php test-lua-bash test-lua-d \
  test-lua-pl test-lua-exs test-lua-rb test-lua-js test-lua-ts test-lua-erl test-lua-cs test-lua-prolog \
  test-lua-cr test-lua-unl test-lua-hx test-lua-bef test-lua-awk test-lua-piet test-go-clj test-go-lisp \
  test-go-rkt test-go-rs test-go-c test-go-cpp test-go-scala test-go-f90 test-go-scm test-go-r \
  test-go-lua test-go-go test-go-ps test-go-vala test-go-pike test-go-pas test-go-kt test-go-m \
  test-go-ml test-go-hs test-go-zig test-go-sml test-go-octave test-go-groovy test-go-ws test-go-coffee \
  test-go-swift test-go-py test-go-fs test-go-nim test-go-fsx test-go-tcl test-go-bf test-go-java \
  test-go-php test-go-bash test-go-d test-go-pl test-go-exs test-go-rb test-go-js test-go-ts \
  test-go-erl test-go-cs test-go-prolog test-go-cr test-go-unl test-go-hx test-go-bef test-go-awk \
  test-go-piet test-ps-clj test-ps-lisp test-ps-rkt test-ps-rs test-ps-c test-ps-cpp test-ps-scala \
  test-ps-f90 test-ps-scm test-ps-r test-ps-lua test-ps-go test-ps-ps test-ps-vala test-ps-pike \
  test-ps-pas test-ps-kt test-ps-m test-ps-ml test-ps-hs test-ps-zig test-ps-sml test-ps-octave \
  test-ps-groovy test-ps-ws test-ps-coffee test-ps-swift test-ps-py test-ps-fs test-ps-nim test-ps-fsx \
  test-ps-tcl test-ps-bf test-ps-java test-ps-php test-ps-bash test-ps-d test-ps-pl test-ps-exs \
  test-ps-rb test-ps-js test-ps-ts test-ps-erl test-ps-cs test-ps-prolog test-ps-cr test-ps-unl \
  test-ps-hx test-ps-bef test-ps-awk test-ps-piet test-vala-clj test-vala-lisp test-vala-rkt test-vala-rs \
  test-vala-c test-vala-cpp test-vala-scala test-vala-f90 test-vala-scm test-vala-r test-vala-lua test-vala-go \
  test-vala-ps test-vala-vala test-vala-pike test-vala-pas test-vala-kt test-vala-m test-vala-ml test-vala-hs \
  test-vala-zig test-vala-sml test-vala-octave test-vala-groovy test-vala-ws test-vala-coffee test-vala-swift test-vala-py \
  test-vala-fs test-vala-nim test-vala-fsx test-vala-tcl test-vala-bf test-vala-java test-vala-php test-vala-bash \
  test-vala-d test-vala-pl test-vala-exs test-vala-rb test-vala-js test-vala-ts test-vala-erl test-vala-cs \
  test-vala-prolog test-vala-cr test-vala-unl test-vala-hx test-vala-bef test-vala-awk test-vala-piet test-pike-clj \
  test-pike-lisp test-pike-rkt test-pike-rs test-pike-c test-pike-cpp test-pike-scala test-pike-f90 test-pike-scm \
  test-pike-r test-pike-lua test-pike-go test-pike-ps test-pike-vala test-pike-pike test-pike-pas test-pike-kt \
  test-pike-m test-pike-ml test-pike-hs test-pike-zig test-pike-sml test-pike-octave test-pike-groovy test-pike-ws \
  test-pike-coffee test-pike-swift test-pike-py test-pike-fs test-pike-nim test-pike-fsx test-pike-tcl test-pike-bf \
  test-pike-java test-pike-php test-pike-bash test-pike-d test-pike-pl test-pike-exs test-pike-rb test-pike-js \
  test-pike-ts test-pike-erl test-pike-cs test-pike-prolog test-pike-cr test-pike-unl test-pike-hx test-pike-bef \
  test-pike-awk test-pike-piet test-pas-clj test-pas-lisp test-pas-rkt test-pas-rs test-pas-c test-pas-cpp \
  test-pas-scala test-pas-f90 test-pas-scm test-pas-r test-pas-lua test-pas-go test-pas-ps test-pas-vala \
  test-pas-pike test-pas-pas test-pas-kt test-pas-m test-pas-ml test-pas-hs test-pas-zig test-pas-sml \
  test-pas-octave test-pas-groovy test-pas-ws test-pas-coffee test-pas-swift test-pas-py test-pas-fs test-pas-nim \
  test-pas-fsx test-pas-tcl test-pas-bf test-pas-java test-pas-php test-pas-bash test-pas-d test-pas-pl \
  test-pas-exs test-pas-rb test-pas-js test-pas-ts test-pas-erl test-pas-cs test-pas-prolog test-pas-cr \
  test-pas-unl test-pas-hx test-pas-bef test-pas-awk test-pas-piet test-kt-clj test-kt-lisp test-kt-rkt \
  test-kt-rs test-kt-c test-kt-cpp test-kt-scala test-kt-f90 test-kt-scm test-kt-r test-kt-lua \
  test-kt-go test-kt-ps test-kt-vala test-kt-pike test-kt-pas test-kt-kt test-kt-m test-kt-ml \
  test-kt-hs test-kt-zig test-kt-sml test-kt-octave test-kt-groovy test-kt-ws test-kt-coffee test-kt-swift \
  test-kt-py test-kt-fs test-kt-nim test-kt-fsx test-kt-tcl test-kt-bf test-kt-java test-kt-php \
  test-kt-bash test-kt-d test-kt-pl test-kt-exs test-kt-rb test-kt-js test-kt-ts test-kt-erl \
  test-kt-cs test-kt-prolog test-kt-cr test-kt-unl test-kt-hx test-kt-bef test-kt-awk test-kt-piet \
  test-m-clj test-m-lisp test-m-rkt test-m-rs test-m-c test-m-cpp test-m-scala test-m-f90 \
  test-m-scm test-m-r test-m-lua test-m-go test-m-ps test-m-vala test-m-pike test-m-pas \
  test-m-kt test-m-m test-m-ml test-m-hs test-m-zig test-m-sml test-m-octave test-m-groovy \
  test-m-ws test-m-coffee test-m-swift test-m-py test-m-fs test-m-nim test-m-fsx test-m-tcl \
  test-m-bf test-m-java test-m-php test-m-bash test-m-d test-m-pl test-m-exs test-m-rb \
  test-m-js test-m-ts test-m-erl test-m-cs test-m-prolog test-m-cr test-m-unl test-m-hx \
  test-m-bef test-m-awk test-m-piet test-ml-clj test-ml-lisp test-ml-rkt test-ml-rs test-ml-c \
  test-ml-cpp test-ml-scala test-ml-f90 test-ml-scm test-ml-r test-ml-lua test-ml-go test-ml-ps \
  test-ml-vala test-ml-pike test-ml-pas test-ml-kt test-ml-m test-ml-ml test-ml-hs test-ml-zig \
  test-ml-sml test-ml-octave test-ml-groovy test-ml-ws test-ml-coffee test-ml-swift test-ml-py test-ml-fs \
  test-ml-nim test-ml-fsx test-ml-tcl test-ml-bf test-ml-java test-ml-php test-ml-bash test-ml-d \
  test-ml-pl test-ml-exs test-ml-rb test-ml-js test-ml-ts test-ml-erl test-ml-cs test-ml-prolog \
  test-ml-cr test-ml-unl test-ml-hx test-ml-bef test-ml-awk test-ml-piet test-hs-clj test-hs-lisp \
  test-hs-rkt test-hs-rs test-hs-c test-hs-cpp test-hs-scala test-hs-f90 test-hs-scm test-hs-r \
  test-hs-lua test-hs-go test-hs-ps test-hs-vala test-hs-pike test-hs-pas test-hs-kt test-hs-m \
  test-hs-ml test-hs-hs test-hs-zig test-hs-sml test-hs-octave test-hs-groovy test-hs-ws test-hs-coffee \
  test-hs-swift test-hs-py test-hs-fs test-hs-nim test-hs-fsx test-hs-tcl test-hs-bf test-hs-java \
  test-hs-php test-hs-bash test-hs-d test-hs-pl test-hs-exs test-hs-rb test-hs-js test-hs-ts \
  test-hs-erl test-hs-cs test-hs-prolog test-hs-cr test-hs-unl test-hs-hx test-hs-bef test-hs-awk \
  test-hs-piet test-zig-clj test-zig-lisp test-zig-rkt test-zig-rs test-zig-c test-zig-cpp test-zig-scala \
  test-zig-f90 test-zig-scm test-zig-r test-zig-lua test-zig-go test-zig-ps test-zig-vala test-zig-pike \
  test-zig-pas test-zig-kt test-zig-m test-zig-ml test-zig-hs test-zig-zig test-zig-sml test-zig-octave \
  test-zig-groovy test-zig-ws test-zig-coffee test-zig-swift test-zig-py test-zig-fs test-zig-nim test-zig-fsx \
  test-zig-tcl test-zig-bf test-zig-java test-zig-php test-zig-bash test-zig-d test-zig-pl test-zig-exs \
  test-zig-rb test-zig-js test-zig-ts test-zig-erl test-zig-cs test-zig-prolog test-zig-cr test-zig-unl \
  test-zig-hx test-zig-bef test-zig-awk test-zig-piet test-sml-clj test-sml-lisp test-sml-rkt test-sml-rs \
  test-sml-c test-sml-cpp test-sml-scala test-sml-f90 test-sml-scm test-sml-r test-sml-lua test-sml-go \
  test-sml-ps test-sml-vala test-sml-pike test-sml-pas test-sml-kt test-sml-m test-sml-ml test-sml-hs \
  test-sml-zig test-sml-sml test-sml-octave test-sml-groovy test-sml-ws test-sml-coffee test-sml-swift test-sml-py \
  test-sml-fs test-sml-nim test-sml-fsx test-sml-tcl test-sml-bf test-sml-java test-sml-php test-sml-bash \
  test-sml-d test-sml-pl test-sml-exs test-sml-rb test-sml-js test-sml-ts test-sml-erl test-sml-cs \
  test-sml-prolog test-sml-cr test-sml-unl test-sml-hx test-sml-bef test-sml-awk test-sml-piet test-octave-clj \
  test-octave-lisp test-octave-rkt test-octave-rs test-octave-c test-octave-cpp test-octave-scala test-octave-f90 test-octave-scm \
  test-octave-r test-octave-lua test-octave-go test-octave-ps test-octave-vala test-octave-pike test-octave-pas test-octave-kt \
  test-octave-m test-octave-ml test-octave-hs test-octave-zig test-octave-sml test-octave-octave test-octave-groovy test-octave-ws \
  test-octave-coffee test-octave-swift test-octave-py test-octave-fs test-octave-nim test-octave-fsx test-octave-tcl test-octave-bf \
  test-octave-java test-octave-php test-octave-bash test-octave-d test-octave-pl test-octave-exs test-octave-rb test-octave-js \
  test-octave-ts test-octave-erl test-octave-cs test-octave-prolog test-octave-cr test-octave-unl test-octave-hx test-octave-bef \
  test-octave-awk test-octave-piet test-groovy-clj test-groovy-lisp test-groovy-rkt test-groovy-rs test-groovy-c test-groovy-cpp \
  test-groovy-scala test-groovy-f90 test-groovy-scm test-groovy-r test-groovy-lua test-groovy-go test-groovy-ps test-groovy-vala \
  test-groovy-pike test-groovy-pas test-groovy-kt test-groovy-m test-groovy-ml test-groovy-hs test-groovy-zig test-groovy-sml \
  test-groovy-octave test-groovy-groovy test-groovy-ws test-groovy-coffee test-groovy-swift test-groovy-py test-groovy-fs test-groovy-nim \
  test-groovy-fsx test-groovy-tcl test-groovy-bf test-groovy-java test-groovy-php test-groovy-bash test-groovy-d test-groovy-pl \
  test-groovy-exs test-groovy-rb test-groovy-js test-groovy-ts test-groovy-erl test-groovy-cs test-groovy-prolog test-groovy-cr \
  test-groovy-unl test-groovy-hx test-groovy-bef test-groovy-awk test-groovy-piet test-ws-clj test-ws-lisp test-ws-rkt \
  test-ws-rs test-ws-c test-ws-cpp test-ws-scala test-ws-f90 test-ws-scm test-ws-r test-ws-lua \
  test-ws-go test-ws-ps test-ws-vala test-ws-pike test-ws-pas test-ws-kt test-ws-m test-ws-ml \
  test-ws-hs test-ws-zig test-ws-sml test-ws-octave test-ws-groovy test-ws-ws test-ws-coffee test-ws-swift \
  test-ws-py test-ws-fs test-ws-nim test-ws-fsx test-ws-tcl test-ws-bf test-ws-java test-ws-php \
  test-ws-bash test-ws-d test-ws-pl test-ws-exs test-ws-rb test-ws-js test-ws-ts test-ws-erl \
  test-ws-cs test-ws-prolog test-ws-cr test-ws-unl test-ws-hx test-ws-bef test-ws-awk test-ws-piet \
  test-coffee-clj test-coffee-lisp test-coffee-rkt test-coffee-rs test-coffee-c test-coffee-cpp test-coffee-scala test-coffee-f90 \
  test-coffee-scm test-coffee-r test-coffee-lua test-coffee-go test-coffee-ps test-coffee-vala test-coffee-pike test-coffee-pas \
  test-coffee-kt test-coffee-m test-coffee-ml test-coffee-hs test-coffee-zig test-coffee-sml test-coffee-octave test-coffee-groovy \
  test-coffee-ws test-coffee-coffee test-coffee-swift test-coffee-py test-coffee-fs test-coffee-nim test-coffee-fsx test-coffee-tcl \
  test-coffee-bf test-coffee-java test-coffee-php test-coffee-bash test-coffee-d test-coffee-pl test-coffee-exs test-coffee-rb \
  test-coffee-js test-coffee-ts test-coffee-erl test-coffee-cs test-coffee-prolog test-coffee-cr test-coffee-unl test-coffee-hx \
  test-coffee-bef test-coffee-awk test-coffee-piet test-swift-clj test-swift-lisp test-swift-rkt test-swift-rs test-swift-c \
  test-swift-cpp test-swift-scala test-swift-f90 test-swift-scm test-swift-r test-swift-lua test-swift-go test-swift-ps \
  test-swift-vala test-swift-pike test-swift-pas test-swift-kt test-swift-m test-swift-ml test-swift-hs test-swift-zig \
  test-swift-sml test-swift-octave test-swift-groovy test-swift-ws test-swift-coffee test-swift-swift test-swift-py test-swift-fs \
  test-swift-nim test-swift-fsx test-swift-tcl test-swift-bf test-swift-java test-swift-php test-swift-bash test-swift-d \
  test-swift-pl test-swift-exs test-swift-rb test-swift-js test-swift-ts test-swift-erl test-swift-cs test-swift-prolog \
  test-swift-cr test-swift-unl test-swift-hx test-swift-bef test-swift-awk test-swift-piet test-py-clj test-py-lisp \
  test-py-rkt test-py-rs test-py-c test-py-cpp test-py-scala test-py-f90 test-py-scm test-py-r \
  test-py-lua test-py-go test-py-ps test-py-vala test-py-pike test-py-pas test-py-kt test-py-m \
  test-py-ml test-py-hs test-py-zig test-py-sml test-py-octave test-py-groovy test-py-ws test-py-coffee \
  test-py-swift test-py-py test-py-fs test-py-nim test-py-fsx test-py-tcl test-py-bf test-py-java \
  test-py-php test-py-bash test-py-d test-py-pl test-py-exs test-py-rb test-py-js test-py-ts \
  test-py-erl test-py-cs test-py-prolog test-py-cr test-py-unl test-py-hx test-py-bef test-py-awk \
  test-py-piet test-fs-clj test-fs-lisp test-fs-rkt test-fs-rs test-fs-c test-fs-cpp test-fs-scala \
  test-fs-f90 test-fs-scm test-fs-r test-fs-lua test-fs-go test-fs-ps test-fs-vala test-fs-pike \
  test-fs-pas test-fs-kt test-fs-m test-fs-ml test-fs-hs test-fs-zig test-fs-sml test-fs-octave \
  test-fs-groovy test-fs-ws test-fs-coffee test-fs-swift test-fs-py test-fs-fs test-fs-nim test-fs-fsx \
  test-fs-tcl test-fs-bf test-fs-java test-fs-php test-fs-bash test-fs-d test-fs-pl test-fs-exs \
  test-fs-rb test-fs-js test-fs-ts test-fs-erl test-fs-cs test-fs-prolog test-fs-cr test-fs-unl \
  test-fs-hx test-fs-bef test-fs-awk test-fs-piet test-nim-clj test-nim-lisp test-nim-rkt test-nim-rs \
  test-nim-c test-nim-cpp test-nim-scala test-nim-f90 test-nim-scm test-nim-r test-nim-lua test-nim-go \
  test-nim-ps test-nim-vala test-nim-pike test-nim-pas test-nim-kt test-nim-m test-nim-ml test-nim-hs \
  test-nim-zig test-nim-sml test-nim-octave test-nim-groovy test-nim-ws test-nim-coffee test-nim-swift test-nim-py \
  test-nim-fs test-nim-nim test-nim-fsx test-nim-tcl test-nim-bf test-nim-java test-nim-php test-nim-bash \
  test-nim-d test-nim-pl test-nim-exs test-nim-rb test-nim-js test-nim-ts test-nim-erl test-nim-cs \
  test-nim-prolog test-nim-cr test-nim-unl test-nim-hx test-nim-bef test-nim-awk test-nim-piet test-fsx-clj \
  test-fsx-lisp test-fsx-rkt test-fsx-rs test-fsx-c test-fsx-cpp test-fsx-scala test-fsx-f90 test-fsx-scm \
  test-fsx-r test-fsx-lua test-fsx-go test-fsx-ps test-fsx-vala test-fsx-pike test-fsx-pas test-fsx-kt \
  test-fsx-m test-fsx-ml test-fsx-hs test-fsx-zig test-fsx-sml test-fsx-octave test-fsx-groovy test-fsx-ws \
  test-fsx-coffee test-fsx-swift test-fsx-py test-fsx-fs test-fsx-nim test-fsx-fsx test-fsx-tcl test-fsx-bf \
  test-fsx-java test-fsx-php test-fsx-bash test-fsx-d test-fsx-pl test-fsx-exs test-fsx-rb test-fsx-js \
  test-fsx-ts test-fsx-erl test-fsx-cs test-fsx-prolog test-fsx-cr test-fsx-unl test-fsx-hx test-fsx-bef \
  test-fsx-awk test-fsx-piet test-tcl-clj test-tcl-lisp test-tcl-rkt test-tcl-rs test-tcl-c test-tcl-cpp \
  test-tcl-scala test-tcl-f90 test-tcl-scm test-tcl-r test-tcl-lua test-tcl-go test-tcl-ps test-tcl-vala \
  test-tcl-pike test-tcl-pas test-tcl-kt test-tcl-m test-tcl-ml test-tcl-hs test-tcl-zig test-tcl-sml \
  test-tcl-octave test-tcl-groovy test-tcl-ws test-tcl-coffee test-tcl-swift test-tcl-py test-tcl-fs test-tcl-nim \
  test-tcl-fsx test-tcl-tcl test-tcl-bf test-tcl-java test-tcl-php test-tcl-bash test-tcl-d test-tcl-pl \
  test-tcl-exs test-tcl-rb test-tcl-js test-tcl-ts test-tcl-erl test-tcl-cs test-tcl-prolog test-tcl-cr \
  test-tcl-unl test-tcl-hx test-tcl-bef test-tcl-awk test-tcl-piet test-bf-clj test-bf-lisp test-bf-rkt \
  test-bf-rs test-bf-c test-bf-cpp test-bf-scala test-bf-f90 test-bf-scm test-bf-r test-bf-lua \
  test-bf-go test-bf-ps test-bf-vala test-bf-pike test-bf-pas test-bf-kt test-bf-m test-bf-ml \
  test-bf-hs test-bf-zig test-bf-sml test-bf-octave test-bf-groovy test-bf-ws test-bf-coffee test-bf-swift \
  test-bf-py test-bf-fs test-bf-nim test-bf-fsx test-bf-tcl test-bf-bf test-bf-java test-bf-php \
  test-bf-bash test-bf-d test-bf-pl test-bf-exs test-bf-rb test-bf-js test-bf-ts test-bf-erl \
  test-bf-cs test-bf-prolog test-bf-cr test-bf-unl test-bf-hx test-bf-bef test-bf-awk test-bf-piet \
  test-java-clj test-java-lisp test-java-rkt test-java-rs test-java-c test-java-cpp test-java-scala test-java-f90 \
  test-java-scm test-java-r test-java-lua test-java-go test-java-ps test-java-vala test-java-pike test-java-pas \
  test-java-kt test-java-m test-java-ml test-java-hs test-java-zig test-java-sml test-java-octave test-java-groovy \
  test-java-ws test-java-coffee test-java-swift test-java-py test-java-fs test-java-nim test-java-fsx test-java-tcl \
  test-java-bf test-java-java test-java-php test-java-bash test-java-d test-java-pl test-java-exs test-java-rb \
  test-java-js test-java-ts test-java-erl test-java-cs test-java-prolog test-java-cr test-java-unl test-java-hx \
  test-java-bef test-java-awk test-java-piet test-php-clj test-php-lisp test-php-rkt test-php-rs test-php-c \
  test-php-cpp test-php-scala test-php-f90 test-php-scm test-php-r test-php-lua test-php-go test-php-ps \
  test-php-vala test-php-pike test-php-pas test-php-kt test-php-m test-php-ml test-php-hs test-php-zig \
  test-php-sml test-php-octave test-php-groovy test-php-ws test-php-coffee test-php-swift test-php-py test-php-fs \
  test-php-nim test-php-fsx test-php-tcl test-php-bf test-php-java test-php-php test-php-bash test-php-d \
  test-php-pl test-php-exs test-php-rb test-php-js test-php-ts test-php-erl test-php-cs test-php-prolog \
  test-php-cr test-php-unl test-php-hx test-php-bef test-php-awk test-php-piet test-bash-clj test-bash-lisp \
  test-bash-rkt test-bash-rs test-bash-c test-bash-cpp test-bash-scala test-bash-f90 test-bash-scm test-bash-r \
  test-bash-lua test-bash-go test-bash-ps test-bash-vala test-bash-pike test-bash-pas test-bash-kt test-bash-m \
  test-bash-ml test-bash-hs test-bash-zig test-bash-sml test-bash-octave test-bash-groovy test-bash-ws test-bash-coffee \
  test-bash-swift test-bash-py test-bash-fs test-bash-nim test-bash-fsx test-bash-tcl test-bash-bf test-bash-java \
  test-bash-php test-bash-bash test-bash-d test-bash-pl test-bash-exs test-bash-rb test-bash-js test-bash-ts \
  test-bash-erl test-bash-cs test-bash-prolog test-bash-cr test-bash-unl test-bash-hx test-bash-bef test-bash-awk \
  test-bash-piet test-d-clj test-d-lisp test-d-rkt test-d-rs test-d-c test-d-cpp test-d-scala \
  test-d-f90 test-d-scm test-d-r test-d-lua test-d-go test-d-ps test-d-vala test-d-pike \
  test-d-pas test-d-kt test-d-m test-d-ml test-d-hs test-d-zig test-d-sml test-d-octave \
  test-d-groovy test-d-ws test-d-coffee test-d-swift test-d-py test-d-fs test-d-nim test-d-fsx \
  test-d-tcl test-d-bf test-d-java test-d-php test-d-bash test-d-d test-d-pl test-d-exs \
  test-d-rb test-d-js test-d-ts test-d-erl test-d-cs test-d-prolog test-d-cr test-d-unl \
  test-d-hx test-d-bef test-d-awk test-d-piet test-pl-clj test-pl-lisp test-pl-rkt test-pl-rs \
  test-pl-c test-pl-cpp test-pl-scala test-pl-f90 test-pl-scm test-pl-r test-pl-lua test-pl-go \
  test-pl-ps test-pl-vala test-pl-pike test-pl-pas test-pl-kt test-pl-m test-pl-ml test-pl-hs \
  test-pl-zig test-pl-sml test-pl-octave test-pl-groovy test-pl-ws test-pl-coffee test-pl-swift test-pl-py \
  test-pl-fs test-pl-nim test-pl-fsx test-pl-tcl test-pl-bf test-pl-java test-pl-php test-pl-bash \
  test-pl-d test-pl-pl test-pl-exs test-pl-rb test-pl-js test-pl-ts test-pl-erl test-pl-cs \
  test-pl-prolog test-pl-cr test-pl-unl test-pl-hx test-pl-bef test-pl-awk test-pl-piet test-exs-clj \
  test-exs-lisp test-exs-rkt test-exs-rs test-exs-c test-exs-cpp test-exs-scala test-exs-f90 test-exs-scm \
  test-exs-r test-exs-lua test-exs-go test-exs-ps test-exs-vala test-exs-pike test-exs-pas test-exs-kt \
  test-exs-m test-exs-ml test-exs-hs test-exs-zig test-exs-sml test-exs-octave test-exs-groovy test-exs-ws \
  test-exs-coffee test-exs-swift test-exs-py test-exs-fs test-exs-nim test-exs-fsx test-exs-tcl test-exs-bf \
  test-exs-java test-exs-php test-exs-bash test-exs-d test-exs-pl test-exs-exs test-exs-rb test-exs-js \
  test-exs-ts test-exs-erl test-exs-cs test-exs-prolog test-exs-cr test-exs-unl test-exs-hx test-exs-bef \
  test-exs-awk test-exs-piet test-rb-clj test-rb-lisp test-rb-rkt test-rb-rs test-rb-c test-rb-cpp \
  test-rb-scala test-rb-f90 test-rb-scm test-rb-r test-rb-lua test-rb-go test-rb-ps test-rb-vala \
  test-rb-pike test-rb-pas test-rb-kt test-rb-m test-rb-ml test-rb-hs test-rb-zig test-rb-sml \
  test-rb-octave test-rb-groovy test-rb-ws test-rb-coffee test-rb-swift test-rb-py test-rb-fs test-rb-nim \
  test-rb-fsx test-rb-tcl test-rb-bf test-rb-java test-rb-php test-rb-bash test-rb-d test-rb-pl \
  test-rb-exs test-rb-rb test-rb-js test-rb-ts test-rb-erl test-rb-cs test-rb-prolog test-rb-cr \
  test-rb-unl test-rb-hx test-rb-bef test-rb-awk test-rb-piet test-js-clj test-js-lisp test-js-rkt \
  test-js-rs test-js-c test-js-cpp test-js-scala test-js-f90 test-js-scm test-js-r test-js-lua \
  test-js-go test-js-ps test-js-vala test-js-pike test-js-pas test-js-kt test-js-m test-js-ml \
  test-js-hs test-js-zig test-js-sml test-js-octave test-js-groovy test-js-ws test-js-coffee test-js-swift \
  test-js-py test-js-fs test-js-nim test-js-fsx test-js-tcl test-js-bf test-js-java test-js-php \
  test-js-bash test-js-d test-js-pl test-js-exs test-js-rb test-js-js test-js-ts test-js-erl \
  test-js-cs test-js-prolog test-js-cr test-js-unl test-js-hx test-js-bef test-js-awk test-js-piet \
  test-ts-clj test-ts-lisp test-ts-rkt test-ts-rs test-ts-c test-ts-cpp test-ts-scala test-ts-f90 \
  test-ts-scm test-ts-r test-ts-lua test-ts-go test-ts-ps test-ts-vala test-ts-pike test-ts-pas \
  test-ts-kt test-ts-m test-ts-ml test-ts-hs test-ts-zig test-ts-sml test-ts-octave test-ts-groovy \
  test-ts-ws test-ts-coffee test-ts-swift test-ts-py test-ts-fs test-ts-nim test-ts-fsx test-ts-tcl \
  test-ts-bf test-ts-java test-ts-php test-ts-bash test-ts-d test-ts-pl test-ts-exs test-ts-rb \
  test-ts-js test-ts-ts test-ts-erl test-ts-cs test-ts-prolog test-ts-cr test-ts-unl test-ts-hx \
  test-ts-bef test-ts-awk test-ts-piet test-erl-clj test-erl-lisp test-erl-rkt test-erl-rs test-erl-c \
  test-erl-cpp test-erl-scala test-erl-f90 test-erl-scm test-erl-r test-erl-lua test-erl-go test-erl-ps \
  test-erl-vala test-erl-pike test-erl-pas test-erl-kt test-erl-m test-erl-ml test-erl-hs test-erl-zig \
  test-erl-sml test-erl-octave test-erl-groovy test-erl-ws test-erl-coffee test-erl-swift test-erl-py test-erl-fs \
  test-erl-nim test-erl-fsx test-erl-tcl test-erl-bf test-erl-java test-erl-php test-erl-bash test-erl-d \
  test-erl-pl test-erl-exs test-erl-rb test-erl-js test-erl-ts test-erl-erl test-erl-cs test-erl-prolog \
  test-erl-cr test-erl-unl test-erl-hx test-erl-bef test-erl-awk test-erl-piet test-cs-clj test-cs-lisp \
  test-cs-rkt test-cs-rs test-cs-c test-cs-cpp test-cs-scala test-cs-f90 test-cs-scm test-cs-r \
  test-cs-lua test-cs-go test-cs-ps test-cs-vala test-cs-pike test-cs-pas test-cs-kt test-cs-m \
  test-cs-ml test-cs-hs test-cs-zig test-cs-sml test-cs-octave test-cs-groovy test-cs-ws test-cs-coffee \
  test-cs-swift test-cs-py test-cs-fs test-cs-nim test-cs-fsx test-cs-tcl test-cs-bf test-cs-java \
  test-cs-php test-cs-bash test-cs-d test-cs-pl test-cs-exs test-cs-rb test-cs-js test-cs-ts \
  test-cs-erl test-cs-cs test-cs-prolog test-cs-cr test-cs-unl test-cs-hx test-cs-bef test-cs-awk \
  test-cs-piet test-prolog-clj test-prolog-lisp test-prolog-rkt test-prolog-rs test-prolog-c test-prolog-cpp test-prolog-scala \
  test-prolog-f90 test-prolog-scm test-prolog-r test-prolog-lua test-prolog-go test-prolog-ps test-prolog-vala test-prolog-pike \
  test-prolog-pas test-prolog-kt test-prolog-m test-prolog-ml test-prolog-hs test-prolog-zig test-prolog-sml test-prolog-octave \
  test-prolog-groovy test-prolog-ws test-prolog-coffee test-prolog-swift test-prolog-py test-prolog-fs test-prolog-nim test-prolog-fsx \
  test-prolog-tcl test-prolog-bf test-prolog-java test-prolog-php test-prolog-bash test-prolog-d test-prolog-pl test-prolog-exs \
  test-prolog-rb test-prolog-js test-prolog-ts test-prolog-erl test-prolog-cs test-prolog-prolog test-prolog-cr test-prolog-unl \
  test-prolog-hx test-prolog-bef test-prolog-awk test-prolog-piet test-cr-clj test-cr-lisp test-cr-rkt test-cr-rs \
  test-cr-c test-cr-cpp test-cr-scala test-cr-f90 test-cr-scm test-cr-r test-cr-lua test-cr-go \
  test-cr-ps test-cr-vala test-cr-pike test-cr-pas test-cr-kt test-cr-m test-cr-ml test-cr-hs \
  test-cr-zig test-cr-sml test-cr-octave test-cr-groovy test-cr-ws test-cr-coffee test-cr-swift test-cr-py \
  test-cr-fs test-cr-nim test-cr-fsx test-cr-tcl test-cr-bf test-cr-java test-cr-php test-cr-bash \
  test-cr-d test-cr-pl test-cr-exs test-cr-rb test-cr-js test-cr-ts test-cr-erl test-cr-cs \
  test-cr-prolog test-cr-cr test-cr-unl test-cr-hx test-cr-bef test-cr-awk test-cr-piet test-unl-clj \
  test-unl-lisp test-unl-rkt test-unl-rs test-unl-c test-unl-cpp test-unl-scala test-unl-f90 test-unl-scm \
  test-unl-r test-unl-lua test-unl-go test-unl-ps test-unl-vala test-unl-pike test-unl-pas test-unl-kt \
  test-unl-m test-unl-ml test-unl-hs test-unl-zig test-unl-sml test-unl-octave test-unl-groovy test-unl-ws \
  test-unl-coffee test-unl-swift test-unl-py test-unl-fs test-unl-nim test-unl-fsx test-unl-tcl test-unl-bf \
  test-unl-java test-unl-php test-unl-bash test-unl-d test-unl-pl test-unl-exs test-unl-rb test-unl-js \
  test-unl-ts test-unl-erl test-unl-cs test-unl-prolog test-unl-cr test-unl-unl test-unl-hx test-unl-bef \
  test-unl-awk test-unl-piet test-hx-clj test-hx-lisp test-hx-rkt test-hx-rs test-hx-c test-hx-cpp \
  test-hx-scala test-hx-f90 test-hx-scm test-hx-r test-hx-lua test-hx-go test-hx-ps test-hx-vala \
  test-hx-pike test-hx-pas test-hx-kt test-hx-m test-hx-ml test-hx-hs test-hx-zig test-hx-sml \
  test-hx-octave test-hx-groovy test-hx-ws test-hx-coffee test-hx-swift test-hx-py test-hx-fs test-hx-nim \
  test-hx-fsx test-hx-tcl test-hx-bf test-hx-java test-hx-php test-hx-bash test-hx-d test-hx-pl \
  test-hx-exs test-hx-rb test-hx-js test-hx-ts test-hx-erl test-hx-cs test-hx-prolog test-hx-cr \
  test-hx-unl test-hx-hx test-hx-bef test-hx-awk test-hx-piet test-bef-clj test-bef-lisp test-bef-rkt \
  test-bef-rs test-bef-c test-bef-cpp test-bef-scala test-bef-f90 test-bef-scm test-bef-r test-bef-lua \
  test-bef-go test-bef-ps test-bef-vala test-bef-pike test-bef-pas test-bef-kt test-bef-m test-bef-ml \
  test-bef-hs test-bef-zig test-bef-sml test-bef-octave test-bef-groovy test-bef-ws test-bef-coffee test-bef-swift \
  test-bef-py test-bef-fs test-bef-nim test-bef-fsx test-bef-tcl test-bef-bf test-bef-java test-bef-php \
  test-bef-bash test-bef-d test-bef-pl test-bef-exs test-bef-rb test-bef-js test-bef-ts test-bef-erl \
  test-bef-cs test-bef-prolog test-bef-cr test-bef-unl test-bef-hx test-bef-bef test-bef-awk test-bef-piet \
  test-awk-clj test-awk-lisp test-awk-rkt test-awk-rs test-awk-c test-awk-cpp test-awk-scala test-awk-f90 \
  test-awk-scm test-awk-r test-awk-lua test-awk-go test-awk-ps test-awk-vala test-awk-pike test-awk-pas \
  test-awk-kt test-awk-m test-awk-ml test-awk-hs test-awk-zig test-awk-sml test-awk-octave test-awk-groovy \
  test-awk-ws test-awk-coffee test-awk-swift test-awk-py test-awk-fs test-awk-nim test-awk-fsx test-awk-tcl \
  test-awk-bf test-awk-java test-awk-php test-awk-bash test-awk-d test-awk-pl test-awk-exs test-awk-rb \
  test-awk-js test-awk-ts test-awk-erl test-awk-cs test-awk-prolog test-awk-cr test-awk-unl test-awk-hx \
  test-awk-bef test-awk-awk test-awk-piet test-piet-clj test-piet-lisp test-piet-rkt test-piet-rs test-piet-c \
  test-piet-cpp test-piet-scala test-piet-f90 test-piet-scm test-piet-r test-piet-lua test-piet-go test-piet-ps \
  test-piet-vala test-piet-pike test-piet-pas test-piet-kt test-piet-m test-piet-ml test-piet-hs test-piet-zig \
  test-piet-sml test-piet-octave test-piet-groovy test-piet-ws test-piet-coffee test-piet-swift test-piet-py test-piet-fs \
  test-piet-nim test-piet-fsx test-piet-tcl test-piet-bf test-piet-java test-piet-php test-piet-bash test-piet-d \
  test-piet-pl test-piet-exs test-piet-rb test-piet-js test-piet-ts test-piet-erl test-piet-cs test-piet-prolog \
  test-piet-cr test-piet-unl test-piet-hx test-piet-bef test-piet-awk test-piet-piet

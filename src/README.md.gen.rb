# Generate the top-level README.md
#
# Usage: ruby src/README.md.gen.rb

require_relative "lib/core_builder"
require "erb"

# The Ubuntu release this was generated on
ubuntu = `bash -c 'source /etc/os-release && echo $VERSION_ID'`.chomp

# Versions of the installed packages (a package not installed here shows as "-")
apts = Lang::MEMBERS.flat_map { |m| m.apt.to_s.split }.uniq.sort
versions = {}
`dpkg -s #{apts.join(" ")} 2>/dev/null`.b.split("\n\n").each do |s|
  name, ver = s[/^Package: (.*)$/, 1], s[/^Version: (.*)$/, 1]
  versions[name] = ver if name && ver
  # A version without a dot means a metapackage; show the version of the package it depends on
  if ver && !ver.include?(".") && (dep = s[/^Depends: ([^,\s]+)/, 1])
    versions[name] = `dpkg -s #{dep} 2>/dev/null`.b[/^Version: (.*)$/, 1] || ver
  end
end

# The language table: Ruby first, then the others by name
vendored = ->(m) { m.run.include?("vendor/bin/") }
members = Lang::MEMBERS.sort_by { |m| [m.key == "rb" ? 0 : 1, m.name.downcase] }
rows = [["\\#", "language", "ubuntu package", "version"]]
rows += members.map.with_index(1) do |m, i|
  pkg = vendored[m] ? "*N/A*" : m.apt.to_s.split.join(", ")
  ver = vendored[m] ? nil : versions[m.apt.to_s.split.first]
  [i.to_s, m.name, pkg, (ver || "-").gsub("~") { "\\~" }]
end
widths = rows.transpose.map { |col| col.map(&:size).max + 1 }
rows[1, 0] = [widths.map { |w| "-" * w }]
table = rows.map { |row| row.zip(widths).map { |s, w| s.ljust(w) }.join("|").rstrip }

# The apt command, folded at about 70 columns
apt_install = "sudo apt install #{(apts + %w[make]).uniq.sort.join(" ")}"
apt_install.gsub!(/.{,70}( |\z)/) { $&[-1] == " " ? $& + "\\\n      " : $& }

# What `ls qc.*` shows after `make members`
files = Lang::MEMBERS.map(&:file).sort.join(" ").gsub(/.{,70}( |\z)/) { $&.rstrip + "\n" }.rstrip

File.write(File.join(__dir__, "..", "README.md"), ERB.new(DATA.read, trim_mode: "%").result(binding))

__END__
# Quine Clique

[qc.rb](qc.rb) is a quine written in Ruby: a program that prints itself.
Ask it for Python, and it prints a Python quine instead.
Or a JavaScript quine. Or a Rust quine. Or a C quine.
Or any of <%= Lang::MEMBERS.size - 1 %> languages in all.

Every one of those quines can do the same: all of them can generate *each other*.
A [clique](https://en.wikipedia.org/wiki/Clique_(graph_theory)) of quines.

<img alt="Quine Clique" src="images/logo.png">

[&#9654; Video explanation (9 min)](https://www.youtube.com/watch?v=3f2wV7Odq8E)

## Quine Clique 101

### Ruby Quine

Here is `qc.rb`:

![The text of qc.rb](images/thumbnail.png)

This is a Ruby program.
It is a quine.
Run it, and it prints itself.

```console
$ ruby qc.rb > out.bin
$ diff -s qc.rb out.bin
Files qc.rb and out.bin are identical
```

### Ruby → Python

Run `qc.rb` with the argument `py`, and it prints a quine written in Python.

```console
$ ruby qc.rb py > qc.py
```

Let's run it.

```console
$ python3 qc.py > out.bin
$ diff -s qc.py out.bin
Files qc.py and out.bin are identical
```

### Python → Ruby

Now, run `qc.py` with the argument `rb`. It prints `qc.rb`.

```console
$ python3 qc.py rb > out.bin
$ diff -s qc.rb out.bin
Files qc.rb and out.bin are identical
```

That is, `qc.rb` and `qc.py` are each a quine, and they print each other depending on the argument.
This is called a [multiquine](https://en.wikipedia.org/wiki/Quine_(computing)#Multiquines).

<img alt="qc.rb and qc.py printing each other" src="images/multiquine-rb-py.png">

### Ruby ↔ JavaScript

Python is not the only thing `qc.rb` can print.
With the argument `js`, it prints a quine written in JavaScript.

```console
$ ruby qc.rb js > qc.js
$ node qc.js > out.bin
$ diff -s qc.js out.bin
Files qc.js and out.bin are identical
```

Of course, `qc.js` can print `qc.rb` too.

```console
$ node qc.js rb > out.bin
$ diff -s qc.rb out.bin
Files qc.rb and out.bin are identical
```

### Python ↔ JavaScript

And Python and JavaScript can print each other as well.

```console
$ python3 qc.py js > out.bin
$ diff -s qc.js out.bin
Files qc.js and out.bin are identical

$ node qc.js py > out.bin
$ diff -s qc.py out.bin
Files qc.py and out.bin are identical
```

That is, `qc.rb`, `qc.py`, and `qc.js` are each a quine, and they print each other depending on the argument.

<img alt="qc.rb, qc.py, and qc.js printing each other" src="images/multiquine-rb-py-js.png">

## <%= Lang::MEMBERS.size - 1 %> + 1 languages

In the same way, it supports <%= Lang::MEMBERS.size - 1 %> languages in total. Including Ruby itself, that makes <%= Lang::MEMBERS.size %>.
The picture at the top is this very graph: every arrow is a pair of programs that print each other.

Notably, it supports 5 esoteric languages: brainfuck, Befunge, Whitespace, Piet, and Unlambda.
They do not support command-line arguments, so give the language name on standard input.

```console
$ ruby qc.rb bf > qc.bf

# qc.bf is a quine
$ echo | vendor/bin/bf qc.bf > out.bin
$ diff -s qc.bf out.bin
Files qc.bf and out.bin are identical

# qc.bf can print qc.rb
$ echo rb | vendor/bin/bf qc.bf > out.bin
$ diff -s qc.rb out.bin
Files qc.rb and out.bin are identical
```

## Languages

This program is tested with the following Ubuntu packages.

% table.each do |row|
<%= row %>
% end

The languages marked *N/A* are not available in Ubuntu.
This repository contains their interpreters in `vendor/`.

## Usage

1. If you are using Ubuntu <%= ubuntu %>, you can install the dependencies with:

```console
$ <%= apt_install %>
```

2. Then, build the bundled interpreters:

```console
$ make -C vendor
```

3. Then, run `make members`. This generates the whole clique: qc.py, qc.js, qc.rs, ...

```console
$ make members
$ ls qc.*
<%= files %>
```

4. To verify that every language can print every other, run `make test-all`. It takes hours.

```console
$ make test-all
```

All 51 x 51 = 2,601 combinations are checked by GitHub Actions on every push.

Alternatively, build the Docker image and run the tests in a container:

```console
$ docker build -t quine-clique .
$ docker run --rm quine-clique
```

## FAQ

### Why?

Why not?

### How?

See [docs/internal.md](docs/internal.md), or [watch the video](https://www.youtube.com/watch?v=3f2wV7Odq8E).

## Related work

- [Quine Relay](https://github.com/mame/quine-relay) (2013).
  A quine that returns to itself by way of 128 languages. A one-way chain, not a multiquine.
- [Quine Chameleon](https://github.com/coolwanglu/quine-chameleon) (2015).
  A 25-language multiquine. It is restricted to languages whose string literals support C-style escapes (`\"` and `\\`).
- [Multiquine with ELVM](https://mametter.hatenablog.com/entry/20161222/p1) (2016, Japanese).
  A multiquine prototype based on [ELVM](https://github.com/shinh/elvm), a compilation infrastructure for esolangs. ELVM is not multiquine-specific, and brainfuck could not be run in realistic time there.

## License

The MIT License (MIT)

Copyright (c) 2026 Yusuke Endoh (@mametter), @hirekoke

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

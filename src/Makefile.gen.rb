# Generate the top-level Makefile
#
# Usage: ruby src/Makefile.gen.rb

require_relative "lib/core_builder"

# Fill a Lang::Member command into a make recipe ($ is escaped so that make does not eat it)
subst = ->(cmd, m, target = "rb") do
  cmd.gsub("SRC", m.file).gsub("BIN", "build/qc.#{m.key}.exe").gsub("KEY", target)
     .gsub("$", "$$").squeeze(" ").strip
end

# Build artifact = the file that Run actually invokes
artifact = ->(m) do
  return "build/qc.class" if m.key == "java"
  tok = m.run[/(BIN|SRC)[\w.]*/] or raise "#{m.key}: cannot read the artifact path from Run"
  subst[tok, m]
end

# The files needed to run that member (an interpreter under vendor/bin/ is built by vendor/Makefile)
dep = ->(m) { [m.build ? artifact[m] : m.file, *m.run[%r{vendor/bin/\w+}]].join(" ") }

# Fold long dependency lists (make reads backslash + newline as one line)
wrap = ->(names) { names.each_slice(8).map { |a| a.join(" ") }.join(" \\\n  ") }

mk = +<<EOS
all: test

members: #{wrap[Lang::MEMBERS.map(&:file)]}

build output:
	mkdir -p $@

vendor/bin/%: vendor/%.c
	$(MAKE) -C vendor bin/$*

EOS

Lang::MEMBERS.each do |m|
  next if m.key == "rb"
  mk << "#{m.file}: qc.rb\n\truby qc.rb #{m.key} > $@\n\n"
end

Lang::MEMBERS.select(&:build).each do |m|
  mk << "#{artifact[m]}: #{m.file} | build\n\t#{subst[m.build, m]}\n\n"
end

tests = []
Lang::MEMBERS.each do |from|
  Lang::MEMBERS.each do |to|
    t = "test-#{from.key}-#{to.key}"
    tests << t
    out = "output/qc.#{from.key}.#{to.key}"
    key = from.key == to.key ? "" : to.key
    mk << "#{t}: #{dep[from]} #{to.file} | output\n" \
       << "\t#{subst[from.run, from, key]} > #{out}\n" \
       << "\tdiff -s #{to.file} #{out}\n\n"
  end
end

mk << <<EOS

test: #{wrap[Lang::MEMBERS.map { |m| "test-#{m.key}-rb" }]}

test-all: #{wrap[tests]}

clean:
	rm -f #{wrap[Lang::MEMBERS.reject { |m| m.key == "rb" }.map(&:file)]}
	rm -rf build output

.PHONY: #{wrap[%w[all members test test-all clean] + tests]}
EOS

File.write(File.join(__dir__, "..", "Makefile"), mk)

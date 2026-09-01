# Usage: ruby --yjit src/qc.rb.gen.rb [key ...]

require_relative "lib/core_builder"

keys = ARGV.empty? ? Lang::MEMBERS.map(&:key) : ARGV
core, zcore, entrypoint, zpad = CoreBuilder.new(keys).build

# Pour it into the ASCII-art stencil to produce qc.rb
open, close = Lang::Ruby.new.bootstrap(entrypoint, core.size)
qc = GEOMETRY.pour(open + zcore + close, Lang::Ruby::Trailer)
GEOMETRY.verify!(qc, zcore, entrypoint)
File.binwrite(File.join(ENV["QC_OUT"] || File.expand_path("..", __dir__), "qc.rb"), qc)

# The ';'s padded before eval (fzcore spaces break text runs, so count in the data stream, not in the text)
spad = qc.delete(" \n")[/;*(?=eval)/].size - 1
gap = qc.lines.first.chomp.size - spad

puts "qc.rb: #{qc.size} bytes (#{qc.lines.first.chomp.size} cols x #{qc.lines.size} rows, " \
     "net #{qc.size - spad} excluding #{spad} padding), " \
     "|core|=#{core.size}, |zcore|=#{zcore.size}" \
     "#{zpad.zero? ? "" : "(padding #{zpad})"} " \
     "(#{(100.0 * zcore.size / core.size).round(1)}%), " \
     "|image|=#{entrypoint + core.size}, members=#{keys.size}, #{gap} more to drop a row"

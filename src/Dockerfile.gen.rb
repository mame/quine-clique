# Generate the top-level Dockerfile
#
# Usage: ruby src/Dockerfile.gen.rb

require_relative "lib/core_builder"

apts = (Lang::MEMBERS.flat_map { |m| m.apt.to_s.split } + %w[make]).uniq.sort

lines = []
lines << "FROM ubuntu:#{`bash -c 'source /etc/os-release && echo $VERSION_ID'`.chomp}"
lines << "ENV DEBIAN_FRONTEND=noninteractive"
lines << "RUN apt-get update && apt-get upgrade -y"
lines << "RUN apt-get -qq install -y apt-utils > /dev/null"
lines << "RUN apt-get -qq install -y moreutils"
apts.each_slice(4) do |slice|
  lines << "RUN chronic apt-get -qq install -y #{slice.join(" ")} && chronic apt-get clean"
end
lines << "ADD . /usr/local/share/quine-clique"
lines << "WORKDIR /usr/local/share/quine-clique"
lines << "RUN make -C vendor"
lines << "CMD make test-all -j $(nproc)"

File.write(File.join(__dir__, "..", "Dockerfile"), lines.join("\n") + "\n")

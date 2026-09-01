FROM ubuntu:26.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get -qq install -y apt-utils > /dev/null
RUN apt-get -qq install -y moreutils
RUN chronic apt-get -qq install -y bash clisp clojure coffeescript && chronic apt-get clean
RUN chronic apt-get -qq install -y crystal dotnet-sdk-10.0 elixir erlang && chronic apt-get clean
RUN chronic apt-get -qq install -y fp-compiler g++ gawk gcc && chronic apt-get clean
RUN chronic apt-get -qq install -y gdc gforth gfortran ghc && chronic apt-get clean
RUN chronic apt-get -qq install -y ghostscript gobjc golang groovy && chronic apt-get clean
RUN chronic apt-get -qq install -y guile-3.0 haxe kotlin libgif-dev && chronic apt-get clean
RUN chronic apt-get -qq install -y libgmp-dev lua5.3 make mlton && chronic apt-get clean
RUN chronic apt-get -qq install -y mono-devel nim node-typescript nodejs && chronic apt-get clean
RUN chronic apt-get -qq install -y ocaml octave openjdk-25-jdk perl && chronic apt-get clean
RUN chronic apt-get -qq install -y php-cli pike8.0 python3 r-base && chronic apt-get clean
RUN chronic apt-get -qq install -y racket ruby rustc scala && chronic apt-get clean
RUN chronic apt-get -qq install -y swi-prolog swiftlang tcl valac && chronic apt-get clean
RUN chronic apt-get -qq install -y zig && chronic apt-get clean
ADD . /usr/local/share/quine-clique
WORKDIR /usr/local/share/quine-clique
RUN make -C vendor
CMD make test-all -j $(nproc)

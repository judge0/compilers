FROM judge0/buildpack-deps:jessie-2017-03-21

RUN apt-get update && apt-get upgrade -y

ENV GCC_VERSIONS \
       7.2.0 \
       6.4.0 \
       6.3.0 \
       5.4.0 \
       4.9.4 \
       4.8.5
RUN set -xe && \
    for GCC_VERSION in $GCC_VERSIONS; do \
      curl -fSsL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz" -o /tmp/gcc-$GCC_VERSION.tar.gz; \
    done; \
    for GCC_VERSION in $GCC_VERSIONS; do \
      mkdir /tmp/gcc-$GCC_VERSION && \
      tar -xf /tmp/gcc-$GCC_VERSION.tar.gz -C /tmp/gcc-$GCC_VERSION --strip-components=1 && \
      rm /tmp/gcc-$GCC_VERSION.tar.gz && \
      cd /tmp/gcc-$GCC_VERSION && \
      ./contrib/download_prerequisites && \
      { rm *.tar.* || true; } && \
      tmpdir="$(mktemp -d)" && \
      cd "$tmpdir" && \
      /tmp/gcc-$GCC_VERSION/configure \
        --disable-multilib \
        --enable-languages=c,c++ \
        --prefix=/usr/local/gcc-$GCC_VERSION && \
      make -j"$(nproc)" && \
      make install-strip && \
      rm -rf "$tmpdir" /tmp/gcc-$GCC_VERSION; \
    done



ENV OCTAVE_VERSIONS \
      4.2.0
RUN set -xe && \
    apt-get update && apt-get install -y gfortran libblas-dev liblapack-dev libpcre3-dev && \
    for OCTAVE_VERSION in $OCTAVE_VERSIONS; do \
      curl -fSsL "https://ftp.gnu.org/gnu/octave/octave-$OCTAVE_VERSION.tar.gz" -o /tmp/octave-$OCTAVE_VERSION.tar.gz; \
    done; \
    for OCTAVE_VERSION in $OCTAVE_VERSIONS; do \
      mkdir /tmp/octave-$OCTAVE_VERSION && \
      tar -xf /tmp/octave-$OCTAVE_VERSION.tar.gz -C /tmp/octave-$OCTAVE_VERSION --strip-components=1 && \
      rm /tmp/octave-$OCTAVE_VERSION.tar.gz && \
      cd /tmp/octave-$OCTAVE_VERSION && \
      ./configure \
        --prefix=/usr/local/octave-$OCTAVE_VERSION && \
      make -j"$(nproc)" && make install && \
      rm -rf /tmp/octave-$OCTAVE_VERSION; \
    done



ENV BASH_VERSIONS \
      4.4 \
      4.0
RUN set -xe && \
    for BASH_VERSION in $BASH_VERSIONS; do \
      curl -fSsL "http://ftpmirror.gnu.org/bash/bash-$BASH_VERSION.tar.gz" -o /tmp/bash-$BASH_VERSION.tar.gz; \
    done; \
    for BASH_VERSION in $BASH_VERSIONS; do \
      mkdir /tmp/bash-$BASH_VERSION && \
      tar -xf /tmp/bash-$BASH_VERSION.tar.gz -C /tmp/bash-$BASH_VERSION --strip-components=1 && \
      rm /tmp/bash-$BASH_VERSION.tar.gz && \
      cd /tmp/bash-$BASH_VERSION && \
      ./configure \
        --prefix=/usr/local/bash-$BASH_VERSION && \
      make -j"$(nproc)" && make install && \
      rm -rf /tmp/bash-$BASH_VERSION; \
    done



ENV RUBY_VERSIONS \
      2.4.0 \
      2.3.3 \
      2.2.6 \
      2.1.9
RUN set -xe && \
    for RUBY_VERSION in $RUBY_VERSIONS; do \
      curl -fSsL "https://cache.ruby-lang.org/pub/ruby/ruby-$RUBY_VERSION.tar.gz" -o /tmp/ruby-$RUBY_VERSION.tar.gz; \
    done; \
    for RUBY_VERSION in $RUBY_VERSIONS; do \
      mkdir /tmp/ruby-$RUBY_VERSION && \
      tar -xf /tmp/ruby-$RUBY_VERSION.tar.gz -C /tmp/ruby-$RUBY_VERSION --strip-components=1 && \
      rm /tmp/ruby-$RUBY_VERSION.tar.gz && \
      cd /tmp/ruby-$RUBY_VERSION && \
      ./configure \
        --disable-install-doc \
        --prefix=/usr/local/ruby-$RUBY_VERSION && \
      make -j"$(nproc)" && make install && \
      rm -rf /tmp/ruby-$RUBY_VERSION; \
    done



ENV PYTHON_VERSIONS \
      3.6.0 \
      3.5.3 \
      2.7.9 \
      2.6.9
RUN set -xe && \
    for PYTHON_VERSION in $PYTHON_VERSIONS; do \
      curl -fSsL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" -o /tmp/python-$PYTHON_VERSION.tar.xz; \
    done; \
    for PYTHON_VERSION in $PYTHON_VERSIONS; do \
      mkdir /tmp/python-$PYTHON_VERSION && \
      tar -xf /tmp/python-$PYTHON_VERSION.tar.xz -C /tmp/python-$PYTHON_VERSION --strip-components=1 && \
      rm /tmp/python-$PYTHON_VERSION.tar.xz && \
      cd /tmp/python-$PYTHON_VERSION && \
      ./configure \
        --prefix=/usr/local/python-$PYTHON_VERSION && \
      make -j"$(nproc)" && make install && \
      rm -rf /tmp/python-$PYTHON_VERSION; \
    done



# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
RUN set -xe && \
    JAVA_8_DEBIAN_VERSION=8u131-b11-1~bpo8+1 && \
    JAVA_7_DEBIAN_VERSION=7u151-2.6.11-1~deb8u1 && \
    CA_CERTIFICATES_JAVA_VERSION=20161107~bpo8+1 && \
    echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list && \
    apt-get update && apt-get install -y \
      openjdk-8-jdk="$JAVA_8_DEBIAN_VERSION" \
      openjdk-7-jdk="$JAVA_7_DEBIAN_VERSION" \
      ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java && \
    update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
RUN set -xe && \
    curl -fSsL "https://github.com/AdoptOpenJDK/openjdk9-openj9-releases/releases/download/jdk-9%2B181/OpenJDK9-OPENJ9_x64_Linux_jdk-9.181.tar.gz" -o /tmp/openjdk9-openj9.tar.gz && \
    mkdir /usr/local/openjdk9-openj9 && \
    tar -xf /tmp/openjdk9-openj9.tar.gz -C /usr/local/openjdk9-openj9 --strip-components=2 && \
    rm /tmp/openjdk9-openj9.tar.gz



RUN set -xe && \
    curl -fSsL "ftp://ftp.freepascal.org/fpc/dist/3.0.0/x86_64-linux/fpc-3.0.0.x86_64-linux.tar" -o /tmp/fpc-3.0.0.tar && \
    mkdir /tmp/fpc-3.0.0 && \
    tar -xf /tmp/fpc-3.0.0.tar -C /tmp/fpc-3.0.0 --strip-components=1 && \
    rm /tmp/fpc-3.0.0.tar && \
    cd /tmp/fpc-3.0.0 && \
    echo "/usr/local/fpc-3.0.0" | sh install.sh && \
    rm -rf /tmp/fpc-3.0.0



ENV HASKELL_VERSIONS \
      8.2.1 \
      8.0.2
RUN set -xe && \
    apt-get update && apt-get install -y libgmp-dev && \
    for HASKELL_VERSION in $HASKELL_VERSIONS; do \
      curl -fSsL "http://downloads.haskell.org/~ghc/$HASKELL_VERSION/ghc-$HASKELL_VERSION-x86_64-deb8-linux.tar.xz" -o /tmp/ghc-$HASKELL_VERSION.tar.xz; \
    done; \
    for HASKELL_VERSION in $HASKELL_VERSIONS; do \
      mkdir /tmp/ghc-$HASKELL_VERSION && \
      tar -xf /tmp/ghc-$HASKELL_VERSION.tar.xz -C /tmp/ghc-$HASKELL_VERSION --strip-components=1 && \
      rm /tmp/ghc-$HASKELL_VERSION.tar.xz && \
      cd /tmp/ghc-$HASKELL_VERSION && \
      ./configure \
        --prefix=/usr/local/ghc-$HASKELL_VERSION && \
      make install && \
      rm -rf /tmp/ghc-$HASKELL_VERSION; \
    done



ENV MONO_VERSIONS \
      5.4.0.167 \
      5.2.0.224
RUN set -xe && \
    apt-get update && apt-get install -y cmake && \
    for MONO_VERSION in $MONO_VERSIONS; do \
      curl -fSsL "https://download.mono-project.com/sources/mono/mono-$MONO_VERSION.tar.bz2" -o /tmp/mono-$MONO_VERSION.tar.bz2; \
    done; \
    for MONO_VERSION in $MONO_VERSIONS; do \
      mkdir /tmp/mono-$MONO_VERSION && \
      tar -xf /tmp/mono-$MONO_VERSION.tar.bz2 -C /tmp/mono-$MONO_VERSION --strip-components=1 && \
      rm /tmp/mono-$MONO_VERSION.tar.bz2 && \
      cd /tmp/mono-$MONO_VERSION && \
      ./configure \
        --prefix=/usr/local/mono-$MONO_VERSION && \
      make -j"$(nproc)" && make install && \
      rm -rf /tmp/mono-$MONO_VERSION; \
    done



ENV NODE_VERSIONS \
      8.5.0  \
      7.10.1
RUN set -xe && \
    for NODE_VERSION in $NODE_VERSIONS; do \
      curl -fSsL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz" -o /tmp/node-$NODE_VERSION.tar.gz; \
    done; \
    for NODE_VERSION in $NODE_VERSIONS; do \
      mkdir /tmp/node-$NODE_VERSION && \
      tar -xf /tmp/node-$NODE_VERSION.tar.gz -C /tmp/node-$NODE_VERSION --strip-components=1 && \
      rm /tmp/node-$NODE_VERSION.tar.gz && \
      cd /tmp/node-$NODE_VERSION && \
      ./configure \
        --prefix=/usr/local/node-$NODE_VERSION && \
      make -j"$(nproc)" && make install && \
      rm -rf /tmp/node-$NODE_VERSION; \
    done



ENV CLOJURE_VERSIONS \
      1.8.0
RUN set -xe && \
    apt-get update && apt-get install -y unzip && \
    for CLOJURE_VERSION in $CLOJURE_VERSIONS; do \
      curl -fSsL "https://repo1.maven.org/maven2/org/clojure/clojure/$CLOJURE_VERSION/clojure-$CLOJURE_VERSION.zip" -o /tmp/clojure-$CLOJURE_VERSION.zip; \
    done; \
    for CLOJURE_VERSION in $CLOJURE_VERSIONS; do \
      unzip -d /usr/local /tmp/clojure-$CLOJURE_VERSION.zip && \
      chmod -R 755 /usr/local/clojure-$CLOJURE_VERSION && \
      rm /tmp/clojure-$CLOJURE_VERSION.zip; \
    done



ENV ERLANG_VERSIONS \
      20.0
RUN set -xe && \
    apt-get update && apt-get install -y unzip && \
    for ERLANG_VERSION in $ERLANG_VERSIONS; do \
      curl -fSsL "https://github.com/erlang/otp/archive/OTP-$ERLANG_VERSION.tar.gz" -o /tmp/erlang-$ERLANG_VERSION.tar.gz; \
    done; \
    for ERLANG_VERSION in $ERLANG_VERSIONS; do \
      mkdir /tmp/erlang-$ERLANG_VERSION && \
      tar -xf /tmp/erlang-$ERLANG_VERSION.tar.gz -C /tmp/erlang-$ERLANG_VERSION --strip-components=1 && \
      rm /tmp/erlang-$ERLANG_VERSION.tar.gz && \
      cd /tmp/erlang-$ERLANG_VERSION && \
      ERL_TOP=$(pwd) ./otp_build autoconf && \
      ERL_TOP=$(pwd) ./configure \
        --prefix=/usr/local/erlang-$ERLANG_VERSION && \
      make -j"$(nproc)" && make install && \
      rm -rf /tmp/erlang-$ERLANG_VERSION; \
    done
# set default Erlang version for Elixir
RUN ln -s /usr/local/erlang-20.0/bin/erl /usr/local/bin/erl



ENV ELIXIR_VERSIONS \
      1.5.1
RUN set -xe && \
    apt-get update && apt-get install -y unzip && \
    for ELIXIR_VERSION in $ELIXIR_VERSIONS; do \
      curl -fSsL "https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR_VERSION/Precompiled.zip" -o /tmp/elixir-$ELIXIR_VERSION.zip; \
    done; \
    for ELIXIR_VERSION in $ELIXIR_VERSIONS; do \
      unzip -d /usr/local/elixir-$ELIXIR_VERSION /tmp/elixir-$ELIXIR_VERSION.zip && \
      rm /tmp/elixir-$ELIXIR_VERSION.zip; \
    done



ENV RUST_VERSIONS \
      1.20.0
RUN set -xe && \
    for RUST_VERSION in $RUST_VERSIONS; do \
      curl -fSsL "https://static.rust-lang.org/dist/rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz" -o /tmp/rust-$RUST_VERSION.tar.gz; \
    done; \
    for RUST_VERSION in $RUST_VERSIONS; do \
      mkdir /tmp/rust-$RUST_VERSION && \
      tar -xf /tmp/rust-$RUST_VERSION.tar.gz -C /tmp/rust-$RUST_VERSION --strip-components=1 && \
      rm /tmp/rust-$RUST_VERSION.tar.gz && \
      cd /tmp/rust-$RUST_VERSION && \
      ./install.sh \
        --prefix=/usr/local/rust-$RUST_VERSION \
        --components=rustc,rust-std-x86_64-unknown-linux-gnu && \
      rm -rf /tmp/rust-$RUST_VERSION; \
    done



ENV GO_VERSIONS \
      1.9
RUN set -xe && \
    for GO_VERSION in $GO_VERSIONS; do \
      curl -fSsL "https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz" -o /tmp/go-$GO_VERSION.tar.gz; \
    done; \
    for GO_VERSION in $GO_VERSIONS; do \
      mkdir /usr/local/go-$GO_VERSION && \
      tar -xf /tmp/go-$GO_VERSION.tar.gz -C /usr/local/go-$GO_VERSION --strip-components=1 && \
      rm /tmp/go-$GO_VERSION.tar.gz; \
    done



ENV INSECT_VERSIONS \
      5.0.0
RUN set -xe && \
    apt-get update && apt-get install -y nodejs-legacy npm && \
    for INSECT_VERSION in $INSECT_VERSIONS; do \
      mkdir /usr/local/insect-$INSECT_VERSION && \
      cd /usr/local/insect-$INSECT_VERSION && \
      npm install insect@$INSECT_VERSION && \
      echo "#!/bin/bash\ncat \"\$1\" | /usr/local/insect-$INSECT_VERSION/node_modules/.bin/insect" > /usr/local/insect-$INSECT_VERSION/insect && \
      chmod +x /usr/local/insect-$INSECT_VERSION/insect; \
    done



ENV CRYSTAL_VERSIONS \
      0.23.1-3
RUN set -xe && \
    for CRYSTAL_VERSION in $CRYSTAL_VERSIONS; do \
      curl -fSsL "https://github.com/crystal-lang/crystal/releases/download/${CRYSTAL_VERSION%-*}/crystal-$CRYSTAL_VERSION-linux-x86_64.tar.gz" -o /tmp/crystal-$CRYSTAL_VERSION.tar.gz; \
    done; \
    for CRYSTAL_VERSION in $CRYSTAL_VERSIONS; do \
      mkdir /usr/local/crystal-$CRYSTAL_VERSION && \
      tar -xf /tmp/crystal-$CRYSTAL_VERSION.tar.gz -C /usr/local/crystal-$CRYSTAL_VERSION --strip-components=1 && \
      rm /tmp/crystal-$CRYSTAL_VERSION.tar.gz; \
    done



ENV FBC_VERSIONS \
      1.05.0 
RUN set -xe && \
    for FBC_VERSION in $FBC_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/fbc/Binaries%20-%20Linux/FreeBASIC-$FBC_VERSION-linux-x86_64.tar.gz" -o /tmp/fbc-$FBC_VERSION.tar.gz; \
    done; \
    for FBC_VERSION in $FBC_VERSIONS; do \
      mkdir /usr/local/fbc-$FBC_VERSION && \
      tar -xf /tmp/fbc-$FBC_VERSION.tar.gz -C /usr/local/fbc-$FBC_VERSION --strip-components=1 && \
      rm /tmp/fbc-$FBC_VERSION.tar.gz; \
    done



ENV OCAML_VERSIONS \
      4.05.0
RUN set -xe && \
    for OCAML_VERSION in $OCAML_VERSIONS; do \
      curl -fSsL "https://github.com/ocaml/ocaml/archive/$OCAML_VERSION.tar.gz" -o /tmp/ocaml-$OCAML_VERSION.tar.gz; \
    done; \
    for OCAML_VERSION in $OCAML_VERSIONS; do \
      mkdir /tmp/ocaml-$OCAML_VERSION && \
      tar -xf /tmp/ocaml-$OCAML_VERSION.tar.gz -C /tmp/ocaml-$OCAML_VERSION --strip-components=1 && \
      rm /tmp/ocaml-$OCAML_VERSION.tar.gz && \
      cd /tmp/ocaml-$OCAML_VERSION && \
      ./configure \
        -prefix /usr/local/ocaml-$OCAML_VERSION \
        -no-ocamldoc -no-debugger -no-graph && \
      make -j"$(nproc)" world.opt && make install && \
      rm -rf /tmp/ocaml-$OCAML_VERSION; \
    done



RUN set -xe && \
    apt-get update && apt-get install -y locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8


 
RUN set -xe && \
    apt-get update && apt-get install -y libcap-dev && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout 18554e83793508acd1032d0cf4229a332c43085e && \
    echo "num_boxes = 2147483647" >> default.cf && \
    make install && \
    rm -rf /tmp/isolate
ENV BOX_ROOT /var/local/lib/isolate



LABEL maintainer="Herman Zvonimir Došilović, hermanz.dosilovic@gmail.com"
LABEL version="0.3.0"

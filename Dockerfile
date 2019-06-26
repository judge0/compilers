FROM judge0/buildpack-deps:stretch-2019-06-19

ENV GCC_VERSIONS \
       9.1.0
RUN set -xe && \
    for GCC_VERSION in $GCC_VERSIONS; do \
      curl -fSsL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz" -o /tmp/gcc-$GCC_VERSION.tar.gz && \
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
        --enable-languages=c,c++,fortran,objc,go \
        --prefix=/usr/local/gcc-$GCC_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf "$tmpdir" /tmp/gcc-$GCC_VERSION; \
    done

ENV OCTAVE_VERSIONS \
      5.1.0
RUN set -xe && \
    apt-get update && \
    apt-get install -y gfortran libblas-dev liblapack-dev libpcre3-dev && \
    rm -rf /var/lib/apt/lists/* && \
    for OCTAVE_VERSION in $OCTAVE_VERSIONS; do \
      curl -fSsL "https://ftp.gnu.org/gnu/octave/octave-$OCTAVE_VERSION.tar.gz" -o /tmp/octave-$OCTAVE_VERSION.tar.gz && \
      mkdir /tmp/octave-$OCTAVE_VERSION && \
      tar -xf /tmp/octave-$OCTAVE_VERSION.tar.gz -C /tmp/octave-$OCTAVE_VERSION --strip-components=1 && \
      rm /tmp/octave-$OCTAVE_VERSION.tar.gz && \
      cd /tmp/octave-$OCTAVE_VERSION && \
      ./configure \
        --prefix=/usr/local/octave-$OCTAVE_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/octave-$OCTAVE_VERSION; \
    done

ENV BASH_VERSIONS \
      5.0
RUN set -xe && \
    for BASH_VERSION in $BASH_VERSIONS; do \
      curl -fSsL "http://ftpmirror.gnu.org/bash/bash-$BASH_VERSION.tar.gz" -o /tmp/bash-$BASH_VERSION.tar.gz && \
      mkdir /tmp/bash-$BASH_VERSION && \
      tar -xf /tmp/bash-$BASH_VERSION.tar.gz -C /tmp/bash-$BASH_VERSION --strip-components=1 && \
      rm /tmp/bash-$BASH_VERSION.tar.gz && \
      cd /tmp/bash-$BASH_VERSION && \
      ./configure \
        --prefix=/usr/local/bash-$BASH_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/bash-$BASH_VERSION; \
    done

ENV RUBY_VERSIONS \
      2.6.3
RUN set -xe && \
    for RUBY_VERSION in $RUBY_VERSIONS; do \
      curl -fSsL "https://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-$RUBY_VERSION.tar.gz" -o /tmp/ruby-$RUBY_VERSION.tar.gz && \
      mkdir /tmp/ruby-$RUBY_VERSION && \
      tar -xf /tmp/ruby-$RUBY_VERSION.tar.gz -C /tmp/ruby-$RUBY_VERSION --strip-components=1 && \
      rm /tmp/ruby-$RUBY_VERSION.tar.gz && \
      cd /tmp/ruby-$RUBY_VERSION && \
      ./configure \
        --disable-install-doc \
        --prefix=/usr/local/ruby-$RUBY_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/ruby-$RUBY_VERSION; \
    done

ENV PYTHON_VERSIONS \
      3.7.3 \
      2.7.16
RUN set -xe && \
    for PYTHON_VERSION in $PYTHON_VERSIONS; do \
      curl -fSsL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" -o /tmp/python-$PYTHON_VERSION.tar.xz && \
      mkdir /tmp/python-$PYTHON_VERSION && \
      tar -xf /tmp/python-$PYTHON_VERSION.tar.xz -C /tmp/python-$PYTHON_VERSION --strip-components=1 && \
      rm /tmp/python-$PYTHON_VERSION.tar.xz && \
      cd /tmp/python-$PYTHON_VERSION && \
      ./configure \
        --prefix=/usr/local/python-$PYTHON_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/python-$PYTHON_VERSION; \
    done

RUN set -xe && \
    curl -fSsL "https://download.java.net/openjdk/jdk12/ri/openjdk-12+32_linux-x64_bin.tar.gz" -o /tmp/openjdk12.tar.gz && \
    mkdir /usr/local/openjdk12 && \
    tar -xf /tmp/openjdk12.tar.gz -C /usr/local/openjdk12 --strip-components=1 && \
    rm /tmp/openjdk12.tar.gz && \
    ln -s /usr/local/openjdk12/bin/javac /usr/local/bin/javac && \
    ln -s /usr/local/openjdk12/bin/java /usr/local/bin/java && \
    ln -s /usr/local/openjdk12/bin/jar /usr/local/bin/jar

ENV FPC_VERSIONS \
      3.0.4
RUN set -xe && \
    for FPC_VERSION in $FPC_VERSIONS; do \
      curl -fSsL "ftp://ftp.freepascal.org/fpc/dist/$FPC_VERSION/x86_64-linux/fpc-$FPC_VERSION.x86_64-linux.tar" -o /tmp/fpc-$FPC_VERSION.tar && \
      mkdir /tmp/fpc-$FPC_VERSION && \
      tar -xf /tmp/fpc-$FPC_VERSION.tar -C /tmp/fpc-$FPC_VERSION --strip-components=1 && \
      rm /tmp/fpc-$FPC_VERSION.tar && \
      cd /tmp/fpc-$FPC_VERSION && \
      echo "/usr/local/fpc-$FPC_VERSION" | sh install.sh && \
      rm -rf /tmp/fpc-$FPC_VERSION; \
    done

ENV HASKELL_VERSIONS \
      8.6.5
RUN set -xe && \
    apt-get update && \
    apt-get install -y libgmp-dev && \
    rm -rf /var/lib/apt/lists/* && \
    for HASKELL_VERSION in $HASKELL_VERSIONS; do \
      curl -fSsL "http://downloads.haskell.org/~ghc/$HASKELL_VERSION/ghc-$HASKELL_VERSION-x86_64-deb8-linux.tar.xz" -o /tmp/ghc-$HASKELL_VERSION.tar.xz && \
      mkdir /tmp/ghc-$HASKELL_VERSION && \
      tar -xf /tmp/ghc-$HASKELL_VERSION.tar.xz -C /tmp/ghc-$HASKELL_VERSION --strip-components=1 && \
      rm /tmp/ghc-$HASKELL_VERSION.tar.xz && \
      cd /tmp/ghc-$HASKELL_VERSION && \
      ./configure \
        --prefix=/usr/local/ghc-$HASKELL_VERSION && \
      make -j$(nproc) install && \
      rm -rf /tmp/ghc-$HASKELL_VERSION; \
    done

ENV MONO_VERSIONS \
      5.20.1.27
RUN set -xe && \
    apt-get update && \
    apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/* && \
    for MONO_VERSION in $MONO_VERSIONS; do \
      curl -fSsL "https://download.mono-project.com/sources/mono/mono-$MONO_VERSION.tar.bz2" -o /tmp/mono-$MONO_VERSION.tar.bz2 && \
      mkdir /tmp/mono-$MONO_VERSION && \
      tar -xf /tmp/mono-$MONO_VERSION.tar.bz2 -C /tmp/mono-$MONO_VERSION --strip-components=1 && \
      rm /tmp/mono-$MONO_VERSION.tar.bz2 && \
      cd /tmp/mono-$MONO_VERSION && \
      ./configure \
        --prefix=/usr/local/mono-$MONO_VERSION && \
      make -j$(nproc) && \
      make -j$(proc) install && \
      rm -rf /tmp/mono-$MONO_VERSION; \
    done

ENV NODE_VERSIONS \
      12.4.0
RUN set -xe && \
    for NODE_VERSION in $NODE_VERSIONS; do \
      curl -fSsL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz" -o /tmp/node-$NODE_VERSION.tar.gz && \
      mkdir /tmp/node-$NODE_VERSION && \
      tar -xf /tmp/node-$NODE_VERSION.tar.gz -C /tmp/node-$NODE_VERSION --strip-components=1 && \
      rm /tmp/node-$NODE_VERSION.tar.gz && \
      cd /tmp/node-$NODE_VERSION && \
      ./configure \
        --prefix=/usr/local/node-$NODE_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/node-$NODE_VERSION; \
    done

ENV CLOJURE_VERSIONS \
      1.10.1.447
RUN set -xe && \
    for CLOJURE_VERSION in $CLOJURE_VERSIONS; do \
      curl -fSsL "https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh" -o /tmp/clojure-$CLOJURE_VERSION.sh && \
      chmod +x /tmp/clojure-$CLOJURE_VERSION.sh && \
      /tmp/clojure-$CLOJURE_VERSION.sh --prefix /usr/local/clojure-$CLOJURE_VERSION && \
      rm /tmp/clojure-$CLOJURE_VERSION.sh; \
    done

ENV ERLANG_VERSIONS \
      21.0.4
RUN set -xe && \
    apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/* && \
    for ERLANG_VERSION in $ERLANG_VERSIONS; do \
      curl -fSsL "https://github.com/erlang/otp/archive/OTP-$ERLANG_VERSION.tar.gz" -o /tmp/erlang-$ERLANG_VERSION.tar.gz && \
      mkdir /tmp/erlang-$ERLANG_VERSION && \
      tar -xf /tmp/erlang-$ERLANG_VERSION.tar.gz -C /tmp/erlang-$ERLANG_VERSION --strip-components=1 && \
      rm /tmp/erlang-$ERLANG_VERSION.tar.gz && \
      cd /tmp/erlang-$ERLANG_VERSION && \
      ./otp_build autoconf && \
      ./configure \
        --prefix=/usr/local/erlang-$ERLANG_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/erlang-$ERLANG_VERSION; \
    done; \
    ln -s /usr/local/erlang-21.3/bin/erl /usr/local/bin/erl

ENV ELIXIR_VERSIONS \
      1.9.0
RUN set -xe && \
    apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/* && \
    for ELIXIR_VERSION in $ELIXIR_VERSIONS; do \
      curl -fSsL "https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR_VERSION/Precompiled.zip" -o /tmp/elixir-$ELIXIR_VERSION.zip && \
      unzip -d /usr/local/elixir-$ELIXIR_VERSION /tmp/elixir-$ELIXIR_VERSION.zip && \
      rm /tmp/elixir-$ELIXIR_VERSION.zip; \
    done

ENV RUST_VERSIONS \
      1.35.0
RUN set -xe && \
    for RUST_VERSION in $RUST_VERSIONS; do \
      curl -fSsL "https://static.rust-lang.org/dist/rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz" -o /tmp/rust-$RUST_VERSION.tar.gz && \
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
      1.12.6
RUN set -xe && \
    for GO_VERSION in $GO_VERSIONS; do \
      curl -fSsL "https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz" -o /tmp/go-$GO_VERSION.tar.gz && \
      mkdir /usr/local/go-$GO_VERSION && \
      tar -xf /tmp/go-$GO_VERSION.tar.gz -C /usr/local/go-$GO_VERSION --strip-components=1 && \
      rm /tmp/go-$GO_VERSION.tar.gz; \
    done

ENV CRYSTAL_VERSIONS \
      0.29.0-1
RUN set -xe && \
    for CRYSTAL_VERSION in $CRYSTAL_VERSIONS; do \
      curl -fSsL "https://github.com/crystal-lang/crystal/releases/download/${CRYSTAL_VERSION%-*}/crystal-$CRYSTAL_VERSION-linux-x86_64.tar.gz" -o /tmp/crystal-$CRYSTAL_VERSION.tar.gz && \
      mkdir /usr/local/crystal-$CRYSTAL_VERSION && \
      tar -xf /tmp/crystal-$CRYSTAL_VERSION.tar.gz -C /usr/local/crystal-$CRYSTAL_VERSION --strip-components=1 && \
      rm /tmp/crystal-$CRYSTAL_VERSION.tar.gz; \
    done

ENV FBC_VERSIONS \
      1.06.0
RUN set -xe && \
    for FBC_VERSION in $FBC_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/fbc/Binaries%20-%20Linux/FreeBASIC-$FBC_VERSION-linux-x86_64.tar.gz" -o /tmp/fbc-$FBC_VERSION.tar.gz && \
      mkdir /usr/local/fbc-$FBC_VERSION && \
      tar -xf /tmp/fbc-$FBC_VERSION.tar.gz -C /usr/local/fbc-$FBC_VERSION --strip-components=1 && \
      rm /tmp/fbc-$FBC_VERSION.tar.gz; \
    done

ENV OCAML_VERSIONS \
      4.08.0
RUN set -xe && \
    for OCAML_VERSION in $OCAML_VERSIONS; do \
      curl -fSsL "https://github.com/ocaml/ocaml/archive/$OCAML_VERSION.tar.gz" -o /tmp/ocaml-$OCAML_VERSION.tar.gz && \
      mkdir /tmp/ocaml-$OCAML_VERSION && \
      tar -xf /tmp/ocaml-$OCAML_VERSION.tar.gz -C /tmp/ocaml-$OCAML_VERSION --strip-components=1 && \
      rm /tmp/ocaml-$OCAML_VERSION.tar.gz && \
      cd /tmp/ocaml-$OCAML_VERSION && \
      ./configure \
        -prefix /usr/local/ocaml-$OCAML_VERSION \
        --disable-ocamldoc --disable-debugger --disable-graph-lib && \
      make -j$(nproc) world.opt && \
      make -j$(nproc) install && \
      rm -rf /tmp/ocaml-$OCAML_VERSION; \
    done

ENV PHP_VERSIONS \
      7.3.6
RUN set -xe && \
    apt-get update && \
    apt-get install -y bison && \
    rm -rf /var/lib/apt/lists/* && \
    for PHP_VERSION in $PHP_VERSIONS; do \
      curl -fSsL "https://codeload.github.com/php/php-src/tar.gz/php-$PHP_VERSION" -o /tmp/php-$PHP_VERSION.tar.gz && \
      mkdir /tmp/php-$PHP_VERSION && \
      tar -xf /tmp/php-$PHP_VERSION.tar.gz -C /tmp/php-$PHP_VERSION --strip-components=1 && \
      rm /tmp/php-$PHP_VERSION.tar.gz && \
      cd /tmp/php-$PHP_VERSION && \
      ./buildconf --force && \
      ./configure \
        --prefix=/usr/local/php-$PHP_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/php-$PHP_VERSION; \
    done

ENV KOTLIN_VERSIONS \
      1.3.40
RUN set -xe && \
    for KOTLIN_VERSION in $KOTLIN_VERSIONS; do \
      curl -fSsL "https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/kotlin-native-linux-${KOTLIN_VERSION%.*}.tar.gz" -o /tmp/kotlin-$KOTLIN_VERSION.tar.gz && \
      mkdir /usr/local/kotlin-$KOTLIN_VERSION && \
      tar -xf /tmp/kotlin-$KOTLIN_VERSION.tar.gz -C /usr/local/kotlin-$KOTLIN_VERSION --strip-components=1 && \
      rm -rf /tmp/kotlin-$KOTLIN_VERSION.tar.gz; \
    done

ENV D_VERSIONS \
      2.086.1
RUN set -xe && \
    for D_VERSION in $D_VERSIONS; do \
      curl -fSsL "http://downloads.dlang.org/releases/2.x/$D_VERSION/dmd.$D_VERSION.linux.tar.xz" -o /tmp/d-$D_VERSION.tar.gz && \
      mkdir /usr/local/d-$D_VERSION && \
      tar -xf /tmp/d-$D_VERSION.tar.gz -C /usr/local/d-$D_VERSION --strip-components=1 && \
      rm -rf /tmp/d-$D_VERSION.tar.gz; \
    done

ENV LUA_VERSIONS \
      5.3.5
RUN set -xe && \
    for LUA_VERSION in $LUA_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/luabinaries/$LUA_VERSION/Tools%20Executables/lua-${LUA_VERSION}_Linux44_64_bin.tar.gz" -o /tmp/lua-$LUA_VERSION.tar.gz && \
      mkdir /usr/local/lua-$LUA_VERSION && \
      tar -xf /tmp/lua-$LUA_VERSION.tar.gz -C /usr/local/lua-$LUA_VERSION && \
      rm -rf /tmp/lua-$LUA_VERSION.tar.gz; \
    done

ENV TYPESCRIPT_VERSIONS \
      3.5
RUN set -xe && \
    curl -fSsL "https://deb.nodesource.com/setup_12.x" | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    for TYPESCRIPT_VERSION in $TYPESCRIPT_VERSIONS; do \
      npm install -g typescript@$TYPESCRIPT_VERSION; \
    done

ENV NASM_VERSIONS \
      2.14.02
RUN set -xe && \
    for NASM_VERSION in $NASM_VERSIONS; do \
      curl -fSsL "https://www.nasm.us/pub/nasm/releasebuilds/$NASM_VERSION/nasm-$NASM_VERSION.tar.gz" -o /tmp/nasm-$NASM_VERSION.tar.gz && \
      mkdir /tmp/nasm-$NASM_VERSIONS && \
      tar -xf /tmp/nasm-$NASM_VERSION.tar.gz -C /tmp/nasm-$NASM_VERSION --strip-components=1 && \
      rm /tmp/nasm-$NASM_VERSION.tar.gz && \
      cd /tmp/nasm-$NASM_VERSION && \
      ./configure \
        --prefix=/usr/local/nasm-$NASM_VERSION && \
      make -j$(nproc) nasm ndisasm && \
      make -j$(nproc) strip && \
      make -j$(nproc) install && \
      rm -rf /tmp/nasm-$NASM_VERSION; \
    done

ENV GPROLOG_VERSIONS \
      1.4.5
RUN set -xe && \
    for GPROLOG_VERSION in $GPROLOG_VERSIONS; do \
      curl -fSsl "http://gprolog.org/gprolog-$GPROLOG_VERSION.tar.gz" -o /tmp/gprolog-$GPROLOG_VERSION.tar.gz && \
      mkdir /tmp/gprolog-$GPROLOG_VERSIONS && \
      tar -xf /tmp/gprolog-$GPROLOG_VERSION.tar.gz -C /tmp/gprolog-$GPROLOG_VERSION --strip-components=1 && \
      rm /tmp/gprolog-$GPROLOG_VERSION.tar.gz && \
      cd /tmp/gprolog-$GPROLOG_VERSION/src && \
      ./configure \
        --prefix=/usr/local/gprolog-$GPROLOG_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/gprolog-$GPROLOG_VERSION; \
    done

ENV R_VERSIONS \
      3.6.0
RUN set -xe && \
    for R_VERSION in $R_VERSIONS; do \
      curl -fSsl "https://cloud.r-project.org/src/base/R-3/R-$R_VERSION.tar.gz" -o /tmp/r-$R_VERSION.tar.gz && \
      mkdir /tmp/r-$R_VERSIONS && \
      tar -xf /tmp/r-$R_VERSION.tar.gz -C /tmp/r-$R_VERSION --strip-components=1 && \
      rm /tmp/r-$R_VERSION.tar.gz && \
      cd /tmp/r-$R_VERSION && \
      ./configure \
        --prefix=/usr/local/r-$R_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/r-$R_VERSION; \
    done

ENV JULIA_VERSIONS \
      1.1.1
RUN set -xe && \
    for JULIA_VERSION in $JULIA_VERSIONS; do \
      curl -fSsl "https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_VERSION%.*}/julia-$JULIA_VERSION-linux-x86_64.tar.gz" -o /tmp/julia-$JULIA_VERSION.tar.gz && \
      mkdir /usr/local/julia-$JULIA_VERSION && \
      tar -xf /tmp/julia-$JULIA_VERSION.tar.gz -C /usr/local/julia-$JULIA_VERSION && \
      rm -rf /tmp/julia-$JULIA_VERSION.tar.gz; \
    done

RUN set -xe && \
    apt-get update && \
    apt-get install -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN set -xe && \
    apt-get update && \
    apt-get install -y libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout 18554e83793508acd1032d0cf4229a332c43085e && \
    echo "num_boxes = 2147483647" >> default.cf && \
    make -j$(nproc) install && \
    rm -rf /tmp/isolate
ENV BOX_ROOT /var/local/lib/isolate

LABEL maintainer="Herman Zvonimir Došilović, hermanz.dosilovic@gmail.com"
LABEL version="1.0.0"

FROM judge0/buildpack-deps:buster-2019-11-23

ENV GCC_VERSIONS \
      7.4.0 \
      8.3.0 \
      9.2.0
RUN set -xe && \
    for GCC_VERSION in $GCC_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz" -o /tmp/gcc-$GCC_VERSION.tar.gz && \
      mkdir /tmp/gcc-$GCC_VERSION && \
      tar -xf /tmp/gcc-$GCC_VERSION.tar.gz -C /tmp/gcc-$GCC_VERSION --strip-components=1 && \
      rm /tmp/gcc-$GCC_VERSION.tar.gz && \
      cd /tmp/gcc-$GCC_VERSION && \
      ./contrib/download_prerequisites && \
      { rm *.tar.* || true; } && \
      tmpdir="$(mktemp -d)" && \
      cd "$tmpdir"; \
      if [ $GCC_VERSION == "9.2.0" ]; then \
        ENABLE_FORTRAN=",fortran"; \
      else \
        ENABLE_FORTRAN=""; \
      fi; \
      /tmp/gcc-$GCC_VERSION/configure \
        --disable-multilib \
        --enable-languages=c,c++$ENABLE_FORTRAN \
        --prefix=/usr/local/gcc-$GCC_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done

ENV RUBY_VERSIONS \
      2.6.5
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
      rm -rf /tmp/*; \
    done

ENV PYTHON_VERSIONS \
      3.8.0 \
      2.7.17
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
      rm -rf /tmp/*; \
    done

ENV OCTAVE_VERSIONS \
      5.1.0
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends gfortran libblas-dev liblapack-dev libpcre3-dev && \
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
      rm -rf /tmp/*; \
    done

RUN set -xe && \
    curl -fSsL "https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_linux-x64_bin.tar.gz" -o /tmp/openjdk13.tar.gz && \
    mkdir /usr/local/openjdk13 && \
    tar -xf /tmp/openjdk13.tar.gz -C /usr/local/openjdk13 --strip-components=1 && \
    rm /tmp/openjdk13.tar.gz && \
    ln -s /usr/local/openjdk13/bin/javac /usr/local/bin/javac && \
    ln -s /usr/local/openjdk13/bin/java /usr/local/bin/java && \
    ln -s /usr/local/openjdk13/bin/jar /usr/local/bin/jar

ENV BASH_VERSIONS \
      5.0
RUN set -xe && \
    for BASH_VERSION in $BASH_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/bash/bash-$BASH_VERSION.tar.gz" -o /tmp/bash-$BASH_VERSION.tar.gz && \
      mkdir /tmp/bash-$BASH_VERSION && \
      tar -xf /tmp/bash-$BASH_VERSION.tar.gz -C /tmp/bash-$BASH_VERSION --strip-components=1 && \
      rm /tmp/bash-$BASH_VERSION.tar.gz && \
      cd /tmp/bash-$BASH_VERSION && \
      ./configure \
        --prefix=/usr/local/bash-$BASH_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

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
      rm -rf /tmp/*; \
    done

ENV HASKELL_VERSIONS \
      8.8.1
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libgmp-dev libtinfo5 && \
    rm -rf /var/lib/apt/lists/* && \
    for HASKELL_VERSION in $HASKELL_VERSIONS; do \
      curl -fSsL "https://downloads.haskell.org/~ghc/$HASKELL_VERSION/ghc-$HASKELL_VERSION-x86_64-deb8-linux.tar.xz" -o /tmp/ghc-$HASKELL_VERSION.tar.xz && \
      mkdir /tmp/ghc-$HASKELL_VERSION && \
      tar -xf /tmp/ghc-$HASKELL_VERSION.tar.xz -C /tmp/ghc-$HASKELL_VERSION --strip-components=1 && \
      rm /tmp/ghc-$HASKELL_VERSION.tar.xz && \
      cd /tmp/ghc-$HASKELL_VERSION && \
      ./configure \
        --prefix=/usr/local/ghc-$HASKELL_VERSION && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV MONO_VERSIONS \
      6.6.0.161
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends cmake && \
    rm -rf /var/lib/apt/lists/* && \
    for MONO_VERSION in $MONO_VERSIONS; do \
      curl -fSsL "https://download.mono-project.com/sources/mono/mono-$MONO_VERSION.tar.xz" -o /tmp/mono-$MONO_VERSION.tar.xz && \
      mkdir /tmp/mono-$MONO_VERSION && \
      tar -xf /tmp/mono-$MONO_VERSION.tar.xz -C /tmp/mono-$MONO_VERSION --strip-components=1 && \
      rm /tmp/mono-$MONO_VERSION.tar.xz && \
      cd /tmp/mono-$MONO_VERSION && \
      ./configure \
        --prefix=/usr/local/mono-$MONO_VERSION && \
      make -j$(nproc) && \
      make -j$(proc) install && \
      rm -rf /tmp/*; \
    done

ENV NODE_VERSIONS \
      12.13.1
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
      rm -rf /tmp/*; \
    done

ENV CLOJURE_VERSIONS \
      1.10.1.492
RUN set -xe && \
    for CLOJURE_VERSION in $CLOJURE_VERSIONS; do \
      curl -fSsL "https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh" -o /tmp/clojure-$CLOJURE_VERSION.sh && \
      chmod +x /tmp/clojure-$CLOJURE_VERSION.sh && \
      /tmp/clojure-$CLOJURE_VERSION.sh --prefix /usr/local/clojure-$CLOJURE_VERSION && \
      rm -rf /tmp/*; \
    done

ENV ERLANG_VERSIONS \
      22.2
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
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
      rm -rf /tmp/*; \
    done; \
    ln -s /usr/local/erlang-21.3/bin/erl /usr/local/bin/erl

ENV ELIXIR_VERSIONS \
      1.9.4
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    for ELIXIR_VERSION in $ELIXIR_VERSIONS; do \
      curl -fSsL "https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR_VERSION/Precompiled.zip" -o /tmp/elixir-$ELIXIR_VERSION.zip && \
      unzip -d /usr/local/elixir-$ELIXIR_VERSION /tmp/elixir-$ELIXIR_VERSION.zip && \
      rm -rf /tmp/*; \
    done

ENV RUST_VERSIONS \
      1.39.0
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
      rm -rf /tmp/*; \
    done

ENV GO_VERSIONS \
      1.13.5
RUN set -xe && \
    for GO_VERSION in $GO_VERSIONS; do \
      curl -fSsL "https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz" -o /tmp/go-$GO_VERSION.tar.gz && \
      mkdir /usr/local/go-$GO_VERSION && \
      tar -xf /tmp/go-$GO_VERSION.tar.gz -C /usr/local/go-$GO_VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

ENV FBC_VERSIONS \
      1.07.1
RUN set -xe && \
    for FBC_VERSION in $FBC_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/fbc/Binaries%20-%20Linux/FreeBASIC-$FBC_VERSION-linux-x86_64.tar.gz" -o /tmp/fbc-$FBC_VERSION.tar.gz && \
      mkdir /usr/local/fbc-$FBC_VERSION && \
      tar -xf /tmp/fbc-$FBC_VERSION.tar.gz -C /usr/local/fbc-$FBC_VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

ENV OCAML_VERSIONS \
      4.09.0
RUN set -xe && \
    for OCAML_VERSION in $OCAML_VERSIONS; do \
      curl -fSsL "https://github.com/ocaml/ocaml/archive/$OCAML_VERSION.tar.gz" -o /tmp/ocaml-$OCAML_VERSION.tar.gz && \
      mkdir /tmp/ocaml-$OCAML_VERSION && \
      tar -xf /tmp/ocaml-$OCAML_VERSION.tar.gz -C /tmp/ocaml-$OCAML_VERSION --strip-components=1 && \
      rm /tmp/ocaml-$OCAML_VERSION.tar.gz && \
      cd /tmp/ocaml-$OCAML_VERSION && \
      ./configure \
        -prefix /usr/local/ocaml-$OCAML_VERSION \
        --disable-ocamldoc --disable-debugger && \
      make -j$(nproc) world.opt && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV PHP_VERSIONS \
      7.4.0
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends bison && \
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
      rm -rf /*; \
    done

ENV KOTLIN_VERSIONS \
      1.3.61
RUN set -xe && \
    for KOTLIN_VERSION in $KOTLIN_VERSIONS; do \
      curl -fSsL "https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/kotlin-native-linux-${KOTLIN_VERSION%.*}.tar.gz" -o /tmp/kotlin-$KOTLIN_VERSION.tar.gz && \
      mkdir /usr/local/kotlin-$KOTLIN_VERSION && \
      tar -xf /tmp/kotlin-$KOTLIN_VERSION.tar.gz -C /usr/local/kotlin-$KOTLIN_VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

ENV D_VERSIONS \
      2.089.0
RUN set -xe && \
    for D_VERSION in $D_VERSIONS; do \
      curl -fSsL "https://downloads.dlang.org/releases/2.x/$D_VERSION/dmd.$D_VERSION.linux.tar.xz" -o /tmp/d-$D_VERSION.tar.gz && \
      mkdir /usr/local/d-$D_VERSION && \
      tar -xf /tmp/d-$D_VERSION.tar.gz -C /usr/local/d-$D_VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

ENV LUA_VERSIONS \
      5.3.5
RUN set -xe && \
    for LUA_VERSION in $LUA_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/luabinaries/$LUA_VERSION/Tools%20Executables/lua-${LUA_VERSION}_Linux44_64_bin.tar.gz" -o /tmp/lua-$LUA_VERSION.tar.gz && \
      mkdir /usr/local/lua-$LUA_VERSION && \
      tar -xf /tmp/lua-$LUA_VERSION.tar.gz -C /usr/local/lua-$LUA_VERSION && \
      rm -rf /tmp/*; \
    done

ENV TYPESCRIPT_VERSIONS \
      3.7.3
RUN set -xe && \
    curl -fSsL "https://deb.nodesource.com/setup_12.x" | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
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
      rm -rf /tmp/*; \
    done

ENV GPROLOG_VERSIONS \
      1.4.5
RUN set -xe && \
    for GPROLOG_VERSION in $GPROLOG_VERSIONS; do \
      curl -fSsl "https://gprolog.org/gprolog-$GPROLOG_VERSION.tar.gz" -o /tmp/gprolog-$GPROLOG_VERSION.tar.gz && \
      mkdir /tmp/gprolog-$GPROLOG_VERSIONS && \
      tar -xf /tmp/gprolog-$GPROLOG_VERSION.tar.gz -C /tmp/gprolog-$GPROLOG_VERSION --strip-components=1 && \
      rm /tmp/gprolog-$GPROLOG_VERSION.tar.gz && \
      cd /tmp/gprolog-$GPROLOG_VERSION/src && \
      ./configure \
        --prefix=/usr/local/gprolog-$GPROLOG_VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done

ENV R_VERSIONS \
      3.6.1
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
      rm -rf /tmp/*; \
    done

ENV JULIA_VERSIONS \
      1.3.0
RUN set -xe && \
    for JULIA_VERSION in $JULIA_VERSIONS; do \
      curl -fSsl "https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_VERSION%.*}/julia-$JULIA_VERSION-linux-x86_64.tar.gz" -o /tmp/julia-$JULIA_VERSION.tar.gz && \
      mkdir /usr/local/julia-$JULIA_VERSION && \
      tar -xf /tmp/julia-$JULIA_VERSION.tar.gz -C /usr/local/julia-$JULIA_VERSION && \
      rm -rf /tmp/*; \
    done

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout 18554e83793508acd1032d0cf4229a332c43085e && \
    echo "num_boxes = 2147483647" >> default.cf && \
    make -j$(nproc) install && \
    rm -rf /tmp/*
ENV BOX_ROOT /var/local/lib/isolate

LABEL maintainer="Herman Zvonimir Došilović, hermanz.dosilovic@gmail.com"
LABEL version="1.0.0"

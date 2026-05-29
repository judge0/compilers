# Base image: buildpack-deps:bookworm (Debian 12)
# https://hub.docker.com/_/buildpack-deps?tab=tags&name=bookworm
# Debian 12 (Bookworm) is the current stable; supported until 2028-06.
# Ships glibc 2.36 + gcc-12 which are sufficient hosts for every modern
# language toolchain installed below.
FROM buildpack-deps:bookworm

# Common build-time deps used by multiple language steps below.
# Kept in one apt-install to share a single cache + layer.
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        bison \
        re2c \
        cmake \
        unzip \
        libgmp-dev \
        libtinfo5 \
        libncurses5 \
        libpcre2-dev \
        libpcre3-dev \
        libblas-dev \
        liblapack-dev \
        gfortran \
        libcap-dev \
        libseccomp-dev \
        libsystemd-dev \
        asciidoc \
        docbook-xml \
        docbook-xsl \
        xsltproc \
        pkg-config \
        locales \
        ca-certificates \
        sqlite3 && \
    rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────
# GCC 14.2.0  (C / C++ / Fortran)
# https://gcc.gnu.org/releases.html
# ─────────────────────────────────────────────
ENV GCC_VERSIONS="14.2.0"
RUN set -xe && \
    for VERSION in $GCC_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/gcc/gcc-$VERSION/gcc-$VERSION.tar.gz" -o /tmp/gcc-$VERSION.tar.gz && \
      mkdir /tmp/gcc-$VERSION && \
      tar -xf /tmp/gcc-$VERSION.tar.gz -C /tmp/gcc-$VERSION --strip-components=1 && \
      rm /tmp/gcc-$VERSION.tar.gz && \
      cd /tmp/gcc-$VERSION && \
      ./contrib/download_prerequisites && \
      { rm *.tar.* || true; } && \
      tmpdir="$(mktemp -d)" && \
      cd "$tmpdir" && \
      /tmp/gcc-$VERSION/configure \
        --disable-multilib \
        --enable-languages=c,c++,fortran \
        --prefix=/usr/local/gcc-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Ruby 3.3.7
# https://www.ruby-lang.org/en/downloads
# ─────────────────────────────────────────────
ENV RUBY_VERSIONS="3.3.7"
RUN set -xe && \
    for VERSION in $RUBY_VERSIONS; do \
      curl -fSsL "https://cache.ruby-lang.org/pub/ruby/${VERSION%.*}/ruby-$VERSION.tar.gz" -o /tmp/ruby-$VERSION.tar.gz && \
      mkdir /tmp/ruby-$VERSION && \
      tar -xf /tmp/ruby-$VERSION.tar.gz -C /tmp/ruby-$VERSION --strip-components=1 && \
      rm /tmp/ruby-$VERSION.tar.gz && \
      cd /tmp/ruby-$VERSION && \
      ./configure \
        --disable-install-doc \
        --prefix=/usr/local/ruby-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Python 3.12.9
# https://www.python.org/downloads
# (Python 2.7 dropped — install bookworm's `python2.7` apt package if needed
#  and repoint active.rb IDs for the old 2.7 entry there.)
# ─────────────────────────────────────────────
ENV PYTHON_VERSIONS="3.12.9"
RUN set -xe && \
    for VERSION in $PYTHON_VERSIONS; do \
      curl -fSsL "https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz" -o /tmp/python-$VERSION.tar.xz && \
      mkdir /tmp/python-$VERSION && \
      tar -xf /tmp/python-$VERSION.tar.xz -C /tmp/python-$VERSION --strip-components=1 && \
      rm /tmp/python-$VERSION.tar.xz && \
      cd /tmp/python-$VERSION && \
      ./configure \
        --enable-optimizations \
        --prefix=/usr/local/python-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Octave 9.2.0
# https://ftp.gnu.org/gnu/octave
# ─────────────────────────────────────────────
ENV OCTAVE_VERSIONS="9.2.0"
RUN set -xe && \
    for VERSION in $OCTAVE_VERSIONS; do \
      curl -fSsL "https://ftp.gnu.org/gnu/octave/octave-$VERSION.tar.gz" -o /tmp/octave-$VERSION.tar.gz && \
      mkdir /tmp/octave-$VERSION && \
      tar -xf /tmp/octave-$VERSION.tar.gz -C /tmp/octave-$VERSION --strip-components=1 && \
      rm /tmp/octave-$VERSION.tar.gz && \
      cd /tmp/octave-$VERSION && \
      ./configure \
        --prefix=/usr/local/octave-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# OpenJDK 21 (LTS)
# https://jdk.java.net/21
# ─────────────────────────────────────────────
ENV JDK_VERSION="21.0.5"
RUN set -xe && \
    curl -fSsL "https://download.java.net/java/GA/jdk21.0.5/9d56b1ef72184d09a4ee46a02e2c8d51/11/GPL/openjdk-21.0.5_linux-x64_bin.tar.gz" -o /tmp/openjdk21.tar.gz && \
    mkdir /usr/local/openjdk21 && \
    tar -xf /tmp/openjdk21.tar.gz -C /usr/local/openjdk21 --strip-components=1 && \
    rm /tmp/openjdk21.tar.gz && \
    ln -s /usr/local/openjdk21/bin/javac /usr/local/bin/javac && \
    ln -s /usr/local/openjdk21/bin/java  /usr/local/bin/java && \
    ln -s /usr/local/openjdk21/bin/jar   /usr/local/bin/jar

# ─────────────────────────────────────────────
# Bash 5.2.21
# https://ftpmirror.gnu.org/bash
# ─────────────────────────────────────────────
ENV BASH_VERSIONS="5.2.21"
RUN set -xe && \
    for VERSION in $BASH_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/bash/bash-$VERSION.tar.gz" -o /tmp/bash-$VERSION.tar.gz && \
      mkdir /tmp/bash-$VERSION && \
      tar -xf /tmp/bash-$VERSION.tar.gz -C /tmp/bash-$VERSION --strip-components=1 && \
      rm /tmp/bash-$VERSION.tar.gz && \
      cd /tmp/bash-$VERSION && \
      ./configure \
        --prefix=/usr/local/bash-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Free Pascal 3.2.2
# https://www.freepascal.org/download.html
# ─────────────────────────────────────────────
ENV FPC_VERSIONS="3.2.2"
RUN set -xe && \
    for VERSION in $FPC_VERSIONS; do \
      curl -fSsL "https://downloads.freepascal.org/fpc/dist/$VERSION/x86_64-linux/fpc-$VERSION.x86_64-linux.tar" -o /tmp/fpc-$VERSION.tar && \
      mkdir /tmp/fpc-$VERSION && \
      tar -xf /tmp/fpc-$VERSION.tar -C /tmp/fpc-$VERSION --strip-components=1 && \
      rm /tmp/fpc-$VERSION.tar && \
      cd /tmp/fpc-$VERSION && \
      echo "/usr/local/fpc-$VERSION" | sh install.sh && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# GHC (Haskell) 9.6.6
# https://www.haskell.org/ghc/download.html
# Drop `-j` from `make install` — parallel install fails to create
# bin/haddock symlink on some hosts.
# ─────────────────────────────────────────────
ENV HASKELL_VERSIONS="9.6.6"
RUN set -xe && \
    for VERSION in $HASKELL_VERSIONS; do \
      curl -fSsL "https://downloads.haskell.org/~ghc/$VERSION/ghc-$VERSION-x86_64-deb12-linux.tar.xz" -o /tmp/ghc-$VERSION.tar.xz && \
      mkdir /tmp/ghc-$VERSION && \
      tar -xf /tmp/ghc-$VERSION.tar.xz -C /tmp/ghc-$VERSION --strip-components=1 && \
      rm /tmp/ghc-$VERSION.tar.xz && \
      cd /tmp/ghc-$VERSION && \
      ./configure \
        --prefix=/usr/local/ghc-$VERSION && \
      make install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Mono (legacy C#) — bookworm-packaged mono-complete
# Upstream Mono ended at 6.12.0.206 (July 2024). For new C# code, see the
# .NET 8 SDK step further down; this entry is kept only so existing
# `Mono` language IDs in active.rb don't 404.
# ─────────────────────────────────────────────
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends mono-complete && \
    rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────
# Node.js 22.15.0
# https://nodejs.org/en
# Built from source (matches existing /usr/local/node-<VERSION>/ layout).
# ─────────────────────────────────────────────
ENV NODE_VERSIONS="22.15.0"
RUN set -xe && \
    for VERSION in $NODE_VERSIONS; do \
      curl -fSsL "https://nodejs.org/dist/v$VERSION/node-v$VERSION-linux-x64.tar.xz" -o /tmp/node-$VERSION.tar.xz && \
      mkdir /usr/local/node-$VERSION && \
      tar -xf /tmp/node-$VERSION.tar.xz -C /usr/local/node-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Erlang/OTP 27.3
# https://github.com/erlang/otp/releases
# ─────────────────────────────────────────────
ENV ERLANG_VERSIONS="27.3"
RUN set -xe && \
    for VERSION in $ERLANG_VERSIONS; do \
      curl -fSsL "https://github.com/erlang/otp/archive/OTP-$VERSION.tar.gz" -o /tmp/erlang-$VERSION.tar.gz && \
      mkdir /tmp/erlang-$VERSION && \
      tar -xf /tmp/erlang-$VERSION.tar.gz -C /tmp/erlang-$VERSION --strip-components=1 && \
      rm /tmp/erlang-$VERSION.tar.gz && \
      cd /tmp/erlang-$VERSION && \
      ./otp_build autoconf && \
      ./configure \
        --prefix=/usr/local/erlang-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done && \
    ln -s /usr/local/erlang-27.3/bin/erl /usr/local/bin/erl

# ─────────────────────────────────────────────
# Elixir 1.18.3
# https://github.com/elixir-lang/elixir/releases
# Pre-compiled zip is the upstream-recommended distribution form.
# ─────────────────────────────────────────────
ENV ELIXIR_VERSIONS="1.18.3"
RUN set -xe && \
    for VERSION in $ELIXIR_VERSIONS; do \
      curl -fSsL "https://github.com/elixir-lang/elixir/releases/download/v$VERSION/elixir-otp-27.zip" -o /tmp/elixir-$VERSION.zip && \
      unzip -d /usr/local/elixir-$VERSION /tmp/elixir-$VERSION.zip && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Rust 1.87.0
# https://www.rust-lang.org
# ─────────────────────────────────────────────
ENV RUST_VERSIONS="1.87.0"
RUN set -xe && \
    for VERSION in $RUST_VERSIONS; do \
      curl -fSsL "https://static.rust-lang.org/dist/rust-$VERSION-x86_64-unknown-linux-gnu.tar.gz" -o /tmp/rust-$VERSION.tar.gz && \
      mkdir /tmp/rust-$VERSION && \
      tar -xf /tmp/rust-$VERSION.tar.gz -C /tmp/rust-$VERSION --strip-components=1 && \
      rm /tmp/rust-$VERSION.tar.gz && \
      cd /tmp/rust-$VERSION && \
      ./install.sh \
        --prefix=/usr/local/rust-$VERSION \
        --components=rustc,rust-std-x86_64-unknown-linux-gnu && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Go 1.24.3
# https://go.dev/dl
# (storage.googleapis.com path returns 403 since 2024 — use go.dev/dl)
# ─────────────────────────────────────────────
ENV GO_VERSIONS="1.24.3"
RUN set -xe && \
    for VERSION in $GO_VERSIONS; do \
      curl -fSsL "https://go.dev/dl/go$VERSION.linux-amd64.tar.gz" -o /tmp/go-$VERSION.tar.gz && \
      mkdir /usr/local/go-$VERSION && \
      tar -xf /tmp/go-$VERSION.tar.gz -C /usr/local/go-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# FreeBASIC 1.10.1
# https://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux
# (Path layout changed post-1.07 — `FreeBASIC-X.Y.Z/Binaries-Linux/...`)
# ─────────────────────────────────────────────
ENV FBC_VERSIONS="1.10.1"
RUN set -xe && \
    for VERSION in $FBC_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/fbc/FreeBASIC-$VERSION/Binaries-Linux/FreeBASIC-$VERSION-linux-x86_64.tar.gz" -o /tmp/fbc-$VERSION.tar.gz && \
      mkdir /usr/local/fbc-$VERSION && \
      tar -xf /tmp/fbc-$VERSION.tar.gz -C /usr/local/fbc-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# OCaml 5.2.0
# https://github.com/ocaml/ocaml/releases
# ─────────────────────────────────────────────
ENV OCAML_VERSIONS="5.2.0"
RUN set -xe && \
    for VERSION in $OCAML_VERSIONS; do \
      curl -fSsL "https://github.com/ocaml/ocaml/archive/$VERSION.tar.gz" -o /tmp/ocaml-$VERSION.tar.gz && \
      mkdir /tmp/ocaml-$VERSION && \
      tar -xf /tmp/ocaml-$VERSION.tar.gz -C /tmp/ocaml-$VERSION --strip-components=1 && \
      rm /tmp/ocaml-$VERSION.tar.gz && \
      cd /tmp/ocaml-$VERSION && \
      ./configure \
        --prefix=/usr/local/ocaml-$VERSION \
        --disable-ocamldoc --disable-debugger && \
      make -j$(nproc) world.opt && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# PHP 8.3.19
# https://www.php.net/downloads
# ─────────────────────────────────────────────
ENV PHP_VERSIONS="8.3.19"
RUN set -xe && \
    for VERSION in $PHP_VERSIONS; do \
      curl -fSsL "https://codeload.github.com/php/php-src/tar.gz/php-$VERSION" -o /tmp/php-$VERSION.tar.gz && \
      mkdir /tmp/php-$VERSION && \
      tar -xf /tmp/php-$VERSION.tar.gz -C /tmp/php-$VERSION --strip-components=1 && \
      rm /tmp/php-$VERSION.tar.gz && \
      cd /tmp/php-$VERSION && \
      ./buildconf --force && \
      ./configure \
        --prefix=/usr/local/php-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# DMD (D) 2.109.1
# https://dlang.org/download.html#dmd
# ─────────────────────────────────────────────
ENV D_VERSIONS="2.109.1"
RUN set -xe && \
    for VERSION in $D_VERSIONS; do \
      curl -fSsL "https://downloads.dlang.org/releases/2.x/$VERSION/dmd.$VERSION.linux.tar.xz" -o /tmp/d-$VERSION.tar.xz && \
      mkdir /usr/local/d-$VERSION && \
      tar -xf /tmp/d-$VERSION.tar.xz -C /usr/local/d-$VERSION --strip-components=1 && \
      rm -rf /usr/local/d-$VERSION/linux/*32 && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Lua 5.4.7
# https://www.lua.org/download.html
# ─────────────────────────────────────────────
ENV LUA_VERSIONS="5.4.7"
RUN set -xe && \
    for VERSION in $LUA_VERSIONS; do \
      curl -fSsL "https://www.lua.org/ftp/lua-$VERSION.tar.gz" -o /tmp/lua-$VERSION.tar.gz && \
      mkdir /tmp/lua-$VERSION && \
      tar -xf /tmp/lua-$VERSION.tar.gz -C /tmp/lua-$VERSION --strip-components=1 && \
      rm /tmp/lua-$VERSION.tar.gz && \
      cd /tmp/lua-$VERSION && \
      make -j$(nproc) linux && \
      make INSTALL_TOP=/usr/local/lua-$VERSION install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# TypeScript 5.4.5 (via npm against the Node.js installed above)
# https://github.com/microsoft/TypeScript/releases
# ─────────────────────────────────────────────
ENV TYPESCRIPT_VERSIONS="5.4.5"
RUN set -xe && \
    ln -sf /usr/local/node-22.15.0/bin/node /usr/local/bin/node && \
    ln -sf /usr/local/node-22.15.0/bin/npm  /usr/local/bin/npm && \
    for VERSION in $TYPESCRIPT_VERSIONS; do \
      npm install -g typescript@$VERSION; \
    done

# ─────────────────────────────────────────────
# NASM 2.16.03
# https://nasm.us
# ─────────────────────────────────────────────
ENV NASM_VERSIONS="2.16.03"
RUN set -xe && \
    for VERSION in $NASM_VERSIONS; do \
      curl -fSsL "https://www.nasm.us/pub/nasm/releasebuilds/$VERSION/nasm-$VERSION.tar.gz" -o /tmp/nasm-$VERSION.tar.gz && \
      mkdir /tmp/nasm-$VERSION && \
      tar -xf /tmp/nasm-$VERSION.tar.gz -C /tmp/nasm-$VERSION --strip-components=1 && \
      rm /tmp/nasm-$VERSION.tar.gz && \
      cd /tmp/nasm-$VERSION && \
      ./configure \
        --prefix=/usr/local/nasm-$VERSION && \
      make -j$(nproc) nasm ndisasm && \
      make -j$(nproc) strip && \
      make -j$(nproc) install && \
      echo "/usr/local/nasm-$VERSION/bin/nasm -o main.o \$@ && ld main.o" >> /usr/local/nasm-$VERSION/bin/nasmld && \
      chmod +x /usr/local/nasm-$VERSION/bin/nasmld && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# GNU Prolog 1.5.0
# http://gprolog.org/#download
# ─────────────────────────────────────────────
ENV GPROLOG_VERSIONS="1.5.0"
RUN set -xe && \
    for VERSION in $GPROLOG_VERSIONS; do \
      curl -fSsL "http://gprolog.org/gprolog-$VERSION.tar.gz" -o /tmp/gprolog-$VERSION.tar.gz && \
      mkdir /tmp/gprolog-$VERSION && \
      tar -xf /tmp/gprolog-$VERSION.tar.gz -C /tmp/gprolog-$VERSION --strip-components=1 && \
      rm /tmp/gprolog-$VERSION.tar.gz && \
      cd /tmp/gprolog-$VERSION/src && \
      ./configure \
        --prefix=/usr/local/gprolog-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# SBCL 2.4.6
# http://www.sbcl.org/platform-table.html
# ─────────────────────────────────────────────
ENV SBCL_VERSIONS="2.4.6"
RUN set -xe && \
    for VERSION in $SBCL_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/sbcl/sbcl/$VERSION/sbcl-$VERSION-x86-64-linux-binary.tar.bz2" -o /tmp/sbcl-$VERSION.tar.bz2 && \
      mkdir /tmp/sbcl-$VERSION && \
      tar -xf /tmp/sbcl-$VERSION.tar.bz2 -C /tmp/sbcl-$VERSION --strip-components=1 && \
      cd /tmp/sbcl-$VERSION && \
      INSTALL_ROOT=/usr/local/sbcl-$VERSION sh install.sh && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# GnuCOBOL 3.2
# https://ftp.gnu.org/gnu/gnucobol
# ─────────────────────────────────────────────
ENV COBOL_VERSIONS="3.2"
RUN set -xe && \
    for VERSION in $COBOL_VERSIONS; do \
      curl -fSsL "https://ftp.gnu.org/gnu/gnucobol/gnucobol-$VERSION.tar.xz" -o /tmp/gnucobol-$VERSION.tar.xz && \
      mkdir /tmp/gnucobol-$VERSION && \
      tar -xf /tmp/gnucobol-$VERSION.tar.xz -C /tmp/gnucobol-$VERSION --strip-components=1 && \
      rm /tmp/gnucobol-$VERSION.tar.xz && \
      cd /tmp/gnucobol-$VERSION && \
      ./configure \
        --prefix=/usr/local/gnucobol-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Swift 5.10.1
# https://swift.org/download
# Swift only ships tarballs targeted at Ubuntu, but the Ubuntu 22.04
# build runs cleanly on bookworm (matching glibc/libstdc++ ABI).
# ─────────────────────────────────────────────
ENV SWIFT_VERSIONS="5.10.1"
RUN set -xe && \
    for VERSION in $SWIFT_VERSIONS; do \
      curl -fSsL "https://download.swift.org/swift-$VERSION-release/ubuntu2204/swift-$VERSION-RELEASE/swift-$VERSION-RELEASE-ubuntu22.04.tar.gz" -o /tmp/swift-$VERSION.tar.gz && \
      mkdir /usr/local/swift-$VERSION && \
      tar -xf /tmp/swift-$VERSION.tar.gz -C /usr/local/swift-$VERSION --strip-components=2 && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Kotlin 2.0.21
# https://kotlinlang.org
# ─────────────────────────────────────────────
ENV KOTLIN_VERSIONS="2.0.21"
RUN set -xe && \
    for VERSION in $KOTLIN_VERSIONS; do \
      curl -fSsL "https://github.com/JetBrains/kotlin/releases/download/v$VERSION/kotlin-compiler-$VERSION.zip" -o /tmp/kotlin-$VERSION.zip && \
      unzip -d /usr/local/kotlin-$VERSION /tmp/kotlin-$VERSION.zip && \
      mv /usr/local/kotlin-$VERSION/kotlinc/* /usr/local/kotlin-$VERSION/ && \
      rm -rf /usr/local/kotlin-$VERSION/kotlinc && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Clang 14 (bookworm default) — additional compiler for C/C++/Objective-C
# https://packages.debian.org/bookworm/clang-14
# ─────────────────────────────────────────────
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends clang-14 gnustep-devel && \
    rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────
# R 4.4.2
# https://cloud.r-project.org/src/base
# ─────────────────────────────────────────────
ENV R_VERSIONS="4.4.2"
RUN set -xe && \
    for VERSION in $R_VERSIONS; do \
      curl -fSsL "https://cloud.r-project.org/src/base/R-${VERSION%%.*}/R-$VERSION.tar.gz" -o /tmp/r-$VERSION.tar.gz && \
      mkdir /tmp/r-$VERSION && \
      tar -xf /tmp/r-$VERSION.tar.gz -C /tmp/r-$VERSION --strip-components=1 && \
      rm /tmp/r-$VERSION.tar.gz && \
      cd /tmp/r-$VERSION && \
      ./configure \
        --prefix=/usr/local/r-$VERSION \
        --with-readline=no \
        --with-x=no && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Scala 3.4.2
# https://scala-lang.org
# ─────────────────────────────────────────────
ENV SCALA_VERSIONS="3.4.2"
RUN set -xe && \
    for VERSION in $SCALA_VERSIONS; do \
      curl -fSsL "https://github.com/scala/scala3/releases/download/$VERSION/scala3-$VERSION.tar.gz" -o /tmp/scala-$VERSION.tgz && \
      mkdir /usr/local/scala-$VERSION && \
      tar -xf /tmp/scala-$VERSION.tgz -C /usr/local/scala-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

# Perl ships in buildpack-deps:bookworm. No extra install needed.

# ─────────────────────────────────────────────
# Clojure 1.11.4 (built via maven against the JDK installed above)
# https://github.com/clojure/clojure/releases
# Use Maven 3.9 from archive.apache.org so we don't pull
# ca-certificates-java post-install hooks that can break on minimal hosts.
# ─────────────────────────────────────────────
ENV CLOJURE_VERSION="1.11.4"
ENV MAVEN_VERSION="3.9.6"
RUN set -xe && \
    curl -fSsL "https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" -o /tmp/maven.tar.gz && \
    mkdir /opt/maven && \
    tar -xf /tmp/maven.tar.gz -C /opt/maven --strip-components=1 && \
    rm /tmp/maven.tar.gz && \
    cd /tmp && \
    git clone https://github.com/clojure/clojure && \
    cd clojure && \
    git checkout clojure-$CLOJURE_VERSION && \
    JAVA_HOME=/usr/local/openjdk21 /opt/maven/bin/mvn -Plocal -Dmaven.test.skip=true package && \
    mkdir /usr/local/clojure-$CLOJURE_VERSION && \
    cp clojure.jar /usr/local/clojure-$CLOJURE_VERSION && \
    rm -rf /opt/maven /tmp/*

# ─────────────────────────────────────────────
# .NET SDK 8.0 (LTS)
# https://github.com/dotnet/sdk/releases
# Used for modern C# / F# / VB submissions (preferred over Mono).
# ─────────────────────────────────────────────
ENV DOTNET_VERSION="8.0.404"
RUN set -xe && \
    curl -fSsL "https://download.visualstudio.microsoft.com/download/pr/1c0e1f0b-f4f3-4f78-b6f4-2a3bb6f3ae5f/01b3c1d5b5b8aa31a8de76e676db5a2c/dotnet-sdk-$DOTNET_VERSION-linux-x64.tar.gz" -o /tmp/dotnet.tar.gz && \
    mkdir /usr/local/dotnet-sdk && \
    tar -xf /tmp/dotnet.tar.gz -C /usr/local/dotnet-sdk && \
    rm -rf /tmp/*

# ─────────────────────────────────────────────
# Groovy 4.0.24
# https://groovy.apache.org/download.html
# (dl.bintray.com sunset 2021-05 — use archive.apache.org)
# ─────────────────────────────────────────────
ENV GROOVY_VERSION="4.0.24"
RUN set -xe && \
    curl -fSsL "https://archive.apache.org/dist/groovy/$GROOVY_VERSION/distribution/apache-groovy-binary-$GROOVY_VERSION.zip" -o /tmp/groovy.zip && \
    unzip /tmp/groovy.zip -d /usr/local && \
    rm -rf /tmp/*

# ─────────────────────────────────────────────
# Locale (en_US.UTF-8) — required for several runtimes' default I/O.
# ─────────────────────────────────────────────
RUN set -xe && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# ─────────────────────────────────────────────
# isolate — sandbox used by judge0 to run submissions
#
# Upstream ioi/isolate v2.6 (2026-05-25). v2.0+ is cgroupv2-only — required to
# run on standard AKS nodepools (Ubuntu 22.04, cgroupv2). The previous pin to
# judge0/isolate@ad39cc4 was a 2021-era fork that supports cgroupv1 only.
#
# Manpage targets need network DTD lookups (a2x/xmllint), so build the
# binaries explicitly and install them by hand to keep the layer self-contained.
# SRE-3142.
# ─────────────────────────────────────────────
RUN set -xe && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout v2.6 && \
    make -j$(nproc) isolate isolate-cg-keeper isolate-check-environment && \
    install -m 4755 isolate /usr/local/bin/isolate && \
    install -m 0755 isolate-cg-keeper /usr/local/bin/isolate-cg-keeper && \
    install -m 0755 isolate-check-environment /usr/local/bin/isolate-check-environment && \
    rm -rf /tmp/*

# isolate v2 config — manual cgroup delegation (no systemd in container).
# cg_root is the subtree the entrypoint delegates to isolate at runtime.
# syscall_flags=0 disables the v2.4+ seccomp filter; needed because the default
# filter blocks fcntl(F_OFD_SETLK) which Go's build cache trim relies on.
# Re-evaluate once Go drops the lock or isolate exposes a finer-grained flag.
RUN mkdir -p /var/local/lib/isolate /run/isolate/locks && \
    printf '%s\n' \
        'box_root = /var/local/lib/isolate' \
        'lock_root = /run/isolate/locks' \
        'cg_root = /sys/fs/cgroup/isolate' \
        'first_uid = 60000' \
        'first_gid = 60000' \
        'num_boxes = 100' \
        'syscall_flags = 0' \
        > /usr/local/etc/isolate

ENV BOX_ROOT=/var/local/lib/isolate

LABEL maintainer="Talview SRE <sre@talview.com>"
LABEL version="2.1.0"
LABEL org.opencontainers.image.source="https://github.com/talview/judge0-compilers"
LABEL org.opencontainers.image.description="Talview-maintained Judge0 compilers image (Bookworm base, modern compilers)"

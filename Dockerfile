FROM buildpack-deps:jessie
LABEL maintainer="Herman Zvonimir Došilović, hermanz.dosilovic@gmail.com" \
      version="0.1.0"


ENV GCC_VERSIONS \
       6.3.0 \
       5.4.0 \
       4.9.4 \
       4.8.5
RUN set -xe && \
    for GCC_VERSION in $GCC_VERSIONS; do \
      curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2" -o /tmp/gcc-$GCC_VERSION.tar.bz2 && \
      mkdir /tmp/gcc-$GCC_VERSION && \
      tar -xf /tmp/gcc-$GCC_VERSION.tar.bz2 -C /tmp/gcc-$GCC_VERSION --strip-components=1 && \
      rm /tmp/gcc-$GCC_VERSION.tar.bz2 && \
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
      cd /tmp && \
      rm -rf "$tmpdir" /tmp/gcc-$GCC_VERSION; \
    done



ENV BASH_VERSIONS \
      4.4 \
      4.0
RUN set -xe && \
    for BASH_VERSION in $BASH_VERSIONS; do \
      curl -fSL "http://ftpmirror.gnu.org/bash/bash-$BASH_VERSION.tar.gz" -o /tmp/bash-$BASH_VERSION.tar.gz && \
      mkdir /tmp/bash-$BASH_VERSION && \
      tar -xf /tmp/bash-$BASH_VERSION.tar.gz -C /tmp/bash-$BASH_VERSION --strip-components=1 && \
      rm /tmp/bash-$BASH_VERSION.tar.gz && \
      cd /tmp/bash-$BASH_VERSION && \
      ./configure \
        --prefix=/usr/local/bash-$BASH_VERSION && \
      make -j"$(nproc)" && make install && \
      cd /tmp && \
      rm -rf /tmp/bash-$BASH_VERSION; \
    done



ENV RUBY_VERSIONS \
      2.4.0 \
      2.3.3 \
      2.2.6 \
      2.1.9
RUN set -xe && \
    for RUBY_VERSION in $RUBY_VERSIONS; do \
      curl -fSL "https://cache.ruby-lang.org/pub/ruby/ruby-$RUBY_VERSION.tar.bz2" -o /tmp/ruby-$RUBY_VERSION.tar.bz2 && \
      mkdir /tmp/ruby-$RUBY_VERSION && \
      tar -xf /tmp/ruby-$RUBY_VERSION.tar.bz2 -C /tmp/ruby-$RUBY_VERSION --strip-components=1 && \
      rm /tmp/ruby-$RUBY_VERSION.tar.bz2 && \
      cd /tmp/ruby-$RUBY_VERSION && \
      ./configure \
        --disable-install-doc \
        --prefix=/usr/local/ruby-$RUBY_VERSION && \
      make -j"$(nproc)" && make install && \
      cd /tmp && \
      rm -rf /tmp/ruby-$RUBY_VERSION; \
    done



ENV PYTHON_VERSIONS \
      3.6.0 \
      3.5.3 \
      2.7.9 \
      2.6.9
RUN set -xe && \
    for PYTHON_VERSION in $PYTHON_VERSIONS; do \
      curl -fSL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" -o /tmp/python-$PYTHON_VERSION.tar.xz && \
      mkdir /tmp/python-$PYTHON_VERSION && \
      tar -xf /tmp/python-$PYTHON_VERSION.tar.xz -C /tmp/python-$PYTHON_VERSION --strip-components=1 && \
      rm /tmp/python-$PYTHON_VERSION.tar.xz && \
      cd /tmp/python-$PYTHON_VERSION && \
      ./configure \
        --prefix=/usr/local/python-$PYTHON_VERSION && \
      make -j"$(nproc)" && make install && \
      cd /tmp && \
      rm -rf /tmp/python-$PYTHON_VERSION; \
    done



RUN set -xe && \
    echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list && \
    apt-get update && \
    apt-get install -y \
      openjdk-8-jdk \
      openjdk-7-jdk



RUN set -xe && \
    curl -fSL "ftp://ftp.freepascal.org/fpc/dist/3.0.0/x86_64-linux/fpc-3.0.0.x86_64-linux.tar" -o /tmp/fpc-3.0.0.tar && \
    mkdir /tmp/fpc-3.0.0 && \
    tar -xf /tmp/fpc-3.0.0.tar -C /tmp/fpc-3.0.0 --strip-components=1 && \
    rm /tmp/fpc-3.0.0.tar && \
    cd /tmp/fpc-3.0.0 && \
    echo "/usr/local/fpc-3.0.0" | sh install.sh && \
    cd /tmp && \
    rm -rf /tmp/fpc-3.0.0



ENV HASKELL_VERSIONS \
      8.0.2
RUN set -xe && \
    apt-get update && apt-get install -y libgmp-dev && \
    for HASKELL_VERSION in $HASKELL_VERSIONS; do \
      curl -fSL "http://downloads.haskell.org/~ghc/$HASKELL_VERSION/ghc-$HASKELL_VERSION-x86_64-deb8-linux.tar.xz" -o /tmp/ghc-$HASKELL_VERSION.tar.xz && \
      mkdir /tmp/ghc-$HASKELL_VERSION && \
      tar -xf /tmp/ghc-$HASKELL_VERSION.tar.xz -C /tmp/ghc-$HASKELL_VERSION --strip-components=1 && \
      rm /tmp/ghc-$HASKELL_VERSION.tar.xz && \
      cd /tmp/ghc-$HASKELL_VERSION && \
      ./configure \
        --prefix=/usr/local/ghc-$HASKELL_VERSION && \
      make install && \
      cd /tmp && \
      rm -rf /tmp/ghc-$HASKELL_VERSION; \
    done



ENV MONO_VERSIONS \
      4.8.0.472
RUN set -xe && \
    apt-get update && apt-get install -y cmake && \
    for MONO_VERSION in $MONO_VERSIONS; do \
      curl -fSL "https://download.mono-project.com/sources/mono/mono-$MONO_VERSION.tar.bz2" -o /tmp/mono-$MONO_VERSION.tar.bz2 && \
      mkdir /tmp/mono-$MONO_VERSION && \
      tar -xf /tmp/mono-$MONO_VERSION.tar.bz2 -C /tmp/mono-$MONO_VERSION --strip-components=1 && \
      rm /tmp/mono-$MONO_VERSION.tar.bz2 && \
      cd /tmp/mono-$MONO_VERSION && \
      ./configure \
        --prefix=/usr/local/mono-$MONO_VERSION && \
      make && make install && \
      cd /tmp && \
      rm -rf /tmp/mono-$MONO_VERSION; \
    done



ENV OCTAVE_VERSIONS \
      4.2.0
RUN set -xe && \
    apt-get update && apt-get install -y gfortran libblas-dev liblapack-dev libpcre3-dev && \
    for OCTAVE_VERSION in $OCTAVE_VERSIONS; do \
      curl -fSL "https://ftp.gnu.org/gnu/octave/octave-$OCTAVE_VERSION.tar.gz" -o /tmp/octave-$OCTAVE_VERSION.tar.gz && \
      mkdir /tmp/octave-$OCTAVE_VERSION && \
      tar -xf /tmp/octave-$OCTAVE_VERSION.tar.gz -C /tmp/octave-$OCTAVE_VERSION --strip-components=1 && \
      rm /tmp/octave-$OCTAVE_VERSION.tar.gz && \
      cd /tmp/octave-$OCTAVE_VERSION && \
      ./configure \
      --prefix=/usr/local/octave-$OCTAVE_VERSION && \
      make && make install && \
      cd /tmp && \
      rm -rf /tmp/octave-$OCTAVE_VERSION; \
    done



ENV NODE_VERSIONS \
      6.10.1 \
      4.8.1
RUN set -xe && \
    for NODE_VERSION in $NODE_VERSIONS; do \
      curl -fSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz" -o /tmp/node-$NODE_VERSION.tar.gz && \
      mkdir /tmp/node-$NODE_VERSION && \
      tar -xf /tmp/node-$NODE_VERSION.tar.gz -C /tmp/node-$NODE_VERSION --strip-components=1 && \
      rm /tmp/node-$NODE_VERSION.tar.gz && \
      cd /tmp/node-$NODE_VERSION && \
      ./configure \
        --prefix=/usr/local/node-$NODE_VERSION && \
      make -j"$(nproc)" && make install && \
      cd /tmp && \
      rm -rf /tmp/node-$NODE_VERSION; \
    done



RUN set -xe && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    echo "num_boxes = 2147483647" >> default.cf && \
    make install && \
    cd /tmp && \
    rm -rf /tmp/isolate
ENV BOX_ROOT /var/local/lib/isolate

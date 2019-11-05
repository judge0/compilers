FROM judge0/buildpack-deps:stretch-2019-06-19

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

ENV GCC_VERSIONS \
      9.2.0
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

LABEL maintainer="Herman Zvonimir Došilović, hermanz.dosilovic@gmail.com"
LABEL version="gcc-latest"
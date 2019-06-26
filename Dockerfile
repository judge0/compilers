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

ENV NIM_VERSIONS \
      0.20.0
RUN set -xe && \
    for NIM_VERSION in $NIM_VERSIONS; do \
      curl -fSsL "https://nim-lang.org/download/nim-$NIM_VERSION-linux_x64.tar.xz" -o /tmp/nim-$NIM_VERSION.tar.xf && \
      tar -xf /tmp/nim-$NIM_VERSION.tar.xf -C /usr/local && \
      chmod +x /usr/local/nim-$NIM_VERSION/bin/nim && \
      rm /tmp/nim-$NIM_VERSION.tar.xf; \
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
LABEL version="nim0.20.0"

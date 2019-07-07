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

ENV V_VERSIONS \
      v0.1.3 \
      v0.1.4 \
      v0.1.5 \
      v0.1.6 \
      v0.1.7 \
      v0.1.8
RUN set -xe && \
    for V_VERSION in $V_VERSIONS; do \
      git clone --branch $V_VERSION https://github.com/vlang/v /usr/local/v-$V_VERSION && \
      cd /usr/local/v-$V_VERSION; \
      if [ "$V_VERSION" = "v0.1.8" ]; then \
        git checkout 4aab26d3; \
      fi; \
      curl -fSsL "https://github.com/vlang/v/releases/download/$V_VERSION/v_linux.zip" -o v_linux.zip && \
      unzip v_linux.zip -d compiler && \
      rm v_linux.zip && \
      mkdir .vlang && \
      chmod -R 777 .vlang && \
      echo $PWD > .vlang/VROOT; \
      if [ "$V_VERSION" = "v0.1.6" ]; then \
        FAKE_HOME=/usr/local/v-v0.1.7; \
      else \
        FAKE_HOME=$PWD; \
      fi; \
      echo "#!/bin/bash\nHOME=$FAKE_HOME $PWD/compiler/v \$@" >> v && \
      chmod +x v; \
    done

ENV V_VERSIONS \
      v0.1.9 \
      v0.1.10 \
      v0.1.11 \
      v0.1.12
RUN set -xe && \
    for V_VERSION in $V_VERSIONS; do \
      mkdir -p /usr/local/v-$V_VERSION && \
      cd /usr/local/v-$V_VERSION && \
      curl -fSsL "https://github.com/vlang/v/releases/download/$V_VERSION/v.zip" -o v.zip && \
      unzip v.zip && \
      rm v.zip && \
      mkdir .vlang && \
      chmod -R 777 .vlang && \
      echo $PWD > .vlang/VROOT && \
      echo "#!/bin/bash\nHOME=$PWD $PWD/v_linux \$@" >> v && \
      chmod +x v; \
    done

LABEL maintainer="Herman Zvonimir Došilović, hermanz.dosilovic@gmail.com"
LABEL version="vlang0.1.12"

FROM judge0/buildpack-deps:jessie-2017-03-21

RUN apt-get update && apt-get upgrade -y

ENV RUBY_VERSIONS \
      2.3.3
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
      3.6.8
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
LABEL version="0.3.0-python3.6.8"

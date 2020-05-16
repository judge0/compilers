# Latest version: https://hub.docker.com/_/buildpack-deps?tab=tags&page=1&name=buster&ordering=last_updated
# This is a snapshot of buildpack-deps:buster that was last updated on 2019-12-28.
FROM judge0/buildpack-deps:buster-2019-12-28

# Install common software and isolate.
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      cmake \
      cmake-extras \
      cron \
      curl \
      g++ \
      gcc \
      git \
      git-lfs \
      libcap-dev \
      locales \
      make \
      nodejs \
      npm \
      tar \
      unzip \
      wget && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    git clone https://github.com/judge0/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout 9be3ff6ff0670763e564912a6662730e55b69536 && \
    make -j$(nproc) install && \
    apt-get autoremove --purge && \
    rm -rf /tmp/* /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
ENV BOX_ROOT /var/local/lib/isolate

# Latest version: https://www.ruby-lang.org/en/downloads
ENV RUBY_VERSIONS 2.7.0
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
    done; \
    apt-get autoremove --purge && \
    rm -rf /tmp/* /var/lib/apt/lists/*

# Latest version: https://github.com/c3lang/c3c
ENV C3_VERSIONS latest
COPY compilers/extra/c3/update.cron /cron/c3
COPY compilers/extra/c3/update.sh /update/c3
RUN set -xe && \
    echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main" > /etc/apt/sources.list.d/llvm.list && \
    echo "deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main" >> /etc/apt/sources.list.d/llvm.list && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-recommends clang-10 llvm-10-dev && \
    /update/c3 && \
    apt-get autoremove --purge && \
    rm -rf /tmp/* /var/lib/apt/lists/*

RUN set -xe && \ 
    mkdir -p /cron /cron-log && \ 
    cat /cron/* | crontab -

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

COPY extra/Dockerfile /

LABEL version="2.0.0-extra"
LABEL maintainer="Herman Zvonimir Došilović <hermanz.dosilovic@gmail.com>"

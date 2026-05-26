# Base image: buildpack-deps:buster (Debian 10)
# https://hub.docker.com/_/buildpack-deps?tab=tags&page=1&name=buster
FROM judge0/buildpack-deps:buster-2019-12-28

# Debian Buster is EOL — redirect apt to archive.debian.org
RUN printf "deb http://archive.debian.org/debian buster main\ndeb http://archive.debian.org/debian-security buster/updates main\n" > /etc/apt/sources.list

# ─────────────────────────────────────────────
# GCC 14.2.0  (covers both C and C++)
# https://gcc.gnu.org/releases.html
# GCC 14 requires a C11-capable host — use gcc-8 (default in buster) as bootstrap
# ─────────────────────────────────────────────
ENV GCC_VERSIONS="14.2.0"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends gcc g++ && \
    rm -rf /var/lib/apt/lists/* && \
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
    CC=gcc CXX=g++ /tmp/gcc-$VERSION/configure \
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
    --prefix=/usr/local/python-$VERSION && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Node.js 22.15.0 LTS  (pre-built binary)
# https://nodejs.org/en
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
# JDK 21.0.7 LTS  (Eclipse Temurin, pre-built)
# https://adoptium.net/temurin/releases
# ─────────────────────────────────────────────
ENV JDK_VERSIONS="21.0.7"
RUN set -xe && \
    for VERSION in $JDK_VERSIONS; do \
    curl -fSsL "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-${VERSION}%2B6/OpenJDK21U-jdk_x64_linux_hotspot_${VERSION}_6.tar.gz" -o /tmp/jdk-$VERSION.tar.gz && \
    mkdir /usr/local/jdk-$VERSION && \
    tar -xf /tmp/jdk-$VERSION.tar.gz -C /usr/local/jdk-$VERSION --strip-components=1 && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# PHP 8.3.19
# https://www.php.net/downloads
# ─────────────────────────────────────────────
ENV PHP_VERSIONS="8.3.19"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends bison re2c libxml2-dev libssl-dev pkg-config && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $PHP_VERSIONS; do \
    curl -fSsL "https://www.php.net/distributions/php-$VERSION.tar.xz" -o /tmp/php-$VERSION.tar.xz && \
    mkdir /tmp/php-$VERSION && \
    tar -xf /tmp/php-$VERSION.tar.xz -C /tmp/php-$VERSION --strip-components=1 && \
    rm /tmp/php-$VERSION.tar.xz && \
    cd /tmp/php-$VERSION && \
    ./buildconf --force && \
    ./configure \
    --prefix=/usr/local/php-$VERSION \
    --with-openssl \
    --with-zlib && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Go 1.24.3  (pre-built binary)
# https://golang.org/dl
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
# Kotlin 2.0.21  (pre-built, requires JDK 21)
# https://kotlinlang.org
# ─────────────────────────────────────────────
ENV KOTLIN_VERSIONS="2.0.21"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $KOTLIN_VERSIONS; do \
    curl -fSsL "https://github.com/JetBrains/kotlin/releases/download/v$VERSION/kotlin-compiler-$VERSION.zip" -o /tmp/kotlin-$VERSION.zip && \
    unzip -d /usr/local/kotlin-$VERSION /tmp/kotlin-$VERSION.zip && \
    mv /usr/local/kotlin-$VERSION/kotlinc/* /usr/local/kotlin-$VERSION/ && \
    rm -rf /usr/local/kotlin-$VERSION/kotlinc && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# TypeScript 5.4.5  (npm global, uses Node 22.15.0)
# https://github.com/microsoft/TypeScript/releases
# ─────────────────────────────────────────────
ENV TYPESCRIPT_VERSIONS="5.4.5"
RUN set -xe && \
    for VERSION in $TYPESCRIPT_VERSIONS; do \
    PATH="/usr/local/node-22.15.0/bin:$PATH" npm install -g typescript@$VERSION; \
    done

# ─────────────────────────────────────────────
# Erlang/OTP 27.3  (required by Elixir)
# https://github.com/erlang/otp/releases
# ─────────────────────────────────────────────
ENV ERLANG_VERSIONS="27.3"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libssl-dev libncurses-dev autoconf && \
    rm -rf /var/lib/apt/lists/* && \
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
    done; \
    ln -s /usr/local/erlang-27.3/bin/erl /usr/local/bin/erl

# ─────────────────────────────────────────────
# Elixir 1.18.3  (pre-built OTP-27 zip)
# https://github.com/elixir-lang/elixir/releases
# ─────────────────────────────────────────────
ENV ELIXIR_VERSIONS="1.18.3"
RUN set -xe && \
    for VERSION in $ELIXIR_VERSIONS; do \
    curl -fSsL "https://github.com/elixir-lang/elixir/releases/download/v$VERSION/elixir-otp-27.zip" -o /tmp/elixir-$VERSION.zip && \
    unzip -d /usr/local/elixir-$VERSION /tmp/elixir-$VERSION.zip && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Rust 1.87.0  (pre-built, min glibc 2.17 — works on Buster 2.28)
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
# .NET 8.0 LTS  (runtime 8.0.15 — Debian 10 officially supported)
# https://github.com/dotnet/sdk/releases
# ─────────────────────────────────────────────
RUN set -xe && \
    curl -fSsL "https://dot.net/v1/dotnet-install.sh" -o /tmp/dotnet-install.sh && \
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh --channel 8.0 --install-dir /usr/local/dotnet-8.0 && \
    rm /tmp/dotnet-install.sh

# ─────────────────────────────────────────────
# GNU COBOL 3.2
# https://ftp.gnu.org/gnu/gnucobol
# ─────────────────────────────────────────────
ENV COBOL_VERSIONS="3.2"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libgmp-dev && \
    rm -rf /var/lib/apt/lists/* && \
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
# Environment paths for all installed languages
# ─────────────────────────────────────────────
ENV JAVA_HOME="/usr/local/jdk-21.0.7"
ENV GOROOT="/usr/local/go-1.24.3"
ENV GOPATH="/root/go"
ENV LD_LIBRARY_PATH="/usr/local/gcc-14.2.0/lib64"
ENV COB_CONFIG_DIR="/usr/local/gnucobol-3.2/share/gnucobol/config"
ENV COB_COPY_DIR="/usr/local/gnucobol-3.2/share/gnucobol/copy"
ENV PATH="/usr/local/gcc-14.2.0/bin:\
    /usr/local/ruby-3.3.7/bin:\
    /usr/local/python-3.12.9/bin:\
    /usr/local/node-22.15.0/bin:\
    /usr/local/jdk-21.0.7/bin:\
    /usr/local/php-8.3.19/bin:\
    /usr/local/go-1.24.3/bin:\
    /usr/local/kotlin-2.0.21/bin:\
    /usr/local/erlang-27.3/bin:\
    /usr/local/elixir-1.18.3/bin:\
    /usr/local/rust-1.87.0/bin:\
    /usr/local/dotnet-8.0:\
    /usr/local/gnucobol-3.2/bin:\
    ${PATH}"

# ─────────────────────────────────────────────
# Locale setup
# ─────────────────────────────────────────────
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# ─────────────────────────────────────────────
# judge0 isolate sandbox
# ─────────────────────────────────────────────
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/judge0/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout ad39cc4d0fbb577fb545910095c9da5ef8fc9a1a && \
    make -j$(nproc) install && \
    rm -rf /tmp/*
ENV BOX_ROOT="/var/local/lib/isolate"

LABEL maintainer="Herman Zvonimir Došilović <hermanz.dosilovic@gmail.com>"
LABEL version="1.4.0"

# Base image: buildpack-deps:buster (Debian 10)
# https://hub.docker.com/_/buildpack-deps?tab=tags&page=1&name=buster
FROM judge0/buildpack-deps:buster-2019-12-28

# Debian Buster is EOL — redirect apt to archive.debian.org
RUN printf "deb http://archive.debian.org/debian buster main\ndeb http://archive.debian.org/debian-security buster/updates main\n" > /etc/apt/sources.list

# ─────────────────────────────────────────────
# GCC 14.2.0  (covers both C and C++)
# https://gcc.gnu.org/releases.html
# GCC 14 requires a C11-capable host — install gcc-9 as bootstrap
# ─────────────────────────────────────────────
ENV GCC_VERSIONS="14.2.0"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends gcc-9 g++-9 && \
    rm -rf /var/lib/apt/lists/* && \
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
    CC=gcc-9 CXX=g++-9 /tmp/gcc-$VERSION/configure \
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
    --prefix=/usr/local/python-$VERSION && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Node.js 22.15.0 LTS  (pre-built binary)
# https://nodejs.org/en
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
# JDK 21.0.7 LTS  (Eclipse Temurin, pre-built)
# https://adoptium.net/temurin/releases
# ─────────────────────────────────────────────
ENV JDK_VERSIONS="21.0.7"
RUN set -xe && \
    for VERSION in $JDK_VERSIONS; do \
    curl -fSsL "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-${VERSION}%2B6/OpenJDK21U-jdk_x64_linux_hotspot_${VERSION}_6.tar.gz" -o /tmp/jdk-$VERSION.tar.gz && \
    mkdir /usr/local/jdk-$VERSION && \
    tar -xf /tmp/jdk-$VERSION.tar.gz -C /usr/local/jdk-$VERSION --strip-components=1 && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# PHP 8.3.19
# https://www.php.net/downloads
# ─────────────────────────────────────────────
ENV PHP_VERSIONS="8.3.19"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends bison re2c libxml2-dev libssl-dev pkg-config && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $PHP_VERSIONS; do \
    curl -fSsL "https://www.php.net/distributions/php-$VERSION.tar.xz" -o /tmp/php-$VERSION.tar.xz && \
    mkdir /tmp/php-$VERSION && \
    tar -xf /tmp/php-$VERSION.tar.xz -C /tmp/php-$VERSION --strip-components=1 && \
    rm /tmp/php-$VERSION.tar.xz && \
    cd /tmp/php-$VERSION && \
    ./buildconf --force && \
    ./configure \
    --prefix=/usr/local/php-$VERSION \
    --with-openssl \
    --with-zlib && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Go 1.24.3  (pre-built binary)
# https://golang.org/dl
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
# Kotlin 2.0.21  (pre-built, requires JDK 21)
# https://kotlinlang.org
# ─────────────────────────────────────────────
ENV KOTLIN_VERSIONS="2.0.21"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $KOTLIN_VERSIONS; do \
    curl -fSsL "https://github.com/JetBrains/kotlin/releases/download/v$VERSION/kotlin-compiler-$VERSION.zip" -o /tmp/kotlin-$VERSION.zip && \
    unzip -d /usr/local/kotlin-$VERSION /tmp/kotlin-$VERSION.zip && \
    mv /usr/local/kotlin-$VERSION/kotlinc/* /usr/local/kotlin-$VERSION/ && \
    rm -rf /usr/local/kotlin-$VERSION/kotlinc && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# TypeScript 5.4.5  (npm global, uses Node 22.15.0)
# https://github.com/microsoft/TypeScript/releases
# ─────────────────────────────────────────────
ENV TYPESCRIPT_VERSIONS="5.4.5"
RUN set -xe && \
    for VERSION in $TYPESCRIPT_VERSIONS; do \
    PATH="/usr/local/node-22.15.0/bin:$PATH" npm install -g typescript@$VERSION; \
    done

# ─────────────────────────────────────────────
# Erlang/OTP 27.3  (required by Elixir)
# https://github.com/erlang/otp/releases
# ─────────────────────────────────────────────
ENV ERLANG_VERSIONS="27.3"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libssl-dev libncurses-dev autoconf && \
    rm -rf /var/lib/apt/lists/* && \
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
    done; \
    ln -s /usr/local/erlang-27.3/bin/erl /usr/local/bin/erl

# ─────────────────────────────────────────────
# Elixir 1.18.3  (pre-built OTP-27 zip)
# https://github.com/elixir-lang/elixir/releases
# ─────────────────────────────────────────────
ENV ELIXIR_VERSIONS="1.18.3"
RUN set -xe && \
    for VERSION in $ELIXIR_VERSIONS; do \
    curl -fSsL "https://github.com/elixir-lang/elixir/releases/download/v$VERSION/elixir-otp-27.zip" -o /tmp/elixir-$VERSION.zip && \
    unzip -d /usr/local/elixir-$VERSION /tmp/elixir-$VERSION.zip && \
    rm -rf /tmp/*; \
    done

# ─────────────────────────────────────────────
# Rust 1.87.0  (pre-built, min glibc 2.17 — works on Buster 2.28)
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
# .NET 8.0 LTS  (runtime 8.0.15 — Debian 10 officially supported)
# https://github.com/dotnet/sdk/releases
# ─────────────────────────────────────────────
RUN set -xe && \
    curl -fSsL "https://dot.net/v1/dotnet-install.sh" -o /tmp/dotnet-install.sh && \
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh --channel 8.0 --install-dir /usr/local/dotnet-8.0 && \
    rm /tmp/dotnet-install.sh

# ─────────────────────────────────────────────
# GNU COBOL 3.2
# https://ftp.gnu.org/gnu/gnucobol
# ─────────────────────────────────────────────
ENV COBOL_VERSIONS="3.2"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libgmp-dev && \
    rm -rf /var/lib/apt/lists/* && \
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
# Environment paths for all installed languages
# ─────────────────────────────────────────────
ENV JAVA_HOME="/usr/local/jdk-21.0.7"
ENV GOROOT="/usr/local/go-1.24.3"
ENV GOPATH="/root/go"
ENV LD_LIBRARY_PATH="/usr/local/gcc-14.2.0/lib64"
ENV COB_CONFIG_DIR="/usr/local/gnucobol-3.2/share/gnucobol/config"
ENV COB_COPY_DIR="/usr/local/gnucobol-3.2/share/gnucobol/copy"
ENV PATH="/usr/local/gcc-14.2.0/bin:\
    /usr/local/ruby-3.3.7/bin:\
    /usr/local/python-3.12.9/bin:\
    /usr/local/node-22.15.0/bin:\
    /usr/local/jdk-21.0.7/bin:\
    /usr/local/php-8.3.19/bin:\
    /usr/local/go-1.24.3/bin:\
    /usr/local/kotlin-2.0.21/bin:\
    /usr/local/erlang-27.3/bin:\
    /usr/local/elixir-1.18.3/bin:\
    /usr/local/rust-1.87.0/bin:\
    /usr/local/dotnet-8.0:\
    /usr/local/gnucobol-3.2/bin:\
    ${PATH}"

# ─────────────────────────────────────────────
# Swift 6.1  — COMMENTED OUT
# Requires glibc 2.34+, Debian Buster only has 2.28
# Upgrade base image to use Swift 6.1
# https://swift.org/download
# ─────────────────────────────────────────────
# ENV SWIFT_VERSIONS="6.1"
# RUN set -xe && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends libncurses5 && \
#     rm -rf /var/lib/apt/lists/* && \
#     for VERSION in $SWIFT_VERSIONS; do \
#       curl -fSsL "https://download.swift.org/swift-$VERSION-release/ubuntu2204/swift-$VERSION-RELEASE/swift-$VERSION-RELEASE-ubuntu22.04.tar.gz" -o /tmp/swift-$VERSION.tar.gz && \
#       mkdir /usr/local/swift-$VERSION && \
#       tar -xf /tmp/swift-$VERSION.tar.gz -C /usr/local/swift-$VERSION --strip-components=2 && \
#       rm -rf /tmp/*; \
#     done

# ─────────────────────────────────────────────
# Locale setup
# ─────────────────────────────────────────────
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# ─────────────────────────────────────────────
# judge0 isolate sandbox
# ─────────────────────────────────────────────
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/judge0/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout ad39cc4d0fbb577fb545910095c9da5ef8fc9a1a && \
    make -j$(nproc) install && \
    rm -rf /tmp/*
ENV BOX_ROOT="/var/local/lib/isolate"

LABEL maintainer="Herman Zvonimir Došilović <hermanz.dosilovic@gmail.com>"
LABEL version="1.4.0"

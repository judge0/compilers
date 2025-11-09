FROM judge0-compilers:1.4.1-slim-amd64

# Python for ML
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install \
        mlxtend \
        numpy \
        pandas \
        scikit-learn \
        pytest \
        scipy && \
    rm -rf /var/lib/apt/lists/*

# Nim
COPY ./bin/update/nim /update/
RUN set -xe && \
    /update/nim

# MPI for C, C++ and Python
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libopenmpi-dev python3-mpi4py && \
    rm -rf /var/lib/apt/lists/*

# Java
RUN set -xe && \
    curl -fSsL "https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_linux-x64_bin.tar.gz" -o /tmp/openjdk14.tar.gz && \
    mkdir /usr/local/openjdk14 && \
    tar -xf /tmp/openjdk14.tar.gz -C /usr/local/openjdk14 --strip-components=1 && \
    rm -rf /tmp/*

# JUnit Platform Console Standalone
RUN set -xe && \
    mkdir /usr/local/junit-platform-console-standalone-1.6.2 && \
    cd /usr/local/junit-platform-console-standalone-1.6.2 && \
    curl -fSsL "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.2/junit-platform-console-standalone-1.6.2.jar" -o launcher.jar

# C3
COPY ./bin/update/c3 /update/
RUN set -xe && \
    echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-11 main" > /etc/apt/sources.list.d/llvm.list && \
    echo "deb-src http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-11 main" >> /etc/apt/sources.list.d/llvm.list && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-recommends clang-11 cmake cmake-extras llvm-11-dev && \
    /update/c3 && \
    rm -rf /var/lib/apt/lists/*

# Bosque
COPY ./bin/update/bosque /update/
ENV PATH="/usr/local/node/bin:$PATH"
RUN set -xe && \
    echo "deb http://snapshot.debian.org/archive/debian/20200515T204659Z sid main" >> /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y --no-install-recommends g++-10 git-lfs && \
    curl -fSsL https://nodejs.org/dist/v12.16.3/node-v12.16.3-linux-x64.tar.xz -o /tmp/node.tar.xz && \
    mkdir /usr/local/node && \
    tar -xf /tmp/node.tar.xz -C /usr/local/node --strip-components=1 && \
    ln -fs /usr/local/node/bin/node /usr/bin/node && \
    ln -fs /usr/local/node/bin/npm /usr/bin/npm && \
    ln -fs /usr/local/node/bin/npx /usr/bin/npx && \
    npm install -g typescript && \
    /update/bosque && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Google Test
RUN set -xe && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y --no-install-recommends libgtest-dev && \
    rm -rf /var/lib/apt/lists/*

# Clang, Clang-Format and Clang-Tidy
RUN set -xe && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y --no-install-recommends clang clang-tidy clang-format && \
    rm -rf /var/lib/apt/lists/*

# .Net Core SDK
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true
RUN set -xe && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y apt-transport-https && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y dotnet-sdk-3.1 && \
    rm -rf /var/lib/apt/lists/*

# Mono
RUN set -xe && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y apt-transport-https dirmngr gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y mono-complete mono-vbnc && \
    rm -rf /var/lib/apt/lists/*

COPY files /files
COPY cron /etc/cron.d

RUN set -xe && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y --no-install-recommends cron && \
    rm -rf /var/lib/apt/lists/* && \
    cat /etc/cron.d/* | crontab - && \
    dotnet restore --packages /NuGet/packages /files/nunit/Test.csproj && \
    dotnet nuget locals all --clear && \
    rm -rf /files/nunit/obj

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

LABEL maintainer="Herman Zvonimir Došilović <hermanz.dosilovic@gmail.com>"
LABEL version="1.6.1-extra"

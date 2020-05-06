FROM judge0/api-base:1.2.1-slim

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install \
        mlxtend \
        numpy \
        pandas \
        scikit-learn \
        scipy && \
    rm -rf /var/lib/apt/lists/*

COPY ./bin/update/nim /update/
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends cron && \
    /update/nim && \
    echo "0 0 * * * /update/nim &> /var/log/nim.log" | crontab - && \
    rm -rf /var/lib/apt/lists/*

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libopenmpi-dev python3-mpi4py && \
    rm -rf /var/lib/apt/lists/*

RUN set -xe && \
    curl -fSsL "https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_linux-x64_bin.tar.gz" -o /tmp/openjdk14.tar.gz && \
    mkdir /usr/local/openjdk14 && \
    tar -xf /tmp/openjdk14.tar.gz -C /usr/local/openjdk14 --strip-components=1

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

LABEL maintainer="Herman Zvonimir Došilović <hermanz.dosilovic@gmail.com>"
LABEL version="1.2.1-extra"
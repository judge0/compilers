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

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

LABEL maintainer="Herman Zvonimir Došilović <hermanz.dosilovic@gmail.com>"
LABEL version="1.2.1-extra"
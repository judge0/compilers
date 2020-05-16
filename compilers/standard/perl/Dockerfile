# Latest version: https://www.perl.org/get.html
ENV PERL_VERSIONS 5.28.1
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends perl && \
    apt-get autoremove --purge && \
    rm -rf /tmp/* /var/lib/apt/lists/*

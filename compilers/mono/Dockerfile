ARG BASE_IMAGE
FROM $BASE_IMAGE

# Latest version: https://www.mono-project.com/download/stable
ENV MONO_VERSIONS 6.8.0.123
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https dirmngr gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends mono-devel mono-vbnc fsharp && \
    apt-get autoremove --purge && \
    rm -rf /tmp/* /var/lib/apt/lists/*

# Start from the existing image
FROM judge0/compilers:1.4.0

# Install dependencies required for building GCC
RUN apt-get update && \
  apt-get install -y build-essential libgmp-dev libmpfr-dev libmpc-dev && \
  rm -rf /var/lib/apt/lists/*

# Download and install GCC 11.3.0
ENV GCC_VERSION 11.3.0
RUN curl -fSsL "https://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz" -o gcc.tar.gz && \
  tar -xf gcc.tar.gz && \
  cd gcc-$GCC_VERSION && \
  ./contrib/download_prerequisites && \
  ./configure --disable-multilib --enable-languages=c,c++ --prefix=/usr/local/gcc-$GCC_VERSION && \
  make -j$(nproc) && \
  make -j$(nproc) install-strip && \
  rm -rf /usr/local/src/gcc-$GCC_VERSION && \
  rm -rf gcc.tar.gz

# Add the new GCC binary to the PATH
ENV PATH /usr/local/gcc-$GCC_VERSION/bin:$PATH

# Add any additional instructions here

LABEL version="1.4.0-gcc11.3.0"

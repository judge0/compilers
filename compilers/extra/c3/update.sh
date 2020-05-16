#!/bin/bash
cd /tmp

if [[ ! -d c3c ]]; then
    git clone https://github.com/c3lang/c3c.git
fi

cd c3c
mkdir -p build
cd build
rm -rf *

cmake -DCMAKE_C_FLAGS="-w" ..
make -j$(nproc)

mkdir -p /usr/local/c3-latest/
if [[ -f c3c ]]; then
    cp -f c3c /usr/local/c3-latest/
fi
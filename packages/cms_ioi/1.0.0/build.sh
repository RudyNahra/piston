#!/usr/bin/env bash

# Put instructions to build your package in here
[[ -d "bin" ]] && exit 0
PREFIX=$(realpath $(dirname $0))

mkdir -p build obj

# Download both tarballs first
cd build
curl "https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz" -o gcc.tar.gz
curl -L "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz" -o jq.tar.gz

# Install jq
mkdir jq
cd jq
tar xzf ../jq.tar.gz --strip-components=1
autoreconf -fi
./configure --prefix="$PREFIX"
make -j$(nproc)
make install -j$(nproc)
cd ..

# Install gcc
mkdir gcc
cd gcc
tar xzf ../gcc.tar.gz --strip-components=1
./contrib/download_prerequisites
cd ..

cd ../obj

# === autoconf based === 
../build/gcc/configure --prefix "$PREFIX" --enable-languages=c,c++,d,fortran --disable-multilib --disable-bootstrap

make -j$(nproc)
make install -j$(nproc)
cd ../
rm -rf build obj

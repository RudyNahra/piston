#!/usr/bin/env bash

# Put instructions to build your package in here
[[ -d "bin" ]] && exit 0
PREFIX=$(realpath $(dirname $0))

# Install gcc first
mkdir gcc
cd gcc
curl "https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz" -o gcc.tar.gz
tar xzf gcc.tar.gz --strip-components=1
./contrib/download_prerequisites
cd ../obj
# === autoconf based === 
../build/configure --prefix "$PREFIX" --enable-languages=c,c++,d,fortran --disable-multilib --disable-bootstrap

make -j$(nproc)
make install -j$(nproc)
cd ../
rm -rf gcc obj

# Install Oniguruma
mkdir onig
cd onig
curl -L "https://github.com/kkos/oniguruma/releases/download/v6.9.8/onig-6.9.8.tar.gz" -o onig.tar.gz
tar xzf onig.tar.gz --strip-components=1
./configure --prefix="$PREFIX"
make -j$(nproc)
make install -j$(nproc)
cd ..
rm -rf onig

# Install jq
mkdir jq
cd jq
curl -L "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz" -o jq.tar.gz
tar xzf jq.tar.gz --strip-components=1
autoreconf -fi
./configure --prefix="$PREFIX"
make -j$(nproc)
make install -j$(nproc)
cd ..

rm -rf jq

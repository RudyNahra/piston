#!/usr/bin/env bash

# Put instructions to build your package in here
# [[ -d "bin" ]] && exit 0
PREFIX=$(realpath $(dirname $0))


# === Install Python ===
mkdir -p build
cd build

curl "https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz" -o python.tar.gz
tar xzf python.tar.gz --strip-components=1
rm python.tar.gz

./configure --prefix "$PREFIX" --with-ensurepip=install
make -j$(nproc)
make install -j$(nproc)

cd ..
rm -rf build

# Install required Python packages
# bin/pip3 install numpy scipy pandas pycryptodome whoosh bcrypt passlib sympy xxhash base58 cryptography PyNaCl

# === Install GCC ===

mkdir -p build obj

cd build

curl "https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz" -o gcc.tar.gz

tar xzf gcc.tar.gz --strip-components=1

./contrib/download_prerequisites

cd ../obj

# === autoconf based === 
../build/configure --prefix "$PREFIX" --enable-languages=c,c++,d,fortran --disable-multilib --disable-bootstrap

make -j$(nproc)
make install -j$(nproc)
cd ../
rm -rf build obj

# === Install Kotlin ===
mkdir kotlin_install
cd kotlin_install

KOTLIN_VERSION="1.9.23"
KOTLIN_ZIP="kotlin-compiler-1.9.23.zip"

curl -LO "https://github.com/JetBrains/kotlin/releases/download/v1.9.23/kotlin-compiler-1.9.23.zip"
unzip "${KOTLIN_ZIP}"

# Copy bin and lib directories to the prefix
cp -r kotlinc/bin/* "$PREFIX/bin/"
cp -r kotlinc/lib/* "$PREFIX/lib/"

cd ..
rm -rf kotlin_install


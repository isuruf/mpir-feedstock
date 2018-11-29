#!/bin/bash

chmod +x configure

if [ "$(uname)" == "Darwin" ];
then
    ./configure --prefix=$PREFIX --enable-pic --enable-cxx --build=x86_64-apple-darwin
else
    export CFLAGS="${CFLAGS} -fPIC"
    export CXXFLAGS="${CXXFLAGS} -fPIC"
    ./configure --prefix=$PREFIX --enable-pic --enable-cxx --enable-fat
fi

make
make check
make install

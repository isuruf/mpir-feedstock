#!/bin/bash

autoreconf -i
chmod +x configure

if [ "$(uname)" == "Darwin" ];
then
    ./configure --prefix=$PREFIX --with-pic --enable-cxx --build=x86_64-apple-darwin
else
    ./configure --prefix=$PREFIX --with-pic --enable-cxx --enable-fat
fi

make -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install

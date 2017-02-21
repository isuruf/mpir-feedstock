#!/bin/bash

chmod +x configure
export CFLAGS="-fPIC $CFLAGS"

./configure --prefix=$PREFIX --enable-cxx --enable-fat
make
make check
make install

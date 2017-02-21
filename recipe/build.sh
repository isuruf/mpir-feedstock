#!/bin/bash

chmod +x configure

./configure --prefix=$PREFIX --enable-cxx --enable-fat
make
make check
make install

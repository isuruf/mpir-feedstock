#!/bin/bash

source activate "${CONDA_DEFAULT_ENV}"

chmod +x configure

export PATH=$PATH:$PREFIX/bin

./configure --prefix=$PREFIX --enable-cxx --enable-fat
make
make check
make install

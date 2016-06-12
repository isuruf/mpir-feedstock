#!/bin/bash

source activate "${CONDA_DEFAULT_ENV}"

chmod +x configure

./configure --prefix=$PREFIX --enable-cxx --enable-fat

make
make check
make install

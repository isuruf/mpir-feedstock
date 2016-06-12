#!/bin/bash

source activate "${CONDA_DEFAULT_ENV}"

chmod +x configure

if [ "$(uname)" == "Darwin" ];
then
    ./configure --prefix=$PREFIX --enable-cxx --build=x86_64-apple-darwin
else
    ./configure --prefix=$PREFIX --enable-cxx --enable-fatg
fi

make
make check
make install

#!/bin/bash

source activate "${CONDA_DEFAULT_ENV}"

chmod +x configure

if [ "$(uname)" == "Darwin" ];
then
    ./configure --prefix=$PREFIX --enable-cxx --build=x86_64-apple-darwin --with-yasm=$PREFIX
else
    ./configure --prefix=$PREFIX --enable-cxx --enable-fat --with-yasm=$PREFIX

fi

make
make check
make install

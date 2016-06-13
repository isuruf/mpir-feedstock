#!/bin/bash

source activate "${CONDA_DEFAULT_ENV}"

chmod +x configure

export PATH=$PATH:$PREFIX/bin

if [ "$(uname)" == "Darwin" ];
then
    ./configure --prefix=$PREFIX --enable-cxx --build=x86_64-apple-darwin --with-system-yasm=yes
else
    ./configure --prefix=$PREFIX --enable-cxx --enable-fat --with-system-yasm=yes

fi

make
make check
make install

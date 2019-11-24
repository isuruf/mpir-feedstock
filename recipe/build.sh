#!/bin/bash


chmod +x configure

if [[ "$target_platform" == "osx-64" ]]; then
    ./configure --prefix=$PREFIX --with-pic --enable-cxx --build=x86_64-apple-darwin
elif [[ "$target_platform" == "win-64" ]]; then
    autoreconf -i
    chmod +x configure
    ./configure --prefix=$PREFIX --with-pic --enable-cxx --enable-fat --disable-static --enable-gmpcompat
else
    ./configure --prefix=$PREFIX --with-pic --enable-cxx --enable-fat
fi

[[ "$target_platform" == "win-64" ]] && patch_libtool
[[ "$target_platform" == "win-64" ]] && sed -i.bak "s@-link -DLL@shared@g" libtool
[[ "$target_platform" == "win-64" ]] && ln -s $BUILD_PREFIX/bin/llvm-lib.exe $BUILD_PREFIX/Library/bin/lib.exe

make -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install

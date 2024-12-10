#!/usr/bin/env bash

if [[ "$target_platform" != "win-"* ]]; then
  # Get an updated config.sub and config.guess
  cp $BUILD_PREFIX/share/libtool/build-aux/config.* .
fi

autoreconf -vfi

chmod +x configure
./configure \
  --prefix=$PREFIX \
  --with-gmp-include=$PREFIX/include \
  --with-gmp-lib=$PREFIX/lib \
  --enable-shared \
  --disable-static

[[ "$target_platform" == "win-"* ]] && patch_libtool

make -j${CPU_COUNT}

chmod +x test.pp1
chmod +x test.pm1
chmod +x test.ecm
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
  make check
fi

make install

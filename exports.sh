#!/bin/sh

# Common build paths and flags
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${TARGET}/lib/pkgconfig"
export PKG_CONFIG=/usr/bin/pkg-config

export PATH="${TARGET}/bin:${PATH}"

export CPPFLAGS="-I${TARGET}/include"
export LDFLAGS="-L${TARGET}/lib"

export CFLAGS="${FLAGS}"
export CXXFLAGS="${FLAGS}"

export LD_LIBRARY_PATH=${TARGET}/lib

echo "Exports invoked!"

FROM lambci/lambda:build-nodejs8.10

################################################
#                                              #
# Prepare system                               #
#                                              #
################################################

RUN rpm --rebuilddb && yum groupinstall -y "Development Tools"  --setopt=group_package_types=mandatory,default
RUN rpm --rebuilddb && yum install -y libmount-devel
RUN rpm --rebuilddb && yum install -y jq
RUN rpm --rebuilddb && yum install -y texlive gtk-doc docbook-utils-pdf
RUN rpm --rebuilddb && yum install -y gmp-devel libssh2-devel
RUN rpm --rebuilddb && yum install -y wget
RUN rpm --rebuilddb && yum install -y gperf

ENV FLAGS="-O3"
ENV TARGET="/var/task"

ADD exports.sh /tmp/exports.sh

################################################
#                                              #
# Add some files for testing                   #
#                                              #
################################################

ADD index.js .
ADD test.pdf .

################################################
#                                              #
# These packages have no dependencies          #
#                                              #
################################################

# zlib
RUN cd /tmp && source ./exports.sh && \
  wget https://github.com/madler/zlib/archive/v1.2.11.tar.gz && \
  tar -xf v1.2.11.tar.gz && \
  cd zlib-1.2.11 && \
  ./configure \
    --prefix=/var/task && \
  make && \
  make install

# pcre
RUN cd /tmp && source ./exports.sh && \
  wget https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.bz2 && \
  tar -xf pcre-8.42.tar.bz2 && \
  cd pcre-8.42 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --enable-unicode-properties \
    --enable-pcre16 \
    --enable-pcre32 \
    --enable-pcregrep-libz && \
  make && \
  make install

# expat
RUN cd /tmp && source ./exports.sh && \
  wget https://netcologne.dl.sourceforge.net/project/expat/expat/2.2.5/expat-2.2.5.tar.bz2 && \
  tar -xf expat-2.2.5.tar.bz2 && \
  cd expat-2.2.5 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static && \
  make && \
  make install

# libffi
RUN cd /tmp && source ./exports.sh && \
  wget ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz && \
  tar -xf libffi-3.2.1.tar.gz && \
  cd libffi-3.2.1 && \
  ./configure \
    --host=${CHOST} \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --disable-builddir && \
  make && \
  make install

# png16
RUN cd /tmp && source ./exports.sh && \
  wget https://downloads.sourceforge.net/libpng/libpng-1.6.34.tar.xz && \
  tar -xf libpng-1.6.34.tar.xz && \
  cd libpng-1.6.34 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static && \
  make && \
  make install

# ORC
RUN cd /tmp && source ./exports.sh && \
  wget https://gstreamer.freedesktop.org/src/orc/orc-0.4.28.tar.xz && \
  tar -xf orc-0.4.28.tar.xz && \
  cd orc-0.4.28 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static && \
  make && \
  make install

# cmake
RUN yum remove -y cmake
RUN cd /tmp && source ./exports.sh && \
  wget https://cmake.org/files/v3.11/cmake-3.11.4.tar.gz && \
  tar -xf cmake-3.11.4.tar.gz && \
  cd cmake-3.11.4 && \
  ./bootstrap \
    --prefix=/var/task && \
  make && \
  make install

### nasm
RUN cd /tmp && source ./exports.sh && \
  wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.xz && \
  tar -xf nasm-2.13.03.tar.xz && \
  cd nasm-2.13.03 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static && \
  make && \
  make install

# exif
RUN cd /tmp && source ./exports.sh && \
  wget https://netcologne.dl.sourceforge.net/project/libexif/libexif/0.6.21/libexif-0.6.21.tar.gz && \
  tar -xf libexif-0.6.21.tar.gz && \
  cd libexif-0.6.21 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static && \
  make && \
  make install

################################################
#                                              #
# These packages have dependencies, keep order #
#                                              #
################################################

# xml2
RUN cd /tmp && source ./exports.sh && \
  wget http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz && \
  tar -xf libxml2-2.9.8.tar.gz && \
  cd libxml2-2.9.8 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --with-html \
    --with-history \
    --enable-ipv6=no \
    --with-icu \
    --with-zlib=/var/task && \
  make && \
  make install

# pixman
RUN cd /tmp && source ./exports.sh && \
  wget https://www.cairographics.org/releases/pixman-0.34.0.tar.gz && \
  tar -xf pixman-0.34.0.tar.gz && \
  cd pixman-0.34.0 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --disable-arm-iwmmxt && \
  make && \
  make install

# libjpeg
RUN cd /tmp && source ./exports.sh && \
  wget http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz && \
  tar -xf libjpeg-turbo-1.5.3.tar.gz && \
  cd libjpeg-turbo-1.5.3 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --with-jpeg8 && \
  make && \
  make install

#tiff
RUN cd /tmp && source ./exports.sh && \
  wget http://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz && \
  tar -xf tiff-4.0.9.tar.gz && \
  cd tiff-4.0.9 && \
  ./configure \
    --prefix=/var/task \
    --disable-mdi \
    --disable-pixarlog \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --disable-cxx && \
  make && \
  make install

# glib
RUN cd /tmp && source ./exports.sh && \
  wget http://ftp.gnome.org/pub/gnome/sources/glib/2.56/glib-2.56.1.tar.xz && \
  tar -xf glib-2.56.1.tar.xz && \
  cd glib-2.56.1 && \
  echo glib_cv_stack_grows=no >>glib.cache && \
  echo glib_cv_uscore=no >>glib.cache && \
  ./configure \
    --cache-file=glib.cache \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --prefix=/var/task && \
  make && \
  make install

# lcms2
RUN cd /tmp && source ./exports.sh && \
  wget https://downloads.sourceforge.net/lcms/lcms2-2.9.tar.gz && \
  tar -xf lcms2-2.9.tar.gz && \
  cd lcms2-2.9 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static && \
  make && \
  make install

# webp
RUN cd /tmp && source ./exports.sh && \
  wget http://downloads.webmproject.org/releases/webp/libwebp-0.6.0.tar.gz && \
  tar -xf libwebp-0.6.0.tar.gz && \
  cd libwebp-0.6.0 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --disable-neon \
    --disable-gif \
    --enable-libwebpmux \
    --with-pngincludedir=/var/task/include \
    --with-pnglibdir=/var/task/lib && \
  make && \
  make install


# HarfBuzz wants freetype before it is installed, and freetype wants harfbuz after it is installed.

# freetype
RUN cd /tmp && source ./exports.sh && \
  wget https://netix.dl.sourceforge.net/project/freetype/freetype2/2.9.1/freetype-2.9.1.tar.gz && \
  tar -xf freetype-2.9.1.tar.gz && \
  cd freetype-2.9.1 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static && \
  make && \
  make install

# fontconfig
RUN cd /tmp && source ./exports.sh && \
  wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.6.tar.gz && \
  tar -xf fontconfig-2.12.6.tar.gz && \
  cd fontconfig-2.12.6 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --with-expat-includes=/var/task/include \
    --with-expat-lib=/var/task/lib \
    --sysconfdir=/var/task/etc && \
  make && \
  make install

# cairo
RUN cd /tmp && source ./exports.sh && \
  wget https://www.cairographics.org/releases/cairo-1.14.12.tar.xz && \
  tar -xf cairo-1.14.12.tar.xz && \
  cd cairo-1.14.12 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --disable-xlib \
    --disable-xcb \
    --disable-quartz \
    --disable-win32 \
    --disable-egl \
    --disable-glx \
    --disable-wgl \
    --disable-script \
    --disable-ps \
    --disable-gobject \
    --disable-trace \
    --disable-interpreter && \
  make && \
  make install

# harfbuzz
RUN cd /tmp && source ./exports.sh && \
  wget https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.8.1.tar.bz2 && \
  tar -xf harfbuzz-1.8.1.tar.bz2 && \
  cd harfbuzz-1.8.1 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static && \
  make && \
  make install

# Reinstall freetype with harfbuzz
RUN cd /tmp && source ./exports.sh && \
  rm -rf freetype-2.9.1 && \
  tar -xf freetype-2.9.1.tar.gz && \
  cd freetype-2.9.1 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static && \
  make && \
  make install

# Reinstall fontconfig with harfbuzz
RUN cd /tmp && source ./exports.sh && \
  rm -rf fontconfig-2.12.6 && \
  tar -xf fontconfig-2.12.6.tar.gz && \
  cd fontconfig-2.12.6 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --with-expat-includes=/var/task/include \
    --with-expat-lib=/var/task/lib \
    --sysconfdir=/var/task/etc && \
  make && \
  make install

# openjpg
RUN cd /tmp && source ./exports.sh && \
  wget https://github.com/uclouvain/openjpeg/archive/v2.3.0.tar.gz && \
  tar -xf v2.3.0.tar.gz && \
  cd openjpeg-2.3.0 && \
  mkdir build && \
  cd build && \
  cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/var/task \
    -DBUILD_SHARED_LIBS:bool=on \
    -DCMAKE_LIBRARY_PATH=/var/task/lib \
    -DCMAKE_C_FLAGS="${FLAGS}" && \
  make && \
  make install

# poppler
RUN cd /tmp && source ./exports.sh && \
  wget https://poppler.freedesktop.org/poppler-0.59.0.tar.xz && \
  tar -xf poppler-0.59.0.tar.xz && \
  cd poppler-0.59.0 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --enable-xpdf-headers \
    --enable-build-type=release \
    --enable-cmyk \
    --enable-libopenjpeg=openjpeg2 \
    --disable-libnss \
    --disable-poppler-qt4 \
    --disable-poppler-qt5 \
    --disable-poppler-cpp \
    --sysconfdir=/var/task/etc \
    --with-font-configuration=fontconfig && \
  make && \
  make install

# vips
RUN cd /tmp && source ./exports.sh && \
  wget https://github.com/jcupitt/libvips/releases/download/v8.6.4/vips-8.6.4.tar.gz && \
  tar -xf vips-8.6.4.tar.gz && \
  cd vips-8.6.4 && \
  ./configure \
    --prefix=/var/task \
    --disable-dependency-tracking \
    --enable-shared \
    --disable-static \
    --disable-introspection \
    --with-zlib-includes=/var/task/include \
    --with-zlib-libraries=/var/task/lib \
    --with-jpeg-includes=/var/task/include \
    --with-jpeg-libraries=/var/task/lib \
    --with-png-includes=/var/task/include \
    --with-png-libraries=/var/task/lib \
    --with-tiff-includes=/var/task/include \
    --with-tiff-libraries=/var/task/lib \
    --with-libwebp-includes=/var/task/include \
    --with-libwebp-libraries=/var/task/lib && \
  make && \
  make install

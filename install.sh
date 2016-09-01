#!/usr/bin/env bash

REPO="sudo apt-get"
if [[ $OSTYPE == darwin* ]]; then 
    REPO="brew"
fi

echo "Installing imagemagick"
$REPO install imagemagick

echo " "
echo "Installing optipng and advdef"
$REPO install optipng advancecomp

echo " "
echo "Installing gnu parallel"
$REPO install parallel

if [[ $OSTYPE == darwin* ]]; then
    echo " "
    echo "Installing mozjpeg and jpeg-archive"
    $REPO install mozjpeg jpeg-archive
else
    echo " "
    echo "Installing mozjpeg"
    sudo apt-get install build-essential autoconf pkg-config nasm libtool
    git clone https://github.com/mozilla/mozjpeg.git
    cd mozjpeg
    autoreconf -fiv
    ./configure --with-jpeg8
    make
    sudo make install

    cd -

    echo " "
    echo "Installing jpeg-archive"
    git clone https://github.com/danielgtaylor/jpeg-archive.git
    cd jpeg-archive
    git checkout 2.1.1
    make
    sudo make install
fi


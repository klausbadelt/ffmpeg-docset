#!/bin/bash
rm -rf _input/ffmpeg*

# fetch ffmpeg
wget -O _input/ffmpeg-snapshot.tar.bz2 http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xf _input/ffmpeg-snapshot.tar.bz2 -C _input

# generate doc htmls
cd _input/ffmpeg
./configure
make doc
cd -


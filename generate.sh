#!/bin/bash
rm -rf _output/ffmpeg.docset/Contents/Resources/docSet.dsidx
rm -rf _output/ffmpeg.docset/Contents/Resources/Documents/*
rm -rf _input/ffmpeg*
mkdir -p _output/ffmpeg.docset/Contents/Resources/Documents

# fetch ffmpeg
wget -O _input/ffmpeg-snapshot.tar.bz2 http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xf _input/ffmpeg-snapshot.tar.bz2 -C _input

# generate doc htmls
cd _input/ffmpeg
./configure
make doc
cd -

# copy into docset
cp -rf _input/ffmpeg/doc/ffmpeg.html _output/ffmpeg.docset/Contents/Resources/Documents
cp -rf _input/ffmpeg/doc/style.min.css _output/ffmpeg.docset/Contents/Resources/Documents
cp -rf _input/ffmpeg/doc/bootstrap.min.css _output/ffmpeg.docset/Contents/Resources/Documents
cp -rf _input/Info.plist _output/ffmpeg.docset/Contents/Info.plist

#cp -rf _input/logo.png _output/erlang.docset/icon.png
#cp -rf _input/otp_doc.css _output/erlang.docset/Contents/Resources/Documents/doc/otp_doc.css

# index
ruby index.rb _input/ffmpeg/doc/ffmpeg.html
#find doc -name \*\.html | xargs -n 1 ruby ~/Codes/erlang.docset/src/generate.rb | sqlite3 ../docSet.dsidx

# compress
cd _output
tar --exclude='*.pdf' --exclude='.DS_Store' -cvzf FFmpeg.tgz ffmpeg.docset
cd -

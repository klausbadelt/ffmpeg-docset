#!/bin/bash
rm -rf _output/ffmpeg.docset
rm -rf _output/FFmpeg.tgz
mkdir -p _output/ffmpeg.docset/Contents/Resources/Documents

# copy into docset
# cp -rf _input/ffmpeg/doc/*.html _output/ffmpeg.docset/Contents/Resources/Documents
cp -rf _input/ffmpeg/doc/*.css _output/ffmpeg.docset/Contents/Resources/Documents
cp -rf _input/icon*.png _output/ffmpeg.docset
cp -rf _input/Info.plist _output/ffmpeg.docset/Contents/Info.plist

# index
ruby index.rb _output/ffmpeg.docset
#find doc -name \*\.html | xargs -n 1 ruby ~/Codes/erlang.docset/src/generate.rb | sqlite3 ../docSet.dsidx

# compress
# cd _output
# tar --exclude='*.pdf' --exclude='.DS_Store' -cvzf FFmpeg.tgz ffmpeg.docset
# cd -

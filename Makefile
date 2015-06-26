# CHANGE THIS TO CURRENT FFMPEG VERSION
FFMPEG_SOURCE_TARBALL=ffmpeg-2.7.1.tar.bz2
# NO CHANGES BELOW THIS

all: ffmpeg.tgz
	
ffmpeg.tgz: ffmpeg.docset
	tar --exclude='*.pdf' --exclude='.DS_Store' -cvzf ffmpeg.tgz ffmpeg.docset

ffmpeg.docset: ffmpeg
	mkdir -p ffmpeg.docset/Contents/Resources/Documents
	cp -rf ffmpeg/doc/*.css ffmpeg.docset/Contents/Resources/Documents
	cp -rf icon*.png ffmpeg.docset
	cp -rf Info.plist ffmpeg.docset/Contents/Info.plist
	bundle exec ruby index.rb

ffmpeg: $(FFMPEG_SOURCE_TARBALL)
	mkdir -p ffmpeg
	tar xf $(FFMPEG_SOURCE_TARBALL) --strip-components=1 -C ffmpeg
	cd ffmpeg && ./configure && make doc
	
$(FFMPEG_SOURCE_TARBALL): 
	wget -O $(FFMPEG_SOURCE_TARBALL) http://ffmpeg.org/releases/$(FFMPEG_SOURCE_TARBALL)
	
clean: clean_local
	rm -rf $(FFMPEG_SOURCE_TARBALL)
	
clean_local:
	rm -rf ffmpeg ffmpeg.docset ffmpeg.tgz
  
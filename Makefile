# CHANGE THIS TO CURRENT FFMPEG VERSION
FFMPEG_SOURCE_TARBALL=ffmpeg-3.1.2.tar.bz2
# NO CHANGES BELOW THIS
BUILD=build/

all: $(BUILD)FFmpeg.tgz
	
$(BUILD)FFmpeg.tgz: $(BUILD)ffmpeg.docset
	rm -rf $(BUILD)FFmpeg.tgz
	tar -C $(BUILD) --exclude='*.pdf' --exclude='.DS_Store' -cvzf $(BUILD)FFmpeg.tgz ffmpeg.docset

$(BUILD)ffmpeg.docset: $(BUILD)ffmpeg
	mkdir -p $(BUILD)ffmpeg.docset/Contents/Resources/Documents
	cp -rf $(BUILD)ffmpeg/doc/*.css $(BUILD)ffmpeg.docset/Contents/Resources/Documents
	cp -rf icon*.png $(BUILD)ffmpeg.docset
	cp -rf Info.plist $(BUILD)ffmpeg.docset/Contents/Info.plist
	bundle exec ruby index.rb $(BUILD)

$(BUILD)ffmpeg: $(BUILD)$(FFMPEG_SOURCE_TARBALL)
	mkdir -p $(BUILD)ffmpeg
	tar xf $(BUILD)$(FFMPEG_SOURCE_TARBALL) --strip-components=1 -C $(BUILD)ffmpeg
	cd $(BUILD)ffmpeg && ./configure  --disable-yasm && make doc
	
$(BUILD)$(FFMPEG_SOURCE_TARBALL): 
	mkdir -p $(BUILD)
	wget -O $(BUILD)$(FFMPEG_SOURCE_TARBALL) http://ffmpeg.org/releases/$(FFMPEG_SOURCE_TARBALL)
	
clean: local_clean
	rm -rf $(BUILD)$(FFMPEG_SOURCE_TARBALL)
	
local_clean:
	rm -rf $(BUILD)ffmpeg $(BUILD)ffmpeg.docset $(BUILD)FFmpeg.tgz
 
.DELETE_ON_ERROR:
	
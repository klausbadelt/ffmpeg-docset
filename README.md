# FFmpeg Docset Generator


## Install

Requires Ruby 2.2+, Bundler, make. Tested only on OS X.

```
bundle install
```

## Update Makefile

Edit the ``FFMPEG_SOURCE_TARBALL`` variable to the current ffmpeg tarball file, if necessary.

## Build FFmpeg Docset

```
make
```

This downloads the ffmpeg source tarball, generates the ffmpeg documentation, creates the docset
and indexes all documenation files.

## TODO

1. Add FFmpeg API doxygen documentation
1. Add tests

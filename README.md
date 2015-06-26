# FFmpeg Docset Generator

This script creates a docset for FFmpeg from its documenation.
The docset can be used in the incredibly useful [Dash](https://kapeli.com/dash).
It is submitted also as a [User Contributed docset](https://github.com/Kapeli/Dash-User-Contributions) for Dash.

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

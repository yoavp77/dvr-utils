#!/bin/bash
# use this script to convert your variuos ebook formats to .mobi. I used it only for txt files
# but it should work for other formats, most likely. 
# the massconv script can be found here:
# http://pastebin.com/0HpA7dy0

if [ $# -ne 1 ]; then
        echo "usage: $0 <dir>"
        exit 0
fi

cd "$1"
pwd
echo "processing rtf..."
massconv -s . -d . --have rtf --want mobi #> /dev/null
echo "processing txt..."
massconv -s . -d . --have txt --want mobi #> /dev/null
echo "processing odt..."
massconv -s . -d . --have odt --want mobi #> /dev/null
echo "processing epub..."
massconv -s . -d . --have html --want mobi #> /dev/null
echo "processing html..."
massconv -s . -d . --have epub --want mobi #> /dev/null
echo "processing lit..."
massconv -s . -d . --have lit --want mobi #> /dev/null

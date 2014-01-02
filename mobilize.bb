#!/bin/bash
# use this to convert a video file to a format compatible with a blackberry (used on a BB Tour)
if [ $# -ne 1 ]; then
	echo "usage: `basename $0` <file>"
	exit 1
fi

if [ ! -f "$1" ]; then
	echo "cant open $1"
	exit 2
fi

var=`ffmpeg -i "$1" 2>&1 | sed -e '/DAR/!d; s/^.*DAR \([0-9]*:[0-9]*\).*/\1/' | sed 's/:/ % /g'`
ratio=`expr $var`
if [ $ratio -gt 4 ]; then
	resolution="320x180"
	aspect="16:9"
else
	resolution="320x240"
	aspect="4:3"
fi

output=`echo "$1" |awk -F/ '{print $NF}'`
ffmpeg -i "$1" -vcodec mpeg4 -s qvga -r 24 -s $resolution -aspect $aspect -acodec aac -strict experimental -ar 22050 -ac 2 -ab 128k -b 400k ${output}.mp4
#ffmpeg -i "$1" -vcodec mpeg4 -s qvga -r 24 -s $resolution -aspect $aspect -acodec libfaac -ar 22050 -ac 2 -ab 128k -b 400k ${output}.mp4

#ffmpeg -i $1 -vcodec mpeg4 -s qvga -r 24 -s 320x180 -aspect 16:9 -acodec libfaac -ar 22050 -ac 2 -ab 48k ${output}.mp4

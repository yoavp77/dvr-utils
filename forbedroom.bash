#!/bin/bash
# this script adds an mp3 and an ac3 audio track to all mkv files in a specific directory. 
# default track is mp3.
# 
# I needed the ac3 audio track for my bedroom, where I have an HD-200 that doesn't support
# DTS audio without a receiver.
# 
# I needed the mp3 audio track to be able to bypass 5.1 surround when I wanted to control
# the volume with the sagetv remote.

export PATH=$PATH:/usr/local/bin

IFS=$'\n'

for file in `find "/monstrous/Import/videos/Anew" -name "*.mkv" | grep -iv eurovisi`; do
	echo "processing $file..."
	has_dts=`mkvinfo "$file" | grep A_DTS | wc -l`
	has_ac3=`mkvinfo "$file" | grep AC3 | wc -l`
	has_stereo=`mkvmerge -i "$file" | egrep -i "mp3|MPEG/L3" | wc -l`
	if [ $has_ac3 -eq 0 ]; then
		echo "no ac3 tracks found..."
		if [ $has_dts -ge 1 ]; then
			echo "found dts track..."
			cd /anew/
			nohup /usr/local/bin/mkvdts2ac3.sh -w /anew/tmp "$file" >> /dev/null 2>&1 &
		fi
	else
		echo "already has ac3 track..."
	fi
	if [ $has_stereo -eq 0 ]; then
		echo "no mp3 track found..."
		count=0
		line=""
		for i in `mkvmerge -i "$file" | grep A_` ; do
			count=`expr $count + 1`
			line="$line --edit track:a$count --set language=heb"
		done
		count=`expr $count + 1`
		echo "mkvpropedit \"$file\" $line --edit track:a$count --set language=eng" > /tmp/propedit.$$
		#mkvpropedit "$file" "$line"
		#
		trackid=`mkvmerge -i "$file" | egrep "AC3|DTS" | head -1 | awk '{print $3}' | awk -F: '{print $1}'`
		echo "extracting ac3 track..."
		/usr/bin/mkvextract tracks "$file" $trackid:/anew/tmp/audio_$$.ac3 > /dev/null 2>&1
		echo "converting track to mp3..."
		ffmpeg -i /anew/tmp/audio_$$.ac3 -acodec libmp3lame -ab 160k -ac 2 /anew/tmp/audio_$$.mp3 > /dev/null 2>&1
		echo "merging video with audio..."
		/usr/bin/mkvmerge -o /anew/tmp/tmp_videofile.mkv "$file" /anew/tmp/audio_$$.mp3 > /dev/null 2>&1
		echo "moving merged file to $file..."
		mv -f /anew/tmp/tmp_videofile.mkv "$file"
		echo "cleaning up temp files..."
		rm -f /anew/tmp/audio_$$.mp3
		rm -f /anew/tmp/audio_$$.ac3
		echo "naming audio tracks..."
		bash /tmp/propedit.$$
                rm -f /tmp/propedit.$$
	else
		echo "already has mp3 track..."
	fi
done

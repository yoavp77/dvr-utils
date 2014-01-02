#!/bin/bash

for file in `find /recordings/ -name "*.edl"`; do
	tsfile=`echo $file | sed 's/edl$/ts/g'`
	if [ ! -e "$tsfile" ]; then
		echo "******** $0 deleting $file..." >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1
		rm -f $file
	fi
done

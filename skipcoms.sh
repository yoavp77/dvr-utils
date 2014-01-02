#!/bin/bash
# script to process recordings and generate .edl (commercial skip) files. works with sagetv.

find /var/tmp/ -maxdepth 1 -name .comskip.lock -mtime +1 -exec rm -f {} \;

if [ -e /var/tmp/.comskip.lock ] ; then
	exit 0
fi

export HOME=/root

export PATH=/usr/bin:$PATH

touch /var/tmp/.comskip.lock

echo "`date '+%H:%M'` $0 starting ..." >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1

for file in `find /recordings/ -mmin +2 -name "*.ts"`; do
	echo "`date '+%H:%M'` checking $file..." >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1
	processed=`echo $file | sed 's/ts$/edl/g'`
	if [ ! -e "$processed" ]; then
		echo "`date '+%H:%M'` $file has not yet been processed..." >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1
		size1=`stat -c %s $file`
		sleep 5
		size2=`stat -c %s $file`
		
		if [ "$size1" == "$size2" ]; then
			echo "`date '+%H:%M'` processing $file..." >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1
			echo "`date '+%H:%M'` RUNNING WINE" >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1
			/usr/bin/wine /usr/local/bin/comskip.exe -q -v 0 -t $file >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1
			#/usr/bin/wine /usr/local/bin/comskip.exe -q -v 0 -t $file >> /var/log/comskip/wine.log 2>&1
			touch $processed
			rm -f /recordings/*txt
			rm -f /recordings/*log
			echo "`date '+%H:%M'` done processing $file" >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1
		else
			echo "`date '+%H:%M'` $file is still recording" >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1
			
		fi
	else
		echo "`date '+%H:%M'` $file has already been processed" >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1
	fi
done

find /var/log/comskip/ -type f -name "comskip_*" -mtime +14 -exec rm -f {} \;
echo "`date '+%H:%M'` $0 finished" >> /var/log/comskip/comskip_`date '+%Y%m%d'`.log 2>&1

rm -f /var/tmp/.comskip.lock

#!/bin/bash
# script to notify you if anyone logs into your system from a new computer. run through cron

who | awk -F'(' '{print $NF}' | sort | uniq > /var/tmp/who.now

diffcount=`comm -23 /var/tmp/who.now /var/tmp/who.prev | wc -l`

if [ $diffcount -ne 0 ]; then
	export EMAIL="Login Alert <loginalert@example.com>"
	w | mutt -s "New Login Detected On DVR" user@example.com
	sort /var/tmp/who.now /var/tmp/who.prev | uniq > /tmp/logins.$$
	mv /tmp/logins.$$ /var/tmp/who.prev
fi


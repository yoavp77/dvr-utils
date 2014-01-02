#!/bin/bash

# script to backup personal photos and videos to S3. it's getting a little expensive 
# so amazon glacier is probably the next step

today=`date '+%Y%m%d'`
cd /directory/Pictures
echo "starting picture backup at `date`" >> /var/log/backup/backup_$today.log
/usr/bin/s3cmd --verbose --no-delete-removed sync ./ s3://s3container
cd /directory/Family
echo "starting video backup at `date`" >> /var/log/backup/backup_$today.log
/usr/bin/s3cmd --verbose --no-delete-removed sync ./ s3://s3container
echo "finished video backup at `date`" >> /var/log/backup/backup_$today.log

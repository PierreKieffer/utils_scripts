#!/bin/bash

####
# HDFS purge allows you to delete stored files older than the retention time (days as integer) .

if [ -z "$1" ]
  then
    echo "No argument supplied : You need to pass retention time as argument (number of days)"
exit 1
fi

retentionTime=$1
DATE="$(date)"
today_unix="$(date +%s)"
logFile=/path/log/purgeHDFS.log

hdfsDirs=(
/hdfs/path
)

function clean_hdfsDirs {
for hdfsDir in ${hdfsDirs[*]}; do
        hdfs dfs -ls $hdfsDir | while read line ; do
        file_date=$(echo ${line} | awk '{print $6}')
        file_date_unix=$(date --date=$file_date +%s)
        difference=$(( ( $today_unix - $file_date_unix ) / ( 24*60*60 ) ))
        filePath=$(echo ${line} | awk '{print $8}')
        if [ ${difference} -gt $retentionTime ]; then
                #echo $file_date
                echo " >> Deleting the file" $filePath
                hdfs dfs -rm -r -skipTrash $filePath
        fi
        done
done
}

echo "__________ Running HDFS Purge __________"
echo " >>>>>>>> Cleaning HDFS Data Storage ..."
echo "$DATE  INFO  Purge HDFS : Start cleaning HDFS Data Storage" >> $logFile
clean_hdfsDirs
echo "$DATE  INFO  Purge HDFS : HDFS Purge completed" >> $logFile
echo "__________ HDFS Purge completed __________"




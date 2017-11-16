#!/bin/sh

# Database credentials
DBUSER='blah'
DBPWD='blahblahblah'
HOST='127.0.0.1'
DB_NAME=(db1 db2)

# Other options
BACK_PATH='/path/to/your/backpath'

# Do the work
for i in "${DB_NAME[@]}"
do
mysqldump --user=$DBUSER --password=$DBPWD --host=$HOST $i | gzip > $BACK_PATH/MySQL_$i_`date +"%Y%m%d%H%M"`.sql.gz
done

# Remove the ones older than 3 days
find $BACK_PATH/ -type f -name *.sql.gz -mtime +3 -exec rm {} \;

# TODO Update backups to external storage, e.g., NAS, FTP

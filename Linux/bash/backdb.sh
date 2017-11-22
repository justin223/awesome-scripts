#!/bin/sh

# Database credentials
DBUSER='blah'
DBPWD='blahblahblah'
HOST='127.0.0.1'
DB_NAME=(db1 db2)

# Other options
BACKUP_DIR='/path/to/your/backup/dir'
DATETIME=`date +"%Y%m%d%H%M"`

# Do the work
for i in "${DB_NAME[@]}"
do
mysqldump --user=$DBUSER --password=$DBPWD --host=$HOST $i | gzip > $BACKUP_DIR/bak_$i_$DATETIME.sql.gz
done

# Remove the ones older than 3 days
find $BACKUP_DIR/ -type f -name *.sql.gz -mtime +3 -exec rm {} \;

# TODO Upload backups to external storage, e.g., NAS, FTP or NFS server

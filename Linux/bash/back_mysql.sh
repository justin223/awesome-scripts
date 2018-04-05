#!/bin/sh

# Database credentials
DBUSER=blah
DBPWD=blahblahblah
HOST=127.0.0.1
DB_NAME="db1 db2"

# Other options
BACKUP_DIR='/path/to/your/backup/dir'
DATETIME=`date +"%Y%m%d%H%M"`
MYSQLDUMP=$(which mysqldump)
GZIP=$(which gzip)

# Do the work
for i in $DB_NAME
do
    $MYSQLDUMP --user=$DBUSER --password=$DBPWD --host=$HOST $i > "$BACKUP_DIR/MySQL_$i-$DATETIME.sql" 
#    $GZIP "$BACKUP_DIR/MySQL_$i-$DATETIME.sql" > $BACKUP_DIR/MySQL_$i_$DATETIME.sql.gz
    $GZIP "$BACKUP_DIR/MySQL_$i-$DATETIME.sql" 
done

# Upload backups to external storage, e.g., NAS, FTP or NFS server
mkdir /mnt/cptemp
mount -t nfs 1.2.3.4:/nfsshare /mnt/cptemp
# or CIFS share
# mount -t cifs -o username=user,password=pass,domain=example.com //1.2.3.4/cifsshare /mnt/cptemp
if [ $? -eq 0]; then
    for i in $DB_NAME
    do
        cp $BACKUP_DIR/MySQL_$i-$DATETIME.sql.gz /mnt/cptemp
    done
    umount /mnt/cptemp
else
    echo "Mount error: $?"
fi

# Remove the ones older than 3 days
find $BACKUP_DIR/ -type f -name *.sql.gz -mtime +3 -exec rm {} \;
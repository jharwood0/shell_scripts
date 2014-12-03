#!/bin/bash


# Dumping the database for backup

USER="root"
PASSWORD="741852963"
OUTPUT="/backup/"
 
rm "$OUTPUTDIR/*gz" > /dev/null 2>&1
 
databases=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
 
for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump --force --opt --user=$USER --password=$PASSWORD --databases $db > $OUTPUT/`date +%Y%m%d`.$db.sql
        gzip $OUTPUT/`date +%Y%m%d`.$db.sql
    fi
done

# Backup up the Home Directory into iso
mkisofs -o home.iso /home

# backup -o webspace.iso /var/www/htdocs
mkisofs -o webspace.iso /var/www/htdocs

###done#### 

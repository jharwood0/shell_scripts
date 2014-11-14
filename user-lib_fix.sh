
# TO DO
#Make sure that the fle is not a directory

FILES="/usr/lib/*"

for f in $FILES
do

        ext=$(echo $f |awk -F . '{if (NF>1) {print $NF}}')

        if [ "$ext" != "la" ]
        then
                #echo "Processing $f"
                fname=$(basename $f)
                #fname="$f" | cut -d'.' --complement -f2-
                fname=$(echo $fname |awk -F . '{if (NF=1) {print $NF}}')
                echo $fname
        fi

done

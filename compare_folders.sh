FILES="/usr/lib/*"
CHECKFILES="/usr/lib_backup/"
errorFiles=""
fileToCheck=""
for f in $FILES
do
        fullFileName=$(basename $f)
        searchFile="$CHECKFILES$fullFileName"

        if [[ -f $fullFileName ]]
        then
                fileToCheck=$(find $searchFile)
                if [ "$fileToCheck" != "$searchFile" ]
                then
                        errorFiles="$errorFiles $fullFileName\n"
                fi
        fi
done

echo -e "The following files couldn't be found\n" $errorFiles

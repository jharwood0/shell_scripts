#!/bin/bash
final=()

password="741852963"
#FinallY works fuck
#NOTE FINAL SIZE DOES NOT GET REDUCED
function remove_duplicates {
i=0
stop=${#final[@]}
while [ "$i" -le "$stop" ]
do
	j=0

	while [ "$j" -le "$stop" ]
	do
		if [ $i -ne $j ] #same position ignore
		then
			c=${final[$i]}
			d=${final[$j]}
			if [ "$c" = "$d" ] && [ ! -z "$c" ] #if same and not null
			then
				final[$j]=""
			fi
		fi
		((j++))
	done
	((i++))
done

}
readarray array < cnos.csv #puts each line into array
for element in "${array[@]}" #foreach element in array...
do
	csv=""
	IFS=',' read -a csv <<< "$element" #this works on fedora

	username=${csv[2]}

	if [ "$username" = "jharwood0" ] || [ "$username" = "scully" ]
	then
		echo "skipping $username"
	else
		echo $username
		out="nothing"
		out=$(lastcomm $username) #only run command if not admin (too many commands)
		IFS=$'\n'
		i=0
		if [ -z "$out" ]
		then
			echo "empty output, user has not run any commands"
		else
			for line in $out
			do
				#wipe all used vars
				enil=$(echo "$line"|rev) #set a reverse of the line

				IFS=" "
				read -a arr <<< "$line" #split by space
				read -a rra <<< "$enil" #split reverse of line
				process="${arr[0]}"
				date=$(echo "${rra[0]} ${rra[1]} ${rra[2]} ${rra[3]}" | rev) #get date and reverse it so readable
				data="$process $date"
				final[$i]=$data
				((i++))
			done
			echo "removing dups"
			remove_duplicates

			echo "creating queries"
			IFS=$'\n'
			for a in ${final[@]}
			do
				#echo "$a"
				IFS=" "
			        read -a arr <<< "$a"
				process=${arr[0]}
				badtime="${arr[1]} ${arr[2]} ${arr[3]} ${arr[4]}" #structure datetime
				datetime=$(date -d "$badtime" +'%Y-%m-%d %H:%M:%S') #convert date and time to mysql datetime
				mysql -u root -p741852963 << END #have to use heredoc because mysql command is so big 
use auditing;
INSERT INTO user_programs(username,process_name,time)
VALUES('$username','$process','$datetime');
END

			done
		final=() #reset final
		fi
	fi
done

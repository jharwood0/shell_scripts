#Unlocks necessary files
chattr -i /etc/group
chattr -i /etc/gshadow
chattr -i /etc/passwd
chattr -i /etc/shadow

readarray array < cnos.csv #puts each line into array
for element in "${array[@]}" #foreach element in array...
do
    	IFS=',' read -a csv <<< $element #separate all text in line by commas
    	command="useradd -m -k /etc/skel -s /bin/rbash -g student -c \"${csv[1]} ${csv[0]}\" ${csv[2]}"

    	#-m makes home directory
	#-k /etc/skel puts everything in /etc/skel to /home/$user
	#-s shell settings
	#-g group
	#-c offically "Comments" but used for full name
	#last var is for username

	echo $command
    	eval $command #evaluates the command and runs it
	
	#this will use chpasswd to change the password of the user
	#easier than encrypting the password by hand - bit dirty but better than nothing
    	password="echo ${csv[2]}:${csv[3]} | chpasswd"
    	eval $password
    	echo $password
	
	#creates the dir of their website
    	website="mkdir /var/www/htdocs/${csv[2]}"
    	eval $website
    	echo $website
	
	#creates an idex file that will state which user space it is
    	index="printf \"<html>\n<head>\n</head>\n<body>\n<h1>Welcome to ${csv[1]} ${csv[2]}'s userspace\n </h1></body></html>\" > /var/www/${csv[2]}/index.html"   	 
    	#printf because it uses \n
    	eval $index
    	echo $index

	#create symlink in userdir to their web user space
	#must be this way round so that we don't get a 403 error
	sym=”ln -s /var/www/htdocs/${csv[2]} /home/${csv[2]}/${csv[2]}”
	echo $sym
	eval $sym
	
	#to allow the user to modify it but and no one else we must chown the dir and the file we created so they can modify it
	#need to set permission for www
	chown="chown /var/www/htdocs/${csv[2]} ${csv[2]}"
	echo $chown
	eval $chown
	chown="chown /var/www/htdocs/${csv[2]}/index.html ${csv[2]}"
	echo $chown
	eval $chown

    	#this is no longer needed, i have added .bash_profile to /etc/skel
    	#.bash_profile
    	#bash="echo \"PATH=/usr/rbin\" > /home/${csv[2]}/.bash_profile"
    	#eval $bash
    	#echo $bash

    	#chmod their home directory so only they can open it
    	chmod="chmod 700 /home/${csv[2]}"
    	eval=chmod
    	echo $chmod
	
	firstlogin="chage -d 0 ${csv[2]}"
	eval=firstlogin
	echo $firstlogin

	##for reference##
    	#echo "last name: ${csv[0]}"
    	#echo "first name: ${csv[1]}"
    	#echo "username: ${csv[2]}"
    	#echo "id: ${csv[3]}"
done

#Locks files again for security reasons.
chattr +i /etc/group
chattr +i /etc/gshadow
chattr +i /etc/passwd
chattr +i /etc/shadow

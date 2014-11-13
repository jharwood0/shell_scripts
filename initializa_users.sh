echo "creating array"
readarray array < test.txt
for element in "${array[@]}"
do
    	#echo $element
    	IFS=',' read -a csv <<< $element
    	command="useradd -m -k /etc/skel -s /bin/rbash -g student -c \"${csv[1]} ${csv[0]}\" ${csv[2]}"
    	echo $command
    	eval $command

    	password="echo ${csv[2]}:${csv[3]} | chpasswd"
    	eval $password
    	echo $password

    	website="mkdir /var/www/${csv[2]}"
    	eval $website
    	echo $website

    	index="printf \"<html>\n<head>\n</head>\n<body>\n<h1>Welcome to ${csv[1]} ${csv[2]}'s userspace\n </h1></body></html>\" > /var/www/${csv[2]}/index.html"   	 
    	#printf because it uses \n
    	eval $index
    	echo $index

#create symlink in userdir (NOT TESTED YET)
sym=”ln -s /var/ww/htdocs/${csv[2]} /home/${csv[2]}/${csv[2]}”
echo $sym
eval $sym

#need to set permission for www
#chown /var/www/htdocs/$username
#chown /var/www/htdocs/$username/index.html
#sorted

    	#this is no longer needed, i have added .bash_profile to /etc/skel
    	#.bash_profile
    	#bash="echo \"PATH=/usr/rbin\" > /home/${csv[2]}/.bash_profile"
    	#eval $bash
    	#echo $bash

    	#chmod their home directory so only they can open it
    	chmod="chmod 700 /home/${csv[2]}"
    	#eval=chmod
    	echo $chmod

    	#echo "last name: ${csv[0]}"
    	#echo "first name: ${csv[1]}"
    	#echo "username: ${csv[2]}"
    	#echo "id: ${csv[3]}"
done


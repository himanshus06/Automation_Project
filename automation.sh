#!/bin/bash

name="himanshu"
s3_bucket="upgrad-himanshu"

#apt-get update -y
echo "Your machine is updated"


#Apache installation if required
package=`dpkg --get-selections apache2 | awk '{ print $2 }'`
#echo $package

if [[ $Package != "install" ]]
 then
        echo "installing the same"
	apt-get install apache2 -y
fi

#Apache service is active or inactive, if inactive then enable it 
service=`systemctl is-active apache2.service | awk '{ print $1 }'`
echo $service

if [[ ${service} -eq "active" ]]
 then
        echo "I in active status no need to enable me"
else
        echo "I starting the process for you"
        systemctl start apache2
fi

#To check the apache server is enabled or not

service_enabled=$(systemctl is-enabled apache2 | grep "enabled")

if [[ enabled != ${Status_Enabled} ]];
then
	#I am starting to enable it
	systemctl enable apache2
fi


timestamp=$(date '+%d%m%Y-%H%M%S')

#tar the file into the /temp folder 
cd /var/log/apache2
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

#Checking if thr file exist or not in the folder then moving it to S3
filetar="${name}-httpd-logs-${timestamp}.tar" 

if [[ -f /tmp/"$filetar" ]]
   then 
	echo "Moving the file to the S# bucket" 
	aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
else 
	echo "File doesn't exist do you want to create it"
fi


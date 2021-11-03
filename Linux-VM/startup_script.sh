#!/bin/bash
source /etc/os-release
echo "$PWD"
os_vendor=`echo $ID`
if [ "$os_vendor" = "centos" ]
  then
    sudo yum install epel-release -y 
	sudo yum install ansible -y 
elif [ "$os_vendor" = "suse" ]
  then
    sudo zypper update
	sudo zypper install ansible -y 
else 
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt install ansible -y 
fi
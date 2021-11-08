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

sudo sh -c "apt update && yes | apt install openjdk-11-jdk && java -version"
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get -y install postgresql postgresql-contrib


sudo systemctl start postgresql
sudo systemctl enable postgresql

su - postgres -c "createuser sonar"

sudo -u postgres psql -c  "ALTER USER sonar WITH ENCRYPTED password 'Raghu@123';"
sudo -u postgres psql -c  "CREATE DATABASE sonarqube OWNER sonar;"
sudo -u postgres psql -c  "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"

sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip
sudo apt-get -y install unzip
sudo unzip sonarqube*.zip -d /opt
sudo mv /opt/sonarqube-9.1.0.47736 /opt/sonarqube -v

sudo groupadd sonar
sudo useradd -c "Sonar System User" -d /opt/sonarqube -g sonar -s /bin/bash sonar
sudo chown -R sonar:sonar /opt/sonarqube
sudo chmod 775 /opt/sonarqube

sudo sed -i -e 's/#sonar.jdbc.username=/sonar.jdbc.username=sonar/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.jdbc.password=/sonar.jdbc.password=Raghu@123/g' /opt/sonarqube/conf/sonar.properties
echo "sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube" >> /opt/sonarqube/conf/sonar.properties


echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=262144" >> /etc/sysctl.conf

sysctl -p

su - sonar -c " sh /opt/sonarqube/bin/linux-x86-64/sonar.sh start"




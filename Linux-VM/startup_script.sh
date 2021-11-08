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

sudo apt-get update && sudo apt-get install default-jdk -y
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get -y install postgresql postgresql-contrib

sed -i -e '1ilocal    postgres     postgres     peer\' /etc/postgresql/10/main/pg_hba.conf

echo "postgres:postgres" | chpasswd
echo "postgres" | passwd --stdin postgres
service postgresql restart
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo systemctl enable postgresql


sudo systemctl start postgresql
sudo systemctl enable postgresql

su - postgres -c "createuser sonar"

sudo -u postgres psql -c  "ALTER USER sonar WITH ENCRYPTED password 'Raghu@123';"
sudo -u postgres psql -c  "CREATE DATABASE sonarqube OWNER sonar;"
sudo -u postgres psql -c  "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"

sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.6.0.39681.zip
sudo apt-get -y install unzip
sudo unzip sonarqube*.zip -d /opt
sudo mv /opt/sonarqube-8.6.0.39681 /opt/sonarqube -v

sudo sed -i -e 's/#sonar.jdbc.username=/sonar.jdbc.username=sonar/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.jdbc.password=/sonar.jdbc.password=Raghu@123/g' /opt/sonarqube/conf/sonar.properties
echo "sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube" >> /opt/sonarqube/conf/sonar.properties

echo "[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
LimitNOFILE=131072
LimitNPROC=8192
User=sonar
Group=sonarGroup
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/sonar.service

echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf

echo "sonar   -   nofile   65536" >> /etc/security/limits.conf
echo "sonar   -   nproc    4096" >> /etc/security/limits.conf

sudo sysctl -p

sudo service sonarqube start
sudo systemctl enable sonar


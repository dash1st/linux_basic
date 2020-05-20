#!/bin/bash
####################################################
##  THIS IS CREATED BY Sean Yun For One line setup                 ##
##  WEB SERVER :  Apache / Nginx 
##  Language     : PHP7 / python3
##  DB             :  Mysql / PostgreSQL
##  Application   : Docker / RedMine / Visitor System
##  Created 2020-05-09
####################################################
clear
echo "5. APPLICATION SETUP";
echo "5-4. REDMINE";
sleep 3;
#################### RED MINE ######################

cat <<EOT >> /root/docker_redmine_compose.yml
version: '3.1'

services:
     redmine:
          network_mode: "host"
          image: redmine
          restart: always
          container_name: redmine
          ports:
               - 3000:3000
          environment:

#              REDMINE_DB_POSTGRES: 172.17.0.1
#              REDMINE_DB_PORT: 5432
               REDMINE_DB_MYSQL: 172.17.0.1
               RDEMINE_DB_PORT: 3306
               REDMINE_DB_USERNAME: redmine
               REDMINE_DB_PASSWORD: Samsung@11
               REDMINE_DB_DATABASE: redmine
               REDMINE_DB_ENCODING: utf8
          volumes:
               - /home/docker/redmine/data:/usr/src/redmine/data
               - /home/docker/redmine/plugins:/usr/src/redmine/plugins
               - /home/docker/redmine/themes:/usr/src/redmine/public/themes

EOT

################### DOCKER REDMINE EXE ####################
docker-compose -f /root/docker_redmine_compose.yml up -d

####################################################
clear
echo "5. APPLICATION SETUP";
echo "5-5. FIREWALL / PHP / Python / MOUNT ";
sleep 3;

##################### FIREWALL CONF ######################

#redmine
firewall-cmd --add-port=3000/tcp --permanent
#apache
firewall-cmd --add-port=80/tcp --permanent
#nginx
firewall-cmd --add-port=8089/tcp --permanent

firewall-cmd --reload

#fw 확인
firewall-cmd --list-ports



###################### PHP7 INSTALL #######################

yum -y install epel-release
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

yum -y install mod_php72w php72w-cli
yum -y install php72w-bcmath php72w-gd php72w-mbstring php72w-mysqlnd php72w-pear php72w-xml php72w-xmlrpc php72w-process

php -v


echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

# 특별히 php 깔고 나서 httpd 을 리스타트
systemctl stop httpd
systemctl start httpd

######################## Python 3 ########################
#knox 연동 pip
#yum install python36-setuptools 
#sudo easy_install-3.6 pip 
#pip3 install beautifulsoup4
#pip3 install lxml


#################### Synology NAS MOUNT ##################
yum -y install nfs-utils
mkdir /NAS
mount -t nfs 192.168.0.14:/volume1/web /NAS
df -h


cp /NAS/DB_redmine.sql /home/docker/redmine/data

# Red mine DB 복구 
mysql -uredmine -pSamsung@11 redmine < /home/docker/redmine/data/DB_redmine.sql


# CVMS install #
cp /NAS/CVMS.zip /var/www/html

unzip /var/www/html/CVMS.zip

mysql -uroot -pSamsung@11 -e "CREATE USER 'cvms'@'%.%.%.%' IDENTIFIED BY 'Samsung@11';"
mysql -uroot -pSamsung@11 -e "CREATE DATABASE IF NOT EXISTS \`cvmsdb\` DEFAULT CHARACTER SET \`utf8\` COLLATE \`utf8_unicode_ci\`;"
mysql -uroot -pSamsung@11 -e "grant all privileges on cvmsdb.* to 'cvms'@'%' identified by 'Samsung@11';"
mysql -uroot -pSamsung@11 -e "grant all privileges on cvmsdb.* to 'cvms'@'localhost' identified by 'Samsung@11';"
mysql -uroot -pSamsung@11 -e "SELECT Host,User,authentication_string FROM mysql.user;"
mysql -uroot -pSamsung@11 -e "flush privileges;"
mysql -uroot -pSamsung@11 cvmsdb < /var/www/html/CVMS_SQL/cvmsdb.sql

echo
echo " /var/www/html/cvms/includes/dbconnection.php  ::>>>   PLZ CHANGE THE DB CONNECTION INFORMATION ";
echo


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
echo "5-1. DOCKER";
sleep 3;
################## Docker Install #######################

curl -sSL https://get.docker.com | sh

docker --version
sudo usermod -aG docker root
systemctl start docker
systemctl enable docker

############### Docker Compose install ##################
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version


####################################################
clear
echo "5. APPLICATION SETUP";
echo "5-2. WEB";
sleep 3;
##################### APACHE ########################

yum -y install httpd

#httpd.conf
#    AddType application/x-httpd-php .php .php3 .php4 .inc
#    AddType application/x-httpd-php-source .phps

##################### NGINX #########################

#yum repo 설정 새로 만들기#
echo "[nginx]" >> /etc/yum.repos.d/nginx.repo
echo "name=nginx repo"  >> /etc/yum.repos.d/nginx.repo
echo "baseurl=http://nginx.org/packages/centos/7/\$basearch/" >> /etc/yum.repos.d/nginx.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
echo "enabled=1" >> /etc/yum.repos.d/nginx.repo

# nignx 설치#
yum install -y nginx

#firewall 설정 8089포트##
#firewall-cmd --permanent --zone=public --add-port=8089/tcp
#firewall-cmd --reload
#firewall-cmd --list-ports

# 80->>8089로 값 변경##
#vi /etc/nginx/conf.d/default.conf
#listen 80;  ->  listen 8089;

sed -i 's:80;:8089;:g' /etc/nginx/conf.d/default.conf

#퍼미션 Deny 오류발생 시 8089포트 등록 ##
semanage port -a -t http_port_t -p tcp 8089

#nginx 데몬실행#
systemctl start nginx
systemctl status nginx
systemctl enable nginx

####################################################

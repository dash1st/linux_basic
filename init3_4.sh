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
echo "3. PACKAGE UPDATE & INSTALL";
sleep 3;
########### YUM PACKAGE UPDATE & INSTALL ##############

yum -y update
yum -y install bc
yum -y install vim
yum -y install psmisc
yum -y install lsof
yum -y install lrzsz
yum -y install curl
yum -y install wget
yum -y install net-tools
yum -y install telnet
yum -y install nc
yum -y install nmap
yum -y install expect
yum -y install mlocate
yum -y install ntp
yum -y install unzip

updatedb
####################################################
clear
echo "4. DATE&TIME SETUP";
sleep 3;
############### Time zone conf FOR INDIA ################

mv /etc/localtime /etc/localtime_org
ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime  

##################### NTP START #####################

systemctl start ntpd
systemctl status ntpd
systemctl enable ntpd


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
echo "1. NETWORK SETTING";
sleep 3;
###################### DHCP IP #######################

#echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-enp1s0

##################### WIRELESS #######################

################## STATIC IP SETTING ###################
cat /dev/null > /etc/sysconfig/network-scripts/ifcfg-enp1s0
cat <<EOT >> /etc/sysconfig/network-scripts/ifcfg-enp1s0
DEVICE=enp1s0
BOOTPROTO=none
ONBOOT=yes
PREFIX=24
IPADDR=192.168.0.34
TYPE=Ethernet

EOT
############## HOSTNAME & GATEWAY###################
echo "NETWORK=yes" >> /etc/sysconfig/network
echo "HOSTNAME=redmine" >> /etc/sysconfig/network
echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network

#################### DNS CONF ######################
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 4.4.4.4" >> /etc/resolv.conf

################### HOSTS CONF ######################
#/etc/hosts conf

echo "redmine 127.0.0.1" >> /etc/hosts
echo "redmine 192.168.0.34" >> /etc/hosts

#/etc/hostname
echo "redmine" > /etc/hostname
####################################################
clear
echo "2.BASIC CONFIGURE FOR USER";
sleep 3;
############### bashrc Basic conf setup ###################

echo "HISTSIZE=10000" >> /etc/bashrc
echo "HISTFILESIZE=20000" >> /etc/bashrc
echo "export HISTTIMEFORMAT=\"[%Y/%m/%d %H:%M:%S] \"" >> /etc/bashrc
echo "alias ll='ls -al --color'" >> /etc/bashrc
echo "alias vi='vim'" >> /etc/bashrc
echo "PS1=\"\n\033[0;33m\t \d \033[0m\033[0;32m[\u@\h \w (\$(lsbytesum) Mb)]\033[0m\n#\"" >> /etc/bashrc 

################## lsbytesum script #####################

cat <<EOT >> /bin/lsbytesum
#!/bin/bash
# lsbytesum - sum the number of bytes in a directory listing
TotalBytes=0
for Bytes in \$(ls -l | grep "^-" | awk '{ print \$5 }')
do
    let TotalBytes=\$TotalBytes+\$Bytes
done
TotalMeg=\$(echo -e "scale=3 \n\$TotalBytes/1048576 \nquit" | bc)
echo -n "\$TotalMeg"

EOT

chmod 755 /bin/lsbytesum
source /etc/bashrc

############### Laptop Do not Turn off ##################

echo "HandleLidSwitch=ignore" >> /etc/systemd/logind.conf
systemctl restart systemd-logind

#console Do not Turn off
echo "setterm -blank 0" >> /etc/bashrc

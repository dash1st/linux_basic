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
echo "5-3. DATABASE";
sleep 3;
####################### MYSQL ######################
wget http://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum -y localinstall mysql57-community-release-el7-11.noarch.rpm
yum repolist enabled | grep "mysql.*-community.*"
yum -y install mysql-community-server 

systemctl start mysqld
systemctl enable mysqld
systemctl status mysqld

NEWPASS="Samsung@11";

PASS=`cat /var/log/mysqld.log | grep temporary | grep root | awk '{print $NF}'`
cat /var/log/mysqld.log | grep temporary | grep root | awk '{print $NF}'

#temppass
#new pass
#confirm pass
#remove anonymous
#disapplow remote root login
#remove test db
#reload


expect -c"

spawn mysql_secure_installation;
expect {
root: {send \"$PASS\r\"; exp_continue}

password: {send \"$NEWPASS\r\"; exp_continue}

password: {send \"$NEWPASS\r\"; exp_continue}

No) : {send \"y\r\"; exp_continue}


No) : {send \"n\r\"; exp_continue}

No) : {send \"y\r\"; exp_continue}

No) : {send \"y\r\"; exp_continue}

};

exit;
"

mysql -uroot -p$NEWPASS -e "CREATE USER 'redmine'@'%.%.%.%' IDENTIFIED BY 'Samsung@11';"
mysql -uroot -p$NEWPASS -e "CREATE DATABASE IF NOT EXISTS \`redmine\` DEFAULT CHARACTER SET \`utf8\` COLLATE \`utf8_unicode_ci\`;"
mysql -uroot -p$NEWPASS -e "grant all privileges on redmine.* to 'redmine'@'%' identified by 'Samsung@11';"
mysql -uroot -p$NEWPASS -e "grant all privileges on redmine.* to 'redmine'@'localhost' identified by 'Samsung@11';"
mysql -uroot -p$NEWPASS -e "SELECT Host,User,authentication_string FROM mysql.user;"
mysql -uroot -p$NEWPASS -e "flush privileges;"


################### POSTGRE SQL #####################

wget https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
rpm -ivh pgdg-redhat-repo-latest.noarch.rpm
yum -y install postgresql96-server postgresql96

# 상위 경로도 같이 생성 -p
mkdir -p /home/postgres/data

chown -R postgres.postgres /home/postgres/

su - postgres -c "/usr/pgsql-9.6/bin/initdb -D /home/postgres/data"

# PGDATA path change
sed -i 's:Environment=PGDATA=/var/lib/pgsql/9.6/data/:Environment=PGDATA=/home/postgres/data/:g' /usr/lib/systemd/system/postgresql-9.6.service

# postgresql.conf change
echo "listen_addresses = '*'" >> /home/postgres/data/postgresql.conf
echo "port = 5432" >> /home/postgres/data/postgresql.conf

#패스워드 변경
#su - postgres
#psql
#ALTER USER postgres PASSWORD 'Samsung@11';
#CREATE ROLE redmine LOGIN ENCRYPTED PASSWORD 'Samsung@11' NOINHERIT VALID UNTIL 'infinity'; 
#CREATE DATABASE redmine WITH ENCODING='UTF8' OWNER=redmine;
#\q

# vi /home/postgres/data/pg_hba.conf 수정
#local   all             all                                     md5
#host    all             all             0.0.0.0/0               md5
#host    all             all             ::1/128                 md5

systemctl enable postgresql-9.6
systemctl start postgresql-9.6
systemctl status postgresql-9.6

## postgre PATH 추가 

echo "PATH=\$PATH:/usr/pgsql-9.6/bin/" >> /etc/profile
echo "export PATH" >> /etc/profile

####################################################


#!/usr/bin/env sh

# If mysql db directory is empty
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  
  /usr/bin/mysql_install_db

  /usr/bin/mysqld_safe > /dev/null 2>&1 &
  /bin/sleep 2s

  /usr/bin/mysqladmin -u root password 'password'
  /usr/bin/mysqladmin -u root password 'password'
  
  /usr/bin/killall mysqld
  /bin/sleep 2s

fi

# Start Mysql
/usr/bin/mysqld_safe > /dev/null 2>&1 &
/bin/sleep 2s


#if ! mysql -uroot -ppassword -e 'use PAR'; then
#	# Create Database
#	mysql -uroot -ppassword -e "CREATE DATABASE PAR"
#
#	# Create (unsafe) HelpSpot user, who can connect remotely
#	mysql -uroot -ppassword -e "GRANT ALL PRIVILEGES ON *.* to 'PARProd'@'%' IDENTIFIED BY 'password';"
#
#	mysql -uroot -ppassword PAR < /etc/mysql/dev_db.sql;
#fi


# Shutdown MySQL
##mysqladmin -uroot -ppassword shutdown

#Start mongo
mongod
/sbin/my_init
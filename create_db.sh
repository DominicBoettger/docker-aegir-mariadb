#!/bin/bash
#===============================================================================
#
#    AUTHOR: Dominic Böttger <Dominic.Boettger@inspirationlabs.com
#
#===============================================================================
echo "Creating Database"
echo $AEGIR_DB_PASSWORD
mysql -h localhost -u root <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'aegir_root'@'%' IDENTIFIED BY '$AEGIR_DB_PASSWORD';
UPDATE user SET Password=PASSWORD('$MYSQL_ROOT_PW') WHERE User='root';
FLUSH PRIVILEGES;
EOF
#===============================================================================
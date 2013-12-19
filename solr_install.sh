#!/bin/sh
# Solr installation
if [ -z "$SOLR_VERSION" ]; then
	SOLR_VERSION=4.6.0
fi

if [ -z "$SOLR_PASS" ]; then
	SOLR_PASS=ajas924r42hasd
fi

cd ~/

if [ -d "/var/lib/tomcat6" ] ; then
	echo "Tomcat already installed"
else
	apt-get -y install tomcat6 tomcat6-admin tomcat6-common tomcat6-user
fi

if [ -f "/usr/share/tomcat6/webapps/solr4.war" ]; then
	echo "Solr already initialized"
else
	echo "Installing solr"
	wget --quiet http://ftp.halifax.rwth-aachen.de/apache/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz
	tar xvzf solr-$SOLR_VERSION.tgz

	mkdir /usr/share/tomcat6/webapps
	cp ~/solr-$SOLR_VERSION/dist/solr-$SOLR_VERSION.war /usr/share/tomcat6/webapps/solr4.war

	mkdir -p /usr/share/solr4/
	cp -R ~/solr-$SOLR_VERSION/* /usr/share/solr4/

	cp -R ~/solr-$SOLR_VERSION/example/lib/ext/* /usr/share/tomcat6/lib/
	cp ~/solr-$SOLR_VERSION/example/resources/log4j.properties  /usr/share/tomcat6/lib/

	echo "<Context docBase=\"/usr/share/tomcat6/webapps/solr4.war\" debug=\"0\" privileged=\"true\" allowLinking=\"true\" crossContext=\"true\">\r
	\t    <Environment name=\"solr/home\" type=\"java.lang.String\" value=\"/usr/share/solr4/main/multicore\" override=\"true\" />\r
	</Context>" > /etc/tomcat6/Catalina/localhost/solr4.xml

	echo "<tomcat-users>\r
	\t    <role rolename=\"admin\"/>\r
	\t    <role rolename=\"manager\"/>\r
	\t    <user username=\"solradmin\" password=\"$SOLR_PASS\" roles=\"admin,manager\"/>\r
	</tomcat-users>" > /etc/tomcat6/tomcat-users.xml

	cat /etc/tomcat6/tomcat-users.xml

	mkdir -p /usr/share/tomcat6/server/classes
	mkdir -p /usr/share/tomcat6/shared/classes

	_CHANGED="YES"
fi

if [ ! -d "/usr/share/solr4/main" ]; then
	echo "Init solr databas"
	cp -R /usr/share/solr4/example /usr/share/solr4/main
	rm -r /usr/share/solr4/main/example-DIH
	rm -r /usr/share/solr4/main/exampledocs
	rm -r /usr/share/solr4/main/solr-webapp

	wget --quiet http://ftp.drupal.org/files/projects/search_api_solr-7.x-1.x-dev.tar.gz 
	tar xvzf search_api_solr-7.x-1.x-dev.tar.gz 

	cp search_api_solr/solr-conf/4.x/* /usr/share/solr4/main/multicore/core0/conf/
	cp search_api_solr/solr-conf/4.x/* /usr/share/solr4/main/multicore/core1/conf/
	_CHANGED="YES"
fi

chgrp -R tomcat6 /usr/share/solr4
chmod -R 2750 /usr/share/solr4
chmod -R 2770 /usr/share/solr4/main/multicore

if [ -z "$_CHANGED" ]; then
	echo "restart tomcat"
	killall java
	/etc/init.d/tomcat6 restart
fi
echo "Solr install/checkup script done"
exit 0

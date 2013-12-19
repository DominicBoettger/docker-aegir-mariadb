docker-aegir-mariadb
====================

This is a Dockerfile and installations scripts to get a Aegir hosting system for Drupal up and running.

Services provided:

- Apache
- MariaDB
- Solr / Tomcat
- SSH

## How to use

First checkout this branch. Then go to the directory and build the docker image.

docker build -t namespace/aegir_maria .

After the successful build we can run a container instance. We are sharing multiple volumes with our host system.

1. /var/aegir
2. /var/log/apache2
3. /var/lib/mysql
4. /etc/mysql/conf.d
5. /var/log/mysql
6. /usr/share/solr4

We are creating these volumes in a directory named with the name of our new instance und /var/docker. For example /var/docker/aegir01/var/aegir.

### Run the container

After the container has been built we can run it. In the run command we add passwords, domain, hostname, version information, port mappings and file system volume mappings.

The database passwords can be changed.

docker run -d -v /var/docker/aegir01/usr/share/solr4:/usr/share/solr4 -v /var/docker/aegir01/var/aegir:/var/aegir -v /var/docker/aegir01/var/log/apache2:/var/log/apache2 -v /var/docker/aegir01/var/lib/mysql:/var/lib/mysql -v /var/docker/aegir01/etc/mysql/conf.d:/etc/mysql/conf.d -v /var/docker/aegir01/var/log/mysql:/var/log/mysql -e POSTFIX_MAILNAME=aegir01.mydomain.com -e POSTFIX_DESTINATION=aegir01.mydomain.com -e AEGIR_SITE=aegir01 -e AEGIR_FRONTEND_URL=aegir01.mydomain.com -e AEGIR_EMAIL=aegir01@mydomain.com -e AEGIR_DB_PASSWORD=CHANGEME -e AEGIR_VERSION=6.x-2.0-rc5 -e MYSQL_ROOT_PW=CHANGEME -e SOLR_PASS=CHANGEME -e SOLR_VERSION=4.6.0 -p 30880:8080 -p 30080:80 -p 30443:443 -p 30022:22  -h aegir01 -name aegir01 mydomain/aegir_maria


#!/bin/sh
if drush help | grep "^ provision-install" > /dev/null ; then
	echo "INFO: Provision already seems to be installed"
else 
	drush dl --destination=/var/aegir/.drush provision-$AEGIR_VERSION
	drush cache-clear drush
fi

if [ -e "/var/aegir/.drush/hostmaster.alias.drushrc.php" ] ; then
	echo "Hostmaster already installed"
else 
	OPTIONS="--yes --debug --aegir_host=$AEGIR_SITE --aegir_db_host=localhost --aegir_db_user=aegir_root --aegir_db_pass=$AEGIR_DB_PASSWORD --version=$AEGIR_VERSION  --client_email=$AEGIR_EMAIL --script_user=aegir --http_service_type=apache $AEGIR_FRONTEND_URL"
	echo $OPTIONS
	drush hostmaster-install $OPTIONS
	drush @hostmaster pm-enable -y hosting_queued
	cp /var/aegir/hostmaster-$AEGIR_VERSION/profiles/hostmaster/modules/hosting/queued/hosting_queued.conf /var/aegir
	cp /var/aegir/hostmaster-$AEGIR_VERSION/profiles/hostmaster/modules/hosting/queued/hosting_queued.sh /var/aegir
fi
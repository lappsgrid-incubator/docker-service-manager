#!/bin/bash
set -e

LOG=/usr/share/tomcat/service-manager/logs/catalina.out
SERVER=http://vassar:8080

service postgresql start
until pg_isready &>/dev/null ; do
	echo -n "."
	sleep 2
done

service tomcat start

if [ -d /etc/lddl ] ; then
	until [ -e $LOG ] ; do
		echo "Waiting for the Tomcat log to appear."
		sleep 2
	done
	
	# Watch the log file for the startup complete message from Tomcat
	
	# This should work, but doesn't...
	# tail -f $LOG | grep "INFO: Server startup in" | read -t 300 dummy_var
	
	# This is a hack, but it works.
	started=`cat $LOG | grep "INFO: Server startup in"`
	while [ -z "$started" ] ; do
		echo "Waiting for Tomcat to startup."
		sleep 2
		started=`cat $LOG | grep "INFO: Server startup in"`
	done
	cd /etc/lddl
	lddl Vassar.lddl -server=$SERVER
fi

tail -f $LOG


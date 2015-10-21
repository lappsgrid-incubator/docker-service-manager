#!/bin/bash
#set -e

LOG=/usr/share/tomcat/service-manager/logs/catalina.out
VASSAR=http://vassar:8080
BRANDEIS=http://brandeis:8080

service postgresql start
until pg_isready &>/dev/null ; do
	echo -n "."
	sleep 2
done

service tomcat start
until [ -e $LOG ] ; do
	echo "Waiting for the Tomcat log to appear."
	sleep 2
done
echo "Tomcat log file found."

# Watch the log file for the startup complete message from Tomcat

# This should work, but doesn't...
# tail -f $LOG | grep "INFO: Server startup in" | read -t 300 dummy_var

# This is a hack, but it works.
started=`cat $LOG | grep "INFO: Server startup in"`
while [ -z "$started" ] ; do
	echo "Waiting for Tomcat finish startup."
	sleep 2
	started=`cat $LOG | grep "INFO: Server startup in"`
done

echo "Initializing the service manager."
cd /etc/lddl
lddl Vassar.lddl -server=$VASSAR
lddl Brandeis.lddl -server=$BRANDEIS

tail -f $LOG


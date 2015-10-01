#!/bin/bash
LOG=/usr/share/tomcat/service-manager/logs/catalina.out
SERVER=http://vassar:8080

service postgresql start
until pg_isready &>/dev/null ; do
	echo -n "."
	sleep 2
done

service tomcat start

if [ -d /etc/lddl ] ; then
	# Watch the log file for the startup complete message from Tomcat
	tail -f $LOG | grep "INFO: Server startup in" | read -t 300 dummy_var
		cd /etc/lddl
		lddl Vassar.lddl -server=$SERVER
	else
		echo "Tomcat did not start in a timely fashion. Aborting."
	fi
fi

tail -f $LOG


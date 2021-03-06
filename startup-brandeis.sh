#!/bin/bash
service postgresql start
until pg_isready &>/dev/null ; do
	echo -n "."
	sleep 2
done
service tomcat start
if [ -d /etc/lddl ] ; then
	sleep 60
	cd /etc/lddl
	lddl Brandeis.lddl -server=http://brandeis:8080
fi

tail -f /usr/share/tomcat/service-manager/logs/catalina.out


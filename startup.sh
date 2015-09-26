#!/bin/bash
service postgresql start
until pg_isready &>/dev/null ; do
	echo -n "."
	sleep 2
done
service tomcat start

tail -f /usr/share/tomcat/service-manager/logs/catalina.out


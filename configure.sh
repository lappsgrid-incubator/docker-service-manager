#!/bin/bash
grep docker /etc/hosts &>/dev/null
if [ $? -eq "1" ] ; then
	echo "192.168.99.100 docker" >> /etc/hosts
fi
service postgresql start
until pg_isready &>/dev/null ; do
	echo -n "."
	sleep 2
done
service tomcat start
sleep 20
cd /etc/lddl
lddl Vassar.lddl -server=http://docker:8080

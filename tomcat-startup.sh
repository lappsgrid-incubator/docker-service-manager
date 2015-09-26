#!/bin/bash

### BEGIN INIT INFO
# Provides:          tomcat
# Required-Start:    $remote_fs $syslog postgresql
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts tomcat at boot time.
# Description:       Control script for Tomcat. 
### END INIT INFO


if [ -z "$JAVA_HOME" ] ; then
	# This is the typical default installation location on Debian and Ubunutu.
	# If this is different on your system either change this or ensure JAVA_HOME
	# is set before this script is run.
	#JAVA_HOME=/usr/lib/jvm/java-7-oracle
	JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
	if [ ! -d $JAVA_HOME ] ; then
		echo "Tomcat service can not start. JAVA_HOME has not been set."
		exit
	fi
fi

MANAGER=/usr/share/tomcat/service-manager
BPEL=/usr/share/tomcat/active-bpel
TOMCAT_USER=tomcat

function is_running()
{
	ps aux | grep java | grep $1 > /dev/null
	return $?	
}

function start()
{
	is_running $MANAGER
	if [ $? -ne 0 ] ; then		
		echo "Service manager starting."
		sudo -u $TOMCAT_USER $MANAGER/bin/startup.sh
	else
		echo "Service manager is already running."
	fi
	is_running $BPEL
	if [ $? -ne 0 ] ; then
		echo "Active BPEL starting"
		sudo -u $TOMCAT_USER $BPEL/bin/startup.sh
	else
		echo "BPEL service is already running."
	fi
}

function stop()
{
	is_running $MANAGER
	if [ $? -eq	 0 ] ; then
		echo "Service manager stopping."
		sudo -u $TOMCAT_USER $MANAGER/bin/shutdown.sh
	else
		echo "Service manager is already offline."
	fi
	
	is_running $BPEL
	if [ $? -eq 0 ] ; then
		echo "Active BPEL stopping."
		sudo -u $TOMCAT_USER $BPEL/bin/shutdown.sh
	else
		echo "Active BPEL is already offline."
	fi
}

case $1 in
	start)
		echo "Staring Tomcat instances..."
		start
		echo "Done."
		;;
	stop)
		echo "Stopping Tomcat instances..."
		stop
		echo "Done."
		;;
	restart)
		echo "Restarting Tomcat instances..."
		stop
		sleep 5
		start
		echo "Done."
		;;
	force-reload)
		echo "Forcing Tomcat instances to restart..."
		stop
		sleep 5
		for proc in `ps a | grep -e java -e tomcat | cut -d\  -f2` ; do
			echo "Killing zombie process $proc"
			kill -9 $proc
		done
		start
		echo "Done."
		;;
	force-stop)
		echo "Killing Tomcat..."
		stop
		sleep 5
		for proc in `ps a | grep -e java -e tomcat | cut -d\  -f2` ; do
			echo "Killing zombie process $proc"
			kill -9 $proc
		done
		echo "Done."
		;;
	status)
		is_running $MANAGER 
		if [ $? -eq 0 ] ; then
			echo "Service Manager: online"
		else
			echo "Service Manager: offline"
		fi
		
		is_running $BPEL
		if [ $? -eq 0 ] ; then
			echo "Active BPEL    : online"
		else
			echo "Active BPEL    : offline"
		fi
		echo
		;;
esac

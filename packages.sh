#!/bin/bash

# Since the .tgz packages are not kept in source control this script can be used
# to download the packages.

PACKAGE_LIST="tomcat lddl-scripts lsd lddl lappsgrid-services lappsgrid-gate lappsgrid-models MASC-3.0.0 brandeis-services"

if [ ! -d packages ] ; then
	mkdir packages
fi

cd packages

case "$1" in
	download)
		for package in $PACKAGE_LIST ; do
			wget http://www.anc.org/downloads/docker/$package.tgz
		done
		;;
	update)
		for package in $PACKAGE_LIST ; do
			if [ -e "$package.tgz" ] ; then
				echo "Skipping $package"
			else
				wget http://www.anc.org/downloads/docker/$package.tgz
			fi
		done
		;;
	clean)
		rm *.tgz
		;;
	*)
		echo "Unrecognized command $1"
		;;
esac



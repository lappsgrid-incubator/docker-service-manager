# Docker Service Manager

## TL;DR

The Service Manager is configured by the LDDL scripts from
[https://github.com/lappsgrid-incubator/lddl-scripts](https://github.com/lappsgrid-incubator/lddl-scripts)

## Long Version

When the Docker image is built the LDDL scripts are cloned into /etc/lddl. When a 
container is started the LDDL scripts will be run to configure the Service Manager after 
it has started.  Trying to configure the Service Manager when the image is built is 
problematic as Postgres and Tomcat need to be started and the Service Manager has to finish
setting up the database. It seems to be much more reliable to perform this configuration
when a container first starts.


# This image extends service-manager:base and adds the Lapps services running
# on the Vassar node.

FROM lappsgrid/service-manager

ENV TERM=xterm

USER root

#ADD ./packages/lddl-scripts.tgz /etc/lddl
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/lappsgrid-incubator/lddl-scripts.git /etc/lddl

ADD ./service_manager-vassar.xml /usr/share/tomcat/service-manager/conf/Catalina/localhost/service_manager.xml
ADD ./startup-all.sh /usr/bin/startup
ADD ./shutdown.sh /usr/bin/shutdown
ADD ./tail-log.sh /usr/bin/taillog
RUN chmod ug+x /usr/bin/taillog && \
	chmod ug+x /usr/bin/shutdown
	
CMD ["/usr/bin/startup"]

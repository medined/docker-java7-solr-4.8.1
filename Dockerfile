FROM    ubuntu
MAINTAINER David Medinets "david.medinets@gmail.com"

# Source: http://searchhub.org/2013/12/02/solrcloud-on-docker/

ENV SOLR solr-4.8.1
RUN mkdir -p /opt

# The add command automatically uncompresses.
ADD $SOLR.tgz /opt
RUN ls -l /opt/solr-4.8.1

RUN ln -s /opt/$SOLR /opt/solr

RUN apt-get update
RUN apt-get --yes install openjdk-7-jdk
EXPOSE 8983
CMD ["/bin/bash", "-c", "cd /opt/solr/example; java -jar start.jar"

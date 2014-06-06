## docker-java7-solr-4.8.1

Running Solr Cloud on Docker images. This project was derived from http://searchhub.org/2013/12/02/solrcloud-on-docker/.


## Build the image

The solr tgz file is over 140M, too large, to reasonably include in the Github project. So the first step is to download it. Then you can build the image.

```
wget http://www.eng.lsu.edu/mirrors/apache/lucene/solr/4.8.1/solr-4.8.1.tgz
docker build --rm=true -t $USER/solr4:4.8.1 .
```

## Stop all processes

When experimenting with Docker, I found it useful to occasionally stop all processes to start with a clean slate.

```
docker ps -a | grep -v "CONTAINER" | awk '{print $1}' | xargs docker stop
```

## Remove old processes

As long as a process can be seen with the _docker ps_ command, links can't be reused. This command removes all non-running processes.

```
docker ps -a | grep -v "CONTAINER" | grep -v 'Up ' | awk '{print $1}' | xargs docker rm
```

## Run Solr Cloud

.. more after lunch..

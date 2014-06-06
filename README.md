## Solr Cloud v4.8.1 on Docker Using Java 7

Running Solr Cloud on Docker images. This project was derived from http://searchhub.org/2013/12/02/solrcloud-on-docker/.

## Build Zookeeper Image

```
git clone https://github.com/medined/docker-oracle8-zookeeper-3-4-6.git.
cd docker-oracle8-zookeeper-3-4-6
docker build -t $USER/oracle8-zookeeper-3-4-6 .
```

## Build the image

The solr tgz file is over 140M which is too large to reasonably include in the Github project. So the first step is to download it. Then you can build the image.

```
git clone https://github.com/medined/docker-java7-solr-4.8.1.git
cd docker-java7-solr-4.8.1
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

```
export NUM_SHARDS=4
# Start Zookeeper
ZOOKEEPER=$(docker run --name zookeeper -d -P $USER/oracle8-zookeeper-3-4-6)

# Start Solr Leader
docker run -d --name solr_leader --link zookeeper:ZK -i -p 8983 -t $USER/solr4:4.8.1 \
    /bin/bash -c 'cd /opt/solr/example; java -Dbootstrap_confdir=./solr/collection1/conf -Dcollection.configName=myconf -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -DnumShards=$NUM_SHARDS -jar start.jar
    
# Start Solr Nodes
for (( c=1; c<=$NUM_SHARDS; c++ ))
do
    docker run -d --name solr_node_$c --link zookeeper:ZK -i -p 8983 -t $USER/solr4:4.8.1 \
    /bin/bash -c 'cd /opt/solr/example; java -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -jar start.jar'
done
```

# Visit the Solr UI page.

```
export SOLR_HOST=50.116.46.249
export SOLR_PORT=`docker port solr_leader 8983|sed 's/.*://'`
export SOLR_URL="http://$SOLR_HOST:$SOLR_PORT/solr/#/~cloud"
echo $SOLR_URL
firefox $SOLR_URL
```

## Remove Solr Cloud

```
docker ps -a | grep "solr_" | awk '{print $1}' | xargs docker stop
docker ps -a | grep "solr_" | awk '{print $1}' | xargs docker rm

```




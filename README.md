docker-java7-solr-4.8.1
=======================

Running Solr Cloud on Docker images.

# Build the image

The solr tgz file is over 140M, too large, to reasonably include in the Github project. So the first step is to download it. Then you can build the image.

```
wget http://www.eng.lsu.edu/mirrors/apache/lucene/solr/4.8.1/solr-4.8.1.tgz
docker build --rm=true -t $USER/solr4:4.8.1 .
```

# 

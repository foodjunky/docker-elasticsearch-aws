#
# Elasticsearch Node
#
# docker-build properties:
# TAG=foodjunky/elasticsearch-aws:latest

FROM foodjunky/java
MAINTAINER Jeremy Jongsma "jeremy@foodjunky.com"

# Download version 1.4.x of elasticsearch
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
	add-apt-repository -y "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main" && \
	apt-get -y update && \
	apt-get -y install elasticsearch && \
	apt-get clean && \
	/usr/share/elasticsearch/bin/plugin install elasticsearch/elasticsearch-cloud-aws/2.4.1 && \
	/usr/share/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf/master

ADD elasticsearch/ /etc/elasticsearch
ADD lib/ /usr/share/elasticsearch/lib

# File locations
ENV LOG_DIR="/var/log/ext/elasticsearch" \
	DATA_DIR="/elasticsearch/data" \
	WORK_DIR="/elasticsearch/tmp" \
	CONF_DIR="/etc/elasticsearch" \
	CONF_FILE="/etc/elasticsearch/elasticsearch.yml"

# ES configuration vars
ENV ES_CLUSTER_NAME="elasticsearch" \
	ES_NODE_MASTER="true" \
	ES_NODE_DATA="true" \
	ES_NODE_COUNT="1" \
	ES_SHARDS="10" \
	ES_REPLICAS="1" \
	ES_CLOUD_AWS_REGION="us-east-1" \
	ES_DISCOVERY_EC2_GROUPS="none" \
	ES_HEAP_SIZE="2g" \
	MAX_LOCKED_MEMORY="unlimited" \
	RESTART_ON_UPGRADE="true" \
	ES_JAVA_OPTS="-Des.default.config=$CONF_FILE -Des.default.path.logs=$LOG_DIR -Des.default.path.data=$DATA_DIR -Des.default.path.work=$WORK_DIR -Des.default.path.conf=$CONF_DIR"

EXPOSE 9200
EXPOSE 9300

VOLUME ["/elasticsearch"]

CMD ["/usr/share/elasticsearch/bin/elasticsearch"]

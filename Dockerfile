FROM phusion/baseimage:0.9.10
MAINTAINER Nick Stenning

# Install system deps
RUN apt-get -q -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
  default-jre-headless \
  nginx-light

# Install ElasticSearch
ENV ES_HOME /opt/elasticsearch
ENV ES_VERSION 1.2.2
ENV ES elasticsearch-$ES_VERSION
RUN mkdir -p $ES_HOME
ADD https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES.tar.gz /opt/$ES.tar.gz
RUN tar zxf /opt/$ES.tar.gz -C $ES_HOME --strip-components 1
RUN mv /opt/$ES $ES_HOME

# Configure elasticsearch
ADD ./elasticsearch.yml $ES_HOME/config/elasticsearch.yml
RUN mkdir /data

# Install Kibana
ENV KIBANA_HOME /opt/kibana
ENV KIBANA_VERSION 3.1.0
ENV KIBANA kibana-$KIBANA_VERSION
RUN mkdir -p $KIBANA_HOME
ADD https://download.elasticsearch.org/kibana/kibana/$KIBANA.tar.gz /opt/$KIBANA.tar.gz
RUN tar zxf /opt/$KIBANA.tar.gz -C $KIBANA_HOME --strip-components 1
RUN mv /opt/$KIBANA $KIBANA_HOME

# Configure nginx
ADD ./nginx.conf /etc/nginx/nginx.conf
RUN mkdir /var/cache/nginx

# Configure runit
ADD ./svc /etc/service
CMD ["/sbin/my_init"]

VOLUME ["/data"]
EXPOSE 9200
EXPOSE 9201
EXPOSE 80

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

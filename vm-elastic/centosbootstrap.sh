#!/bin/bash

export ESVERSION=6

# install wget for the next action
sudo yum -y install wget

# install Java
sudo yum -y install java-1.8.0-openjdk

# elasticsearch GPG key
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

################
# ElasticSearch 
################

# create elasticsearch repo
sudo bash -c "cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md 
EOF"

# install elasticsearch
sudo yum -y install elasticsearch

# start elasticsearch on boot
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service


# allow host OS to access through port forwarding
sudo echo "
network.bind_host: 0
network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
sudo sed -i -e '$a\' /etc/elasticsearch/elasticsearch.yml
sudo sed -i -e '$a\' /etc/elasticsearch/elasticsearch.yml


################
#    KIBANA
################

# create the kibana repo
sudo bash -c "cat <<EOF > /etc/yum.repos.d/kibana.repo
[kibana-6.x]
name=Kibana repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF"

# install kibana
sudo yum -y install kibana

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service

################
#   LOGSTASH 
################
sudo bash -c "cat <<EOF > /etc/yum.repos.d/logstash.repo
[logstash-6.x]
name=Elastic repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF"

# install logstash
sudo yum -y install logstash



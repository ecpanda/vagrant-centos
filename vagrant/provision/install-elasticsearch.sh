#!/usr/bin/env bash

# install jdk8
if [ ! -e "/usr/bin/java" ]; then
    echo ">>> Installing java"
    sudo yum install -y java-1.8.0-openjdk
    echo ">>> Java installed"
else
    echo ">>> Java already installed"
fi

if [ ! -e "/usr/share/elasticsearch/bin/elasticsearch" ]; then
    echo ">>> Installing elasticsearch"

    cd ~
    curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.0.rpm
    sudo rpm -ivh elasticsearch-6.3.0.rpm
    sudo systemctl enable elasticsearch.service
    sudo systemctl restart elasticsearch.service

LIMIT_LINES="
*                soft    nofile          65536
*                hard    nofile          65536
*                soft    nproc           4096
*                hard    nproc           4096
"

    echo "$LIMIT_LINES" | sudo tee -a /etc/security/limits.conf
    echo "vm.max_map_count = 262144" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

    echo ">>> Elasticsearch installed"
else
    echo ">>> Elasticsearch already installed"
fi




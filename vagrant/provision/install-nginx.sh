#!/usr/bin/env bash

if [ ! -e "/usr/sbin/nginx" ]; then
    echo ">>> Installing nignx"

    sudo yum install -y epel-release
    sudo yum install -y nginx

    sudo cp /home/vagrant/vm/conf/nginx.conf /etc/nginx

    sudo systemctl start nginx
    sudo systemctl enable nginx

    echo ">>> Nignx Installed "
else
    echo ">>> Nignx already Installed "
fi

echo ">>> clearing old nginx confs"
sudo rm -f /etc/nginx/conf.d/*
sudo rm -f /etc/nginx/site.d/*
echo ">>> Old nginx confs cleared"



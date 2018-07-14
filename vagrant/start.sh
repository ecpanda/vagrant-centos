#!/usr/bin/env bash

# add centos repo of 163.com
if [ ! -e "/home/vagrant/vm/booted" ]; then
    echo ">>> set EPEL(Extra Packages for Enterprise Linux)"

    sudo yum install -y epel-release 

    echo ">>> set EPEL completed"

    echo ">>> set repo of 163.com"

    cd /etc/yum.repos.d

    sudo curl http://mirrors.163.com/.help/CentOS7-Base-163.repo -o CentOS7-Base-163.repo

    #backup the default repo
    sudo mv CentOS-Base.repo CentOS-Base.repo.backup

    #clean the yum
    sudo yum clean all && sudo yum clean metadata && sudo yum clean dbcache && sudo yum makecache && sudo yum update

    echo ">>> set repo of 163.com completed"
fi

# disable selinux
SELINUX_STATUS=`getenforce`
if [ "$SELINUX_STATUS" = "Enforcing" ]; then
    echo ">>> disable selinux"
    sudo setenforce 0
    sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
    echo ">>> selinux disabled"
fi

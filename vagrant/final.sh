#!/bin/sh

sudo su

#setLocal
localblock="
    LANG=en_US.utf-8
    LC_ALL=en_US.utf-8
"

echo "$localblock" > "/etc/environment"

#guest machine booted flag file to idicate loading the custom ssh private key
echo "Machined booted" > "/home/vagrant/vm/booted"




#!/usr/bin/env bash
#
# script to set the hostname (run as root)

# set the umask
umask 0022

# check the command line
if [ $# != 1 ]; then
  echo usage: $0 FQDN
  exit 1
fi

# unload the command line args
fqdn=$1

# use hostnamectl
if which hostnamectl > /dev/null 2>&1; then
    hostnamectl set-hostname $fqdn --transient --static || exit 1
    exit 0
fi

# use hostname
hostname $fqdn || exit 1

# AWS cloud config
cat /etc/cloud/cloud.cfg \
    | sed "s/preserve_hostname: false/preserve_hostname: true/" \
    > /tmp/cloud.cfg
if ! diff /etc/cloud/cloud.cfg /tmp/cloud.cfg; then
    mv /tmp/cloud.cfg /etc/cloud
else
    rm /tmp/cloud.cfg
fi

# typical Linux
if [ -f /etc/sysconfig/network ]; then

    # load the current entry
    hostname_entry=$(cat /etc/sysconfig/network | grep HOSTNAME)

    # set the new entry
    new_entry="HOSTNAME=$fqdn"

    # no entry -- create one
    if [ -z $hostname_entry ]; then
        echo $new_entry >> /etc/sysconfig/network

    # update existing entry
    elif [ $hostname_entry != $new_entry ]; then
        cat /etc/sysconfig/network | sed "s/$hostname_entry/$new_entry/" \
            > /tmp/network
        mv /tmp/network /etc/sysconfig/network
    fi

# SUSE
elif [ -f /etc/HOSTNAME ]; then

    # load the current entry
    hostname_entry=$(cat /etc/HOSTNAME)

    # update existing entry
    if [ $hostname_entry != $fqdn ]; then
        echo $fqdn > /etc/HOSTNAME
    fi

# error
else
    echo could not find hostname file
    exit 1
fi

# check /etc/hosts for existing entry
host_entry=$(cat /etc/hosts | grep 127.0.0.1 | grep -v localhost)

# set the new entry
hostname=$(echo $fqdn | cut -d '.' -f 1)
new_entry="127.0.0.1 $fqdn $hostname"

# add an entry to /etc/hosts
if [ -z "$host_entry" ]; then
    echo $new_entry >> /etc/hosts

# update existing entry
elif [ "$host_entry" != "$new_entry" ]; then
    cat /etc/hosts | sed "s/$host_entry/$new_entry/" > /tmp/hosts
    mv /tmp/hosts /etc/hosts
fi

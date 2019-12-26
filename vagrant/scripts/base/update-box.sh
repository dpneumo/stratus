#!/usr/bin/env bash

# Run as root
printf "\n========= Update Box ====================\n"
yum clean all
rm -rf /var/cache/yum/*
yum install deltarpm -y
yum install https://centos7.iuscommunity.org/ius-release.rpm -y
yum install epel-release -y
yum update -y

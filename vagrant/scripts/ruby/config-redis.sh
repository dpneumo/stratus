#!/usr/bin/env bash
SRC='/vagrant/client_files'
DATE="$(date +%s)"

# Run as root
printf "\n========= Configure Redis =========================\n"
adduser --system --no-create-home redis

mkdir /etc/redis
cp $SRC/redis/redis_*.conf /etc/redis/         -fb --suffix=.$DATE
chown redis:redis /etc/redis/*
chmod 644 /etc/redis/*

mkdir -p /var/redis/redis_stratus
chown redis:redis /var/redis/redis_stratus
chmod 770 /var/redis/redis_stratus

mkdir -p /var/log/redis
touch /var/log/redis/redis_stratus.log
chown redis:redis /var/log/redis/redis_stratus.log

cp $SRC/redis/40-redis.conf /usr/lib/sysctl.d/ -fb --suffix=.$DATE
chmod 644 /usr/lib/sysctl.d/40-redis.conf
sysctl vm.overcommit_memory=1

cp $SRC/redis/*.service /etc/systemd/system/   -fb --suffix=.$DATE
chmod 644 /etc/systemd/system/redis_*.service


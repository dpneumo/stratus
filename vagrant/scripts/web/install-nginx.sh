#!/usr/bin/env bash
SRC='/vagrant/client_files'
DATE="$(date +%s)"

# Run as root
printf "\n========= Install & configure nginx ===============\n"
cp $SRC/nginx/nginx.repo   /etc/yum.repos.d/  -fb --suffix=.$DATE
chmod 644 /etc/yum.repos.d/nginx.repo
yum update -y
yum reinstall nginx -y

cp $SRC/nginx/nginx.conf   /etc/nginx/         -fb --suffix=.$DATE
cp $SRC/nginx/stratus.conf /etc/nginx/conf.d/  -fb --suffix=.$DATE
cp $SRC/nginx/demo_app.conf /etc/nginx/conf.d/ -fb --suffix=.$DATE
chmod 644 /etc/nginx/nginx.conf /etc/nginx/conf.d/*
if [[ ! -f /etc/nginx/dhparam.pem ]]; then
  echo "This will take a loooong time. Go get coffee. Maybe two cups!"
  openssl dhparam -out /etc/nginx/dhparam.pem 4096 > /dev/null
else
  echo "dhparam.pem exists. Did not replace it."
fi

printf "\n========= Create nginx logs =======================\n"
touch /var/log/nginx/error.log
touch /var/log/nginx/access.log

# Do not start nginx yet. Need certs for TLS in place first.


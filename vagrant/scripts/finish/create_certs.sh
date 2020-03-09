#!/usr/bin/env bash

# Run as root
cd /home/vagrant
source setup_rootca.sh
source setup_blacklakeca.sh

ipaddr=$(ip route get 8.8.8.8 | awk '{print $7}')
SUBJ_IP=$ipaddr source stratus_server_cert.sh

#!/usr/bin/env bash

# Run as root
printf "\n========= Stop & disable rpcbind ===============\n"
systemctl stop rpcbind
systemctl stop rpcbind.socket
systemctl disable rpcbind


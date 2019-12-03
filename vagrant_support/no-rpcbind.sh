#!/usr/bin/env bash

printf "========= Stop & disable rpcbind ===============\n"
systemctl stop rpcbind
systemctl stop rpcbind.socket
systemctl disable rpcbind

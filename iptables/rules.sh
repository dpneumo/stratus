#!/bin/bash
# iptables base rules script

LAN_IF=enp0s3         # 10.0.2.15
WAN_IF=enp0s8         # 192.168.1.90 ??
HOST="192.168.1.69"
GHUB_IP="192.30.253.112 192.30.253.113"

# Flush all current rules from iptables (ignores mangle, raw and security tables)
 iptables -F
 iptables -X
 iptables -t nat -F
 iptables -t nat -X

# Create user defined tables ###############
 iptables -N wan_in
 iptables -N wan_out
 iptables -N lan_in
 iptables -N lan_out
 iptables -N logging

# Default policies #########################
 iptables -P INPUT DROP
 iptables -P FORWARD DROP
 iptables -P OUTPUT DROP

# INPUT chain ##############################
 iptables -A INPUT -i lo            -j ACCEPT
 iptables -A INPUT -i $LAN_IF       -j lan_in
 iptables -A INPUT -i $WAN_IF       -j wan_in
 iptables -A INPUT                  -j DROP

# OUTPUT chain ##############################
 iptables -A OUTPUT -o lo           -j ACCEPT
 iptables -A OUTPUT -o $LAN_IF      -j lan_out
 iptables -A OUTPUT -o $WAN_IF      -j wan_out
 iptables -A OUTPUT                 -j DROP

 # FORWARD chain ############################
 iptables -A FORWARD 				-j logging
 iptables -A FORWARD 				-j DROP


 # WAN chains ###############################
 # HTTP Server (to world)
 iptables -A wan_in  -s $HOST -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
 iptables -A wan_out -d $HOST -p tcp --sport 80 -m state --state ESTABLISHED     -j ACCEPT

 # HTTPS Server (to world)
 iptables -A wan_in  -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
 iptables -A wan_out -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT

 # SSH Client (Github)
 for IP in $GHUB_IP; do
   iptables -A wan_in  -s $IP -p tcp --sport 22  -m state --state ESTABLISHED     -j ACCEPT
   iptables -A wan_out -d $IP -p tcp --dport 22  -m state --state NEW,ESTABLISHED -j ACCEPT
 done

 # HTTP Client (YUM)
 iptables -A wan_in  -p tcp --sport 80  -m state --state ESTABLISHED     -j ACCEPT
 iptables -A wan_out -p tcp --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT

 # HTTPS Client (YUM, Git)
 iptables -A wan_in  -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT
 iptables -A wan_out -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT

 # DNS Client
 iptables -A wan_in  -p tcp --sport 53 -m state --state ESTABLISHED     -j ACCEPT
 iptables -A wan_out -p tcp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
 iptables -A wan_in  -p udp --sport 53 -m state --state ESTABLISHED     -j ACCEPT
 iptables -A wan_out -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT

 # DHCP Client
 iptables -A wan_in  -p udp --sport 67:68 -m state --state ESTABLISHED     -j ACCEPT
 iptables -A wan_out -p udp --dport 67:68 -m state --state NEW,ESTABLISHED -j ACCEPT

 # ICMP inbound
 iptables -A wan_in  -p icmp -m icmp --icmp-type echo-request -m limit --limit 1/sec -j ACCEPT
 iptables -A wan_out -p icmp -m icmp --icmp-type echo-reply   -m limit --limit 1/sec -j ACCEPT
 iptables -A wan_in  -p icmp -m icmp --icmp-type destination-unreachable             -j ACCEPT
 iptables -A wan_out -p icmp -m icmp --icmp-type destination-unreachable             -j ACCEPT

 # ICMP outbound
 iptables -A wan_in  -p icmp -m icmp --icmp-type echo-reply   -m limit --limit 1/sec -j ACCEPT
 iptables -A wan_out -p icmp -m icmp --icmp-type echo-request -m limit --limit 1/sec -j ACCEPT

 # Logging
 iptables -A wan_in  -j logging
 iptables -A wan_out -j logging


 # LAN chains ###############################
 # SSH Server
 iptables -A lan_in  -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
 iptables -A lan_out -p tcp --sport 22 -m state --state ESTABLISHED     -j ACCEPT

 # ICMP inbound
 iptables -A lan_in  -p icmp -m icmp --icmp-type echo-request -m limit --limit 1/sec -j ACCEPT
 iptables -A lan_out -p icmp -m icmp --icmp-type echo-reply   -m limit --limit 1/sec -j ACCEPT
 iptables -A lan_in  -p icmp -m icmp --icmp-type destination-unreachable             -j ACCEPT
 iptables -A lan_out -p icmp -m icmp --icmp-type destination-unreachable             -j ACCEPT

 # ICMP outbound
 iptables -A lan_in  -p icmp -m icmp --icmp-type echo-reply   -m limit --limit 1/sec -j ACCEPT
 iptables -A lan_out -p icmp -m icmp --icmp-type echo-request -m limit --limit 1/sec -j ACCEPT

 # Logging
 iptables -A lan_in  -j logging
 iptables -A lan_out -j logging


# logging chain #############################
 iptables -A logging -p icmp                        -j DROP
 iptables -A logging -m state --state INVALID       -j DROP
 iptables -A logging -m limit --limit 2/min --limit-burst 10 \
          -j LOG --log-prefix "IPTables-Dropped: " --log-level 4


# Save settings #############################
 /sbin/service iptables save


# List rules ################################
 printf "\n\nFILTER table\n"
 iptables -L -v --line-numbers
 printf "\n\nNAT table\n"
 iptables -t nat -L -v --line-numbers

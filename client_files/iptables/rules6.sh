#!/bin/bash
# ip6tables base rules script

# Flush all rules and delete all chains
# for a clean startup

printf "\n========= Backup existing ip6tables rules =======\n"
cp /etc/sysconfig/ip6tables /etc/sysconfig/ip6tables-$(date +%s)

printf "\n========= Install Base ip6tables rules ==========\n"
LAN_IF=enp0s3         # fe80::a00:27ff:fe3a:75b/64
WAN_IF=enp0s8         # fe80::a00:27ff:fea5:ae06/64

# Flush all rules & delete all chains
ip6tables -F
ip6tables -X

# Zero out all counters
ip6tables -Z

# Create user defined tables ###############
 ip6tables -N wan_in
 ip6tables -N wan_out
 ip6tables -N lan_in
 ip6tables -N lan_out
 ip6tables -N logging

# Default policies: deny all incoming & outgoing
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP

# INPUT chain ##############################
 ip6tables -A INPUT -i lo            -j ACCEPT
 ip6tables -A INPUT -i $LAN_IF       -j lan_in
 ip6tables -A INPUT -i $WAN_IF       -j wan_in
 ip6tables -A INPUT                  -j DROP

# OUTPUT chain ##############################
 ip6tables -A OUTPUT -o lo           -j ACCEPT
 ip6tables -A OUTPUT -o $LAN_IF      -j lan_out
 ip6tables -A OUTPUT -o $WAN_IF      -j wan_out
 ip6tables -A OUTPUT                 -j DROP

# FORWARD chain ############################
 ip6tables -A FORWARD        -j logging
 ip6tables -A FORWARD        -j DROP


# WAN chains ###############################
 # DNS Client
 ip6tables -A wan_in  -p tcp --sport  53 -m state --state ESTABLISHED     -j ACCEPT
 ip6tables -A wan_out -p tcp --dport  53 -m state --state NEW,ESTABLISHED -j ACCEPT
 ip6tables -A wan_in  -p udp --sport  53 -m state --state ESTABLISHED     -j ACCEPT
 ip6tables -A wan_out -p udp --dport  53 -m state --state NEW,ESTABLISHED -j ACCEPT

 # Logging
 ip6tables -A wan_in  -j logging
 ip6tables -A wan_out -j logging


# LAN chains ###############################
 # DNS Client
 ip6tables -A lan_in  -p tcp --sport  53 -m state --state ESTABLISHED     -j ACCEPT
 ip6tables -A lan_out -p tcp --dport  53 -m state --state NEW,ESTABLISHED -j ACCEPT
 ip6tables -A lan_in  -p udp --sport  53 -m state --state ESTABLISHED     -j ACCEPT
 ip6tables -A lan_out -p udp --dport  53 -m state --state NEW,ESTABLISHED -j ACCEPT

 # Logging
 ip6tables -A lan_in  -j logging
 ip6tables -A lan_out -j logging


# logging chain #############################
 ip6tables -A logging -p udp                         -j DROP
 ip6tables -A logging -p icmpv6                      -j DROP
 ip6tables -A logging -m state --state INVALID       -j DROP
 ip6tables -A logging -m limit --limit 2/min --limit-burst 10 \
          -j LOG --log-prefix "IP6Tables-Dropped: " --log-level 4

# Save settings #############################
 /sbin/service ip6tables save

# List rules ################################
 printf "\n\nFILTER table\n"
 ip6tables -L -v -n

printf "\n========= New ip6tables rules installed! =========\n"

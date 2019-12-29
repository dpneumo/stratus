!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run as root
printf "\n========= Reload SSH server =======================\n"
systemctl reload sshd.service

printf "\n========= Restart Postfix =========================\n"
systemctl restart postfix

printf "\n========= Restart Nginx ===========================\n"
systemctl restart nginx
systemctl enable nginx

printf "\n========= Restart Redis ===========================\n"
systemctl restart redis_stratus
systemctl enable redis_stratus

printf "\n========= Restart Sidekiq =========================\n"
systemctl restart sidekiq
systemctl enable sidekiq

printf "========= Stop firewalld & Start iptables============\n"
systemctl stop firewalld
systemctl disable firewalld
systemctl mask firewalld
systemctl start iptables
systemctl enable iptables


printf "\n========= Restart Fail2Ban ========================\n"
# Don't start fail2ban until all else is working
#systemctl restart fail2ban
#systemctl enable fail2ban

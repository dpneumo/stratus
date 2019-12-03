# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative 'vagrant_support/bridged_interfaces'

Vagrant.configure("2") do |config|

  # create stratus node
  config.vm.define :stratus do |stratus|
    stratus.vm.box = "geerlingguy/centos7"
    stratus.vm.box_version = "1.2.10"
    stratus.vm.hostname = "stratus"
    stratus.vm.synced_folder  "C:/Users/dpneu/Projects/ansible/cirrus",
                              "/home/vagrant/cirrus",
                              mount_options: ["dmode=755", "fmode=644"]
    stratus.vm.synced_folder  "C:/Users/dpneu/Projects/ansible/pk2do",
                              "/home/vagrant/ansible",
                              mount_options: ["dmode=755", "fmode=644"]
    stratus.vm.synced_folder  "C:/bench/cummulus",
                              "/home/vagrant/cummulus",
                              mount_options: ["dmode=755", "fmode=644"]
    #stratus.vm.network "forwarded_port",
    #                    guest: 3000,
    #                    host: 3000
    # If VB can't find a bridged network, do 'vagrant halt'
    # then in VirtualBox Manager be certain that NO adapter is attached to a 'Bridged Adapter'.
    # Finally do 'vagrant up'.
    # VB does NOT like changes to adapters while up or suspended!
    stratus.vm.network "public_network",
                       bridge: BridgedInterfaces.new.preferred&.[]('Name')
    stratus.vm.boot_timeout = 600
    stratus.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    stratus.vm.provision  :shell,
                          run: "always",
                          inline: <<-SHELL
      sudo sed -i 's/DEFROUTE="yes"/DEFROUTE="no"/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3
      sudo systemctl restart network
      ip route get 8.8.8.8 | awk '{print $7}' | xargs -I IPADDR echo "BRIDGED IP: IPADDR"
      netstat -rn
    SHELL
=begin    stratus.vm.provision  :shell,
                          path: "vagrant_support/bootstrap-centos-stratus.sh",
                          privileged: false
=end
    stratus.vm.provision  :shell,
                          path: "vagrant_support/update-box.sh",
                          privileged: true
    stratus.vm.provision  :shell,
                          path: "vagrant_support/development-tools.sh",
                          privileged: true
    stratus.vm.provision  :shell,
                          path: "vagrant_support/no-rpcbind.sh",
                          privileged: true
    stratus.vm.provision  :shell,
                          path: "vagrant_support/iptables.sh",
                          privileged: true
    stratus.vm.provision  :shell,
                          path: "vagrant_support/install-fail2ban.sh",
                          privileged: true
    stratus.vm.provision  :shell,
                          path: "vagrant_support/git.sh",
                          privileged: false
    stratus.vm.provision  :shell,
                          path: "vagrant_support/config-ssh.sh",
                          privileged: false
  end

end

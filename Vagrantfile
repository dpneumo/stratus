# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # create stratus node
  config.vm.define :stratus do |stratus|
    stratus.vm.box = "geerlingguy/centos7"
    stratus.vm.box_version = "1.2.10"
    stratus.vm.hostname = "stratus"
    stratus.vm.synced_folder  "C:/Users/loco/My Projects/ansible/cirrus",
                              "/home/vagrant/cirrus",
                              mount_options: ["dmode=755", "fmode=644"]
    stratus.vm.synced_folder  "C:/Users/loco/My Projects/ansible/pk2do",
                              "/home/vagrant/ansible",
                              mount_options: ["dmode=755", "fmode=644"]
    stratus.vm.synced_folder  "C:/bench/cummulus",
                              "/home/vagrant/cummulus",
                              mount_options: ["dmode=755", "fmode=644"]
    stratus.vm.network "forwarded_port", guest: 3000, host: 3000
    # config.vm.network "public_network", bridge: "host_controller_name - see README"
    stratus.vm.network "public_network", bridge: "Realtek PCIe FE Family Controller"
    stratus.vm.boot_timeout = 1200
    stratus.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    stratus.vm.provision  :shell,
                          run: "always",
                          inline: <<-SHELL
      sudo sed -i 's/DEFROUTE="yes"/DEFROUTE="no"/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3
      sudo systemctl restart network
      ip route get 8.8.8.8 | awk '{print $7}' | xargs -I IPADDR echo "The bridged IP is IPADDR"
      netstat -rn
    SHELL
    stratus.vm.provision  :shell,
                          path: "bootstrap-centos-stratus.sh",
                          privileged: false
  end

end

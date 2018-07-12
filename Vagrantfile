# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # create test node
  config.vm.define :test do |test_config|
    #test_config.vm.box = "ubuntu/xenial64"
    #test_config.vm.box = "geerlingguy/ubuntu1604"
    #test_config.vm.box_version = "1.1.8"
    test_config.vm.box = "geerlingguy/centos7"
    test_config.vm.box_version = "1.2.7"
    test_config.vm.hostname = "test"
    test_config.vm.synced_folder "C:/Users/loco/My Projects/ansible/cirrus",
                                 "/home/vagrant/cirrus",
                                 mount_options: ["dmode=755", "fmode=644"]
    test_config.vm.synced_folder "C:/Users/loco/My Projects/ansible/pk2do",
                                 "/home/vagrant/ansible",
                                 mount_options: ["dmode=755", "fmode=644"]
    test_config.vm.network "forwarded_port", guest: 80, host: 8080
    test_config.vm.network "forwarded_port", guest: 3000, host: 3000
    test_config.vm.boot_timeout = 600
    test_config.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    #test_config.vm.provision :shell, path: "bootstrap-ubuntu-test.sh", privileged: false
    test_config.vm.provision :shell, path: "bootstrap-centos-test.sh", privileged: false
  end

end

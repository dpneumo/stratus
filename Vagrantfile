# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative 'vagrant/helpers/bridged_interfaces'
require_relative 'vagrant/helpers/script_runner'

Vagrant.configure("2") do |config|

  # create stratus vm
  config.vm.define :stratus do |stratus|
    vm = stratus.vm
    vm.box = "geerlingguy/centos7"
    vm.box_version = "1.2.10"
    vm.hostname = "stratus"
    vm.synced_folder  "C:/Users/dpneu/Projects/ansible/cirrus",
                      "/home/vagrant/cirrus",
                      mount_options: ["dmode=755", "fmode=644"]
    vm.synced_folder  "C:/Users/dpneu/Projects/ansible/pk2do",
                      "/home/vagrant/ansible",
                      mount_options: ["dmode=755", "fmode=644"]
    vm.synced_folder  "C:/bench/cummulus",
                      "/home/vagrant/cummulus",
                      mount_options: ["dmode=755", "fmode=644"]
    vm.network  "public_network",
                bridge: BridgedInterfaces.new.preferred&.[]('Name')
    vm.boot_timeout = 600
    vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    sr = ScriptRunner.new(vm: vm)
    # See vagrant/helpers/stacks.rb for list of scripts in a stack
    sr.run_always
    sr.run_stack("base")
    sr.run_stack("ruby")
    sr.run_stack("web")
    sr.run_stack("rails")
    sr.run_stack("finish")
  end
end

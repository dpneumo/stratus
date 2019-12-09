require_relative 'stacks'

class ScriptRunner
  include Stack

  def initialize(vm:)
    @vm = vm
  end

  def run_always
    @vm.provision :shell,
                  run: "always",
                  inline: <<-SHELL
    sed -i 's/DEFROUTE="yes"/DEFROUTE="no"/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3
    systemctl restart network
    ip route get 8.8.8.8 | awk '{print $7}' | xargs -I IPADDR echo "BRIDGED IP: IPADDR"
    netstat -rn
    SHELL
  end

  def run_stack(stack)
    stacks[stack].each do |script,privilege|
      @vm.provision :shell,
                    path: "vagrant/scripts/#{stack}/#{script}",
                    privileged: (privilege == 'priv')
    end
  end
end


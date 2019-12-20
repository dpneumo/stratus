require_relative 'stacks'

class ScriptRunner
  include Stack

  # StackList = %w[ base ruby web demo_app ]
  StackList = %w[ demo_app ]

  def initialize(vm:)
    @vm = vm
  end
  private :initialize

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

  def run_stacks
    StackList.each {|stack| run_stack(stack) }
  end

  def run_stack(stack)
    scripts = stacks[stack]
    scripts.each {|script,privilege| run_script(stack, script, privilege) }
  end

  def run_script(stack, script, privilege)
    @vm.provision :shell,
                  path: "vagrant/scripts/#{stack}/#{script}",
                  privileged: (privilege == 'priv')
  end
end

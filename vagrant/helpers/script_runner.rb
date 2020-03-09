require_relative 'stacks'

class ScriptRunner
  include Stack

  # StackList = %w[ demo_app ]
  # StackList = %w[ base ruby web rails ]
  StackList = %w[ base ruby web finish ]
  # StackList = %w[ base ]

  def initialize(vm:)
    @vm = vm
  end
  private :initialize

  def run_always
    @vm.provision :shell,
                  run: "always",
                  privileged: true,
                  binary: true,
                  inline: <<-SHELL
    ip route get 8.8.8.8 | awk '{print $7}' | xargs -I IPADDR echo "BRIDGED IP: IPADDR"
    netstat -rn
    SHELL
  end

  def run_stacklist
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


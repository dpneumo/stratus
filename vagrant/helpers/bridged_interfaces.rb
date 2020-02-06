require_relative 'parse_vb_manage_list'
require_relative 'cmd_runner'

# If VB can't find a bridged network, do 'vagrant halt'
# then in VirtualBox Manager be certain
# that NO adapter is attached to a 'Bridged Adapter'.
# Be certain no vpn client is running.
# Finally do 'vagrant up'.
# Possibly repeat 'vagrant halt'/'vagrant up' dance 1 - 2 times
# VB does NOT like changes to adapters while up or suspended!

class BridgedInterfaces
  IFCNOTAVAIL = <<-MSG
    WARNING:
      No available bridged interface.
      Check that an interface is enabled and connected to the network.\n
  MSG

  def initialize( cmd: 'VBoxManage.exe list bridgedifs',
                  cmdrunner: CmdRunner,
                  parser: ParseVbManageList )
    @cmd       = cmd
    @cmdrunner = cmdrunner
    @parser    = parser
  end

  def preferred
    @parser.new.parse(if_list)
    .select {|ifc| ifc['Status'] == 'Up' }
    .sort_by {|ifc| ifc['Wireless'] }
    .first
    .tap do |ifc|
      if not ENV['TESTING']
        puts IFCNOTAVAIL if ifc.nil?
      end
    end
  end

  def if_list
    @cmdrunner.run(@cmd)
  end
end


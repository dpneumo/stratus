require_relative 'parse_vb_manage_list'
require_relative 'cmd_runner'

# If VB can't find a bridged network, do 'vagrant halt'
# then in VirtualBox Manager be certain
# that NO adapter is attached to a 'Bridged Adapter'.
# Finally do 'vagrant up'.
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
    @cmd     = cmd
    @if_list = cmdrunner.new(cmd: @cmd)
    @parser  = parser.new
  end

  def preferred
    @parser.parse(@if_list.runcmd)
    .select {|ifc| ifc['Status'] == 'Up' }
    .sort_by {|ifc| ifc['Wireless'] }
    .first
    .tap {|ifc| puts IFCNOTAVAIL if ifc.nil? }
  end
end

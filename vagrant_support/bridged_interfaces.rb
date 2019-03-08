require_relative 'parse_vb_manage_list'
require_relative 'cmd_runner'

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
    .select {|ifc| usable?(ifc) }
    .sort_by {|ifc| ifc['Wireless'] }
    .first
    .tap {|ifc| puts IFCNOTAVAIL if ifc.nil? }
  end

  private
    def usable?(ifc)
      ifc['Status'] == 'Up' && !ifc['Wireless'].empty?
    end
end


require_relative 'parse_vagrant_list'
class BridgedInterfaces
  IFCNOTAVAIL = <<-MSG
    WARNING:
      No available bridged interface.
      Check that an interface is enabled and connected to the network.\n
  MSG

  def initialize( list_parser: ParseVagrantList,
                  vbdir:      'C:\Program Files\Oracle\VirtualBox',
                  cmd:        'VBoxManage.exe list bridgedifs'      )
    @parser = list_parser.new
    @vbdir  = vbdir
    @cmd    = cmd
  end

  def preferred
    @parser.parse(runcmd)
    .select {|ifc| usable(ifc) }
    .sort_by {|ifc| ifc['Wireless'] }
    .first
    .tap {|ifc| puts IFCNOTAVAIL if ifc.nil? }
  end

  private
    def runcmd
      out = IO.popen(@cmd, err: %i[child out], chdir: @vbdir) do |io|
        io.readlines
      end
      raise "Error running command #{@cmd}" unless $?.exitstatus.zero?
      out
    end

    def usable(ifc)
      ifc['Status'] == 'Up' && !ifc['Wireless'].empty?
    end
end

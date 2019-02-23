require_relative 'interface_parm_list'
class BridgedInterfaces
  IFCNOTAVAIL = <<-MSG
    WARNING:
      No available bridged interface.
      Check that an interface is enabled and connected to the network.\n
  MSG

  def initialize(interface_attr: InterfaceAttr)
    @ifc_attr = interface_attr.new
  end

  def preferred
    preferred_bridged_ifc
    .sort_by {|ifc| ifc['Wireless'] }
    .first
    .tap {|ifc| puts IFCNOTAVAIL if ifc.nil? }
  end

  private
    def preferred_bridged_ifc
      @ifc_attr.runcmd
      .map {|string_pair| clean(string_pair) }
      .chunk {|string_pair| !!string_pair }
      .select {|chunk| chunk[0] }
      .map {|chunk| chunk2ifc(chunk[1]) }
      .select {|ifc| usable(ifc) }
    end

    def clean(string_pair)
      cleaned = string_pair&.strip
      cleaned.empty? ? nil : cleaned
    end

    def chunk2ifc(string_pairs)
      string_pairs
      .map {|string_pair| components(string_pair) }
      .to_h
    end

    def components(string_pair)
      return if string_pair.nil?
      k, v = string_pair.split(':')
      [ k, v&.strip ]
    end

    def usable(ifc)
      ifc['Status'] == 'Up' && !ifc['Wireless'].empty?
    end
end

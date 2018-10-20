class BridgedInterfaces
  def self.preferred
    new
    .bridged_ifcs
    .sort_by {|ifc| ifc['Wireless'] }
    .first
  end

  private
    def initialize( print_output: false )
      @cmd = 'VBoxManage.exe list bridgedifs'
      @directory = 'C:\Program Files\Oracle\VirtualBox'
      @print_output = print_output
    end

    def bridged_ifcs
      @bridged_ifcs || bridged_ifc_list
    end

    def bridged_ifc_list
      list = runcmd
      last_key, _ = list[-2].split(':')
      bifcs, ifc = [], {}
      list.each do |item|
        item = clean(item)
        next if item.nil?
        k, v = components(item)
        ifc[k] = v
        if k == last_key
          bifcs << ifc if usable(ifc)
          ifc = {}
        end
      end
      bifcs
    end

    def runcmd
      out = IO.popen(@cmd, err: %i[child out], chdir: @directory) do |io|
        io.readlines
      end
      raise "Error running command #{@cmd}" unless $?.exitstatus.zero?
      print out if @print_output
      out
    end

    def clean(item)
      return nil unless item
      item = item.chomp
      return nil unless item
      item = item.strip
      return nil if item.empty?
      item
    end

    def components(item)
      k, v = item.split(':')
      [ k, (v || "nil").strip ]
    end

    def usable(ifc)
      ifc['Status'] == 'Up' && !ifc['Wireless'].empty?
    end
end

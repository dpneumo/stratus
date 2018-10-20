class BridgedInterfaces
  def initialize( print_output: false )
    @cmd = 'VBoxManage.exe list bridgedifs'
    @directory = 'C:\Program Files\Oracle\VirtualBox'
    @print_output = print_output
  end

  def self.preferred
    new
    .bridged_ifcs
    .sort_by {|ifc| ifc['Wireless'] }
    .first
  end

  def bridged_ifcs
    @bridged_ifcs || bridged_ifc_list
  end

  private
    def bridged_ifc_list
      list = run_command
      last_key, _ = list[-2].split(':')
      bifs, ifc = [], {}
      list.each do |item|
        next if item.empty?
        k, v = item.split(':')
        ifc[k] = v.strip
        if k == last_key
          bifs << ifc if usable(ifc)
          ifc = {}
        end
      end
      bifs
    end

    def run_command
      out = IO.popen(@cmd, err: %i[child out], chdir: @directory) do |io|
        begin
          out = ''
          loop do
            chunk = io.readpartial(4096)
            print chunk if @print_output
            out += chunk
          end
        rescue EOFError; end
        out
      end
      $?.exitstatus.zero? || (raise "Error running command #{@cmd}")
      out.split("\n")
         .map { |line| line.tr("\r\n", '') }
    end

    def usable(ifc)
      ifc['Status'] == 'Up' && !ifc['Wireless'].empty?
    end
end

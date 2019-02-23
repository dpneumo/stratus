class InterfaceAttr
# Should produce a string representing
# a list of interface attributes structured like this:

# "Name:            Intel(R) WiFi Link 1000 BGN\n
#  GUID:            8f431c89-a522-4490-9946-62fd34a9d359\n
#  DHCP:            Enabled\n
#  ...
#  MediumType:      Ethernet\n
#  Wireless:        Yes\n
#  Status:          Up\n
#  VBoxNetworkName: HostInterfaceNetworking-Intel(R) WiFi Link 1000 BGN\n
#  \n
#  Name:            Realtek PCIe FE Family Controller\n
#  GUID:            6157c7b4-64e5-44fe-b367-84309e5bbaf0\n
#  DHCP:            Enabled\n
#  ...
#  MediumType:      Ethernet\n
#  Wireless:        No\n
#  Status:          Up\n
#  VBoxNetworkName: HostInterfaceNetworking-Realtek PCIe FE Family Controller\n"

  def runcmd
    cmd = 'VBoxManage.exe list bridgedifs'
    dir = 'C:\Program Files\Oracle\VirtualBox'
    out = IO.popen(cmd, err: %i[child out], chdir: dir) do |io|
      io.readlines
    end
    raise "Error running command #{@cmd}" unless $?.exitstatus.zero?
    out
  end
end

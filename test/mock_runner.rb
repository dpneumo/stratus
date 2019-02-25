class MockRunner
  def initialize( cmd: ,
                  vbdir: 'mockdir' )
    @cmd = cmd
  end

  def runcmd
    case @cmd
    when 'wired_is_up'
      wired_up
    when 'wired_is_down'
      wired_down
    when 'wireless_is_up'
      wireless_up
    when 'wireless_is_down'
      wireless_down
    when 'both_avail'
      wired_up + wireless_up
    else
      tap_adapt
    end
  end

  def wired_up
    [
      "Name:            Wired iF\n",
      "MediumType:      Ethernet\n",
      "Wireless:        No\n",
      "Status:          Up\n",
      "VBoxNetworkName: HostInterfaceNetworking-Wired iF\n",
      "\n",
    ]
  end

  def wired_down
    [
      "Name:            Wired iF\n",
      "MediumType:      Ethernet\n",
      "Wireless:        No\n",
      "Status:          Down\n",
      "VBoxNetworkName: HostInterfaceNetworking-Wired iF\n",
      "\n",
    ]
  end

  def wireless_up
    [
      "Name:            WireleSs If\n",
      "MediumType:      Ethernet\n",
      "Wireless:        Yes\n",
      "Status:          Up\n",
      "VBoxNetworkName: HostInterfaceNetworking-WireleSs If\n",
      "\n"
    ]
  end

  def wireless_down
    [
      "Name:            WireleSs If\n",
      "MediumType:      Ethernet\n",
      "Wireless:        Yes\n",
      "Status:          Down\n",
      "VBoxNetworkName: HostInterfaceNetworking-WireleSs If\n",
      "\n"
    ]
  end

  def tap_adapt
    [
      "Name:            TAP-Windows Adapter V9\n",
      "MediumType:      Ethernet\n",
      "Wireless:        No\n",
      "Status:          Down\n",
      "VBoxNetworkName: HostInterfaceNetworking-TAP-Windows Adapter V9\n",
      "\n"
    ]
  end
end

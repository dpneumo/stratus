class MockRunner
  def initialize( cmd: ,
                  vbdir: 'mockdir' )
    @cmd = cmd
  end

  def runcmd
    case @cmd
    when 'wired_up'
      wired_up
    when 'wireless_up'
      wireless_up
    when 'both_up'
      wired_up + wireless_up
    when 'both_up_reversed'
      wireless_up + wired_up
    else  #both down
      tap_adapt
    end
  end

  def wired_up
    [
      "Name:            Wired iF\n",
      "MediumType:      Ethernet\n",
      "Wireless:        No\n",
      "Status:          Up\n",
      "\n",
    ]
  end

  def wireless_up
    [
      "Name:            WireleSs If\n",
      "MediumType:      Ethernet\n",
      "Wireless:        Yes\n",
      "Status:          Up\n",
      "\n"
    ]
  end

  def tap_adapt
    [
      "Name:            TAP-Windows Adapter V9\n",
      "MediumType:      Ethernet\n",
      "Wireless:        No\n",
      "Status:          Down\n",
      "\n"
    ]
  end
end

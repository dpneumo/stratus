class MockRunner
  def self.run(cmd)
    mr = self.new
    case cmd
    when 'wired_up'
      mr.wired_up
    when 'wireless_up'
      mr.wireless_up
    when 'both_up'
      mr.wired_up + mr.wireless_up
    when 'both_up_reversed'
      mr.wireless_up + mr.wired_up
    else  #both down
      mr.tap_adapt
    end
  end

  def initialize( vbdir: 'mockdir', iorunner: nil )
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


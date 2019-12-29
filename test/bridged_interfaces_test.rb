require 'test_helper'
require_relative '../bridged_interfaces'
require_relative 'mock_runner'

class TestBridgedInterfaces < MiniTest::Test
  def test_preferred_returns_a_wireless_interface_when_available
    bi = BridgedInterfaces.new(cmd: 'wireless_up', cmdrunner: MockRunner )
    assert_equal 'WireleSs If', bi.preferred['Name']
  end

  def test_preferred_returns_a_wired_interface_when_available
    bi = BridgedInterfaces.new(cmd: 'wired_up', cmdrunner: MockRunner )
    assert_equal 'Wired iF', bi.preferred['Name']
  end

  def test_preferred_returns_a_wired_ifc_when_wired_and_wireless_are_available
    bi = BridgedInterfaces.new(cmd: 'both_up', cmdrunner: MockRunner )
    assert_equal 'Wired iF', bi.preferred['Name']
  end

  def test_preferred_sorts_by_the_ifc_Wireless_key
    bi = BridgedInterfaces.new(cmd: 'both_up_reversed', cmdrunner: MockRunner )
    assert_equal 'Wired iF', bi.preferred['Name']
  end

  def test_preferred_returns_nil_when_no_interface_is_available
    bi = BridgedInterfaces.new(cmd: 'tap_adapt', cmdrunner: MockRunner )
    assert_nil bi.preferred
  end
end


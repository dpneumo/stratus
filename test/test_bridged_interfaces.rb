require_relative '../bridged_interfaces'
require_relative 'mock_runner'
require 'test/unit'
require 'pry'

class TestBridgedInterfaces < Test::Unit::TestCase
  def test_preferred_returns_a_wireless_interface_when_available
    bi = BridgedInterfaces.new(command: 'wireless_up', cmdrunner: MockRunner )
    assert_equal 'WireleSs If', bi.preferred['Name']
  end

  def test_preferred_returns_a_wired_interface_when_available
    bi = BridgedInterfaces.new(command: 'wired_up', cmdrunner: MockRunner )
    assert_equal 'Wired iF', bi.preferred['Name']
  end

  def test_preferred_returns_a_wired_ifc_when_wired_and_wireless_are_available
    bi = BridgedInterfaces.new(command: 'both_up', cmdrunner: MockRunner )
    assert_equal 'Wired iF', bi.preferred['Name']
  end

  def test_preferred_returns_nil_when_no_interface_is_available
    bi = BridgedInterfaces.new(command: 'tap_adapt', cmdrunner: MockRunner )
    assert_equal nil, bi.preferred
  end
end

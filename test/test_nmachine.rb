require 'minitest/autorun'
require 'nmachine'

class NMachineTest < Minitest::Test
  attr_accessor :machine

  def setup
    @side_effect = nil
    @machine = NMachine.new(:new)
    machine.when(:see, new: :seen) do
      @side_effect = "See"
    end
    machine.when(:ignore, new: :ignored, seen: :ignored) do
      @side_effect = "Ignore"
    end
    machine.when(:handle, new: :handled, seen: :handled) do
      @side_effect = "Handle"
    end
    machine.when(:reset, seen: :new, ignored: :new, handled: :new) do
      @side_effect = "Reset"
    end
    machine.when(:confuse, seen: :ignored, ignored: :seen, new: :handled, handled: :new) do
      @side_effect = "Huh"
    end
  end

  def test_setting_up_a_new_machine
    assert_equal :new, machine.state
  end

  def test_transitions
    assert_equal :ignored, machine.ignore.state
    assert_equal "Ignore", @side_effect
    assert_equal :new, machine.reset.state
    assert_equal "Reset", @side_effect
    assert_equal :handled, machine.confuse.state
    assert_equal "Huh", @side_effect
  end

  def test_error_handling
    assert_raises(NMachine::InvalidEventError, 'see not valid from ignored') { machine.ignore.see }
    assert_raises(NoMethodError) { machine.asdf }
  end
end

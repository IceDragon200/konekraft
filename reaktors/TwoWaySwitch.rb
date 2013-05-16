#
# Sadie/src/reaktors/TwoWaySwitch.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 14/05/2013
class Sadie::TwoWaySwitchReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.0".freeze
  ##
  # Input
    INPUT_COMMON_ID = INPUT_ID  = 0x0
  ##
  # Output
    OUTPUT_T1_ID = 0x0
    OUTPUT_T2_ID = 0x1

  bool_accessor :state

  def init
    super
    reset
  end

  def reset
    self.state = false
  end

  def toggle
    self.state = !self.state
  end

  def setup_ports
    @input[INPUT_ID] = nil
    @output[OUTPUT_T1_ID] = nil
    @output[OUTPUT_T2_ID] = nil
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      if self.state
        emit(OUTPUT_T2_ID, energy)
        try_callback(:on_react_t1, self, connection, energy)
      else
        emit(OUTPUT_T1_ID, energy)
        try_callback(:on_react_t2, self, connection, energy)
      end
    end
    super(input_id, energy)
  end

  register('counter')

end

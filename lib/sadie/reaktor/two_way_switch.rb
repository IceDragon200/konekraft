#
# Sadie/lib/sadie/reaktor/two_way_switch.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 18/05/2013
class Sadie::TwoWaySwitchReaktor < Sadie::ReaktorBase

  ### constants
  VERSION = "1.1.0".freeze

  ##
  # Input
  register_input(INPUT_COMMON_ID = INPUT_ID  = 0x0, "input")

  ##
  # Output
  register_output(OUTPUT_T1_ID = 0x0, "t1")
  register_output(OUTPUT_T2_ID = 0x1, "t2")

  attr_accessor :state # Boolean

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

  register('two_way_switch')

end

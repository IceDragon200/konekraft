#
# Sadie/lib/sadie/reaktor/floodgate.rb
#   by IceDragon
#   dc 12/03/2013
#   dm 18/05/2013
class Sadie::FloodgateReaktor < Sadie::ReaktorBase

  ### constants
  VERSION = "1.1.0".freeze

  ##
  # Input
  register_input(INPUT_ID   = 0x0, "input")

  ##
  # Output
  register_output(OUTPUT_ID = 0x0, "output")

  attr_accessor :flood_trigger_energy # Integer

  def init
    super
    @flood_trigger_energy = 1
  end

  def trigger_floodgate?(energy)
    energy.value >= @flood_trigger_energy
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      if trigger_floodgate?(energy)
        emit(OUTPUT_ID, energy)
        try_callback(:on_react_flood, self, connection, energy)
      end
    end
    super(input_id, energy)
  end

  register('floodgate')

end

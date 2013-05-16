#
# Sadie/src/reaktors/Floodgate.rb
#   by IceDragon
#   dc 12/03/2013
#   dm 20/04/2013
class Sadie::FloodgateReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.2".freeze

  # inputs
    INPUT_ID  = 0x0
  # outputs
    OUTPUT_ID = 0x0

  int_accessor :flood_trigger_energy

  def init
    super
    @flood_trigger_energy = 1
  end

  def trigger_floodgate?(energy)
    energy.value >= @flood_trigger_energy
  end

  def setup_ports
    @input[INPUT_ID] = nil
    @output[OUTPUT_ID] = nil
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

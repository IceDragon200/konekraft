#
# EDOS/src/sadie/reaktors/Drain.rb
#   by IceDragon
#   dc 12/03/2013
#   dm 20/04/2013
class Sadie::DrainReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.2".freeze

  # inputs
    INPUT_ID  = 0x0
  # outputs
    OUTPUT_ID = 0x0

  def setup_ports
    @input[INPUT_ID] = nil
    @output[OUTPUT_ID] = nil
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      try_callback(:on_react_drain_pre, self, connection, energy)
      energy.value = 0
    end
    super(input_id, energy)
  end

  register('drain')

end

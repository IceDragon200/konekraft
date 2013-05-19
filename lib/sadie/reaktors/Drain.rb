#
# EDOS/src/sadie/reaktors/Drain.rb
#   by IceDragon
#   dc 12/03/2013
#   dm 18/05/2013
class Sadie::DrainReaktor < Sadie::ReaktorBase

  ## constants
  VERSION = "1.1.0".freeze

  ##
  # Input
  register_input(INPUT_ID  = 0x0, "input")

  ##
  # Output
  register_input(OUTPUT_ID = 0x0, "output")

  def react(input_id, energy)
    if connection = @input[input_id]
      try_callback(:on_react_drain_pre, self, connection, energy)
      energy.value = 0
    end
    super(input_id, energy)
  end

  register('drain')

end

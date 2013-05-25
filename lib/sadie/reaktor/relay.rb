#
# Sadie/src/reaktors/Relay.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 18/05/2013
class Sadie::RelayReaktor < Sadie::ReaktorBase

  ### constants
  VERSION = "1.1.0".freeze

  ##
  # Input
  register_input(INPUT_COIL_ID    = 0x0, "coil")
  register_input(INPUT_COMMON_ID  = 0x1, "common")

  ##
  # Output
  register_output(OUTPUT_COIL_ID  = 0x0, "coil")
  register_output(OUTPUT_NC_ID    = 0x1, "nc")
  register_output(OUTPUT_NO_ID    = 0x2, "no")

  # accessors
  attr_reader :coil_state # Boolean
  attr_accessor :coil_state_normal # Boolean
  attr_accessor :coil_trigger_energy # Integer

  def init
    super
    @coil_state = @coil_state_normal = false
    @coil_trigger_energy = 1
  end

  def coil_state_inverted
    return !coil_state_normal
  end

  def coil_trigger?(energy)
    # can the coil be trigger from the given energy?
    energy.value >= @coil_trigger_energy
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      case connection.input_id
      when INPUT_COIL_ID
        # if energy is valid for coil then its state is inverted (ON)
        # however if it is not present then the coil will default to its
        # normal state (OFF)
        @coil_state = coil_trigger?(energy) ? coil_state_inverted :
                                              coil_state_normal
        emit(OUTPUT_COIL_ID, energy)
        try_callback(:on_react_coil, self, connection, energy)
      when INPUT_COMMON_ID
        emit(@coil_state ? OUTPUT_NO_ID : OUTPUT_NC_ID, energy)
      end
    end
    super(input_id, energy)
  end

  register('relay')

end

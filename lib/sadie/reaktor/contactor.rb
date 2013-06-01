#
# Sadie/lib/sadie/reaktor/contactor.rb
#   by IceDragon
#   dc 30/05/2013
#   dm 30/05/2013
class Sadie::ContactorReaktor < Sadie::ReaktorBase

  ### constants
  VERSION = "1.1.0".freeze

  AUX1    = 0x0
  AUX2    = 0x1
  COMMON1 = 0x2
  COMMON2 = 0x3
  COMMON3 = 0x4

  ## input
  register_input(INPUT_AUX1_ID     = INPUT_COIL1_ID = AUX1, "aux1")
  register_input(INPUT_AUX2_ID     = INPUT_COIL2_ID = AUX2, "aux2")
  register_input(INPUT_COMMON1_ID  = COMMON1, "common1")
  register_input(INPUT_COMMON2_ID  = COMMON2, "common2")
  register_input(INPUT_COMMON3_ID  = COMMON3, "common3")

  ## output
  register_output(OUTPUT_AUX1_WEIGHT_ID = AUX1, "aux-w1")
  register_output(OUTPUT_AUX2_WEIGHT_ID = AUX2, "aux-w2")
  register_output(OUTPUT_COMMON1_ID     = COMMON1, "common1")
  register_output(OUTPUT_COMMON2_ID     = COMMON2, "common2")
  register_output(OUTPUT_COMMON3_ID     = COMMON3, "common3")

  ### instance_variables
  attr_reader :aux_state             # Array<Boolean>
  attr_accessor :aux_trigger_energy  # Array<Integer>
  attr_accessor :coil_state_normal   # Boolean

  ##
  # init
  def init
    super
    # constant
    @coil_state_normal   = false           # N(ormally)O(pen)
    @aux_trigger_energy  = Array.new(2, 1) # Energy required to trigger each auxiliary

    # internal_variable
    @aux_state           = Array.new(2, false)
  end

  ##
  # coil_state_inverted -> Boolean
  def coil_state_inverted
    !coil_state_normal
  end

  ##
  # coil_trigger?(Integer id, Energy energy) -> Boolean
  def aux_trigger?(id, energy)
    # can the coil be trigger from the given energy?
    energy.value >= @aux_trigger_energy[id]
  end

  ##
  # react(INPUT_ID input_id, Energy energy)
  def react(input_id, energy)
    if connection = @input[input_id]
      case id = connection.input_id
      when INPUT_AUX1_ID, INPUT_AUX2_ID
        @aux_state[id] = aux_trigger?(energy) ? coil_state_inverted :
                                                coil_state_normal
          emit(OUTPUT_COIL_ID, energy)
        try_callback(:on_react_coil, self, connection, energy)
      when INPUT_COMMON1_ID, INPUT_COMMON2_ID, INPUT_COMMON3_ID
        emit(OUTPUT_AUX1_ID, energy) if @aux_state[AUX1]
        emit(OUTPUT_AUX2_ID, energy) if @aux_state[AUX2]
        if @coil_state_normal ? !@aux_state.all? : @aux_state.all?
          emit(id, energy)
        end
      end
    end
    super(input_id, energy)
  end

  register('contactor')

end

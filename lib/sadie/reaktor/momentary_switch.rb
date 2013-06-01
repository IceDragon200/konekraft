#
# EDOS/lib/sadie/reaktor/indicator.rb
#   by IceDragon
#   dc 31/05/2013
#   dm 31/05/2013
module Sadie
  class MomentarySwitchReaktor < ReaktorBase

    include Sadie::Mixin::SwitchState2

    ### constants
    VERSION = "1.0.0".freeze

    ### inputs
    register_input(INPUT_ID = 0x0, "input")

    ### outputs
    register_output(OUTPUT_ID = 0x0, "output")

    ### instance_variables
    ## constant
    attr_accessor :normal_state # Boolean [NO//NC][false//true]
    ## internal
    attr_accessor :state        # Boolean

    ##
    # init
    def init
      super
      @normal_state = false
      @state        = @normal_state
    end

    ##
    # reset
    def reset
      @state = @normal_state
    end

    ##
    # react(INPUT_ID input_id, Energy energy)
    def react(input_id, energy)
      if connection = @input_id[input_id]
        case connection.input_id
        when INPUT_ID
          emit(OUTPUT_ID, @state ? energy : emit_energy_null)
          state_depress if state_pressed?
        end
      end
    end

    register('momentary_switch')

  end
end

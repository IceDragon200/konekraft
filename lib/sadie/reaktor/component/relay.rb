#
# Sadie/lib/sadie/reaktors/component/relay.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 22/06/2013
module Sadie
  module Reaktor
    class Relay < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_COIL_ID    = :coil_in, "coil_in")
      register_port(:in,  INPUT_COMMON_ID  = :common_in, "common")

      ## outputs
      register_port(:out, OUTPUT_COIL_ID  = :coil_out, "coil_out")
      register_port(:out, OUTPUT_NC_ID    = :nc_out, "nc_out")
      register_port(:out, OUTPUT_NO_ID    = :no_out, "no_out")

      ### extensions
      extend Sadie::Reaktor::Mixin::SwitchState2
      ss2_def :coil_state

      ### instance_attributes
      attr_reader :coil_state            # Boolean
      attr_accessor :coil_state_default  # Boolean
      attr_accessor :coil_state_thresh   # Integer

      ##
      # init
      def init
        super
        @coil_state = @coil_state_default = false
        @coil_state_thresh = 1
      end

      ##
      # coil_state_inverted
      def coil_state_inverted
        return !coil_state_default
      end

      ##
      # coil_trigger?(energy)
      def coil_trigger?(energy)
        # can the coil be trigger from the given energy?
        energy.value >= @coil_state_thresh
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        case port.id
        when INPUT_COIL_ID
          # if energy is valid for coil then its state is inverted (ON)
          # however if it is not present then the coil will default to its
          # normal state (OFF)
          @coil_state = coil_trigger?(energy) ? coil_state_inverted :
                                                coil_state_default
          emit(OUTPUT_COIL_ID, energy)
          try_callback(:on_react_coil, self, port, energy)
        when INPUT_COMMON_ID
          emit(@coil_state ? OUTPUT_NO_ID : OUTPUT_NC_ID, energy)
          emit(!@coil_state ? OUTPUT_NO_ID : OUTPUT_NC_ID, emit_energy_null)
          try_callback(:on_react_common, self, port, energy)
        end
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(coil_state: @coil_state, coil_state_default: @coil_state_default, coil_state_thresh: @coil_state_thresh)
      end

      ### registration
      register('relay')

    end
  end
end

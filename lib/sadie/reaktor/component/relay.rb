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
      ss2_def :state

      ### instance_attributes
      attr_reader :state           # Boolean
      attr_accessor :default_state # Boolean
      attr_accessor :threshold     # Integer

      ##
      # init
      def init
        super
        @state = @default_state = false
        @threshold = 1
      end

      ##
      # state_inverted
      def state_inverted
        return !default_state
      end

      ##
      # coil_trigger?(energy)
      def coil_trigger?(energy)
        # can the coil be trigger from the given energy?
        energy.value >= @threshold
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
          @state = coil_trigger?(energy) ? state_inverted :
                                                default_state
          emit(OUTPUT_COIL_ID, energy)
          try_callback(:on_react_coil, self, port, energy)
        when INPUT_COMMON_ID
          emit(@state ? OUTPUT_NO_ID : OUTPUT_NC_ID, energy)
          emit(!@state ? OUTPUT_NO_ID : OUTPUT_NC_ID, emit_energy_null)
          try_callback(:on_react_common, self, port, energy)
        end
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(state: @state,
                    default_state: @default_state,
                    threshold: @threshold)
      end

      def property_get(k)
        case k.to_s
        when "default_state" then @default_state
        when "state"         then @state
        when "threshold"     then @threshold
        else
          super(k)
        end
      end

      def property_set(k, v)
        case k.to_s
        when "default_state" then @default_state = bool_parse(v)
        when "state"         then @state = bool_parse(v) # state is released afterwards anyway
        when "threshold"     then @threshold = v.to_i
        else
          super(k, v)
        end
      end

      ### registration
      register('relay')

    end
  end
end

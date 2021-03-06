#
# Konekraft/lib/konekraft/konekt/component/indicator.rb
#
require 'konekraft/konekt2/component/base'

module Konekraft
  module Konekt2
    class MomentarySwitch < Base

      ### constants
      VERSION = "2.1.0".freeze

      ### inputs
      register_port(:in,  INPUT_ID  = :input, "input")

      ### outputs
      register_port(:out, OUTPUT_ID = :output, "output")

      ### extensions
      extend Konekraft::Konekt2::Mixin::SwitchState2
      ss2_def :state

      ### instance_attributes
      ## constant
      attr_accessor :default_state # Boolean [NO//NC][false//true]
      ## internal
      attr_accessor :state         # Boolean

      ##
      # init
      def init
        super
        @default_state = false
        @state         = @default_state
      end

      ##
      # reset
      def reset
        super
        state_reset
      end

      ##
      # post_tick
      def post_tick
        super
        state_reset
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        emit(OUTPUT_ID, @state ? energy : emit_energy_null)
        state_depress if state_pressed?
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(state: @state, default_state: @default_state)
      end

      def property_get(k)
        case k.to_s
        when "default_state" then @default_state
        when "state"         then @state
        else
          super(k)
        end
      end

      def property_set(k, v)
        case k.to_s
        when "default_state" then @default_state = bool_parse(v)
        when "state"         then @state = bool_parse(v) # state is released afterwards anyway
        else
          super(k, v)
        end
      end

      ### registration
      register('momentary_switch')

    end
  end
end

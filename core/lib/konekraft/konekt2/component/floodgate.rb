#
# Konekraft/lib/konekraft/konekt/component/floodgate.rb
#
require 'konekraft/konekt2/component/base'

module Konekraft
  module Konekt2
    class Floodgate < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_ID  = :input, "input")

      ## outputs
      register_port(:out, OUTPUT_ID = :output, "output")

      ### instance_attributes
      attr_accessor :threshold # Integer

      ##
      # init
      def init
        super
        @threshold = 1
      end

      ##
      # trigger_floodgate?
      def trigger_floodgate?(energy)
        energy.value >= @threshold
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        if trigger_floodgate?(energy)
          emit(OUTPUT_ID, energy)
          try_callback(:on_react_flood, self, port, energy)
        end
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(threshold: @threshold)
      end

      def property_get(k)
        case k.to_s
        when "threshold" then @threshold
        else
          super(k)
        end
      end

      def property_set(k, v)
        case k.to_s
        when "threshold" then @threshold = v.to_i
        else
          super(k, v)
        end
      end

      ### registration
      register('floodgate')

    end
  end
end

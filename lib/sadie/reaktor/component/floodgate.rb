#
# Sadie/lib/sadie/reaktor/component/floodgate.rb
#   by IceDragon
#   dc 12/03/2013
#   dm 22/06/2013
module Sadie
  module Reaktor
    class Floodgate < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_ID  = :input, "input")

      ## outputs
      register_port(:out, OUTPUT_ID = :output, "output")

      ### instance_attributes
      attr_accessor :flood_trigger_thresh # Integer

      ##
      # init
      def init
        super
        @flood_trigger_thresh = 1
      end

      ##
      # trigger_floodgate?
      def trigger_floodgate?(energy)
        energy.value >= @flood_trigger_thresh
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
        super.merge(flood_trigger_thresh: @flood_trigger_thresh)
      end

      ### registration
      register('floodgate')

    end
  end
end

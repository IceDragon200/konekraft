#
# Sadie/lib/sadie/reaktor/component/drain.rb
#   by IceDragon
#   dc 12/03/2013
#   dm 22/06/2013
require 'sadie/reaktor2/component/base'
module Sadie
  module Reaktor2
    class Drain < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_ID  = :input, "input")

      ### instance_attributes
      attr_accessor :threshold

      def init
        super
        @threshold = 0
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        if energy.value >= threshold
          energy.value = 0
          try_callback(:on_react_drain, self, port, energy)
        end
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(threshold: threshold)
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
      register('drain')

    end
  end
end

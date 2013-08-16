#
# Sadie/lib/sadie/reaktor/component/drain.rb
#   by IceDragon
#   dc 12/03/2013
#   dm 22/06/2013
module Sadie
  module Reaktor
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

      ### registration
      register('drain')

    end
  end
end

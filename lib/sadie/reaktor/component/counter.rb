#
# Sadie/lib/sadie/reaktor/component/counter.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 22/06/2013
module Sadie
  module Reaktor
    class Counter < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_RESET_ID = :reset, "reset") # resetter
      register_port(:in,  INPUT_INC_ID   = :adder, "add")   # adder
      register_port(:in,  INPUT_DEC_ID   = :subtracter, "sub")   # subtracter

      ## outputs
      register_port(:out, OUTPUT_ID      = :output, "output") # unused

      ### instance_attributes
      attr_accessor :counter # Integer
      attr_accessor :threshold

      ##
      # init
      def init
        super
        @threshold = 1
        reset
      end

      ##
      # reset
      def reset
        super
        self.counter = 0
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        if energy.value >= threshold
          case port.id
          when INPUT_RESET_ID then reset
          when INPUT_INC_ID   then self.counter += 1
          when INPUT_DEC_ID   then self.counter -= 1
          end
        end
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(counter: counter)
      end

      ### registration
      register('counter')

    end
  end
end

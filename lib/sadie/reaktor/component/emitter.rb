#
# Sadie/lib/sadie/reaktor/component/emitter.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 22/06/2013
module Sadie
  module Reaktor
    class Emitter < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## outputs
      register_port(:out, OUTPUT_ID = :output, "output")

      ##
      # emit_energy
      def emit_energy
        @energy.dup
      end

      ##
      # trigger
      def trigger
        super
        emit(OUTPUT_ID)
      end

      ### registration
      register('emitter')

    end
  end
end

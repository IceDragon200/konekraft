#
# Konekraft/lib/konekraft/konekt/component/emitter.rb
#
require 'konekraft/konekt2/component/base'

module Konekraft
  module Konekt2
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

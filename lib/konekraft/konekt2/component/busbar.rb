#
# Konekraft/lib/konekraft/konekt/component/busbar.rb
#
require 'konekraft/konekt2/component/base'
module Konekraft
  module Konekt2
    class Busbar < Base

      ### constans
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_COMMON_ID = :common, "common")

      ## outputs
      register_port(:out, OUTPUT_FEED1_ID = :feed1, "feed1")
      register_port(:out, OUTPUT_FEED2_ID = :feed2, "feed2")
      register_port(:out, OUTPUT_FEED3_ID = :feed3, "feed3")
      register_port(:out, OUTPUT_FEED4_ID = :feed4, "feed4")
      register_port(:out, OUTPUT_FEED5_ID = :feed5, "feed5")
      register_port(:out, OUTPUT_FEED6_ID = :feed6, "feed6")
      register_port(:out, OUTPUT_FEED7_ID = :feed7, "feed7")
      register_port(:out, OUTPUT_FEED8_ID = :feed8, "feed8")

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        emit(OUTPUT_FEED1_ID, energy)
        emit(OUTPUT_FEED2_ID, energy)
        emit(OUTPUT_FEED3_ID, energy)
        emit(OUTPUT_FEED4_ID, energy)
        emit(OUTPUT_FEED5_ID, energy)
        emit(OUTPUT_FEED6_ID, energy)
        emit(OUTPUT_FEED7_ID, energy)
        emit(OUTPUT_FEED8_ID, energy)
      end

      ### registration
      register('busbar')

    end
  end
end

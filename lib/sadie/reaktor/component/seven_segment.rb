#
# Sadie/lib/sadie/reaktor/component/seven_segment.rb
#   by IceDragon
#   dc 14/04/2013
#   dm 22/06/2013
module Sadie
  module Reaktor
    class SevenSegment < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_CLEAR_SEGS_ID = :clear, "clear")
      register_port(:in,  INPUT_SEG1_ID       = :seg1_in, "seg1_in")
      register_port(:in,  INPUT_SEG2_ID       = :seg2_in, "seg2_in")
      register_port(:in,  INPUT_SEG3_ID       = :seg3_in, "seg3_in")
      register_port(:in,  INPUT_SEG4_ID       = :seg4_in, "seg4_in")
      register_port(:in,  INPUT_SEG5_ID       = :seg5_in, "seg5_in")
      register_port(:in,  INPUT_SEG6_ID       = :seg6_in, "seg6_in")
      register_port(:in,  INPUT_SEG7_ID       = :seg7_in, "seg7_in")

      ## outputs
      register_port(:out, OUTPUT_ID           = :output, "output")

      ### instance_attributes
      attr_accessor :segment_thresh # Integer

      ##
      # init
      def init
        super
        @segments = {
          INPUT_SEG1_ID => false,
          INPUT_SEG2_ID => false,
          INPUT_SEG3_ID => false,
          INPUT_SEG4_ID => false,
          INPUT_SEG5_ID => false,
          INPUT_SEG6_ID => false,
          INPUT_SEG7_ID => false
        }
        @segment_thresh = 1
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        case id = port.id
        when INPUT_CLEAR_SEGS_ID
          if energy.value >= @segment_thresh
            @segments.each_key do |key|
              @segments[key] = false
            end
          end
          try_callback(:on_react_clear, self, port, energy)
        when INPUT_SEG1_ID, INPUT_SEG2_ID, INPUT_SEG3_ID, INPUT_SEG4_ID,
             INPUT_SEG5_ID, INPUT_SEG6_ID, INPUT_SEG7_ID
          @segments[id] = energy.value >= @segment_thresh
          try_callback(:on_react_seg, self, port, energy)
        end
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(@segments)
      end

      ### registration
      register('seven_segment')

    end
  end
end

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
      attr_accessor :threshold # Integer

      ##
      # init
      def init
        super
        @segments = {
          seg1: false,
          seg2: false,
          seg3: false,
          seg4: false,
          seg5: false,
          seg6: false,
          seg7: false
        }
        @threshold = 1
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        case id = port.id
        when INPUT_CLEAR_SEGS_ID
          if energy.value >= @threshold
            @segments.each_key do |key|
              @segments[key] = false
            end
          end
          try_callback(:on_react_clear, self, port, energy)
        when INPUT_SEG1_ID, INPUT_SEG2_ID, INPUT_SEG3_ID, INPUT_SEG4_ID,
             INPUT_SEG5_ID, INPUT_SEG6_ID, INPUT_SEG7_ID
          @segments[id.to_s.gsub("_in","").to_sym] = energy.value >= @threshold
          try_callback(:on_react_seg, self, port, energy)
        end
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(@segments).merge(threshold: @threshold)
      end

      def property_get(k)
        case k.to_s
        when "seg1"      then @segments[:seg1]
        when "seg2"      then @segments[:seg2]
        when "seg3"      then @segments[:seg3]
        when "seg4"      then @segments[:seg4]
        when "seg5"      then @segments[:seg5]
        when "seg6"      then @segments[:seg6]
        when "seg7"      then @segments[:seg7]
        when "threshold" then @threshold
        else
          super(k)
        end
      end

      def property_set(k, v)
        case k.to_s
        when "seg1"      then @segments[:seg1] = bool_parse(v)
        when "seg2"      then @segments[:seg2] = bool_parse(v)
        when "seg3"      then @segments[:seg3] = bool_parse(v)
        when "seg4"      then @segments[:seg4] = bool_parse(v)
        when "seg5"      then @segments[:seg5] = bool_parse(v)
        when "seg6"      then @segments[:seg6] = bool_parse(v)
        when "seg7"      then @segments[:seg7] = bool_parse(v)
        when "threshold" then @threshold = v.to_i
        else
          super(k, v)
        end
      end

      ### registration
      register('seven_segment')

    end
  end
end

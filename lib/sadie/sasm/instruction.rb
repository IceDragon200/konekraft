#
# Sadie/lib/sadie/sasm/instruction.rb
#   by IceDragon
#   dc 21/05/2013
#   dm 30/07/2013
module Sadie
  module SASM
    class Instruction

      ### constants
      VERSION = "1.0.0".freeze

      ### instance_variables
      attr_reader :instruction_set
      attr_reader :opcode
      attr_reader :raw_params

      ##
      # initialize(inst_set, int opcode, params)
      def initialize(inst_set, opcode, params=[])
        @instruction_set = inst_set
        @opcode          = opcode
        @raw_params      = params
      end

      ##
      # instruction_spec
      def instruction_spec
        @instruction_set.instspec_table[@opcode]
      end

      ##
      # name
      def name
        instruction_spec.name
      end

      ##
      #
      def opcode
        instruction_spec.opcode
      end

      def params
        result = []
        raw = raw_params.dup
        for type in instruction_spec.param_types
          bytesize = Sadie::BitTool.type_bytesize(type)
          next unless bytesize > 0
          r = bytesize.times.map { raw.shift }
          result << (r.inject(0) { |r, i| (r | i) << 8 } >> 8)
        end
        return result
      end

      ##
      # literal_params
      def literal_params
        instruction_spec.param_types.zip(params).map do |(datatype, data)|
          Sadie::BitTool.literal_cast_as(datatype, data)
        end
      end

      def to_s
        "#{"%03d" % opcode} | #{name} #{params.join(", ")}"
      end

    end
  end
end

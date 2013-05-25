#
# Sadie/lib/sadie/sasm/instruction.rb
#   by IceDragon
#   dc 21/05/2013
#   dm 21/05/2013
module Sadie
  module SASM
    class Instruction

      ### constants
      VERSION = "1.0.0".freeze

      ### instance_variables
      attr_accessor :code
      attr_accessor :params

      ##
      # initialize(inst_set, code, params)
      def initialize(inst_set, code, params)
        @instruction_set = inst_set
        @code   = code
        @params = params
      end

      def instruction_spec
        @instruction_set.table[@code]
      end

      def cpu_sym
        instruction_spec.cpu_sym
      end

      def name
        instruction_spec.name
      end

      def exec_using(cpu)
        cpu.send(cpu_sym, @params)
      end

      def literal_params
        instruction_spec.param_types.zip(@params).map do |datatype, data|
          Sadie::SASM.literal_cast_as(datatype, data)
        end
      end

      def opcode
        instruction_spec.opcode(params)
      end

      def bytecode
        instruction_spec.bytecode(params)
      end

      def to_s
        "#{instruction_spec.name} #{literal_params.join(", ")}"
      end

    end
  end
end

#
# Sadie/lib/sadie/sasm/bytecode_interpreter.rb
#   by IceDragon
#   dc 27/05/2013
#   dm 29/05/2013
module Sadie
  module SASM
    class BytecodeInterpreter

      include Sadie::SASM::Constants

      ### instance_variables
      attr_reader :interpreter

      ##
      # initialize(Sadie::SASM::Interpreter interpreter)
      def initialize(interpreter)
        @interpreter = interpreter
      end

      ##
      # instruction_set -> Sadie::SASM::InstructionSet
      def instruction_set
        @interpreter.instruction_set
      end

      ##
      # exec(Integer bytecode, Array<Integer> params)
      def exec(bytecode, params)
        sym, ppend = self.class.bytecode_table[bytecode]
        code = Sadie::SASM::InstructionSet.name_to_code(sym)
        inst = Sadie::SASM::Instruction.new(instruction_set, code,
                                            ppend + params)
        @cpu.exec_inst(inst)
      end

      ##
      # ::bytecode_table
      def self.bytecode_table
        @bytecode_table ||= {}
      end

      ##
      # ::bytecode(Integer code, Symbol symbol, Array<Integer> params_prepend)
      def self.bytecode(code, symbol, *param_prepend)
        bytecode_table[code] = [symbol, param_prepend]
      end

    end
  end
end

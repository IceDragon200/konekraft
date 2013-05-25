#
# Sadie/lib/sadie/sasm/instruction_spec.rb
#   by IceDragon
#   dc 21/05/2013
#   dm 25/05/2013
module Sadie
  module SASM
    class InstructionSpec

      attr_accessor :bytesize
      attr_accessor :code
      attr_accessor :cpu_sym
      attr_accessor :name
      attr_accessor :param_types
      attr_writer :opcode

      def initialize(code, opcode, name, cpu_sym, param_types)
        @code, @opcode, @name, @cpu_sym, @param_types =
         code, opcode, name, cpu_sym, param_types
        @bytesize = 1
      end

      def calc_set(&func)
        @calc = func
      end

      def calc(want=:opcode, params)
        @calc ? @calc.(want, params) : (want == :opcode ? @opcode : params)
      end

      def opcode(params=nil)
        calc(:opcode, params)
      end

      def bytecode(params)
        opc = calc(:opcode, params)
        prm = calc(:params, params)
        return [opc] + prm
      end

    end
  end
end

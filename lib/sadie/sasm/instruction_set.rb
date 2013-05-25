#
# Sadie/lib/sadie/sasm/instruction_set.rb
#   dc 23/05/2013
#   dm 23/05/2013
module Sadie
  module SASM
    class InstructionSet

      include Sadie::SASM::Constants

      class NoInstructionError < Exception

        def initialize(inst)
          @inst = inst
        end

        def message
          "#{@inst.name}: no such instruction or label"
        end

      end

      class InstructionNameError < Exception
        #
      end

      ### constants
      VERSION = "1.0.0".freeze

      ### instance_variables
      attr_reader :cpu
      attr_reader :name

      def initialize(cpu)
        @cpu = cpu
        init_name
      end

      def init_name
        @name = "Sadie - NULL"
      end

      def reg(id)
        @cpu.reg(id)
      end

      def exec(inst)
        meth = inst.cpu_sym
        if respond_to?(meth)
          send(meth, *inst.params)
        else
          instruction_missing(inst)
        end
      end

      def instruction_missing(inst)
        raise(NoInstructionError, inst)
      end

      def self.table
        @table ||= {}
      end

      def self.mnemonic_to_code
        @mnemonic_to_code ||= {}
      end

      def self.name_to_code(name)
        BitTool.ary4_to_int32be(name.to_s.bytes)
      end

      ##
      # ::reg_instspec(Integer opcode,
      #                String name,
      #                Array<Symbol>* param_types) -> InstructionSpec
      def self.reg_instspec(opcode, name, param_types)
        code = name_to_code(name)
        cpu_sym = name.downcase.to_sym
        self.table[code] = InstructionSpec.new(code, opcode, name.upcase,
                                                    cpu_sym, param_types)
      end

      ##
      # ::setup_mnemonic_table
      def self.setup_mnemonic_table
        self.table.each_value do |instspec|
          self.mnemonic_to_code[instspec.name] = instspec.code
        end
      end

      def self.fix_inst_name(srcname)
        name = srcname.to_s
        raise(InstructionNameError, "name is too long") if name.size > 4
        raise(InstructionNameError,
              "name must start with ASCII letter") unless name[0] =~ /[A-Z]/i
        return name
      end

      def self.inst(opcode, srcname, *param_types, &block)
        (@inst_state ||= {})[srcname.upcase] = 1 # TEMP
        name  = fix_inst_name(srcname)
        reg_instspec(opcode, name, param_types) # register the InstructionSpec
        define_method(name, &block)
      end

      def self.uinst(opcode, srcname, *param_types)
        inst(opcode, srcname, *param_types) do |*args|
          puts "Unimplemented Instruction #{srcname.upcase}"
        end
        (@inst_state ||= {})[srcname.upcase] = -1 # TEMP
      end

      def self.einstspec(srcname)
        code = name_to_code(srcname)
        instspec = table[code]
        yield instspec if block_given?
        instspec
      end

      ## TEMP
      # _completion_rate -> Rate
      def self._completion_rate
        [@inst_state.values.count(-1), @inst_state.size]
      end

    end
  end
end

require 'sadie/sasm/instruction_set/is8085.rb'
require 'sadie/sasm/instruction_set/isavr.rb'

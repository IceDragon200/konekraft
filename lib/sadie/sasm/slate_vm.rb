#
# Sadie/lib/sadie/sasm/sasmvm.rb
#   by IceDragon
#   dc 28/07/2013
#   dm 28/07/2013
# vr 0.1.0
# CHANELOG
#   vr 0.1.0 (28/07/2013)
#     Started the Slate Virtual Machine
#
# Introduction
#   This is the Slate Virtual Machine, a virtual machine for the SASM language
module Sadie
  module SASM
    class SlateVM

      ### constants
      VERSION = "0.1.0".freeze

      ## memory
      @@default_memory_size = 0x10000

      ## instance_attributes
      attr_reader :cpu
      attr_reader :memory
      attr_reader :interpreter

      def initialize(memory_size=@@default_memory_size)
        @memory_blocksize = 8 # 8-bit
        @memory_size = memory_size
        init_cpu
        init_memory
        init_interpreter
      end

      ##
      # init_cpu
      def init_cpu
        @cpu = Sadie::SASM::Sacpu.new
      end

      ##
      # init_memory
      def init_memory
        @memory = Sadie::SASM::Sacpu::Memory.new(@cpu, @memory_size, @memory_blocksize)
      end

      def init_interpreter
        @interpreter = Sadie::SASM::Interpreter8085.new(@cpu)
      end

      ##
      # exec_opcode(int bytecode, *Array<int> parameters)
      def exec_opcode(bytecode, *parameters)
        @interpreter.exec_opcode(bytecode, *parameters)
      end

      ##
      # exec_inst(Sadie::SASM::Instruction inst)
      def exec_inst(inst)
        @interpreter.exec_inst(inst)
      end

      ##
      # exec_eval(String string)
      def exec_eval(string)
        #
      end

      ##
      # exec(*args)
      def exec(*args)
        arg = args.shift
        case arg
        when Integer                  then exec_opcode(arg, *args)
        when String                   then exec_eval(arg)
        when Sadie::SASM::Instruction then exec_inst(arg)
        else
          raise(ArgumentError, "expected a Bytecode or String or a Instruction")
        end
      end

    end
  end
end
#
# Sadie/lib/sadie/sasm/cpu.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 20/05/2013

# Sadie's Sacpu is a 16 bit CPU based on the Intel
# 8085 CPU, it interprets assembled SASM code
# Using 16 bit opcodes
#   INSTRUCTION-PARAM1-PARAM2-PARAM3
#   0000-0000-0000-0000
module Sadie
  module SASM
    class Sacpu

      include Sadie::SASM::Constants

      ### constants
      VERSION = "0.1.0".freeze

      ## InstructionSet
      IS_DEFAULT = Sadie::SASM::InstructionSet::IS8085

      ### instance_variables
      attr_reader :clock
      attr_reader :instruction_set
      attr_reader :interpreter
      attr_reader :memory
      attr_reader :register

      ##
      # initialize(Integer memory_size,)
      def initialize(memory_size, instset=IS_DEFAULT)
        @memory_size = memory_size
        @instruction_set = instset.new(self)
        init_clock
        init_register
        init_memory
        init_port
        init_interpreter
      end

      ##
      # init_clock
      def init_clock
        @clock = Sadie::SASM::Sacpu::Clock.new(self)
      end

      ##
      # init_register
      def init_register
        @register = {}
        REGISTERS.each do |code|
          size = REGISTER_SIZE[code]
          @register[code] = Sadie::SASM::Sacpu::Register.new(self, size)
        end.freeze
        REGISTER_PAIR.each_pair do |code, (h_id, l_id)|
          h, l = @register[h_id], @register[l_id]
          @register[code] = Sadie::SASM::Sacpu::RegisterPair.new(self, h, l)
        end
        sp.block_data_set(0xFFFF)
      end

      ##
      # init_memory
      def init_memory
        @memory = Sadie::SASM::Sacpu::Memory.new(self, @memory_size, 8)
      end

      ##
      # init_port
      def init_port
        @port = Sadie::SASM::Sacpu::Ports.new(self, 256, 256)
      end

      ##
      # init_interpreter
      def init_interpreter
        @interpreter = Sadie::SASM::Interpreter.new(self)
      end

      ##
      # freq_s
      #   translates to number of instructions per tick
      def freq_s
        "CPU Clock Frequency: #{@clock.frequency} hz"
      end

      ##
      # reg_abs(REG_ID id) -> Register
      def reg_abs(id)
        @register[id]
      end

      ##
      # reg(REG_ID id) -> Register
      def reg(id)
        id == REG_MEMORY ? @memory : reg_abs(id)
      end

      ##
      # reg_pair(REG_ID id) -> RegisterPair
      def reg_pair(id)
        id == REG_MEMORY ? @memory : reg_abs(CODE2REGPAIRCODE[id])
      end

      ##
      # accumulator
      def accumulator
        reg(REG_ACCUMULATOR)
      end

      ## REG_B
      # b
      def b
        reg(REG_B)
      end

      ## REG_C
      # c
      def c
        reg(REG_C)
      end

      ## REG_BC
      # bc
      def bc
        reg_pair(REG_BC)
      end

      ## REG_D
      # d
      def d
        reg(REG_D)
      end

      ## REG_E
      # e
      def e
        reg(REG_E)
      end

      ## REG_DE
      # de
      def de
        reg_pair(REG_DE)
      end

      ## REG_H
      # h
      def h
        reg(REG_H)
      end

      ## REG_L
      # l
      def l
        reg(REG_L)
      end

      ## REG_HL
      # hl
      def hl
        reg_pair(REG_HL)
      end

      ## REG_SP
      # stack_pointer
      def stack_pointer
        reg(REG_SP)
      end

      ## REG_PC
      # program_counter
      def program_counter
        reg(REG_PC)
      end

      ### flags
      ##
      # flag
      def flag
        reg(REG_FLAG)
      end

      ## flag.carry
      # carry
      def carry
        flag[FLAG_CARRY]
      end

      ##
      # carry
      def carry=(n)
        flag[FLAG_CARRY] = n
      end

      ##
      # flag_z
      def flag_z
        flag[FLAG_ZERO]
      end

      ##
      # flag_z=(Integer n)
      def flag_z=(n)
        flag[FLAG_ZERO] = n
      end

      ##
      # flag_p
      def flag_p
        flag[FLAG_PARITY]
      end

      ##
      # flag_p(Integer n)
      def flag_p=(n)
        flag[FLAG_PARITY] = n
      end

      ##
      # flag_s
      def flag_s
        flag[FLAG_SIGN]
      end

      ##
      # flag_s=(Integer n)
      def flag_s=(n)
        flag[FLAG_SIGN] = n
      end

      ##
      # memory_pointer_reg -> Register
      def memory_pointer_reg
        hl
      end

      ##
      # memory_pointer_value -> Integer
      def memory_pointer_value
        memory_pointer_reg.block_data
      end

      ##
      # to_s
      def to_s
        [[:A, a],
         [:B, b], [:C, c], [:D, d], [:E, e],
         [:H, h], [:L, l], [:PC, pc], [:SP, sp]
         ].map { |a| "%s[%s]" % [a[0], a[1].to_s] }.join("\n")
      end

      ##
      # interupt!
      def interupt!
        # TODO
      end

      ### Instructions

      ##
      # exec_inst(Instruction inst)
      def exec_inst(inst)
        @instruction_set.exec(inst)
      end

      alias :a :accumulator
      alias :f :flag
      alias :pc :program_counter
      alias :sp :stack_pointer
      alias :m :memory
      alias :mem :memory

    end
  end
end

require 'sadie/sasm/sacpu/clock'
require 'sadie/sasm/sacpu/memory'
require 'sadie/sasm/sacpu/register'
require 'sadie/sasm/sacpu/register_pair'
require 'sadie/sasm/sacpu/ports'

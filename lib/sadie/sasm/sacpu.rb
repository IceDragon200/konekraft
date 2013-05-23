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

      ##
      # Constants
      VERSION = "0.1.0".freeze

      # Boolean and such
      BNULL  = 0x0
      BFALSE = 0x0
      BTRUE  = 0x1

      # BitMask[bit_index]
      BITMASK = (Array.new(16) { |i| (i > 0) ? (2 ** (i - 1)) : 0 }).freeze

      # Registers
      REG_ACCUMULATOR =
        REG_A      = 0x0 #  8-bit Accumulator
      REG_FLAG =
        REG_F      = 0x1 #  8-bit Flag Register
      # B // C
      REG_B        = 0x2 #  8-bit General Register B
      REG_C        = 0x3 #  8-bit General Register C
      # D // E
      REG_D        = 0x4 #  8-bit General Register D
      REG_E        = 0x5 #  8-bit General Register E
      # HL Registers 16 bit pair - Memory Location (RAM)
      REG_H        = 0x6 #  8-bit General Register H
      REG_L        = 0x7 #  8-bit General Register L
      # used for position in memory
      REG_STACK_POINTER =
        REG_SP     = 0x8 # 16-bit Stack Pointer (SP)
      # used for the program index
      REG_PROGRAM_COUNTER =
        REG_PC     = 0x9 # 16-bit Program Counter (PC)

      REG_MEMORY   = 0x10 # Not really a register used to access the memory bank

      # Flag Register Index
      FLAG_SIGN      = 0x0
      FLAG_ZERO      = 0x1
      FLAG_AUX_CARRY = 0x2
      FLAG_PARITY    = 0x3
      FLAG_CARRY     = 0x4

      REGISTER2CODE = {
        "A"    => REG_ACCUMULATOR,
        "ACM"  => REG_ACCUMULATOR,
        "B"    => REG_B,
        "C"    => REG_C,
        "D"    => REG_D,
        "E"    => REG_E,
        "H"    => REG_H,
        "L"    => REG_L,
        "SP"   => REG_STACK_POINTER,
        "PC"   => REG_PROGRAM_COUNTER,
        "FLAG" => REG_FLAG,
        "M"    => REG_MEMORY,
        "MEM"  => REG_MEMORY,
      }

      CODE2REGISTER = REGISTER2CODE.invert

      REGISTER_SIZE = {
        REG_A    => 8,
        REG_B    => 8,
        REG_C    => 8,
        REG_D    => 8,
        REG_E    => 8,
        REG_H    => 8,
        REG_L    => 8,
        REG_SP   => 16,
        REG_PC   => 16,
        REG_FLAG => 8
      }

      IS_DEFAULT = Sadie::SASM::InstructionSet::IS8085

      attr_reader :clock
      attr_reader :interpreter
      attr_reader :memory
      attr_reader :register

      def initialize(memory_size, instset=IS_DEFAULT)
        @memory_size = memory_size
        @instruction_set = instset.new(self)
        init_clock
        init_register
        init_memory
        init_interpreter
      end

      def init_clock
        @clock = Sadie::SASM::Sacpu::Clock.new(self)
      end

      def init_register
        @register = REGISTER_SIZE.each_with_object({}) do |(k, size), register|
          register[k] = Sadie::SASM::Sacpu::Register.new(self, size)
        end
      end

      def init_memory
        @memory = Sadie::SASM::Sacpu::Memory.new(self, @memory_size, 8)
      end

      def init_interpreter
        @interpreter = Sadie::SASM::Interpreter.new(self)
      end

      ##
      # freq_s
      #   translates to number of instructions per tick
      def freq_s
        "CPU Clock Frequency: #{@clock.frequency} hz"
      end

      def reg(id)
        id == REG_MEMORY ? @memory : @register[id]
      end

      def reg_pair(aid, bid)
        reg(aid).mend(reg(bid))
      end

      def accumulator
        reg(REG_ACCUMULATOR)
      end

      def b
        reg(REG_B)
      end

      def c
        reg(REG_C)
      end

      def d
        reg(REG_D)
      end

      def e
        reg(REG_E)
      end

      def h
        reg(REG_H)
      end

      def l
        reg(REG_L)
      end

      def stack_pointer
        reg(REG_SP)
      end

      def program_counter
        reg(REG_PC)
      end

      def flag
        reg(REG_FLAG)
      end

      def carry
        flag[FLAG_CARRY]
      end

      def carry=(n)
        flag[FLAG_CARRY] = n
      end

      def flag_z
        flag[FLAG_ZERO]
      end

      def flag_z=(n)
        flag[FLAG_ZERO] = n
      end

      def memory_pointer_reg
        h.mend(l)
      end

      def memory_pointer_value
        memory_pointer_reg.block_data
      end

      def to_s
        [[:A, a],
         [:B, b], [:C, c], [:D, d], [:E, e],
         [:H, h], [:L, l], [:PC, pc], [:SP, sp]
         ].map { |a| "%s[%s]" % [a[0], a[1].to_s] }.join("\n")
      end

      def interupt!
        # TODO
      end

      ### Instructions

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

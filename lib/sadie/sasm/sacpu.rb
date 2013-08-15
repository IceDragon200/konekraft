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

      ### instance_variables
      attr_reader :clock
      attr_reader :register
      attr_accessor :memory

      ##
      # initialize([int memory_size, SASM::InstructionSet instset])
      #   (memory_size) is in number of bytes
      def initialize
        init_clock
        init_register
        init_port
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
        reg_sp.cell_data_set(0xFFFF)
      end

      ##
      # init_port
      def init_port
        @port = Sadie::SASM::Sacpu::Ports.new(self, 256, 256)
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
      # reg_accumulator
      def reg_accumulator
        reg(REG_ACCUMULATOR)
      end

      ## REG_B
      # reg_b
      def reg_b
        reg(REG_B)
      end

      ## REG_C
      # reg_c
      def reg_c
        reg(REG_C)
      end

      ## REG_BC
      # reg_bc
      def reg_bc
        reg_pair(REG_BC)
      end

      ## REG_D
      # reg_d
      def reg_d
        reg(REG_D)
      end

      ## REG_E
      # reg_e
      def reg_e
        reg(REG_E)
      end

      ## REG_DE
      # reg_de
      def reg_de
        reg_pair(REG_DE)
      end

      ## REG_H
      # reg_h
      def reg_h
        reg(REG_H)
      end

      ## REG_L
      # reg_l
      def reg_l
        reg(REG_L)
      end

      ## REG_HL
      # reg_hl
      def reg_hl
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
      # reg_flag
      def reg_flag
        reg(REG_FLAG)
      end

      ## reg_flag.ac
      # flag_ac
      #   Auxillary Carry
      def flag_ac
        reg_flag[FLAG_AUX_CARRY]
      end

      ##
      # flag_ac=(bit n)
      def flag_ac=(n)
        reg_flag[FLAG_AUX_CARRY] = n
      end

      ## reg_flag.carry
      # flag_c
      def flag_c
        reg_flag[FLAG_C]
      end

      ##
      # flag_c=(bit n)
      def flag_c=(n)
        reg_flag[FLAG_C] = n
      end

      ##
      # flag_z
      def flag_z
        reg_flag[FLAG_ZERO]
      end

      ##
      # flag_z=(bit n)
      def flag_z=(n)
        reg_flag[FLAG_ZERO] = n
      end

      ##
      # flag_p
      def flag_p
        reg_flag[FLAG_PARITY]
      end

      ##
      # flag_p(bit n)
      def flag_p=(n)
        reg_flag[FLAG_PARITY] = n
      end

      ##
      # flag_s
      def flag_s
        reg_flag[FLAG_SIGN]
      end

      ##
      # flag_s=(bit n)
      def flag_s=(n)
        reg_flag[FLAG_SIGN] = n
      end

      ##
      # memory_pointer_reg -> Register
      def memory_pointer_reg
        reg_hl
      end

      ##
      # memory_pointer_value -> Integer
      def memory_pointer_value
        memory_pointer_reg.cell_data
      end

      def clear_flags
        reg_flag.cell_data_set(0)
      end

      ##
      # to_s
      def to_s
        [[:A, reg_a],
         [:B, reg_b], [:C, reg_c], [:D, reg_d], [:E, reg_e],
         [:H, reg_h], [:L, reg_l], [:PC, reg_pc], [:SP, reg_sp]
         ].map { |a| "%s  %s" % [a[0], a[1].to_s] }.join("\n")
      end

      ##
      # interupt!
      def interupt!
        # TODO
      end

      alias :reg_a :reg_accumulator
      alias :reg_f :reg_flag
      alias :reg_pc :program_counter
      alias :reg_sp :stack_pointer

    end
  end
end

require 'sadie/sasm/sacpu/clock'
require 'sadie/sasm/sacpu/memory'
require 'sadie/sasm/sacpu/register'
require 'sadie/sasm/sacpu/register_pair'
require 'sadie/sasm/sacpu/ports'

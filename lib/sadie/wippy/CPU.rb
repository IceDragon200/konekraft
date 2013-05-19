#
# Sadie/src/CPU.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 14/05/2013

# one day this place will grow codez
# Sadie's Sacpu is a 16 bit CPU based on the Intel
# 8085 CPU, it interprets assembled SASM code
# Using 16 bit opcodes
#   INSTRUCTION-PARAM1-PARAM2-PARAM3
#   0000-0000-0000-0000
module Sadie
  class Sacpu

    class Register < BitArray
    end

    ##
    # Constants
    VERSION = "0.0.1".freeze

    # Boolean and such
    BNULL  = 0x0
    BFALSE = 0x0
    BTRUE  = 0x1

    # BitMask[bit_index]
    BITMASK = (Array.new(16) { |i| i > 0 ? 2 ** (i - 1) : 0 }).freeze

    # Registers
    REG_ACM =
      REG_A      = 0x0 #  8-bit Accumulator
    REG_FLAG =
      REG_F      = 0x1 #  8-bit Flag Register
    # B // C
    REG_B        = 0x2 #  8-bit General Register B
    REG_C        = 0x3 #  8-bit General Register C
    # D // E
    REG_D        = 0x4 #  8-bit General Register D
    REG_E        = 0x5 #  8-bit General Register E
    # HL Registers 16 bit pair 3 - Memory Location (RAM)
    REG_H        = 0x6 #  8-bit General Register H
    REG_L        = 0x7 #  8-bit General Register L

    REG_STCK_PNT = 0x8 # 16-bit Stack Pointer (SP)
    REG_PROG_CNT = 0x9 # 16-bit Program Counter (PC)

    # Flag Register Index
    FLAG_SIGN      = 0x0
    FLAG_ZERO      = 0x1
    FLAG_AUX_CARRY = 0x2
    FLAG_PARITY    = 0x3
    FLAG_CARRY     = 0x4

    REGISTER2CODE = {
      "A" => REG_A,
      "F" => REG_F,
      "B" => REG_B,
      "C" => REG_C,
      "D" => REG_D,
      "E" => REG_E,
      "H" => REG_H,
      "L" => REG_L,
    }

    attr_reader :register

    def initialize
      @register = {}
      @register[REG_ACM]      = Register.new(8)
      @register[REG_FLAG]     = Register.new(8)
      @register[REG_B]        = Register.new(8)
      @register[REG_C]        = Register.new(8)
      @register[REG_D]        = Register.new(8)
      @register[REG_E]        = Register.new(8)
      @register[REG_H]        = Register.new(8)
      @register[REG_L]        = Register.new(8)
      @register[REG_STCK_PNT] = Register.new(16)
      @register[REG_PROG_CNT] = Register.new(16)
    end

    def reg(id)
      @register[id]
    end

    def interupt!
      # TODO
    end

    ### Instructions

    ##
    # add(REG sreg1_id, REG sreg2_id, REG treg_id)
    def add(sreg1_id, sreg2_id, treg_id=sreg1_id)
      reg(treg_id).set(reg(sreg1_id).add(reg(sreg2_id)))
    end

    # addi(REG sreg_id, Numeric num, REG treg_id)
    def addi(sreg_id, num, treg_id=sreg_id)
      reg(treg_id).set(reg(sreg_id).add(num))
    end

    # sub(REG sreg1_id, REG sreg2_id, REG treg_id)
    def sub(sreg1_id, sreg2_id, treg_id=sreg1_id)
      reg(treg_id).set(reg(sreg1_id).sub(reg(sreg2_id)))
    end

    # subi(REG sreg_id, Numeric num, REG treg_id)
    def subi(sreg_id, num, treg_id=sreg_id)
      reg(treg_id).set(reg(sreg_id).sub(num))
    end

    # mul(REG sreg1_id, REG sreg2_id, REG treg_id)
    def mul(sreg1_id, sreg2_id, treg_id=sreg1_id)
      reg(treg_id).set(reg(sreg1_id).mul(reg(sreg2_id)))
    end

    # muli(REG sreg_id, Numeric num, REG treg_id)
    def muli(sreg_id, num, treg_id=sreg_id)
      reg(treg_id).set(reg(sreg_id).mul(num))
    end

    # div(REG sreg1_id, REG sreg2_id, REG treg_id)
    def div(sreg1_id, sreg2_id, treg_id=sreg1_id)
      reg(treg_id).set(reg(sreg1_id).div(reg(sreg2_id)))
    end

    # divi(REG sreg_id, Numeric num, REG treg_id)
    def divi(sreg_id, num, treg_id=sreg_id)
      reg(treg_id).set(reg(sreg_id).div(num))
    end

    # mov(REG reg1_id, REG reg2_id)
    def mov(reg1_id, reg2_id)
      reg(reg1_id).set(reg(reg2_id))
    end

    # hlt(REG reg1_id, REG reg2_id)
    def hlt(reg1_id, reg2_id)
      interupt!
    end

  end
end

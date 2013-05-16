#
# Sadie/src/i8085-microprocessor.rb
#   by IceDragon
#   dc 11/05/2013
#   dm 11/05/2013
# vr 0.0.1
module Sadie

class Intel8085

  BNULL  = 0
  BFALSE = 0
  BTRUE  = 1

  # Registers
  REG_ACM =
    REG_A      = 0x0 #  8-bit Accumulator
  REG_FLAG     = 0x1 #  8-bit Flag Register
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

  attr_reader :register

  def initialize
    @register = {}
    @register[REG_ACM]      = BitArray.new(8)
    @register[REG_FLAG]     = BitArray.new(8)
    @register[REG_B]        = BitArray.new(8)
    @register[REG_C]        = BitArray.new(8)
    @register[REG_D]        = BitArray.new(8)
    @register[REG_E]        = BitArray.new(8)
    @register[REG_H]        = BitArray.new(8)
    @register[REG_L]        = BitArray.new(8)
    @register[REG_STCK_PNT] = BitArray.new(16)
    @register[REG_PROG_CNT] = BitArray.new(16)
  end

end

end

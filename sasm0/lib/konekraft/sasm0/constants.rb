#
# konekraft/sasm0/constants.rb
#
module Konekraft
  module SlateAssembly0
    module Constants
      ## Bit Booleans
      BNULL  = 0x0
      BFALSE = 0x0
      BTRUE  = 0x1

      ## BITMASK[Integer bit_index]
      BITMASK = (Array.new(16) { |i| (i > 0) ? (2 ** (i - 1)) : 0 }).freeze

      ## registers
      #REG_MASK = 0x10000000
      #REG_PAIR_MASK = REG_MASK | 0x1000
      REG_ACCUMULATOR = REG_A      = :reg_a   #  8-bit Accumulator
      REG_FLAG = REG_F             = :reg_f   #  8-bit Flag Register
      REG_B                        = :reg_b   #  8-bit general Register B
      REG_C                        = :reg_c   #  8-bit general Register C
      REG_D                        = :reg_d   #  8-bit general Register D
      REG_E                        = :reg_e   #  8-bit general Register E
      REG_H                        = :reg_h   #  8-bit general Register H
      REG_L                        = :reg_l   #  8-bit general Register L
      REG_AF                       = :reg_af  # 16-bit pair Register AF - Special
      REG_BC                       = :reg_bc  # 16-bit pair Register BC - General
      REG_DE                       = :reg_de  # 16-bit pair Register DE - General
      REG_HL                       = :reg_hl  # 16-bit pair Register HL - Memory
      REG_PSW                      = :reg_psw # Process State Word
      REG_STACK_POINTER = REG_SP   = :reg_sp  # 16-bit Stack Pointer (SP)
      REG_PROGRAM_COUNTER = REG_PC = :reg_pc  # 16-bit Program Counter (PC)
      REG_MEMORY = REG_M           = :reg_m   # Not really a register used to access the memory bank

      ## flag_index
      FLAG_SIGN      = 0x0
      FLAG_ZERO      = 0x1
      FLAG_AUX_CARRY = 0x2
      FLAG_PARITY    = 0x3
      FLAG_CARRY     = 0x4

      REGISTERS = [REG_A,
                   REG_FLAG,
                   REG_B, REG_C,
                   REG_D, REG_E,
                   REG_H, REG_L,
                   REG_PSW,
                   REG_PC,
                   REG_SP]

      ## REGISTER2CODE[String code] -> Integer code
      REGISTER2CODE = {
        "ACM"  => REG_ACCUMULATOR,
        "A"    => REG_ACCUMULATOR,
        "FLAG" => REG_FLAG,
        "F"    => REG_F,
        "AF"   => REG_AF,
        "B"    => REG_B,
        "C"    => REG_C,
        "BC"   => REG_BC,
        "D"    => REG_D,
        "E"    => REG_E,
        "DE"   => REG_DE,
        "H"    => REG_H,
        "L"    => REG_L,
        "HL"   => REG_HL,
        "PSW"  => REG_PSW,
        "PC"   => REG_PROGRAM_COUNTER,
        "SP"   => REG_STACK_POINTER,
        "MEM"  => REG_MEMORY,
        "M"    => REG_MEMORY,
      }

      REGISTERPAIR2CODE = {
        "A"   => REG_AF,
        "F"   => REG_AF,
        "AF"  => REG_AF,
        "B"   => REG_BC,
        "C"   => REG_BC,
        "BC"  => REG_BC,
        "D"   => REG_DE,
        "E"   => REG_DE,
        "DE"  => REG_DE,
        "H"   => REG_HL,
        "L"   => REG_HL,
        "HL"  => REG_HL,
        "PSW" => REG_PSW,
        "PC"  => REG_PC,
        "SP"  => REG_SP,
      }

      CODE2REGPAIRCODE = {
        REG_A   => REG_AF,
        REG_F   => REG_AF,
        REG_AF  => REG_AF,
        REG_B   => REG_BC,
        REG_C   => REG_BC,
        REG_BC  => REG_BC,
        REG_D   => REG_DE,
        REG_E   => REG_DE,
        REG_DE  => REG_DE,
        REG_H   => REG_HL,
        REG_L   => REG_HL,
        REG_HL  => REG_HL,
        REG_PSW => REG_PSW,
        REG_PC  => REG_PC,
        REG_SP  => REG_SP,
      }

      ## REGISTER2CODE[Integer code] -> String code
      CODE2REGISTER = REGISTER2CODE.invert

      ## REGISTER_SIZE[REG_ID] -> Integer size
      REGISTER_SIZE = {
        REG_A   => 8,
        REG_F   => 8,
        REG_AF  => 16,
        REG_B   => 8,
        REG_C   => 8,
        REG_BC  => 16,
        REG_D   => 8,
        REG_E   => 8,
        REG_DE  => 16,
        REG_H   => 8,
        REG_L   => 8,
        REG_HL  => 16,
        REG_PSW => 16,
        REG_PC  => 16,
        REG_SP  => 16,
      }

      ## REGISTER_PAIR[REG_PAIR_ID] -> Array[HIGH_ID, LOW_ID] pair
      REGISTER_PAIR = {
        REG_AF => [REG_A, REG_F],
        REG_BC => [REG_B, REG_C],
        REG_DE => [REG_D, REG_E],
        REG_HL => [REG_H, REG_L],
      }
    end
  end
end

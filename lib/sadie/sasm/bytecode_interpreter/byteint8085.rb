module Sadie
  module SASM
    class BytecodeInterpreter8085 < Sadie::SASM::BytecodeInterpreter

      bytecode 0x00, :nop
      bytecode 0x01, :lxi, REG_BC
      bytecode 0x02, :stax, REG_BC
      bytecode 0x03, :inx, REG_BC
      bytecode 0x04, :inr, REG_B
      bytecode 0x05, :dcr, REG_B
      bytecode 0x06, :mvi, REG_B
      bytecode 0x07, :rlc
      bytecode 0x08, :nop
      bytecode 0x09, :dad, REG_BC
      bytecode 0x0A, :ldax, REG_BC
      bytecode 0x0B, :dcx, REG_BC
      bytecode 0x0C, :inr, REG_C
      bytecode 0x0D, :dcr, REG_C
      bytecode 0x0E, :mvi, REG_C
      bytecode 0x0F, :rrc
      bytecode 0x10, :nop
      bytecode 0x11, :lxi, REG_DE
      bytecode 0x12, :stax, REG_DE
      bytecode 0x13, :inx, REG_DE
      bytecode 0x14, :inr, REG_D
      bytecode 0x15, :dcr, REG_D
      bytecode 0x16, :mvi, REG_D
      bytecode 0x17, :ral
      bytecode 0x18, :nop
      bytecode 0x19, :dad, REG_DE
      bytecode 0x1A, :ldax, REG_DE
      bytecode 0x1B, :dcx, REG_DE
      bytecode 0x1C, :inr, REG_E
      bytecode 0x1D, :dcr, REG_E
      bytecode 0x1E, :mvi, REG_E
      bytecode 0x1F, :rar
      bytecode 0x20, :rim
      bytecode 0x21, :lxi, REG_HL
      bytecode 0x22, :shld
      bytecode 0x23, :inx, REG_HL
      bytecode 0x24, :inr, REG_H
      bytecode 0x25, :dcr, REG_H
      bytecode 0x26, :mvi, REG_H
      bytecode 0x27, :daa
      bytecode 0x28, :nop
      bytecode 0x29, :dad, REG_HL
      bytecode 0x2A, :lhld
      bytecode 0x2B, :dcx, REG_HL
      bytecode 0x2C, :inr, REG_L
      bytecode 0x2D, :dcr, REG_L
      bytecode 0x2E, :mvi, REG_L
      bytecode 0x2F, :cma
      bytecode 0x30, :sim
      bytecode 0x31, :lxi, REG_SP
      bytecode 0x32, :sta
      bytecode 0x33, :inx, REG_SP
      bytecode 0x34, :inr, REG_M
      bytecode 0x35, :dcr, REG_M
      bytecode 0x36, :mvi, REG_M
      bytecode 0x37, :stc
      bytecode 0x38, :nop
      bytecode 0x39, :dad, REG_SP
      bytecode 0x3A, :lda
      bytecode 0x3B, :dcx, REG_SP
      bytecode 0x3C, :inr, REG_A
      bytecode 0x3D, :dcr, REG_A
      bytecode 0x3E, :mvi, REG_A
      bytecode 0x3F, :cmc
      bytecode 0x40, :mov, REG_B, REG_B
      bytecode 0x41, :mov, REG_B, REG_C
      bytecode 0x42, :mov, REG_B, REG_D
      bytecode 0x43, :mov, REG_B, REG_E
      bytecode 0x44, :mov, REG_B, REG_H
      bytecode 0x45, :mov, REG_B, REG_L
      bytecode 0x46, :mov, REG_B, REG_M
      bytecode 0x47, :mov, REG_B, REG_A
      bytecode 0x48, :mov, REG_C, REG_B
      bytecode 0x49, :mov, REG_C, REG_C
      bytecode 0x4A, :mov, REG_C, REG_D
      bytecode 0x4B, :mov, REG_C, REG_E
      bytecode 0x4C, :mov, REG_C, REG_H
      bytecode 0x4D, :mov, REG_C, REG_L
      bytecode 0x4E, :mov, REG_C, REG_M
      bytecode 0x4F, :mov, REG_C, REG_A
      bytecode 0x50, :mov, REG_D, REG_B
      bytecode 0x51, :mov, REG_D, REG_C
      bytecode 0x52, :mov, REG_D, REG_D
      bytecode 0x53, :mov, REG_D, REG_E
      bytecode 0x54, :mov, REG_D, REG_H
      bytecode 0x55, :mov, REG_D, REG_L
      bytecode 0x56, :mov, REG_D, REG_M
      bytecode 0x57, :mov, REG_D, REG_A
      bytecode 0x58, :mov, REG_E, REG_B
      bytecode 0x59, :mov, REG_E, REG_C
      bytecode 0x5A, :mov, REG_E, REG_D
      bytecode 0x5B, :mov, REG_E, REG_E
      bytecode 0x5C, :mov, REG_E, REG_H
      bytecode 0x5D, :mov, REG_E, REG_L
      bytecode 0x5E, :mov, REG_E, REG_M
      bytecode 0x5F, :mov, REG_E, REG_A
      bytecode 0x60, :mov, REG_H, REG_B
      bytecode 0x61, :mov, REG_H, REG_C
      bytecode 0x62, :mov, REG_H, REG_D
      bytecode 0x63, :mov, REG_H, REG_E
      bytecode 0x64, :mov, REG_H, REG_H
      bytecode 0x65, :mov, REG_H, REG_L
      bytecode 0x66, :mov, REG_H, REG_M
      bytecode 0x67, :mov, REG_H, REG_A
      bytecode 0x68, :mov, REG_L, REG_B
      bytecode 0x69, :mov, REG_L, REG_C
      bytecode 0x6A, :mov, REG_L, REG_D
      bytecode 0x6B, :mov, REG_L, REG_E
      bytecode 0x6C, :mov, REG_L, REG_H
      bytecode 0x6D, :mov, REG_L, REG_L
      bytecode 0x6E, :mov, REG_L, REG_M
      bytecode 0x6F, :mov, REG_L, REG_A
      bytecode 0x70, :mov, REG_M, REG_B
      bytecode 0x71, :mov, REG_M, REG_C
      bytecode 0x72, :mov, REG_M, REG_D
      bytecode 0x73, :mov, REG_M, REG_E
      bytecode 0x74, :mov, REG_M, REG_H
      bytecode 0x75, :mov, REG_M, REG_L
      bytecode 0x76, :hlt
      bytecode 0x77, :mov, REG_M, REG_A
      bytecode 0x78, :mov, REG_A, REG_B
      bytecode 0x79, :mov, REG_A, REG_C
      bytecode 0x7A, :mov, REG_A, REG_D
      bytecode 0x7B, :mov, REG_A, REG_E
      bytecode 0x7C, :mov, REG_A, REG_H
      bytecode 0x7D, :mov, REG_A, REG_L
      bytecode 0x7E, :mov, REG_A, REG_M
      bytecode 0x7F, :mov, REG_A, REG_A
      bytecode 0x80, :add, REG_B
      bytecode 0x81, :add, REG_C
      bytecode 0x82, :add, REG_D
      bytecode 0x83, :add, REG_E
      bytecode 0x84, :add, REG_H
      bytecode 0x85, :add, REG_L
      bytecode 0x86, :add, REG_M
      bytecode 0x87, :add, REG_A
      bytecode 0x88, :adc, REG_B
      bytecode 0x89, :adc, REG_C
      bytecode 0x8A, :adc, REG_D
      bytecode 0x8B, :adc, REG_E
      bytecode 0x8C, :adc, REG_H
      bytecode 0x8D, :adc, REG_L
      bytecode 0x8E, :adc, REG_M
      bytecode 0x8F, :adc, REG_A
      bytecode 0x90, :sub, REG_B
      bytecode 0x91, :sub, REG_C
      bytecode 0x92, :sub, REG_D
      bytecode 0x93, :sub, REG_E
      bytecode 0x94, :sub, REG_H
      bytecode 0x95, :sub, REG_L
      bytecode 0x96, :sub, REG_M
      bytecode 0x97, :sub, REG_A
      bytecode 0x98, :sbb, REG_B
      bytecode 0x99, :sbb, REG_C
      bytecode 0x9A, :sbb, REG_D
      bytecode 0x9B, :sbb, REG_E
      bytecode 0x9C, :sbb, REG_H
      bytecode 0x9D, :sbb, REG_L
      bytecode 0x9E, :sbb, REG_M
      bytecode 0x9F, :sbb, REG_A
      bytecode 0xA0, :ana, REG_B
      bytecode 0xA1, :ana, REG_C
      bytecode 0xA2, :ana, REG_D
      bytecode 0xA3, :ana, REG_E
      bytecode 0xA4, :ana, REG_H
      bytecode 0xA5, :ana, REG_L
      bytecode 0xA6, :ana, REG_M
      bytecode 0xA7, :ana, REG_A
      bytecode 0xA8, :xra, REG_B
      bytecode 0xA9, :xra, REG_C
      bytecode 0xAA, :xra, REG_D
      bytecode 0xAB, :xra, REG_E
      bytecode 0xAC, :xra, REG_H
      bytecode 0xAD, :xra, REG_L
      bytecode 0xAE, :xra, REG_M
      bytecode 0xAF, :xra, REG_A
      bytecode 0xB0, :ora, REG_B
      bytecode 0xB1, :ora, REG_C
      bytecode 0xB2, :ora, REG_D
      bytecode 0xB3, :ora, REG_E
      bytecode 0xB4, :ora, REG_H
      bytecode 0xB5, :ora, REG_L
      bytecode 0xB6, :ora, REG_M
      bytecode 0xB7, :ora, REG_A
      bytecode 0xB8, :cmp, REG_B
      bytecode 0xB9, :cmp, REG_C
      bytecode 0xBA, :cmp, REG_D
      bytecode 0xBB, :cmp, REG_E
      bytecode 0xBC, :cmp, REG_H
      bytecode 0xBD, :cmp, REG_L
      bytecode 0xBE, :cmp, REG_M
      bytecode 0xBF, :cmp, REG_A
      bytecode 0xC0, :rnz
      bytecode 0xC1, :pop, REG_BC
      bytecode 0xC2, :jnz
      bytecode 0xC3, :jmp
      bytecode 0xC4, :cnz
      bytecode 0xC5, :push, REG_BC
      bytecode 0xC6, :adi
      bytecode 0xC7, :rst, 0
      bytecode 0xC8, :rz
      bytecode 0xC9, :ret
      bytecode 0xCA, :jz
      bytecode 0xCB, :nop
      bytecode 0xCC, :cz
      bytecode 0xCD, :call
      bytecode 0xCE, :aci
      bytecode 0xCF, :rst, 1
      bytecode 0xD0, :rnc
      bytecode 0xD1, :pop, REG_DE
      bytecode 0xD2, :jnc
      bytecode 0xD3, :out
      bytecode 0xD4, :cnc
      bytecode 0xD5, :push, REG_DE
      bytecode 0xD6, :sui
      bytecode 0xD7, :rst, 2
      bytecode 0xD8, :rc
      bytecode 0xD9, :nop
      bytecode 0xDA, :jc
      bytecode 0xDB, :in
      bytecode 0xDC, :cc
      bytecode 0xDD, :nop
      bytecode 0xDE, :sbi
      bytecode 0xDF, :rst, 3
      bytecode 0xE0, :rpo
      bytecode 0xE1, :pop, REG_HL
      bytecode 0xE2, :jpo
      bytecode 0xE3, :xthl
      bytecode 0xE4, :cpo
      bytecode 0xE5, :push, REG_HL
      bytecode 0xE6, :ani
      bytecode 0xE7, :rst, 4
      bytecode 0xE8, :rpe
      bytecode 0xE9, :pchl
      bytecode 0xEA, :jpe
      bytecode 0xEB, :xchg
      bytecode 0xEC, :cpe
      bytecode 0xED, :nop
      bytecode 0xEE, :xri
      bytecode 0xEF, :rst, 5
      bytecode 0xF0, :rp
      bytecode 0xF1, :pop, REG_PSW
      bytecode 0xF2, :jp
      bytecode 0xF3, :di
      bytecode 0xF4, :cp
      bytecode 0xF5, :push, REG_PSW
      bytecode 0xF6, :ori
      bytecode 0xF7, :rst, 6
      bytecode 0xF8, :rm
      bytecode 0xF9, :sphl
      bytecode 0xFA, :jm
      bytecode 0xFB, :ei
      bytecode 0xFC, :cm
      bytecode 0xFD, :nop
      bytecode 0xFE, :cpi
      bytecode 0xFF, :rst, 7

    end
  end
end



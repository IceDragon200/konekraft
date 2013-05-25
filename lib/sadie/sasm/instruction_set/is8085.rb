#
# Sadie/lib/sadie/sasm/instruction_set/is8085.rb
#   dc 23/05/2013
#   dm 23/05/2013
module Sadie
  module SASM
    class InstructionSet
      class IS8085 < InstructionSet

        ### constants
        VERSION = "0.3.0".freeze

        ##
        # init_name
        def init_name
          @name = "Sadie - Intel 8085"
        end

        def accum
          @cpu.a
        end

        def l
          @cpu.l
        end

        def h
          @cpu.h
        end

        def hl
          @cpu.hl
        end

        def pc
          @cpu.pc
        end

        def sp
          @cpu.sp
        end

        def mem
          @cpu.m
        end

        def compare(a, b)
          if a < b
            @cpu.carry  = 1
            @cpu.flag_z = 0
          elsif a == b
            @cpu.carry  = 0
            @cpu.flag_z = 1
          elsif a > b
            @cpu.carry  = 0
            @cpu.flag_z = 0
          end
        end

        ## add immediate with carry
        # aci(Integer int)
        inst 0xCE, :aci, :int do |int|
          accum.add!(int).add!(@cpu.carry)
        end

        ## add register with carry
        # adc(REGISTER_ID reg_id)
        inst nil, :adc, :reg do |reg_id|
          accum.add!(reg(reg_id)).add!(@cpu.carry)
        end

        ## add register without carry
        # add(REGISTER_ID reg_id)
        inst nil, :add, :reg do |reg_id|
          accum.add!(reg(reg_id))
        end

        ## add immediate without carry
        # adi(Integer int)
        inst 0xC6, :adi, :int do |int|
          accum.add!(int)
        end

        ## logical 'and' with register
        # ana(REGISTER_ID reg_id)
        inst nil, :ana, :reg do |reg_id|
          accum.land!(reg_id)
        end

        ## logical 'and' with immediate
        # ani(Integer int)
        inst 0xE6, :ani, :int do |int|
          accum.land!(int)
        end

        uinst 0xCD, :call, :adr16
        uinst 0xDC, :cc,   :adr16
        uinst 0xFC, :cm,   :adr16

        ## complement accumulator
        # cma
        inst 0x2F, :cma do
          accum.complement!
        end

        ## complement carry flag
        # cmc
        inst 0x3F, :cmc do
          @cpu.carry = @cpu.carry == 1 ? 0 : 1
        end

        ## compare accumulator with register
        # cmp(REGISTER_ID reg_id)
        inst nil, :cmp, :reg do |reg_id|
          compare(accum, reg(reg_id))
        end

        uinst 0xD4, :cnc,  :adr16
        uinst 0xC4, :cnz,  :adr16
        uinst 0xF4, :cp,   :adr16
        uinst 0xEC, :cpe,  :adr16

        ## compare accumulator with immediate
        # cpi(Integer int)
        inst 0xFE, :cpi, :int do |int|
          compare(accum, int)
        end

        uinst 0xE4, :cpo,  :adr16
        uinst 0xCC, :cz,   :adr16

        uinst 0x27, :daa

        ##
        # dad
        inst nil, :dad, :reg_pair do |reg_pair_id|
          hl.add!(reg_pair(reg_pair_id))
        end

        ## decrement register
        # dcr(REGISTER_ID reg_id)
        inst nil, :dcr, :reg do |reg_id|
          reg(reg_id).dec!
        end

        inst nil, :dcx, :reg_pair do |reg_pair_id|
          reg_pair(reg_pair_id).dec!
        end

        uinst 0xF3, :di
        uinst 0xFB, :ei

        uinst 0x76, :hlt

        ## IO input
        # in
        inst 0xDB, :in, :adr do |address|
          @cpu.port.input[address] >> accum
        end

        ## increment register
        # inr(REGISTER_ID reg_id)
        inst nil, :inr, :reg do |reg_id|
          reg(reg_id).inc!
        end

        ##
        # inx
        inst nil, :inx, :reg_pair do |reg_pair_id|
          reg_pair(reg_pair_id).inc!
        end

        uinst 0xDA, :jc,  :adr16
        uinst 0xFA, :jm,  :adr16
        uinst 0xC3, :jmp, :adr16
        uinst 0xD2, :jnc, :adr16
        uinst 0xC2, :jnz, :adr16
        uinst 0xF2, :jp,  :adr16
        uinst 0xEA, :jpe, :adr16
        uinst 0xE2, :jpo, :adr16
        uinst 0xCA, :jz,  :adr16

        ##
        # lda(address16)
        inst 0x3A, :lda, :adr16 do |address16|
          accum.set!(mem[address16])
        end

        ##
        # ldax
        inst nil, :ldax, :reg_pair do |reg_pair_id|
          accum.set!(mem[reg_pair(reg_pair_id)])
        end

        ##
        # lhld
        inst 0x2A, :lhld, :adr16 do |address16|
          l.set!(mem[address16])
          h.set!(mem[address16 + 1])
        end

        ##
        # lxi
        inst nil, :lxi, :reg_pair, :int16 do |reg_pair_id, int16|
          reg_pair(reg_pair_id).set!(int16)
        end

        ## copies src_register into target_register
        # mov(REGISTER_ID trg_reg_id, REGISTER_ID src_reg_id)
        inst nil, :mov, :reg, :reg do |trg_reg_id, src_reg_id|
          reg(trg_reg_id).set!(reg(src_reg_id))
        end

        ## copies immediate into target_register
        # mvi(REGISTER_ID trg_reg_id, Integer int)
        inst nil, :mvi, :reg, :int do |trg_reg_id, int|
          reg(trg_reg_id).set!(int)
        end

        ## no operation
        # nop
        inst 0x00, :nop do
          # does nothing
        end

        ## logical or with register
        # ora(REGISTER_ID reg_id)
        inst nil, :ora, :reg do |reg_id|
          accum.lor!(reg_id)
        end

        ## logical or with immediate
        # ori(Integer int)
        inst 0xF6, :ori, :int do |int|
          accum.lor!(int)
        end

        ## IO output
        # out
        inst 0xF6, :out, :adr do |address|
          @cpu.port.output[address] << accum
        end

        ##
        # phcl
        inst 0xE9, :phcl do
          pc.low_data_set(l.block_data)
          pc.high_data_set(h.block_data)
        end

        ## stack
        # pop
        inst nil, :pop, :reg_pair do |reg_id|
          regpair = reg_pair(reg_id)
          regpair.low_data_set(mem.stack_data)
          @cpu.sp.inc!
          regpair.high_data_set(mem.stack_data)
        end

        ## stack
        # push
        inst nil, :push, :reg_pair do |reg_id|
          regpair = reg_pair(reg_id)
          mem.stack_data_set(regpair.high_data)
          @cpu.sp.inc!
          mem.stack_data_set(regpair.low_data)
        end

        ##
        # ral
        inst 0x17, :ral do
          accum.rotate!(-1)
        end

        ##
        # rar
        inst 0x1F, :rar do
          accum.rotate!(+1)
        end

        ##
        # rc
        #   return if carry
        inst 0xD8, :rc do
          inst_ret if @cpu.carry == BTRUE
        end

        ##
        # ret
        inst 0xC9, :ret do
          adr16 = sp.block_data
          lbyte = mem[adr16]
          hbyte = mem[adr16 - 1]
          pc.low_data_set(lbyte)
          pc.high_data_set(hbyte)
        end

        uinst 0x20, :rim

        ##
        # rlc
        inst 0x07, :rlc do
          accum.rotate!(-1)
        end

        ##
        # rm
        #   return if negative sign
        inst 0xF8, :rm do
          inst_ret if @cpu.flag_s == 1
        end

        ##
        # rnc
        #   return if no carry
        inst 0xD0, :rnc do
          inst_ret if @cpu.carry == BFALSE
        end

        ##
        # rnz
        #   return if not zero
        inst 0xC0, :rnz do
          inst_ret if @cpu.flag_z == 1
        end

        ##
        # rp
        #   return if positive sign
        inst 0xF0, :rp do
          inst_ret if @cpu.flag_s == 0
        end

        ##
        # rpe
        #   return if even parity
        inst 0xE8, :rpe do
          inst_ret if @cpu.flag_p == 1
        end

        ##
        # rpo
        #   return if odd parity
        inst 0xE0, :rpo do
          inst_ret if @cpu.flag_p == 0
        end

        ##
        # rrc
        inst 0x0F, :rrc do
          accum.rotate!(-1)
        end

        uinst nil, :rst, :int

        ##
        # rz
        #   return if zero
        inst 0xC8, :rz do
          inst_ret if @cpu.flag_z == 0
        end

        uinst nil, :sbb, :reg
        uinst 0xDE, :sbi, :int

        inst 0x22, :shld, :adr16 do |address16|
          mem[address16] = l.block_data
          mem[address16 + 1] = h.block_data
        end

        uinst 0x30, :sim
        inst 0xF9, :sphl do
          sp.high_data_set(h.block_data)
          sp.low_data_set(l.block_data)
        end

        ##
        # sta
        #   store contents of accumulator in memory at (address16)
        inst 0x32, :sta, :adr16 do |address16|
          mem[address16] = accum.block_data
        end

        ##
        # stax
        inst nil, :stax, :reg_pair do |reg_pair_id|
          mem[reg_pair(reg_pair_id).block_data] = accum.block_data
        end

        ##
        # stc
        #   carry flag is set to 1
        inst 0x37, :stc do
          @cpu.carry = 1
        end

        ## subtract register from accumulator
        # sub(REGISTER_ID reg_id)
        inst nil, :sub, :reg do |reg_id|
          accum.sub!(reg(reg_id))
        end

        ## subtract immediate from accumulator
        # sbi(Integer int)
        inst 0xD6, :sui, :int do |int|
          accum.sbi!(int)
        end

        ## exchanges the contents of register D with H and E with L
        # xchng
        inst 0xEB, :xchg do
          a, b = @cpu.d.block_data, @cpu.h.block_data
          @cpu.d.block_data_set(b)
          @cpu.h.block_data_set(b)
          a, b = @cpu.e.block_data, @cpu.l.block_data
          @cpu.e.block_data_set(b)
          @cpu.l.block_data_set(b)
        end

        ## exclusive or (xor) of accumulator with register
        # xra(REGISTER_ID reg_id)
        inst nil, :xra, :reg do |reg_id|
          accum.xor!(reg(reg_id))
        end

        ## exclusive or (xor) of accumulator with immediate
        # xri(Integer int)
        inst 0xEE, :xri, :int do |int|
          accum.xor!(int)
        end

        ##
        # xthl
        inst 0xE3, :xthl do
          l.set!(mem.stack_data)
          h.set!(mem.stack_data(+1))
        end

        setup_mnemonic_table

        einstspec(:adc).bytesize = 2

        einstspec :adc do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0x88
              when REG_C then 0x89
              when REG_D then 0x8A
              when REG_E then 0x8B
              when REG_H then 0x8C
              when REG_L then 0x8D
              when REG_M then 0x8E
              when REG_A then 0x8F
              end
            when :params then []
            end
          end
        end

        einstspec :add do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0x80
              when REG_C then 0x81
              when REG_D then 0x82
              when REG_E then 0x83
              when REG_H then 0x84
              when REG_L then 0x85
              when REG_M then 0x86
              when REG_A then 0x87
              end
            when :params then []
            end
          end
        end

        einstspec(:adi).bytesize  = 2

        einstspec :ana do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0xA0
              when REG_C then 0xA1
              when REG_D then 0xA2
              when REG_E then 0xA3
              when REG_H then 0xA4
              when REG_L then 0xA5
              when REG_M then 0xA6
              when REG_A then 0xA7
              end
            when :params then []
            end
          end
        end

        einstspec(:ani).bytesize  = 2

        einstspec(:call).bytesize = 3
        einstspec(:cc).bytesize   = 3
        einstspec(:cm).bytesize   = 3

        einstspec :cmp do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0xB8
              when REG_C then 0xB9
              when REG_D then 0xBA
              when REG_E then 0xBB
              when REG_H then 0xBC
              when REG_L then 0xBD
              when REG_M then 0xBE
              when REG_A then 0xBF
              end
            when :params then []
            end
          end
        end

        einstspec(:cnc).bytesize  = 3
        einstspec(:cnz).bytesize  = 3
        einstspec(:cp).bytesize   = 3
        einstspec(:cpe).bytesize  = 3
        einstspec(:cpi).bytesize  = 2
        einstspec(:cpo).bytesize  = 3
        einstspec(:cz).bytesize   = 3

        einstspec :dad do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B, REG_C, REG_BC then 0x09
              when REG_D, REG_E, REG_DE then 0x19
              when REG_H, REG_L, REG_HL then 0x29
              when REG_SP               then 0x39
              end
            when :params then []
            end
          end
        end

        einstspec :dcr do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0x05
              when REG_C then 0x0D
              when REG_D then 0x15
              when REG_E then 0x1D
              when REG_H then 0x25
              when REG_L then 0x2D
              when REG_M then 0x35
              when REG_A then 0x3D
              end
            when :params then []
            end
          end
        end

        einstspec :dcx do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B, REG_C, REG_BC then 0x0B
              when REG_D, REG_E, REG_DE then 0x1B
              when REG_H, REG_L, REG_HL then 0x2B
              when REG_SP               then 0x3B
              end
            when :params then []
            end
          end
        end

        einstspec(:in).bytesize   = 2

        einstspec :inr do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0x04
              when REG_C then 0x0C
              when REG_D then 0x14
              when REG_E then 0x1C
              when REG_H then 0x24
              when REG_L then 0x2C
              when REG_M then 0x34
              when REG_A then 0x3C
              end
            when :params then []
            end
          end
        end

        einstspec :inx do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B, REG_C, REG_BC then 0x03
              when REG_D, REG_E, REG_DE then 0x13
              when REG_H, REG_L, REG_HL then 0x23
              when REG_SP               then 0x33
              end
            when :params then []
            end
          end
        end

        einstspec(:jc).bytesize   = 3
        einstspec(:jm).bytesize   = 3
        einstspec(:jmp).bytesize  = 3
        einstspec(:jnc).bytesize  = 3
        einstspec(:jnz).bytesize  = 3
        einstspec(:jp).bytesize   = 3
        einstspec(:jpe).bytesize  = 3
        einstspec(:jpo).bytesize  = 3
        einstspec(:jz).bytesize   = 3

        einstspec(:lda).bytesize  = 3
        # :ldax, :lxi, :mov, :mvi, :ora, :pop, :push, :rst, :sbb, :stax, :sub, :xra

        einstspec :inx do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B, REG_C, REG_BC then 0x0A
              when REG_D, REG_E, REG_DE then 0x1A
              end
            when :params then []
            end
          end
        end

        einstspec(:lhld).bytesize  = 3

        einstspec :lxi do |is|
          is.bytesize = 3
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B, REG_C, REG_BC then 0x01
              when REG_D, REG_E, REG_DE then 0x11
              when REG_H, REG_L, REG_HL then 0x21
              when REG_SP               then 0x31
              end
            when :params then []
            end
          end
        end

        einstspec :mov do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms
              when [REG_B, REG_B] then 0x40
              when [REG_B, REG_C] then 0x41
              when [REG_B, REG_D] then 0x42
              when [REG_B, REG_E] then 0x43
              when [REG_B, REG_H] then 0x44
              when [REG_B, REG_L] then 0x45
              when [REG_B, REG_M] then 0x46
              when [REG_B, REG_A] then 0x47

              when [REG_C, REG_B] then 0x48
              when [REG_C, REG_C] then 0x49
              when [REG_C, REG_D] then 0x4A
              when [REG_C, REG_E] then 0x4B
              when [REG_C, REG_H] then 0x4C
              when [REG_C, REG_L] then 0x4D
              when [REG_C, REG_M] then 0x4E
              when [REG_C, REG_A] then 0x4F

              when [REG_D, REG_B] then 0x50
              when [REG_D, REG_C] then 0x51
              when [REG_D, REG_D] then 0x52
              when [REG_D, REG_E] then 0x53
              when [REG_D, REG_H] then 0x54
              when [REG_D, REG_L] then 0x55
              when [REG_D, REG_M] then 0x56
              when [REG_D, REG_A] then 0x57

              when [REG_E, REG_B] then 0x58
              when [REG_E, REG_C] then 0x59
              when [REG_E, REG_D] then 0x5A
              when [REG_E, REG_E] then 0x5B
              when [REG_E, REG_H] then 0x5C
              when [REG_E, REG_L] then 0x5D
              when [REG_E, REG_M] then 0x5E
              when [REG_E, REG_A] then 0x5F

              when [REG_H, REG_B] then 0x60
              when [REG_H, REG_C] then 0x61
              when [REG_H, REG_D] then 0x62
              when [REG_H, REG_E] then 0x63
              when [REG_H, REG_H] then 0x64
              when [REG_H, REG_L] then 0x65
              when [REG_H, REG_M] then 0x66
              when [REG_H, REG_A] then 0x67

              when [REG_L, REG_B] then 0x68
              when [REG_L, REG_C] then 0x69
              when [REG_L, REG_D] then 0x6A
              when [REG_L, REG_E] then 0x6B
              when [REG_L, REG_H] then 0x6C
              when [REG_L, REG_L] then 0x6D
              when [REG_L, REG_M] then 0x6E
              when [REG_L, REG_A] then 0x6F

              when [REG_M, REG_B] then 0x70
              when [REG_M, REG_C] then 0x71
              when [REG_M, REG_D] then 0x72
              when [REG_M, REG_E] then 0x73
              when [REG_M, REG_H] then 0x74
              when [REG_M, REG_L] then 0x75
              when [REG_M, REG_M] then 0x76
              when [REG_M, REG_A] then 0x77

              when [REG_A, REG_B] then 0x78
              when [REG_A, REG_C] then 0x79
              when [REG_A, REG_D] then 0x7A
              when [REG_A, REG_E] then 0x7B
              when [REG_A, REG_H] then 0x7C
              when [REG_A, REG_L] then 0x7D
              when [REG_A, REG_M] then 0x7E
              when [REG_A, REG_A] then 0x7F
              end
            when :params then []
            end
          end
        end

        einstspec :mvi do |is|
          is.bytesize = 2
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0x06
              when REG_C then 0x0E
              when REG_D then 0x16
              when REG_E then 0x1E
              when REG_H then 0x26
              when REG_L then 0x2E
              when REG_M then 0x36
              when REG_A then 0x3E
              end
            when :params then [prms[1]]
            end
          end
        end

        einstspec :ora do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0xB0
              when REG_C then 0xB1
              when REG_D then 0xB2
              when REG_E then 0xB3
              when REG_H then 0xB4
              when REG_L then 0xB5
              when REG_M then 0xB6
              when REG_A then 0xB7
              end
            when :params then [prms[1]]
            end
          end
        end

        einstspec(:ori).bytesize = 2
        einstspec(:out).bytesize = 2

        einstspec :pop do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B, REG_C, REG_BC then 0xC1
              when REG_D, REG_E, REG_DE then 0xD1
              when REG_H, REG_L, REG_HL then 0xE1
              when REG_PSW              then 0xF1
              end
            when :params then []
            end
          end
        end

        einstspec :push do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B, REG_C, REG_BC then 0xC5
              when REG_D, REG_E, REG_DE then 0xD5
              when REG_H, REG_L, REG_HL then 0xE5
              when REG_PSW              then 0xF5
              end
            when :params then []
            end
          end
        end

        einstspec :rst do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when 0 then 0xC7
              when 1 then 0xCF
              when 2 then 0xD7
              when 3 then 0xDF
              when 4 then 0xE7
              when 5 then 0xEF
              when 6 then 0xF7
              when 7 then 0xFF
              end
            when :params then []
            end
          end
        end

        einstspec :sbb do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0x98
              when REG_C then 0x99
              when REG_D then 0x9A
              when REG_E then 0x9B
              when REG_H then 0x9C
              when REG_L then 0x9D
              when REG_M then 0x9E
              when REG_A then 0x9F
              end
            when :params then []
            end
          end
        end

        einstspec(:sbi).bytesize  = 2
        einstspec(:shld).bytesize = 3
        einstspec(:sta).bytesize  = 3

        einstspec :stax do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B, REG_C, REG_BC then 0x02
              when REG_D, REG_E, REG_DE then 0x12
              end
            when :params then []
            end
          end
        end

        einstspec :sub do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0x90
              when REG_C then 0x91
              when REG_D then 0x92
              when REG_E then 0x93
              when REG_H then 0x94
              when REG_L then 0x95
              when REG_M then 0x96
              when REG_A then 0x97
              end
            when :params then []
            end
          end
        end

        einstspec(:sui).bytesize  = 2

        einstspec :xra do |is|
          is.calc_set do |what, prms|
            case what
            when :opcode
              case prms.first
              when REG_B then 0xA8
              when REG_C then 0xA9
              when REG_D then 0xAA
              when REG_E then 0xAB
              when REG_H then 0xAC
              when REG_L then 0xAD
              when REG_M then 0xAE
              when REG_A then 0xAF
              end
            when :params then []
            end
          end
        end

        einstspec(:xri).bytesize  = 2

      end
    end
  end
end

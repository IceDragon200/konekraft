#
# Sadie/lib/sadie/sasm/interpreter/interpreter_8085.rb
#   by IceDragon
#   dc 21/05/2013
#   dm 30/07/2013
module Sadie
  module SASM
    class Interpreter8085 < Sadie::SASM::Interpreter

      ### constants
      VERSION = "1.0.0".freeze

      ##
      # init_name
      def init_name
        @name = "Sadie - Intel 8085"
      end

      def compare(a, b)
        if a < b
          self.flag_c = 1
          self.flag_z = 0
        elsif a == b
          self.flag_c = 0
          self.flag_z = 1
        elsif a > b
          self.flag_c = 0
          self.flag_z = 0
        end
      end

      ## gracefully swiped from GNUSim8085
      # is_carry?
      #   check for carry in this operation
      def is_carry?(a, b, op)
        if (op == :+)
          return !((a + b) < 256);
        else
          return a < b;
        end
      end

      ## gracefully swiped from GNUSim8085
      # is_auxillary_carry?
      def is_auxillary_carry?(a, b, op)
        a <<= 4;
        a >>= 4;
        b <<= 4;
        b >>= 4;

        if (op == :+)
          return !((a + b) < 16)
        else
          return !((a - b) <= a)
        end
      end

      def find_and_set_flags(result)
        self.flag_z = result == 0 ? 1 : 0
        self.flag_s = result >= 128 ? 1 : 0
        self.flag_p = (Sadie::BitTool.count_one_bits(result) % 2) != 0 ? 1 : 0
      end

      def flag_check_and_set_aux_c(a, b, op)
        flag_ac_set(is_auxillary_carry?(a, b, op) ? 1 : 0)
      end

      def flag_check_and_set_carry(a, b, op)
        self.flag_c = (is_carry?(a, b, op) ? 1 : 0)
      end

      ##
      # add_i
      #   Add immediate with flags and op
      def add_i(data, op)
        # check for flags
        flag_check_and_set_carry(reg_a.cell_data, data, op)
        flag_check_and_set_aux_c(reg_a.cell_data, data, op)

        # add
        reg_a.cell_add!((op == :+) ? data : -data)
        find_and_set_flags(reg_a.cell_data);
      end

      ## add register with carry
      # adc(REGISTER_ID reg_id)
      def adc(reg_id)
        reg_a.cell_add!(reg(reg_id)) #.cell_add!(flag_c)
      end

      ## add register without carry
      # add(REGISTER_ID reg_id)
      def add(reg_id)
        reg_a.cell_add!(reg(reg_id))
      end

      ## logical 'and' with register
      # ana(REGISTER_ID reg_id)
      def ana(reg_id)
        reg_a.cell_land!(reg_id)
      end

      ## compare accumulator with register
      # cmp(REGISTER_ID reg_id)
      def cmp(reg_id)
        compare(reg_a.cell_data, reg(reg_id).cell_data)
      end

      ## add register pair to HL
      # dad(REGISTER_PAIR_ID reg_pair_id)
      def dad(reg_pair_id)
        reg_hl.cell_add!(reg_pair(reg_pair_id))
      end

      ## decrement register
      # dcr(REGISTER_ID reg_id)
      def dcr(reg_id)
        reg(reg_id).cell_dec!
      end

      ## decrement register pair
      # dcx(REGISTER_PAIR_ID reg_pair_id)
      def dcx(reg_pair_id)
        reg_pair(reg_pair_id).cell_dec!
      end

      ## increment register
      # inr(REGISTER_ID reg_id)
      def inr(reg_id)
        reg(reg_id).cell_inc!
      end

      ## increment register pair
      # inx(REGISTER_PAIR_ID reg_pair_id)
      def inx(reg_pair_id)
        reg_pair(reg_pair_id).cell_inc!
      end

      ## load value from memory address at reg_pair
      # ldax
      def ldax(reg_pair_id)
        reg_a.cell_set!(memory[reg_pair(reg_pair_id)])
      end

      ## set immediate register pair
      # lxi
      def lxi(reg_pair_id, int16)
        reg_pair(reg_pair_id).cell_set!(int16)
      end

      ## copies src_register into target_register
      # mov(REGISTER_ID trg_reg_id, REGISTER_ID src_reg_id)
      def mov(trg_reg_id, src_reg_id)
        reg(trg_reg_id).cell_set!(reg(src_reg_id).cell_data)
      end

      ## copies immediate into target_register
      # mvi(REGISTER_ID trg_reg_id, int int)
      def mvi(trg_reg_id, int)
        reg(trg_reg_id).cell_set!(int)
      end

      ## no operation
      # nop
      def nop
        #
      end

      ## halt instrustion
      # hlt
      def hlt
        halt_program
      end

      ## logical or with register
      # ora(REGISTER_ID reg_id)
      def ora(reg_id)
        reg_a.cell_lor!(reg_id)
      end

      def sub(reg_id)
        reg_a.cell_sub!(reg(reg_id).cell_data)
      end

      def sbb(reg_id)
        reg_a.cell_sub!(reg(reg_id).cell_data)
      end

      ##
      # pop(REGISTER_ID reg_pair_id)
      def pop(reg_pair_id)
        regpair = reg_pair(reg_pair_id)
        regpair.low_data_set(memory.stack_data)
        reg_sp.cell_inc!
        regpair.high_data_set(memory.stack_data)
      end

      ##
      # push(REGISTER_ID reg_pair_id)
      def push(reg_pair_id)
        regpair = reg_pair(reg_pair_id)
        memory.stack_data_set(regpair.high_data)
        reg_sp.cell_dec!
        memory.stack_data_set(regpair.low_data)
      end

      ## return
      # ret
      def ret
        adr16 = reg_sp.cell_data
        data = memory.cell_data
        reg_pc.low_data_set(data)
        reg_sp.cell_inc!
        data = memory.cell_data
        reg_pc.high_data_set(data)
      end

      ## jump instruction
      # jmp
      def jmp(address16)
        reg_pc.cell_data_set(address16)
      end

      def store_address
        reg = reg_pair(REG_HL)
        address = reg_pc.cell_data
        old_data = reg.cell_data
        reg.cell_data_set(address + 1)
        push(REG_HL)
        reg.cell_data_set(old_data)
      end

      ## call instruction
      # call
      def call(address16)
        # store address
        store_address
        # jump
        jmp(address16)
      end

      ## subtract register from accumulator
      # sub(REGISTER_ID reg_id)
      def sub(reg_id)
        reg_a.cell_sub!(reg(reg_id))
      end

      ##
      # stax
      def stax(reg_pair_id)
        memory[reg_pair(reg_pair_id).cell_data] = reg_a.cell_data
      end

      ## exclusive or (xor) of accumulator with register
      # xra(REGISTER_ID reg_id)
      def xra(reg_id)
        reg_a.cell_xor!(reg(reg_id).cell_data)
      end

    ##
    # def_inst code, :sym,  *prepend_args

      ## no operation
      # nop
      def_inst 0x00, :nop

      ##
      # lxi B, int16
      def_inst 0x01, :lxi, REG_BC, :int16

      ##
      # stax B
      def_inst 0x02, :stax, REG_BC

      ##
      # inx
      def_inst 0x03, :inx, REG_BC
      def_inst 0x04, :inr, REG_B
      def_inst 0x05, :dcr, REG_B
      def_inst 0x06, :mvi, REG_B, :int8

      ##
      # rlc
      def_inst 0x07, :rlc do
        reg_a.cell_rotate!(-1)
      end

      def_inst 0x08, :null
      def_inst 0x09, :dad, REG_BC
      def_inst 0x0A, :ldax, REG_BC
      def_inst 0x0B, :dcx, REG_BC
      def_inst 0x0C, :inr, REG_C
      def_inst 0x0D, :dcr, REG_C
      def_inst 0x0E, :mvi, REG_C, :int8
      ##
      # rrc
      def_inst 0x0F, :rrc do
        reg_a.cell_rotate!(-1)
      end

      def_inst 0x10, :null
      def_inst 0x11, :lxi, REG_DE, :int16
      def_inst 0x12, :stax, REG_DE
      def_inst 0x13, :inx, REG_DE
      def_inst 0x14, :inr, REG_D
      def_inst 0x15, :dcr, REG_D
      def_inst 0x16, :mvi, REG_D, :int8

      ## rotate accumulator by 1 bit to the left
      # ral
      def_inst 0x17, :ral do
        reg_a.cell_rotate!(-1)
      end

      def_inst 0x18, :null
      def_inst 0x19, :dad, REG_DE
      def_inst 0x1A, :ldax, REG_DE
      def_inst 0x1B, :dcx, REG_DE
      def_inst 0x1C, :inr, REG_E
      def_inst 0x1D, :dcr, REG_E
      def_inst 0x1E, :mvi, REG_E, :int8

      ## rotate accumulator by 1 bit to the right
      # rar
      def_inst 0x1F, :rar do
        reg_a.cell_rotate!(+1)
      end

      ##
      # rim
      #   Read Interrupt Status
      def_inst 0x20, :rim do
        # TODO
      end

      ##
      # lxi
      def_inst 0x21, :lxi, REG_HL, :int16

      def_inst 0x22, :shld, :address16 do |address16|
        memory[address16]     = reg_l.cell_data
        memory[address16 + 1] = reg_h.cell_data
      end

      def_inst 0x23, :inx, REG_HL
      def_inst 0x24, :inr, REG_H
      def_inst 0x25, :dcr, REG_H
      def_inst 0x26, :mvi, REG_H, :int8

      def_inst 0x27, :daa do
        old_carry = flag_c
        low_data = reg_a.cell_data & 0x0F

        if low_data > 9 || flag_ac == 1
          add_i(6, :+)
          self.flag_c = ((flag_c == 1 || old_carry == 1) ? 1 : 0)
          flag_ac_set(1)
        end

        if reg_a.cell_data > 0x99 || flag_c == 1
          reg_a.cell_data_set(reg_a.cell_data + 0x60)
          self.flag_c = (1)
        end
      end

      def_inst 0x28, :null
      def_inst 0x29, :dad, REG_HL

      def_inst 0x2A, :lhld, :address16 do |address16|
        reg_l.set!(memory[address16])
        reg_h.set!(memory[address16 + 1])
      end

      def_inst 0x2B, :dcx, REG_HL
      def_inst 0x2C, :inr, REG_L
      def_inst 0x2D, :dcr, REG_L
      def_inst 0x2E, :mvi, REG_L, :int8

      ## complement accumulator
      # cma
      def_inst 0x2F, :cma do
        reg_a.cell_complement!
      end

      ##
      # sim
      def_inst 0x30, :sim do
        # TODO
      end

      def_inst 0x31, :lxi, REG_SP, :int16

      ##
      # sta
      #   store contents of accumulator in memory at (address16)
      def_inst 0x32, :sta, :address16 do |address16|
        memory[address16] = reg_a.cell_data
      end

      def_inst 0x33, :inx, REG_SP
      def_inst 0x34, :inr, REG_M
      def_inst 0x35, :dcr, REG_M
      def_inst 0x36, :mvi, REG_M, :int8

      ##
      # stc
      #   carry flag is set to 1
      def_inst 0x37, :stc do
        @cpu.carry = 1
      end

      def_inst 0x38, :null

      def_inst 0x39, :dad, REG_SP

      def_inst 0x3A, :lda, :address16 do |address16|
        reg_a.set!(memory[address16])
      end

      def_inst 0x3B, :dcx, REG_SP
      def_inst 0x3C, :inr, REG_A
      def_inst 0x3D, :dcr, REG_A
      def_inst 0x3E, :mvi, REG_A, :int8

      ## complement carry flag
      # cmc
      def_inst 0x3F, :cmc do
        @cpu.carry = @cpu.carry == 1 ? 0 : 1
      end

      def_inst 0x40, :mov, REG_B, REG_B
      def_inst 0x41, :mov, REG_B, REG_C
      def_inst 0x42, :mov, REG_B, REG_D
      def_inst 0x43, :mov, REG_B, REG_B
      def_inst 0x44, :mov, REG_B, REG_H
      def_inst 0x45, :mov, REG_B, REG_L
      def_inst 0x46, :mov, REG_B, REG_M
      def_inst 0x47, :mov, REG_B, REG_A
      def_inst 0x48, :mov, REG_C, REG_B
      def_inst 0x49, :mov, REG_C, REG_C
      def_inst 0x4A, :mov, REG_C, REG_D
      def_inst 0x4B, :mov, REG_C, REG_E
      def_inst 0x4C, :mov, REG_C, REG_H
      def_inst 0x4D, :mov, REG_C, REG_L
      def_inst 0x4E, :mov, REG_C, REG_M
      def_inst 0x4F, :mov, REG_C, REG_A
      def_inst 0x50, :mov, REG_D, REG_B
      def_inst 0x51, :mov, REG_D, REG_C
      def_inst 0x52, :mov, REG_D, REG_D
      def_inst 0x53, :mov, REG_D, REG_E
      def_inst 0x54, :mov, REG_D, REG_H
      def_inst 0x55, :mov, REG_D, REG_L
      def_inst 0x56, :mov, REG_D, REG_M
      def_inst 0x57, :mov, REG_D, REG_A
      def_inst 0x58, :mov, REG_E, REG_B
      def_inst 0x59, :mov, REG_E, REG_C
      def_inst 0x5A, :mov, REG_E, REG_D
      def_inst 0x5B, :mov, REG_E, REG_E
      def_inst 0x5C, :mov, REG_E, REG_H
      def_inst 0x5D, :mov, REG_E, REG_L
      def_inst 0x5E, :mov, REG_E, REG_M
      def_inst 0x5F, :mov, REG_E, REG_A
      def_inst 0x60, :mov, REG_H, REG_B
      def_inst 0x61, :mov, REG_H, REG_C
      def_inst 0x62, :mov, REG_H, REG_D
      def_inst 0x63, :mov, REG_H, REG_E
      def_inst 0x64, :mov, REG_H, REG_H
      def_inst 0x65, :mov, REG_H, REG_L
      def_inst 0x66, :mov, REG_H, REG_M
      def_inst 0x67, :mov, REG_H, REG_A
      def_inst 0x68, :mov, REG_L, REG_B
      def_inst 0x69, :mov, REG_L, REG_C
      def_inst 0x6A, :mov, REG_L, REG_D
      def_inst 0x6B, :mov, REG_L, REG_E
      def_inst 0x6C, :mov, REG_L, REG_H
      def_inst 0x6D, :mov, REG_L, REG_L
      def_inst 0x6E, :mov, REG_L, REG_M
      def_inst 0x6F, :mov, REG_L, REG_A
      def_inst 0x70, :mov, REG_M, REG_B
      def_inst 0x71, :mov, REG_M, REG_C
      def_inst 0x72, :mov, REG_M, REG_D
      def_inst 0x73, :mov, REG_M, REG_E
      def_inst 0x74, :mov, REG_M, REG_H
      def_inst 0x75, :mov, REG_M, REG_L

      def_inst 0x76, :hlt

      def_inst 0x77, :mov, REG_M, REG_A
      def_inst 0x78, :mov, REG_A, REG_B
      def_inst 0x79, :mov, REG_A, REG_C
      def_inst 0x7A, :mov, REG_A, REG_D
      def_inst 0x7B, :mov, REG_A, REG_E
      def_inst 0x7C, :mov, REG_A, REG_H
      def_inst 0x7D, :mov, REG_A, REG_L
      def_inst 0x7E, :mov, REG_A, REG_M
      def_inst 0x7F, :mov, REG_A, REG_A

      def_inst 0x80, :add, REG_B
      def_inst 0x81, :add, REG_C
      def_inst 0x82, :add, REG_D
      def_inst 0x83, :add, REG_E
      def_inst 0x84, :add, REG_H
      def_inst 0x85, :add, REG_L
      def_inst 0x86, :add, REG_M
      def_inst 0x87, :add, REG_A

      ## add register with carry
      # adc(REGISTER_ID reg_id)
      def_inst 0x88, :adc, REG_B
      def_inst 0x89, :adc, REG_C
      def_inst 0x8A, :adc, REG_D
      def_inst 0x8B, :adc, REG_E
      def_inst 0x8C, :adc, REG_H
      def_inst 0x8D, :adc, REG_L
      def_inst 0x8E, :adc, REG_M
      def_inst 0x8F, :adc, REG_A

      def_inst 0x90, :sub, REG_B
      def_inst 0x91, :sub, REG_C
      def_inst 0x92, :sub, REG_D
      def_inst 0x93, :sub, REG_E
      def_inst 0x94, :sub, REG_H
      def_inst 0x95, :sub, REG_L
      def_inst 0x96, :sub, REG_M
      def_inst 0x97, :sub, REG_A

      def_inst 0x98, :sbb, REG_B
      def_inst 0x99, :sbb, REG_C
      def_inst 0x9A, :sbb, REG_D
      def_inst 0x9B, :sbb, REG_E
      def_inst 0x9C, :sbb, REG_H
      def_inst 0x9D, :sbb, REG_L
      def_inst 0x9E, :sbb, REG_M
      def_inst 0x9F, :sbb, REG_A

      def_inst 0xA0, :ana, REG_B
      def_inst 0xA1, :ana, REG_C
      def_inst 0xA2, :ana, REG_D
      def_inst 0xA3, :ana, REG_E
      def_inst 0xA4, :ana, REG_H
      def_inst 0xA5, :ana, REG_L
      def_inst 0xA6, :ana, REG_M
      def_inst 0xA7, :ana, REG_A

      def_inst 0xA8, :xra, REG_B
      def_inst 0xA9, :xra, REG_C
      def_inst 0xAA, :xra, REG_D
      def_inst 0xAB, :xra, REG_E
      def_inst 0xAC, :xra, REG_H
      def_inst 0xAD, :xra, REG_L
      def_inst 0xAE, :xra, REG_M
      def_inst 0xAF, :xra, REG_A

      def_inst 0xB0, :ora, REG_B
      def_inst 0xB1, :ora, REG_C
      def_inst 0xB2, :ora, REG_D
      def_inst 0xB3, :ora, REG_E
      def_inst 0xB4, :ora, REG_H
      def_inst 0xB5, :ora, REG_L
      def_inst 0xB6, :ora, REG_M
      def_inst 0xB7, :ora, REG_A

      def_inst 0xB8, :cmp, REG_B
      def_inst 0xB9, :cmp, REG_C
      def_inst 0xBA, :cmp, REG_D
      def_inst 0xBB, :cmp, REG_E
      def_inst 0xBC, :cmp, REG_H
      def_inst 0xBD, :cmp, REG_L
      def_inst 0xBE, :cmp, REG_M
      def_inst 0xBF, :cmp, REG_A

      ##
      # rnz
      #   return if not zero
      def_inst 0xC0, :rnz do
        ret if flag_z == 1
      end

      def_inst 0xC1, :pop, REG_BC

      def_inst 0xC2, :jnz, :address16 do |address16|
        jmp(address16) if flag_z == 0
      end

      def_inst 0xC3, :jmp, :address16

      def_inst 0xC4, :cnz, :address16 do |address16|
        call(address16) if flag_z == 0
      end

      def_inst 0xC5, :push, REG_BC

      ## add immediate without carry
      # adi(int int8)
      def_inst 0xC6, :adi, :int8 do |int8|
        reg_a.cell_add!(int8)
      end

      def_inst 0xC7, :rst,  0

      ##
      # rz
      #   return if zero
      def_inst 0xC8, :rz do
        ret if flag_z == 0
      end

      def_inst 0xC9, :ret do
        ret
      end

      def_inst 0xCA, :jz, :address16 do |address16|
        jmp(address16) if flag_z == 1
      end

      def_inst 0xCB, :null

      def_inst 0xCC, :cz, :address16 do |address16|
        call(address16) if flag_z == 1
      end

      def_inst 0xCD, :call, :address16 do |address16|
        call(address16)
      end

      ## add immediate with carry
      # aci(int n)
      def_inst 0xCE, :aci, :int8 do |int8|
        reg_a.cell_add!(int8).cell_add!(flag_c)
      end

      def_inst 0xCF, :rst,  1

      ##
      # rnc
      #   return if no carry
      def_inst 0xD0, :rnc do
        ret if flag_c == BFALSE
      end

      def_inst 0xD1, :pop, REG_DE

      def_inst 0xD2, :jnc, :address16 do |address16|
        jmp(address16) if flag_c == 0
      end

      ## IO output
      # out(address)
      def_inst 0xD3, :out, :address8 do |address8|
        port.output[address8] << reg_a
      end

      def_inst 0xD4, :cnc, :address16 do |address16|
        call(address16) if flag_c == 0
      end

      def_inst 0xD5, :push, REG_DE

      ## subtract immediate from accumulator
      # sui(int n)
      def_inst 0xD6, :sui, :int8 do |int8|
        reg_a.cell_sub!(int8)
      end

      def_inst 0xD7, :rst,  2

      ##
      # rc
      #   return if carry
      def_inst 0xD8, :rc do
        ret if flag_c == BTRUE
      end

      def_inst 0xD9, :null

      def_inst 0xDA, :jc, :address16 do |address16|
        jmp(address16) if flag_c == 1
      end

      ## IO input
      # in
      def_inst 0xDB, :in, :address8 do |address8|
        port.input[address8] >> reg_a
      end

      def_inst 0xDC, :cc, :address16 do |address16|
        call(address16) if flag_c == 1
      end

      def_inst 0xDD, :null

      ## subtract immediate from accumulator with borrow
      # sbi
      def_inst 0xDE, :sbi, :int8 do |int8|
        reg_a.cell_sub!(int8)
      end

      def_inst 0xDF, :rst,  3

      ##
      # rpo
      #   return if odd parity
      def_inst 0xE0, :rpo do
        ret if flag_p == 0
      end

      def_inst 0xE1, :pop, REG_HL

      def_inst 0xE2, :jpo do
        jmp if flag_p == 0
      end

      def_inst 0xE3, :xthl do
        reg_l.set!(memory.stack_data)
        reg_h.set!(memory.stack_data(+1))
      end

      ## call if odd parity
      # cpo
      def_inst 0xE4, :cpo, :address16 do |address16|
        call(address16) if flag_p == 0
      end

      def_inst 0xE5, :push, REG_HL

      ## logical 'and' with immediate
      # ani(int n)
      def_inst 0xE6, :ani, :int8 do |int8|
        reg_a.land!(n)
      end

      def_inst 0xE7, :rst,  4

      ##
      # rpe
      #   return if even parity
      def_inst 0xE8, :rpe do
        ret if flag_p == 1
      end

      ##
      # pchl
      def_inst 0xE9, :pchl do
        reg_pc.low_data_set(reg_l.cell_data)
        reg_pc.high_data_set(reg_h.cell_data)
      end

      ## jmp if even parity
      # jpe
      def_inst 0xEA, :jpe, :address16 do |address16|
        jmp(address16) if flag_p == 1
      end

      ## exchanges the contents of register D with H and E with L
      # xchng
      def_inst 0xEB, :xchg do
        a, b = reg_d.cell_data, reg_h.cell_data
        reg_d.cell_data_set(b)
        reg_h.cell_data_set(a)
        a, b = reg_e.cell_data, reg_l.cell_data
        reg_e.cell_data_set(b)
        reg_l.cell_data_set(a)
      end

      def_inst 0xEC, :cpe, :address16 do |address16|
        call(address16) if flag_p == 1
      end

      def_inst 0xED, :null

      ## exclusive or (xor) of accumulator with immediate
      # xri(Integer int8)
      def_inst 0xEE, :xri, :int8 do |int8|
        reg_a.xor!(int8)
      end

      def_inst 0xEF, :rst,  5

      ##
      # rp
      #  return if positive sign
      def_inst 0xF0, :rp do
        ret if flag_s == 0
      end

      def_inst 0xF1, :pop, REG_PSW

      ## jump if positive
      # jp
      def_inst 0xF2, :jp, :address16 do |address16|
        jmp(address16) if flag_p == 1
      end

      ## disable interrupt system
      # di
      def_inst 0xF3, :di do
        # TODO
      end

      def_inst 0xF4, :cp, :address16 do |address16|
        call(address16) if flag_p == 1
      end

      def_inst 0xF5, :push, REG_PSW

      ## logical or with immediate
      # ori(Integer int)
      def_inst 0xF6, :ori, :int8 do |int8|
        reg_a.cell_lor!(int8)
      end

      def_inst 0xF7, :rst,  6

      ##
      # rm
      #   return if negative sign
      def_inst 0xF8, :rm do
        ret if flag_s == 1
      end

      def_inst 0xF9, :sphl do
        reg_sp.high_data_set(reg_h.cell_data)
        reg_sp.low_data_set(reg_l.cell_data)
      end

      def_inst 0xFA, :jm, :address16 do |address16|
        jmp(address16) if flag_p == 0
      end

      ## enable interrupt system
      # ei
      def_inst 0xFB, :ei do
        # TODO
      end

      def_inst 0xFC, :cm, :address16 do |address16|
        call(address16) if flag_p == 0
      end

      def_inst 0xFD, :null

      def_inst 0xFE, :cpi, :int8 do |int8|
        compare(reg_a, int8)
      end

      def_inst 0xFF, :rst,  7

    end
  end
end


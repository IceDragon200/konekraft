#
# Sadie/lib/sadie/sasm/instruction_set/is8085.rb
#   dc 23/05/2013
#   dm 23/05/2013
module Sadie
  module SASM
    class InstructionSet
      class IS8085 < InstructionSet

        VERSION = "0.3.0".freeze

        def init_name
          @name = "Sadie - Intel 8085"
        end

        def accum
          @cpu.a
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
        inst :aci, :int do |int|
          accum.add!(int).add!(@cpu.carry)
        end

        ## add register with carry
        # adc(REGISTER_ID reg_id)
        inst :adc, :reg do |reg_id|
          accum.add!(reg(reg_id)).add!(@cpu.carry)
        end

        ## add register without carry
        # add(REGISTER_ID reg_id)
        inst :add, :reg do |reg_id|
          accum.add!(reg(reg_id))
        end

        ## add immediate without carry
        # adi(Integer int)
        inst :adi, :int do |int|
          accum.add!(int)
        end

        ## logical 'and' with register
        # ana(REGISTER_ID reg_id)
        inst :ana, :reg do |reg_id|
          accum.land!(reg_id)
        end

        ## logical 'and' with immediate
        # ani(Integer int)
        inst :ani, :int do |int|
          accum.land!(int)
        end

        uinst :call, :adr16
        uinst :cc,   :adr16
        uinst :cm,   :adr16

        ## complement accumulator
        # cma
        inst :cma do
          accum.complement!
        end

        ## complement carry flag
        # cmc
        inst :cmc do
          @cpu.carry = @cpu.carry == 1 ? 0 : 1
        end

        ## compare accumulator with register
        # cmp(REGISTER_ID reg_id)
        inst :cmp, :reg do |reg_id|
          compare(accum, reg(reg_id))
        end

        uinst :cnc,  :adr16
        uinst :cnz,  :adr16
        uinst :cp,   :adr16
        uinst :cpe,  :adr16

        ## compare accumulator with immediate
        # cpi(Integer int)
        inst :cpi, :int do |int|
          compare(accum, int)
        end

        uinst :cpo,  :adr16
        uinst :cz,   :adr16

        uinst :daa
        uinst :dad, :reg_pair

        ## decrement register
        # dcr(REGISTER_ID reg_id)
        inst :dcr, :reg do |reg_id|
          reg(reg_id).dec!
        end

        uinst :dcx, :reg_pair
        uinst :di
        uinst :ei

        uinst :hlt

        uinst :in, :adr

        ## increment register
        # inr(REGISTER_ID reg_id)
        inst :inr, :reg do |reg_id|
          reg(reg_id).inc!
        end

        uinst :inx, :reg_pair

        uinst :jc,  :adr16
        uinst :jm,  :adr16
        uinst :jmp, :adr16
        uinst :jnc, :adr16
        uinst :jnz, :adr16
        uinst :jp,  :adr16
        uinst :jpe, :adr16
        uinst :jpo, :adr16
        uinst :jz,  :adr16

        uinst :lda, :adr16
        uinst :ldax, :reg_pair
        uinst :lhld, :adr16
        uinst :lxi, :reg_pair, :adr16

        ## copies src_register into target_register
        # mov(REGISTER_ID trg_reg_id, REGISTER_ID src_reg_id)
        inst :mov, :reg, :reg do |trg_reg_id, src_reg_id|
          reg(trg_reg_id).set!(reg(src_reg_id))
        end

        ## copies immediate into target_register
        # mvi(REGISTER_ID trg_reg_id, Integer int)
        inst :mvi, :reg, :int do |trg_reg_id, int|
          reg(trg_reg_id).set!(int)
        end

        ## no operation
        # nop
        inst :nop do
          # does nothing
        end

        ## logical or with register
        # ora(REGISTER_ID reg_id)
        inst :ora, :reg do |reg_id|
          accum.lor!(reg_id)
        end

        ## logical or with immediate
        # ori(Integer int)
        inst :ori, :int do |int|
          accum.lor!(int)
        end

        uinst :out, :adr

        uinst :phcl
        uinst :rnz

        uinst :pop, :reg_pair
        uinst :push, :reg_pair

        uinst :ral
        uinst :rar
        uinst :rc
        uinst :ret
        uinst :rim
        uinst :rlc
        uinst :rm
        uinst :rnc
        uinst :rp
        uinst :rpe
        uinst :rpo
        uinst :rrc
        uinst :rst, :int
        uinst :rz

        uinst :sbb, :reg
        uinst :sbi, :int
        uinst :shld, :adr16
        uinst :sim
        uinst :sphl

        uinst :sta, :adr16
        uinst :stax, :reg_pair

        ## carry flag is set to 1
        # stc
        inst :stc do
          @cpu.carry = 1
        end

        ## subtract register from accumulator
        # sub(REGISTER_ID reg_id)
        inst :sub, :reg do |reg_id|
          accum.sub!(reg(reg_id))
        end

        ## subtract immediate from accumulator
        # sbi(Integer int)
        inst :sui, :int do |int|
          accum.sbi!(int)
        end

        ## exchanges the contents of register D with H and E with L
        # xchng
        inst :xchg do
          a, b = @cpu.d.block_data, @cpu.h.block_data
          @cpu.d.block_data_set(b)
          @cpu.h.block_data_set(b)
          a, b = @cpu.e.block_data, @cpu.l.block_data
          @cpu.e.block_data_set(b)
          @cpu.l.block_data_set(b)
        end

        ## exclusive or (xor) of accumulator with register
        # xra(REGISTER_ID reg_id)
        inst :xra, :reg do |reg_id|
          accum.xor!(reg(reg_id))
        end

        ## exclusive or (xor) of accumulator with immediate
        # xri(Integer int)
        inst :xri, :int do |int|
          accum.xor!(int)
        end

        uinst :xthl

        setup_nmemonic_table

      end
    end
  end
end

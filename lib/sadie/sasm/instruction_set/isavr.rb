#
# Sadie/lib/sadie/sasm/instruction_set/isavr.rb
#   dc 23/05/2013
#   dm 23/05/2013
module Sadie
  module SASM
    class InstructionSet
      class ISAVR < InstructionSet

        VERSION = "0.1.0".freeze

        def init_name
          @name = "Sadie - AVR"
        end

        ##
        # add(REG sreg1_id, REG sreg2_id)
        inst :add, :reg, :reg do |sreg1_id, sreg2_id|
          reg(sreg1_id).add!(reg(sreg2_id))
        end

        # addi(REG sreg_id, Numeric num)
        inst :addi, :reg, :int do |sreg_id, num|
          reg(sreg_id).add!(num)
        end

        # sub(REG sreg1_id, REG sreg2_id)
        inst :sub, :reg, :reg do |sreg1_id, sreg2_id|
          reg(sreg1_id).sub!(reg(sreg2_id))
        end

        # subi(REG sreg_id, Numeric num)
        inst :subi, :reg, :int do |sreg_id, num|
          reg(sreg_id).sub!(num)
        end

        # mul(REG sreg1_id, REG sreg2_id)
        inst :mul, :reg, :reg do |sreg1_id, sreg2_id|
          reg(sreg1_id).mul!(reg(sreg2_id))
        end

        # muli(REG sreg_id, Numeric num)
        inst :muli, :reg, :int do |sreg_id, num|
          reg(sreg_id).mul!(num)
        end

        # div(REG sreg1_id, REG sreg2_id)
        inst :div, :reg, :reg do |sreg1_id, sreg2_id|
          reg(sreg1_id).div!(reg(sreg2_id))
        end

        # divi(REG sreg_id, Numeric num)
        inst :divi, :reg, :int do |sreg_id, num|
          reg(sreg_id).div!(num)
        end

        # mov(REG reg1_id, REG reg2_id)
        inst :mov, :reg, :reg do |reg1_id, reg2_id|
          reg(reg1_id).set!(reg(reg2_id))
        end

        # nop
        inst :nop do
          # do nothing :D
        end

        # hlt
        inst :hlt do
          interupt!
        end

        setup_nmemonic_table

      end
    end
  end
end

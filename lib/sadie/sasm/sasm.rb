#
# Sadie/lib/sadie/sasm/sasm.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 23/05/2013
# TODO
#   define entry point for a SASM program
#
# SASM - Sadie Assembly VM
module Sadie
  module SASM

    class CompileError < Exception
      #
    end

    class UnimplementedError < Exception
      #
    end

    class RegisterError < Exception
    end

    ## Completion (66.25%)
    # IS8085 Assembler (Based off the Intel 8085 micro-processor)
    #ASM_8085 = Sadie::SASM::Assembler.new(Sadie::SASM::InstructionSet::IS8085)

    ## Completion (??.??%)
    # ISAVR Assembler (Based off the AVR micro-processor)
    #ASM_AVR  = Sadie::SASM::Assembler.new(Sadie::SASM::InstructionSet::ISAVR)

  end
end

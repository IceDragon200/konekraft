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

    VERSION = "0.1.3".freeze

    ASM_8085 = Sadie::SASM::Assembler.new(Sadie::SASM::InstructionSet::IS8085)
    ASM_AVR  = Sadie::SASM::Assembler.new(Sadie::SASM::InstructionSet::ISAVR)

  end
end

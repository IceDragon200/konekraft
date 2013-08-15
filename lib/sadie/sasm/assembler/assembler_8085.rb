#
# Sadie/sasm/assembler/assembler_8085.rb
#   by IceDragon
#   dc 03/08/2013
#   dm 03/08/2013
module Sadie
  module SASM
    class Assembler8085 < Assembler

      def initialize
        super(Sadie::SASM::Interpreter8085)
      end

      def self.build(string)
        new.build(string)
      end

    end
  end
end
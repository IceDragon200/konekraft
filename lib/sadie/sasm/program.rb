#
# Sadie/lib/sadie/sasm/program.rb
#   by IceDragon
#   dc 22/05/2013
#   dm 22/05/2013
module Sadie
  module SASM
    class Program

      ### constants
      VERSION = "1.0.0".freeze

      ### instance_variables
      attr_reader :instructions

      ##
      # initialize(Array<Instruction> instructions)
      def initialize(instructions)
        @instructions = instructions
      end

      def instructions_str
        @instructions.map do |inst|
          inst.to_s
        end.join("\n")
      end

      def [](index)
        @instructions[index]
      end

      def size
        @instructions.size
      end

    end
  end
end

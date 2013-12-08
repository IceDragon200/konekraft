#
# Sadie/lib/sadie/sasm/program.rb
#   by IceDragon
module Sadie
  module SASM
    class Program

      include Enumerable

      ### constants
      VERSION = "1.0.0".freeze

      ### instance_variables
      attr_reader :instructions

      ##
      # initialize(Array<Instruction> instructions)
      def initialize(instructions)
        @instructions = instructions
      end

      def [](index)
        @instructions[index]
      end

      def size
        @instructions.size
      end

      def each(&block)
        @instructions.each(&block)
      end

      def to_bytecode_a
        @instructions.map(&:to_bytecode_a)
      end

      def to_bytecode
        @instructions.map(&:to_bytecode).join("")
      end

    end
  end
end
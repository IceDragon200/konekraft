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
      attr_accessor :entry_label

      def initialize(instructions)
        @instructions = instructions
        @entry_label = "main"
      end

      def assert_entry_label
        raise(NoEntryError,
              "this program has no entry label"
              ) unless @instructions.has_key?(@entry_label)
        return @entry_label
      end

      def block(label)
        @instructions[label]
      end

      def entry_block
        block(@entry_label)
      end

      alias :[] :block

    end
  end
end

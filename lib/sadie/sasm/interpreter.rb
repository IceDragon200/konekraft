#
# Sadie/lib/sadie/sasm/Interpreter.rb
#   by IceDragon
#   dc 20/05/2013
#   dm 20/05/2013
#
# TODO
#   finish SASM VM to read SASM compiled code
#
# SASM - Interpreter
module Sadie
  module SASM
    class Interpreter

      VERSION = "0.1.0".freeze

      def initialize(cpu)
        @cpu = cpu
      end

      def run(sasm)
        # TODO O:
        #sasm.each do |()|
      end

    end
  end
end

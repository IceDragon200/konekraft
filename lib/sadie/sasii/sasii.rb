#
# Sadie/lib/sadie/sasm/sasii/sasii.rb
#   by IceDragon
# sasii - SASM Interactive Interpreter [Core]
require 'sadie/slate'

module Sadie
  module SASM
    module Sasii

      extend Sadie::Logger

      ### constants
      VERSION = "1.0.0".freeze

      def self.init
        @slate = Sadie::Slate::VirtualMachine.new
      end

      def self.exec_eval(string)
        @slate.exec_eval(string)
      end

      def self.run
        loop do
          time = Time.now.strftime("%H:%M:%S")
          print "[#{time}] Slate::VirtualMachine :> "
          begin
            str = gets.chomp
            if str == "quit" || str == "exit"
              break
            else
              exec_eval(str)
            end
          rescue => ex
            p ex
          end
        end
      end

    end
  end
end
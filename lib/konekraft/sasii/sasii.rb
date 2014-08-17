#
# Konekraft/lib/konekraft/sasm/sasii/sasii.rb
#
# sasii - SlateAssembly Interactive Interpreter [Core]
require 'konekraft/slate'

module Konekraft
  module SlateAssembly
    module Sasii

      extend Konekraft::Logger

      ### constants
      VERSION = "1.0.0".freeze

      def self.init
        @slate = Konekraft::Slate::VirtualMachine.new
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

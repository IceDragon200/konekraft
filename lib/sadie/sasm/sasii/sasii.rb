#
# Sadie/lib/sadie/sasm/sasii/sasii.rb
#   dc 28/07/2013
#   dm 28/07/2013
# 
#   sasii - SASM Interactive Interpreter [Core]
require 'sadie/sasm'

module Sadie
  module SASM
    module SasII

      extend Sadie::Logger

      ### constants
      VERSION = "1.0.0".freeze

      def self.init
        @slate = Sadie::SASM::SlateVM.new
      end

      def self.exec_eval(string)
        @slate.exec_eval(string)
      end

    end
  end
end
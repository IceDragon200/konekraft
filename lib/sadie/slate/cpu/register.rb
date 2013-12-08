#
# Sadie/lib/sadie/sasm/sacpu/register.rb
#   by IceDragon
#   dc 22/05/2013
#   dm 25/05/2013
require 'sadie/slate/struct/bit_array'
module Sadie
  module Slate
    class CPU
      class Register < Sadie::BitArray

        include Enumerable

        ### constants
        VERSION = "1.1.2".freeze

        ### instance_variables
        attr_reader :cpu

        ##
        # initialize(Sacpu cpu, Integer size)
        def initialize(cpu, size)
          @cpu = cpu
          super(size)
        end

        ##
        # to_s -> String
        def to_s
          block_s
        end

        ##
        # each
        def each
          to_enum(:each) unless block_given?
          (0...@size).each { |i| yield bit_at(i) }
        end

      end
    end
  end
end

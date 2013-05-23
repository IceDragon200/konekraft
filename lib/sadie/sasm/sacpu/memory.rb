#
# Sadie/lib/sadie/sasm/sacpu/memory.rb
#   by IceDragon
#   dc 22/05/2013
#   dm 22/05/2013
module Sadie
  module SASM
    class Sacpu
      class Memory

        include Enumerable
        include Sadie::SASM::Interface::IRegister

        VERSION = "1.0.0".freeze

        attr_reader :block_size
        attr_reader :cpu
        attr_reader :data
        attr_reader :data_range

        def initialize(cpu, size_in_k, block_size)
          @cpu = cpu
          @block_size = block_size
          @data = Array.new(((size_in_k * 1024) / @block_size).to_i, 0)
          init_data_range
        end

        def init_data_range
          @data_range = (2 ** @block_size) - 1
        end

        def each(*args, &block)
          @data.each(*args, &block)
        end

        def [](index)
          @data[index]
        end

        def []=(index, n)
          @data[index] = [[n, -@data_range].max, @data_range].min
        end

        def block_count
          @data.size
        end

        def block_data
          self[@cpu.memory_pointer_value]
        end

        def block_data_set(n)
          self[@cpu.memory_pointer_value] = n
        end

        def post_access_data
          #
        end

      end
    end
  end
end

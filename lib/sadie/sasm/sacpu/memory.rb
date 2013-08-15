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
        include Sadie::SASM::Helper::IRegisterData

        ### constants
        VERSION = "1.1.0".freeze

        ### instance_variables
        attr_reader :block_size
        attr_reader :cpu
        attr_reader :data       # Array<int>
        attr_reader :data_range # int

        ##
        # initialize(Sacpu cpu, int size_in_bytes, Integer block_size)
        def initialize(cpu, size_in_bytes, block_size)
          @cpu = cpu
          @block_size = block_size
          init_data(size_in_bytes)
          init_data_range
          @cpu.memory = self
        end

        def init_data(size_in_bytes=0x10000)
          @data = Array.new(((size_in_bytes * 1024) / @block_size).to_i, 0)
        end

        ##
        # init_data_range
        def init_data_range
          @data_range = (2 ** @block_size) - 1
        end

        ## Enumerable
        # each
        def each(*args, &block)
          to_enum(:each) unless block_given?
          @data.each(*args, &block)
        end

        ##
        # [](Integer index)
        def [](index)
          @data[index]
        end

        ##
        # []=(Integer index, Integer n)
        def []=(index, n)
          @data[index] = [[n, -@data_range].max, @data_range].min
        end

        ##
        # block_ount -> Integer
        def block_count
          @data.size
        end

        ##
        # cell_data -> Integer
        def cell_data
          self[@cpu.memory_pointer_value]
        end

        ##
        # cell_data_set(Integer data)
        def cell_data_set(data)
          self[@cpu.memory_pointer_value] = data
        end

        ##
        # post_access_data
        def post_access_data
          #
        end

        ##
        # stack_data -> int
        def stack_data(offset=0)
          self[@cpu.sp.cell_data + offset]
        end

        ##
        # stack_data_set(int data)
        def stack_data_set(data, offset=0)
          self[@cpu.sp.cell_data + offset] = data
        end

        def dump
          @data.pack("C*")
        end

      end
    end
  end
end

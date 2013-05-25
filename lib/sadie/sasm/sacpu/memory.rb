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

        ### constants
        VERSION = "1.1.0".freeze

        ### instance_variables
        attr_reader :block_size
        attr_reader :cpu
        attr_reader :data
        attr_reader :data_range

        ##
        # initialize(Sacpu cpu, Integer size_in_k, Integer block_size)
        def initialize(cpu, size_in_k, block_size)
          @cpu = cpu
          @block_size = block_size
          @data = Array.new(((size_in_k * 1024) / @block_size).to_i, 0)
          init_data_range
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
        # block_data -> Integer
        def block_data
          self[@cpu.memory_pointer_value]
        end

        ##
        # block_data_set(Integer data)
        def block_data_set(data)
          self[@cpu.memory_pointer_value] = data
        end

        ##
        # post_access_data
        def post_access_data
          #
        end

        ##
        # stack_data -> Integer
        def stack_data(offset=0)
          self[@cpu.sp.block_data + offset]
        end

        ##
        # stack_data_set(Integer data)
        def stack_data_set(data, offset=0)
          self[@cpu.sp.block_data + offset] = data
        end

      end
    end
  end
end

#
# Konekraft/lib/konekraft/slate/memory.rb
#
require 'narray'
require 'konekraft/slate/helper'

module Konekraft
  module Slate
    class Memory
      include Enumerable
      include Konekraft::Slate::Helper::IRegisterData

      ### constants
      VERSION = "1.1.0".freeze

      ### instance_variables
      attr_reader :block_size
      attr_reader :cpu
      attr_reader :data       # Array<int>
      attr_reader :data_limit # int

      ##
      # initialize(Sacpu cpu, int size_in_bytes, Integer block_size)
      # block_size is the number of bits per block, the value is expected
      # to be a power of 2.
      def initialize(cpu, size_in_bytes, block_size)
        if block_size % 2 != 0
          raise ArgumentError, "block_size must be a power of 2"
        end
        unless [8, 16, 32].include?(block_size)
          raise ArgumentError, "block_size must be 8, 16, or 32"
        end
        @cpu = cpu
        @block_size = block_size
        init_data(size_in_bytes)
        init_data_limit
        @cpu.memory = self
      end

      def init_data(size_in_bytes)
        case @block_size
        when 8  then @data = NArray.byte(size_in_bytes / @block_size)
        when 16 then @data = NArray.sint(size_in_bytes / @block_size)
        when 32 then @data = NArray.int(size_in_bytes / @block_size)
        end
      end

      ##
      # init_data_limit
      def init_data_limit
        @data_limit = (2 ** @block_size) - 1
      end

      ##
      # reset
      def reset
        memclr
      end

      ## Enumerable
      # each
      def each(&block)
        to_enum(:each) unless block_given?
        @data.each(&block)
      end

      ##
      # [](Integer index)
      def [](index)
        @data[index]
      end

      ##
      # []=(Integer index, Integer n)
      def []=(index, n)
        @data[index] = [[n, -@data_limit].max, @data_limit].min
      end

      ##
      # block_ount -> Integer
      def block_count
        @data.size
      end

      ##
      # memclr
      def memclr
        @data.fill(0)
      end

      ##
      # memset
      def memset(from, value, length)
        stopat = from + length
        if stopat > block_count
          raise IndexError, "memory index exceeded!"
        end
        @data[from...stopat] = [[value, -@data_limit].max, @data_limit].min
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

      def program_cell_data
        self[@cpu.reg_pc.cell_data]
      end

      def program_cell_data_set(data)
        self[@cpu.reg_pc.cell_data] = data
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

      def to_s
        @data.join(" ")
      end

      def status_s
        "block_size=#{@block_size}bit block_count=#{@data.size} capacity=#{@data.size * @block_size}bytes"
      end
    end
  end
end

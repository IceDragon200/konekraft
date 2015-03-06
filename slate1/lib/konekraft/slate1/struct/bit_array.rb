#
# Konekraft/lib/konekraft/slate/struct/bit_array.rb
#
# Array<Bit> used by Konekraft::Sacpu for its registers, otherwise
# pretty much useless
require 'konekraft/slate1/helper/iregister_data'

module Konekraft
  class BitArray
    VERSION = "1.1.0"

    include Slate1::Helper::IRegisterData

    attr_reader :data
    attr_reader :size

    ##
    # initialize(Integer size)
    #   Size of the BitArray (representing the number of bits)
    #   Try to remain below 32 bits
    def initialize(size)
      @data = 0
      @size = size
    end

    def [](*args)
      bit_at(*args)
    end

    def []=(*args)
      bit_at_set(*args)
    end

    ### IRegister
    ##
    # cell_data
    def cell_data
      @data
    end

    ##
    # cell_data_set
    def cell_data_set(n)
      @data = n
    end

    ##
    # block_size
    def block_size
      @size
    end

    ##
    # post_access_data
    def post_access_data
      @data %= 2 ** @size
    end

    def cell_inc
      dup.cell_inc!
    end

    def cell_dec
      dup.cell_dec!
    end

    def cell_set(other)
      dup.cell_set!(other)
    end

    def cell_add(other)
      dup.cell_add!(other)
    end

    def cell_sub(other)
      dup.cell_sub!(other)
    end

    def cell_mul(other)
      dup.mul!(other)
    end

    def cell_div(other)
      dup.cell_div!(other)
    end

    def cell_lor(other)
      dup.lor!(other)
    end

    def cell_land(other)
      dup.land!(other)
    end

    def cell_complement
      dup.cell_complement!
    end

    def mend(other)
      self.class.mend(self, mend)
    end

    def self.mend(barray1, barray2)
      # Create a new BitArray using the size of the both source arrays summed
      barray = BitArray.new(barray1.size + barray2.size)
      # Assign the first bits from the first array
      for x in 0...barray1.size
        barray[x] = barray1[x]
      end
      # Assign the remainig bits from the last array
      for x in 0...barray2.size
        barray[barray1.size + x] = barray2[x]
      end
      # return the resultant bit array
      return barray
    end

    alias :+ :cell_add  # Arithmetic Add
    alias :- :cell_sub  # Arithmetic Subtract
    alias :* :cell_mul  # Arithmetic Multiply
    alias :/ :cell_div  # Arithmetic Divide
    alias :| :cell_lor  # Logical OR
    alias :& :cell_land # Logical AND
  end
end

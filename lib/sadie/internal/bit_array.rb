#
# Sadie/src/internal/BitArray.rb
#   by IceDragon
#   dc 11/05/2013
#   dm 23/05/2013
# Array<Bit> used by Sadie::Sacpu for its registers, otherwise
# pretty much useless
module Sadie
  class BitArray

    VERSION = "1.1.0"

    include Sadie::SASM::Interface::IRegister

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
    # block_data
    def block_data
      @data
    end

    ##
    # block_data_set
    def block_data_set(n)
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

    def inc
      dup.inc!
    end

    def dec
      dup.dec!
    end

    def set(other)
      dup.set!(other)
    end

    def add(other)
      dup.add!(other)
    end

    def sub(other)
      dup.sub!(other)
    end

    def mul(other)
      dup.mul!(other)
    end

    def div(other)
      dup.div!(other)
    end

    def lor(other)
      dup.lor!(other)
    end

    def land(other)
      dup.land!(other)
    end

    def complement
      dup.complement!
    end

    def mend(other)
      self.class.mend(self, mend)
    end

    def self.mend(barray1, barray2)
      # Create a new BitArray using the size of the both source registers summed
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

    alias :+ :add  # Arithmetic Add
    alias :- :sub  # Arithmetic Subtract
    alias :* :mul  # Arithmetic Multiply
    alias :/ :div  # Arithmetic Divide
    alias :| :lor  # Logical OR
    alias :& :land # Logical AND

  end
end

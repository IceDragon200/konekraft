#
# Sadie/src/internal/BitArray.rb
#   by IceDragon
#   dc 11/05/2013
#   dm 14/05/2013
# vr 1.0.0
# Array<Bit> used by Sadie::Sacpu for its registers, otherwise
# pretty much useless
module Sadie
  class BitArray

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

  private

    def cast_data(obj)
      self.class.cast_data(obj)
    end

    def wrap_data!
      yield if block_given?
      @data %= 2 ** @size
      self
    end

    def assert_bit_index(bit_index)
      raise(ArgumentError,
            "bit_index is out of range") if bit_index < 0 || @size < bit_index
    end

  public

    def [](bit_index)
      assert_bit_index(bit_index)
      (@data >> bit_index) & 0x1
    end

    def []=(bit_index, bit)
      assert_bit_index(bit_index)
      bit = BitArray.cast_bit(bit)
      @data |= (bit & 0x1) << bit_index
    end

    def inc(n)
      @data += n
    end

    def dec(n)
      @data -= n
    end

    ##
    # set!(BitArray other)
    def set!(other)
      wrap_data! { @data = cast_data(other) }
    end

    ##
    # add!(BitArray other)
    def add!(other)
      wrap_data! { @data += cast_data(other) }
    end

    ##
    # sub!(BitArray other)
    def sub!(other)
      wrap_data! { @data -= cast_data(other) }
    end

    ##
    # mul!(BitArray other)
    def mul!(other)
      wrap_data! { @data *= cast_data(other) }
    end

    ##
    # div!(BitArray other)
    def div!(other)
      wrap_data! { @data /= cast_data(other) }
    end

    ### Binary Operation
    ##
    # bor!(BitArray other)
    def bor!(other)
      wrap_data! { @data |= cast_data(other) }
    end

    ##
    # band!(BitArray other)
    def band!(other)
      wrap_data! { @data &= cast_data(other) }
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

    def bor(other)
      dup.bor!(other)
    end

    def band(other)
      dup.band!(other)
    end

  public

    def self.cast_data(obj)
      obj.kind_of?(BitArray) ? obj.data : obj
    end

    def self.cast_bit(obj)
      obj.kind_of?(Numeric) ? obj.to_i : (!!obj ? 1 : 0)
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

    alias :+ :add
    alias :- :sub
    alias :* :mul
    alias :/ :div
    alias :| :bor
    alias :& :band

  end
end

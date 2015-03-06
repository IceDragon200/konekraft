#
# Konekraft/lib/konekraft/internal/bit_tool.rb
#
module Konekraft
  module BitTool
    ### constants
    VERSION = '0.1.0'

    class CastFailure < TypeError
      #
    end

    UINT4_MIN  =  0x0
    UINT8_MIN  =  0x0
    UINT16_MIN =  0x0
    UINT32_MIN =  0x0

    UINT4_MAX  =  0xF
    UINT8_MAX  =  0xFF
    UINT16_MAX =  0xFFFF
    UINT32_MAX =  0xFFFFFFFF

    INT4_MIN   = -0x7
    INT8_MIN   = -0x7F
    INT16_MIN  = -0x7FFF
    INT32_MIN  = -0x7FFFFFFF

    INT4_MAX   =  0x7
    INT8_MAX   =  0x7F
    INT16_MAX  =  0x7FFF
    INT32_MAX  =  0x7FFFFFFF

    [
      [:uint4,  [UINT4_MIN,  UINT4_MAX]],
      [:uint8,  [UINT8_MIN,  UINT8_MAX]],
      [:uint16, [UINT16_MIN, UINT16_MAX]],
      [:uint32, [UINT32_MIN, UINT32_MAX]],
      [:int4,   [INT4_MIN,   INT4_MAX]],
      [:int8,   [INT8_MIN,   INT8_MAX]],
      [:int16,  [INT16_MIN,  INT16_MAX]],
      [:int32,  [INT32_MIN,  INT32_MAX]]
    ].each do |s, (mn, mx)|
      define_method("#{s}_wrap") do |value|
        mn + (value % (mx - mn))
      end
      define_method("#{s}_clamp") do |value|
        [[value, mn].max, mx].min
      end
    end

    ##
    # ::ary_to_int(Array<int> ary) -> int
    #   Converts an Array<int> to a |Little Endian| int
    def ary_to_int(ary)
      result = 0
      ary.each_with_index { |i, index| result |= i << (8 * index) }
      return result
    end

    def ary2_to_int16(ary)
      a, b, = ary
      return ary_to_int([a, b])
    end

    ##
    # ::ary4_to_int32be(Array<int> ary4) -> int32
    #   Converts a Array<int>[4] to a single |Big Endian| int32
    def ary4_to_int32be(ary4)
      result  = (ary4[0] || 0) << 0
      result |= (ary4[1] || 0) << 8
      result |= (ary4[2] || 0) << 16
      result |= (ary4[3] || 0) << 24
      return result
    end

    def int16_to_be_ary(int)
      low = int & 0xFF
      high = (int >> 8) & 0xFF
      return [high, low]
    end

    ##
    # ::cast_data(obj) -> Integer
    def cast_data(obj)
      obj.respond_to?(:cell_data) ? obj.cell_data : obj.to_i
    end

    ##
    # ::cast_bit(obj) -> Bit
    #   Converts a given Object to a Binary bool (0 or 1)
    #   If the object evaluates to true then the bit is 1 else 0
    def cast_bit(obj)
      obj.kind_of?(Numeric) ? [[0, obj.to_i].max, 1].min : (!!obj ? 1 : 0)
    end

    ##
    # cast_bool(int) -> Boolean
    def cast_bool(int)
      int > 0 ? true : false
    end

    ##
    # count_one_bits(int data)
    #   counts the binary ones (1) present in (data)
    def count_one_bits(data)
      mask = 1
      cnt = 0
      while data != 0
        cnt += 1 if data & mask == mask
        data >>= 1
      end
      return cnt
    end

    [:and, :or, :buffer, :invert, :nand, :nor, :xor, :xnor].each do |sym|
      define_method(sym) do |*args|
        cast_bit(Konekraft::LogicTool.send(sym, *args.map(&method(:cast_bool))))
      end
    end
    extend self
  end
end

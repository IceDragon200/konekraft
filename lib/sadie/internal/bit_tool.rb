#
# Sadie/lib/sadie/internal/bit_tool.rb
#   by IceDragon
#   dc 21/05/2013
#   dm 23/05/2013
module Sadie
  module BitTool

    VERSION = "0.1.0"

    ##
    # ::ary_to_int(Array<Integer> ary) -> Integer
    def ary_to_int(ary)
      result = 0
      ary.each_with_index { |i, index| result |= i << (8 * i) }
      return result
    end

    ##
    # ::ary4_to_int32be(Array<Integer> ary4) -> Integer
    def ary4_to_int32be(ary4)
      result  = (ary4[0] || 0) << 0
      result |= (ary4[1] || 0) << 8
      result |= (ary4[2] || 0) << 16
      result |= (ary4[3] || 0) << 24
      return result
    end

    ##
    # ::cast_data(obj) -> Integer
    def cast_data(obj)
      obj.respond_to?(:block_data) ? obj.block_data : obj.to_i
    end

    ##
    # ::cast_bit(obj) -> Bit
    def cast_bit(obj)
      obj.kind_of?(Numeric) ? obj.to_i : (!!obj ? 1 : 0)
    end

    ##
    # cast_bool(int) -> Boolean
    def cast_bool(int)
      int > 0 ? true : false
    end

    [:and, :or, :buffer, :invert, :nand, :nor, :xor, :xnor].each do |sym|
      define_method(sym) do |*args|
        cast_bit(Sadie::LogicTool.send(sym, *args.map(&method(:cast_bool))))
      end
    end

    extend self

  end
end

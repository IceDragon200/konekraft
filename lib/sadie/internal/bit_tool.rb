#
# Sadie/lib/sadie/internal/bit_tool.rb
#   by IceDragon
#   dc 21/05/2013
#   dm 23/05/2013
module Sadie
  module BitTool

    VERSION = "0.1.0"

    class CastFailure < Exception
      #
    end

    ##
    # ::ary_to_int(Array<int> ary) -> int
    #   Converts an Array<int> to a |Little Endian| int
    def ary_to_int(ary)
      result = 0
      ary.each_with_index { |i, index| result |= i << (8 * i) }
      return result
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
        cast_bit(Sadie::LogicTool.send(sym, *args.map(&method(:cast_bool))))
      end
    end

    def is_register?(data)
      if data.is_a?(String)
        !!Sadie::SASM::Sacpu::REGISTER2CODE[data.upcase]
      else
        data & REG_MASK == REG_MASK
      end
    end

    def is_register_pair?(data)
      if data.is_a?(String)
        !!Sadie::SASM::Sacpu::REGISTERPAIR2CODE[data.upcase]
      else
        data & REG_PAIR_MASK == REG_PAIR_MASK
      end
    end

    def literal_cast_as(target_datatype, data)
      case target_datatype
      when :register, :reg
        return Sadie::SASM::Sacpu::CODE2REGISTER[data]
      else
        return data
      end
    end

    def cast_as_null(data)
      return Sadie::SASM::Sacpu::BNULL
    end

    def cast_as_register(data)
      if code = Sadie::SASM::Sacpu::REGISTER2CODE[data.upcase]
        return code
      else
        return nil
        #raise(Sadie::SASM::RegisterError, "invalid register %s" % data)
      end
    end

    def cast_as_register_pair(data)
      if reg2code = Sadie::SASM::Sacpu::REGISTERPAIR2CODE[data.upcase]
        return reg2code
      else
        return nil
      end
    end

    def cast_as_int(data)
      if data.is_a?(String)
        if mtch_data = data.match(/(?:0x([A-F0-9]+)|([A-F0-9]+H))/i) # is a Hexi Decimal
          return (mtch_data[1] || mtch_data[2]).hex
        elsif mtch_data = data.match(/(0[01]+)/) # is a binary number
          return mtch_data[1].to_i(2)
        #elsif mtch_data = data.match(/(\d+)/) # is a regular integer
        else
          return data.to_i
        end
      else
        return data.to_i
      end
    end

    def cast_as_int16(data)
      cast_as_int(data)
    end

    def cast_as_address(data)
      cast_as_int(data)
    end

    def cast_as_address16(data)
      cast_as_int16(data)
    end

    def data_cast_as(target_datatype, data)
      case target_datatype
      when :null
        cast_as_null(data)
      when :register, :reg # A, B, C, D, E, H, L
        cast_as_register(data)
      when :register_pair, :reg_pair
        cast_as_register_pair(data)
      when :integer, :int, :integer8, :int8
        cast_as_int(data)
      when :integer16, :int16
        cast_as_int16(data)
      when :address, :adr
        cast_as_address(data)
      when :address16, :adr16
        cast_as_address16(data)
      else
        raise(CastFailure,
              "failed to cast %s as a %s" % [data.inspect,
                                             target_datatype.inspect])
      end
    end

    def identify_type(obj)
      if is_register?(obj)
        return is_register_pair?(obj) ? :register_pair : :register
      end
      case obj
      when Integer
        obj < 0x100 ? :int8 : :int16
      when String
        :string
      end
    end

    def try_cast_obj(obj)
      data_cast_as(identify_type(obj), obj)
    end

    def type_bytesize(type)
      case type
      when :integer, :int, :int8, :address, :adr
        1
      when :integer16, :int16, :address16, :adr16
        2
      else
        0
      end
    end

    extend self

  end
end

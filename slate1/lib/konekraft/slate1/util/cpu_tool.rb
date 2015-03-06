module Konekraft
  module CpuTool
    def is_register?(data)
      return !!Slate1::CPU::REGISTER2CODE[data.to_s]
    end

    def is_register_pair?(data)
      return !!Slate1::CPU::REGISTERPAIR2CODE[data.to_s]
    end

    def literal_cast_as(target_datatype, data)
      case target_datatype
      when :register, :reg
        return Slate1::CPU::CODE2REGISTER[data]
      else
        return data
      end
    end

    def cast_as_null(data)
      return Slate1::CPU::BNULL
    end

    def cast_as_register(data)
      if code = Slate1::CPU::REGISTER2CODE[data.upcase]
        return code
      else
        return nil
        #raise(Konekraft::SlateAssembly::RegisterError, "invalid register %s" % data)
      end
    end

    def cast_as_register_pair(data)
      if reg2code = Slate1::CPU::REGISTERPAIR2CODE[data.upcase]
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

    def cast_as_int8(data)
      cast_as_int(data)
    end

    def cast_as_int16(data)
      cast_as_int(data)
    end

    def cast_as_address(data)
      uint8_clamp(cast_as_int8(data))
    end

    def cast_as_address16(data)
      uint16_clamp(cast_as_int16(data))
    end

    def data_cast_as(data, target_datatype)
      case target_datatype
      when :null                              then cast_as_null(data)
      when :register, :reg                    then cast_as_register(data)
      when :register_pair, :reg_pair          then cast_as_register_pair(data)
      when :integer, :int, :integer8, :int8   then cast_as_int8(data)
      when :integer16, :int16                 then cast_as_int16(data)
      when :address, :adr                     then cast_as_address(data)
      when :address16, :adr16                 then cast_as_address16(data)
      else
        raise(CastFailure,
              "failed to cast %s as a %s" % [data.inspect,
                                             target_datatype.inspect])
      end
    end

    ##
    # @param [Object] type
    # @return [Symbol]
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
      data_cast_as(obj, identify_type(obj))
    end

    ##
    # @param [Symbol] type
    # @param [Integer]
    def type_bytesize(type)
      case type
      when :integer, :int, :int8, :address, :adr  then 1
      when :integer16, :int16, :address16, :adr16 then 2
      when :integer32, :int32, :address32, :adr32 then 4
      else                                             0
      end
    end

    extend self
  end
end

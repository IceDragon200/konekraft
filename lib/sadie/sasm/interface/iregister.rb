#
# Sadie/lib/sadie/sasm/interface/iregister.rb
#   by IceDragon
#   dc 23/05/2013
#   dm 23/05/2013
module Sadie
  module SASM
    module Interface
      module IRegister

        VERSION = "0.5.0".freeze

        # implement a #block_data and #block_data_set method within your class
        # to interface with the IRegister

        include Comparable

        ### overwrite in subclass
        ##
        # block_data -> Integer
        def block_data
          nil
        end

        ##
        # block_data_set
        def block_data_set(data)
          nil
        end

        ##
        # block_size -> Integer
        def block_size
          nil
        end

        ##
        # post_access_data
        def post_access_data
          nil
        end

        ##
        # low_data
        def low_data
          nil
        end

        ##
        # low_data_set(Integer data)
        def low_data_set(data)
          nil
        end

        ##
        # high_data
        def high_data
          nil
        end

        ##
        # high_data_set(Integer data)
        def high_data_set(data)
          nil
        end

        ##
        # block_mask
        def block_mask
          (2 ** block_size) - 1
        end

        ##
        # cast_data
        def cast_data(obj)
          Sadie::BitTool.cast_data(obj)
        end

        ##
        # post_access_data
        #   called after every use of access_data
        def post_access_data
          # overwrite in subclass
        end

        ##
        # access_data { |data| }
        def access_data
          yield block_data if block_given?
          post_access_data
          self
        end

        ##
        # assert_bit_index(Integer bit_index)
        def assert_bit_index(bit_index)
          raise(ArgumentError,
                "bit_index is out of range") if bit_index < 0 ||
                                                block_size < bit_index
        end

        ##
        # bit_at(Integer bit_index)
        def bit_at(bit_index)
          assert_bit_index(bit_index)
          (block_data >> bit_index) & 0x1
        end

        ##
        # bit_at_set(Integer bit_index, Integer bit)
        def bit_at_set(bit_index, bit)
          assert_bit_index(bit_index)
          bit = Sadie::BitTool.cast_bit(bit)
          access_data { |d| block_data_set(d | (bit & 0x1) << bit_index) }
        end

        ##
        # inc!
        def inc!
          access_data { |d| block_data_set(d + 1) }
        end

        ##
        # dec!
        def dec!
          access_data { |d| block_data_set(d - 1) }
        end

        ##
        # set!(IRegister other)
        def set!(other)
          access_data { block_data_set(cast_data(other)) }
        end

        ##
        # add!(IRegister other)
        def add!(other)
          access_data { |d| block_data_set(d + cast_data(other)) }
        end

        ##
        # sub!(IRegister other)
        def sub!(other)
          access_data { |d| block_data_set(d - cast_data(other)) }
        end

        ##
        # mul!(IRegister other)
        def mul!(other)
          access_data { |d| block_data_set(d * cast_data(other)) }
        end

        ##
        # div!(IRegister other)
        def div!(other)
          access_data { |d| block_data_set(d / cast_data(other)) }
        end

        ### Logical Operation
        ## Logical OR
        # lor!(IRegister other)
        def lor!(other)
          access_data { |d| block_data_set(d | cast_data(other)) }
        end

        ## Logical AND
        # land!(IRegister other)
        def land!(other)
          access_data { |d| block_data_set(d & cast_data(other)) }
        end

        ## Logical XOR
        # lxor!(IRegister other)
        def lxor!(other)
          b = cast_data(other)
          access_data { |a| block_data_set((a | b) & -(a & b)) }
        end

        ## Bit Shift ROTATE
        # rotate!(Integer length)
        def rotate!(length)
          sig = length <=> 0
          length.abs.times do
            d  = block_data
            if sig < 0
              rd = (d << 1)
              block_data_set(rd | (d >> 7))
            elsif sig > 0
              rd = d & 1
              block_data_set((d >> 1) | (rd << 7))
            end
          end
        end

        ##
        # complement!
        def complement!
          access_data do |d|
            dat = d
            block_size.times do |i|
              dat = (dat | ((((d >> i) & 1) == 1 ? 0 : 1) << i))
            end
            block_data_set(dat)
          end
        end

        ##
        # null?
        def null?(index=nil)
          (index ? self[index] : block_data) == 0
        end

        ##
        # true?
        def true?(index=nil)
          (index ? self[index] : block_data) == 1
        end

        ## Comparable
        # <=>(Object* other) -> Integer
        def <=>(other)
          cast_data(self) <=> cast_data(other)
        end

        ##
        # block_s
        def block_s
          bs = block_size
          ds = (bs / 3.0).ceil
          hs = bs / 4
          "BIN[%1$0#{bs}b] DEC[%1$0#{ds}d] HEX[%1$0#{hs}X]" % block_data
        end

        alias :false? :null?

      end
    end
  end
end

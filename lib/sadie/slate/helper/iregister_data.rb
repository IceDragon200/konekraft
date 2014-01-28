#
# Sadie/lib/sadie/slate/helper/iregister_data.rb
#   by IceDragon
require 'sadie/slate/interface/iregister'
module Sadie
  module Slate
    module Helper
      module IRegisterData

        include Sadie::Slate::Interface::IRegister
        include Comparable

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
          yield cell_data if block_given?
          post_access_data
          self
        end

        ##
        # block_s
        def block_s
          bs = block_size
          ds = (bs / 3.0).ceil
          hs = bs / 4
          "BIN %1$0#{bs}b | DEC %1$0#{ds}d | HEX %1$0#{hs}X" % cell_data
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
          (cell_data >> bit_index) & 0x1
        end

        ##
        # bit_at_set(Integer bit_index, Integer bit)
        def bit_at_set(bit_index, bit)
          assert_bit_index(bit_index)
          bit = Sadie::BitTool.cast_bit(bit)
          access_data { |d| cell_data_set(d | (bit & 0x1) << bit_index) }
        end

        ##
        # cell_inc!
        def cell_inc!
          access_data { |d| cell_data_set(d + 1) }
        end

        ##
        # cell_dec!
        def cell_dec!
          access_data { |d| cell_data_set(d - 1) }
        end

        ##
        # cell_set!(IRegister other)
        def cell_set!(other)
          access_data { cell_data_set(cast_data(other)) }
        end

        ##
        # cell_add!(IRegister other)
        def cell_add!(other)
          access_data { |d| cell_data_set(d + cast_data(other)) }
        end

        ##
        # cell_sub!(IRegister other)
        def cell_sub!(other)
          access_data { |d| cell_data_set(d - cast_data(other)) }
        end

        ##
        # cell_mul!(IRegister other)
        def cell_mul!(other)
          access_data { |d| cell_data_set(d * cast_data(other)) }
        end

        ##
        # cell_div!(IRegister other)
        def cell_div!(other)
          access_data { |d| cell_data_set(d / cast_data(other)) }
        end

        ### Logical Operation
        ## Logical OR
        # cell_lor!(IRegister other)
        def cell_lor!(other)
          access_data { |d| cell_data_set(d | cast_data(other)) }
        end

        ## Logical AND
        # cell_land!(IRegister other)
        def cell_land!(other)
          access_data { |d| cell_data_set(d & cast_data(other)) }
        end

        ## Logical XOR
        # cell_lxor!(IRegister other)
        def cell_lxor!(other)
          b = cast_data(other)
          access_data { |a| cell_data_set((a | b) & -(a & b)) }
        end

        ## Bit Shift ROTATE
        # cell_rotate!(Integer length)
        def cell_rotate!(length)
          sig = length <=> 0
          length.abs.times do
            d  = cell_data
            if sig < 0
              rd = (d << 1)
              cell_data_set(rd | (d >> 7))
            elsif sig > 0
              rd = d & 1
              cell_data_set((d >> 1) | (rd << 7))
            end
          end
        end

        ##
        # cell_complement!
        def cell_complement!
          access_data do |d|
            dat = d
            block_size.times do |i|
              dat = (dat | ((((d >> i) & 1) == 1 ? 0 : 1) << i))
            end
            cell_data_set(dat)
          end
        end

        ##
        # cell_null? -> bool
        def cell_null?(index=nil)
          (index ? self[index] : cell_data) == 0
        end

        ##
        # cell_false? -> bool
        def cell_false?(index=nil)
          (index ? self[index] : cell_data) == 0
        end

        ##
        # cell_true? -> bool
        def cell_true?(index=nil)
          (index ? self[index] : cell_data) == 1
        end

        ## Comparable
        # <=>(Object* other) -> Integer
        def <=>(other)
          cast_data(self) <=> cast_data(other)
        end

      end
    end
  end
end
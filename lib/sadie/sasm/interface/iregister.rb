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

        def assert_bit_index(bit_index)
          raise(ArgumentError,
                "bit_index is out of range") if bit_index < 0 ||
                                                block_size < bit_index
        end

        def bit_at(bit_index)
          assert_bit_index(bit_index)
          (block_data >> bit_index) & 0x1
        end

        def bit_at_set(bit_index, bit)
          assert_bit_index(bit_index)
          bit = Sadie::BitTool.cast_bit(bit)
          access_data { |d| block_data_set(d | (bit & 0x1) << bit_index) }
        end

        ##
        # block_size -> Integer
        def block_size
          nil # overwrite in subclass
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
        # set!(BitArray other)
        def set!(other)
          access_data { block_data_set(cast_data(other)) }
        end

        ##
        # add!(BitArray other)
        def add!(other)
          access_data { |d| block_data_set(d + cast_data(other)) }
        end

        ##
        # sub!(BitArray other)
        def sub!(other)
          access_data { |d| block_data_set(d - cast_data(other)) }
        end

        ##
        # mul!(BitArray other)
        def mul!(other)
          access_data { |d| block_data_set(d * cast_data(other)) }
        end

        ##
        # div!(BitArray other)
        def div!(other)
          access_data { |d| block_data_set(d / cast_data(other)) }
        end

        ### Logical Operation
        ## Logical OR
        # lor!(BitArray other)
        def lor!(other)
          access_data { |d| block_data_set(d | cast_data(other)) }
        end

        ## Logical AND
        # land!(BitArray other)
        def land!(other)
          access_data { |d| block_data_set(d & cast_data(other)) }
        end

        def lxor!(other)
          b = cast_data(other)
          access_data { |a| block_data_set((a | b) & -(a & b)) }
        end

        def complement!
          access_data do |d|
            dat = d
            block_size.times do |i|
              dat = (dat | ((((d >> i) & 1) == 1 ? 0 : 1) << i))
            end
            block_data_set(dat)
          end
        end

        def null?(index=nil)
          (index ? self[index] : block_data) == 0
        end

        def true?(index=nil)
          (index ? self[index] : block_data) == 1
        end

        ##
        # <=>(Object* other) -> Integer
        def <=>(other)
          cast_data(self) <=> cast_data(other)
        end

        alias :false? :null?

      end
    end
  end
end

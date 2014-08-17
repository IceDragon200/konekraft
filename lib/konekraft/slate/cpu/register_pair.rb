#
# Konekraft/lib/konekraft/slate/cpu/register_pair.rb
#   by IceDragon
require 'konekraft/slate/interface/iregister'
require 'konekraft/slate/helper/iregister_data'
module Konekraft
  module Slate
    class CPU
      class RegisterPair

        include Konekraft::Slate::Interface::IRegister
        include Konekraft::Slate::Helper::IRegisterData

        ### constants
        VERSION = "1.0.0".freeze

        ### instance_variables
        attr_reader :cpu
        attr_reader :reg_high
        attr_reader :reg_low

        ##
        # initialize(Sacpu cpu, IRegister reg_high, IRegister reg_low)
        def initialize(cpu, reg_high, reg_low)
          @cpu = cpu
          @reg_high, @reg_low = reg_high, reg_low
        end

        ##
        # high_data
        def high_data
          @reg_high.cell_data
        end

        ##
        # high_data_set(Integer data)
        def high_data_set(data)
          @reg_high.cell_data_set(data)
        end

        ##
        # high_mask
        def high_mask
          @reg_high.block_mask
        end

        ##
        # high_size
        def high_size
          @reg_high.block_size
        end

        ##
        # low_data
        def low_data
          @reg_low.cell_data
        end

        ##
        # low_data_set(Integer data)
        def low_data_set(data)
          @reg_low.cell_data_set(data)
        end

        ##
        # low_mask
        def low_mask
          @reg_low.block_mask
        end

        ##
        # low_size
        def low_size
          @reg_low.block_size
        end

        ##
        # cell_data -> Integer
        def cell_data
          (high_data << low_size) | low_data
        end

        ##
        # cell_data_set(Integer data)
        def cell_data_set(data)
          low_data_set(data & low_mask)
          high_data_set((data >> low_size) & high_mask)
        end

        ##
        # block_size
        def block_size
          high_size + low_size
        end

        ##
        # to_s -> String
        def to_s
          block_s
        end

        def reset
          cell_data_set(0)
        end

      end
    end
  end
end

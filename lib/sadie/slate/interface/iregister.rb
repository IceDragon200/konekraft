#
# Sadie/lib/sadie/slate/interface/iregister.rb
#   by IceDragon
# IRegister is the storage interface for SASM, any Object requiring the ability
# to store and access data through SASM objects must implement the IRegister
# interface.
module Sadie
  module Slate
    module Interface
      module IRegister

        VERSION = "0.6.0".freeze

        # implement a #cell_data and #cell_data_set method within your class
        # to interface with the IRegister

        ### overwrite in subclass
        ##
        # cell_data -> Integer
        def cell_data
          raise
        end

        ##
        # cell_data_set
        def cell_data_set(data)
          raise
        end

        ##
        # block_size -> Integer
        def block_size
          raise
        end

        ##
        # post_access_data
        def post_access_data
          raise
        end

        ##
        # low_data
        def low_data
          raise
        end

        ##
        # low_data_set(Integer data)
        def low_data_set(data)
          raise
        end

        ##
        # high_data
        def high_data
          raise
        end

        ##
        # high_data_set(Integer data)
        def high_data_set(data)
          raise
        end

      end
    end
  end
end

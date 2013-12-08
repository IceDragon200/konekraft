#
# Sadie/lib/sadie/sasm/interface/iregister.rb
#   by IceDragon
#   dc 23/05/2013
#   dm 23/05/2013
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
          nil
        end

        ##
        # cell_data_set
        def cell_data_set(data)
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

      end
    end
  end
end

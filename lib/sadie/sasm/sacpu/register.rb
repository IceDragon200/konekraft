#
# Sadie/lib/sadie/sasm/sacpu/register.rb
#   by IceDragon
#   dc 22/05/2013
#   dm 22/05/2013
module Sadie
  module SASM
    class Sacpu
      class Register < Sadie::BitArray

        VERSION = "1.1.0".freeze

        attr_reader :cpu

        def initialize(cpu, size)
          @cpu = cpu
          super(size)
        end

        def to_s
          bs = size
          ds = (size / 3.0).ceil
          hs = size / 4
          "BIN[%1$0#{bs}b] DEC[%1$0#{ds}d] HEX[%1$0#{hs}X]" % data
        end

      end
    end
  end
end

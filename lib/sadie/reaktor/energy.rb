#
# Sadie/lib/sadie/reaktor/energy.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 17/08/2013
module Sadie
  module Reaktor
    class Energy

      VERSION = "1.2.0".freeze

      attr_accessor :value

      def initialize(value=0)
        @value = value
      end

      def coerce(obj)
        return self, obj
      end

      def cast_value(obj)
        obj.is_a?(Energy) ? obj.value : obj.to_i
      end

      def +(other)
        if v = cast_value(other)
          @value += v
        end
      end

      def -(other)
        if v = cast_value(other)
          @value -= v
        end
      end

      def *(other)
        if v = cast_value(other)
          @value *= v
        end
      end

      def /(other)
        if v = cast_value(other)
          @value /= v
        end
      end

      def zero
        @value = 0
      end

      def calc_pull(src_energy, max, min, cap)
        rem  = src_energy.value - max
        pull = rem < 0 ? (max + rem) : max
        pull = (n = self.value + pull) > cap ? n - cap : pull
        return pull >= min ? pull : 0
      end

      def to_s
        "power|#{@value}"
      end

      private :cast_value

    end
  end
end
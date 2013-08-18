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

      def add!(other)
        @value += cast_value(other)
        self
      end

      def sub!(other)
        @value -= cast_value(other)
        self
      end

      def mul!(other)
        @value *= cast_value(other)
        self
      end

      def div!(other)
        @value /= cast_value(other)
        self
      end

      def add(other)
        dup.add!(other)
      end

      def sub(other)
        dup.sub!(other)
      end

      def mul(other)
        dup.mul!(other)
      end

      def div(other)
        dup.div!(other)
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

      def to_i
        @value.to_i
      end

      def to_f
        @value.to_f
      end

      def save
        (@history ||= []).push(@value)
      end

      def restore
        @value = @history.pop
      end

      private :cast_value

      alias :+ :add
      alias :- :sub
      alias :* :mul
      alias :/ :div

    end
  end
end

en = Sadie::Reaktor::Energy.new(4)
p en
p en + en
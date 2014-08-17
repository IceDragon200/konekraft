#
# Konekraft/lib/konekraft/konekt/energy.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 18/08/2013
require 'konekraft/mixin/mathable'
module Konekraft
  module Konekt2
    class Energy

      ### constants
      VERSION = "1.2.1".freeze

      ### includes
      include Konekraft::Mixin::Mathable

      ### instance_attributes
      attr_accessor :value

      ##
      # initialize(int value)
      def initialize(value=0)
        @value = value
      end

      ##
      # coerce(obj)
      def coerce(obj)
        return self, obj
      end

      ##
      # cast_value(obj)
      def cast_value(obj)
        obj.is_a?(Energy) ? obj.value : obj.to_i
      end

      ##
      # set(int other)
      # set(Energy other)
      def set(other)
        @value = cast_value(other)
        self
      end

      ##
      # add!(int other)
      # add!(Energy other)
      def add!(other)
        @value += cast_value(other)
        self
      end

      ##
      # sub!(int other)
      # sub!(Energy other)
      def sub!(other)
        @value -= cast_value(other)
        self
      end

      ##
      # mul!(int other)
      # mul!(Energy other)
      def mul!(other)
        @value *= cast_value(other)
        self
      end

      ##
      # div!(int other)
      # div!(Energy other)
      def div!(other)
        @value /= cast_value(other)
        self
      end

      ##
      # zero!
      def zero!
        @value = 0
        self
      end

      ##
      # zero
      def zero
        dup.zero!
      end

      ##
      # calc_pull(int src_energy, int max, int min, int cap)
      # calc_pull(Energy src_energy, int max, int min, int cap)
      def calc_pull(src_energy, max, min, cap)
        rem  = cast_value(src_energy) - max
        pull = rem < 0 ? (max + rem) : max
        pull = (n = @value + pull) > cap ? n - cap : pull
        return pull >= min ? pull : 0
      end

      ##
      # to_s -> String
      def to_s
        "power:#{@value}"
      end

      ##
      # to_i -> int
      def to_i
        @value.to_i
      end

      ##
      # to_f -> float
      def to_f
        @value.to_f
      end

      ### state manager
      ##
      # restore
      def restore
        @value = @history.pop
      end

      ##
      # save
      def save
        (@history ||= []).push(@value)
        if block_given?
          yield self
          restore
        end
      end

      ### visibility
      private :cast_value

    end
  end
end

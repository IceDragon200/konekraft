#
# Konekraft/lib/konekraft/mixin/mathable.rb
#
# Create a add!, sub!, mul!, and div! method in your class, when using this
# mixin
module Konekraft
  module Mixin
    module Mathable
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

      alias :+ :add
      alias :- :sub
      alias :* :mul
      alias :/ :div
    end
  end
end

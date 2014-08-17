module Konekraft
  module Konekt3
    class Poll

      def initialize
        @value = nil
      end

      def push(v)
        @value = v
      end

      def pop
        v = @value
        @value = nil
        return v
      end

      def read
        @value
      end

      alias :write :push

    end
  end
end

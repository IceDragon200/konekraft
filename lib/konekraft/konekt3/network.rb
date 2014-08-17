module Konekraft
  module Konekt3
    class Network

      def tick
        @ticks += 1
      end

      def poll
        @poll_c += 1
      end

      def process
        @process_c += 1
      end

    end
  end
end

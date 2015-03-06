module Konekraft
  module Konekt3
    module Component

      @@list = []

      def self.add(konekt_klass)
        @@list << konekt_klass
      end

      def self.all
        @@list
      end

    end
  end
end

module Sadie
  module Reaktor3
    module Component

      @@list = []

      def self.add(reaktor_klass)
        @@list << reaktor_klass
      end

      def self.all
        @@list
      end

    end
  end
end
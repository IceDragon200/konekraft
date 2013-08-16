#
# Sadie/lib/sadie/reaktor/port_spec.rb
#
module Sadie
  module Reaktor
    class PortSpec

      attr_accessor :id, :name, :type

      def initialize(id, name, type)
        @id   = id
        @name = name
        @type = type
      end

      def to_s
        "#{id}|#{name}|#{type}"
      end

    end
  end
end
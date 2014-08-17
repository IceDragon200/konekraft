require 'konekraft/konekt3/poll'
module Konekraft
  module Konekt3
    module Component
      class Base

        def initialize
          @ticks = 0
          init
        end

        def init
        end

        def tick
          @ticks += 1
        end

        def process
          #
        end

        def self.poll(name)
          define_method(name) do
            poll = instance_variable_get("@#{name}")
            poll = instance_variable_set("@#{name}", Poll.new(name)) unless poll
            return poll
          end
          @polls << name
        end

        def self.inherited
          @polls = []
        end

      end
    end
  end
end

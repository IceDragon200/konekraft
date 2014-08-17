require 'sadie/reaktor3/component/emitter'
module Sadie
  module Reaktor3
    module Component
      class Pulse < Emitter

        attr_accessor :frequency

        def tick
          @pulse_value = (@tick / @frequency) % 2 == 0 ? @value : 0
          super
        end

        def process
          output.write(@pulse_value)
        end

      end
    end
  end
end
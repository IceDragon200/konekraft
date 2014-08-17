require 'sadie/reaktor3/component/base'
module Sadie
  module Reaktor3
    module Component
      class Emitter < Base

        poll :output

        attr_accessor :value

        def init
          super
          @value = 1
        end

        def process
          output.write(@value)
        end

      end
    end
  end
end
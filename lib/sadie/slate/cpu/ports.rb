#
# Sadie/lib/sadie/sasm/sacpu/clock.rb
#   dc 22/05/2013
#   dm 22/05/2013
module Sadie
  module Slate
    class CPU
      class Ports
        class Port

          ### instance_variables
          attr_accessor :data

          ##
          # initialize
          def initialize
            @data = 0
          end

          ## read
          # >>(IRegister ireg)
          def >>(ireg)
            ireg.cell_data_set(@data)
          end

          ## write
          # <<(IRegister ireg)
          def <<(ireg)
            @data = ireg.cell_data
          end

        end

        ### constants
        VERSION = "1.0.0".freeze

        ### instance_variables
        attr_reader :cpu
        attr_reader :input
        attr_reader :output

        def initialize(cpu, input_count, output_count)
          @cpu = cpu
          @input = Array.new(input_count) { Port.new }
          @output = Array.new(output_count) { Port.new }
        end

      end
    end
  end
end

#
# Sadie/lib/sadie/slate/cpu/clock.rb
#
module Sadie
  module Slate
    class CPU
      class Clock

        ### constants
        VERSION = "1.0.0".freeze

        ### instance_variables
        attr_accessor :frequency
        attr_reader :cpu
        attr_reader :cycle_count
        attr_reader :cycle_tick
        attr_reader :tick

        def initialize(cpu, frequency=120)
          @cpu = cpu
          @frequency = frequency
          init_ticks
          init_cycle_tick
          init_cycle_count
        end

        def init_ticks
          @tick = 0
        end

        def init_cycle_tick
          @cycle_tick = 0
        end

        def init_cycle_count
          @cycle_count = 0
        end

        def resolve_cycle_tick
          @cycle_count += @cycle_tick / @frequency
          @cycle_tick %= @frequency
        end

        def cycle
          resolve_cycle_tick
          @frequency.times do |_|
            @tick += 1
            @cycle_tick += 1
            yield self
          end
        end

        def reset
          @tick = 0
          @cycle_tick = 0
          @cycle_count = 0
        end

      end
    end
  end
end

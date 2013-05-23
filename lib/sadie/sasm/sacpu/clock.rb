#
# Sadie/lib/sadie/sasm/sacpu/clock.rb
#   dc 22/05/2013
#   dm 22/05/2013
module Sadie
  module SASM
    class Sacpu
      class Clock

        VERSION = "1.0.0".freeze

        attr_accessor :frequency
        attr_reader :cpu
        attr_reader :cycle_count
        attr_reader :cycle_tick
        attr_reader :tick

        def initialize(cpu, frequency=60)
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

      end
    end
  end
end

#
# Sadie/lib/sadie/reaktor/component/capacitor.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 22/06/2013
module Sadie
  module Reaktor
    class Capacitor < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_ID  = :input, "input")

      ## outputs
      register_port(:out, OUTPUT_ID = :output, "output")

      ### instance_attributes
      attr_accessor :charge_pull_min
      attr_accessor :charge_pull_max
      attr_accessor :charge_lost
      attr_accessor :charge_foot
      attr_accessor :charge_ceil

      ##
      # init
      def init
        super
        @charge_lost = 1
        @charge_pull_min = 1
        @charge_pull_max = 1
        @charge_foot = 0
        @charge_ceil = 1
        @discharge = false
      end

      ##
      # discharge?(Energy energy)
      #   determines if the capacitor should discharge from given energy
      #   If the supplied energy is insufficient to charge the capacitor
      #   it will discharge instead
      def discharge?(energy)
        energy.value < @charge_pull_min
      end

      ##
      # tick
      def tick
        super
        if @discharge
          @energy.value = [[@energy.value - @charge_lost,
                            @charge_foot].max, @charge_ceil].min
          @discharge = false
        end
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        if discharge?(energy)
          @discharge = true
        else
          pull = @energy.calc_pull(energy,
                                   @charge_pull_max,
                                   @charge_pull_min, @charge_ceil)
          @energy.value = [[@charge_foot, (@energy.value + pull)].max, @charge_ceil].min
          energy.value -= pull
        end
        emit(OUTPUT_ID)
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(
          discharge: @discharge,
          charge_lost: @charge_lost,
          charge_pull_min: @charge_pull_min,
          charge_pull_max: @charge_pull_max,
          charge_foot: @charge_foot,
          charge_ceil: @charge_ceil
        )
      end

      def property_get(k)
        case k.to_s
        when "charge_ceil"     then @charge_ceil
        when "charge_foot"     then @charge_foot
        when "charge_lost"     then @charge_lost
        when "charge_pull_max" then @charge_pull_max
        when "charge_pull_min" then @charge_pull_min
        when "discharge"       then @discharge
        else
          super(k)
        end
      end

      def property_set(k, v)
        case k.to_s
        when "charge_ceil"     then @charge_ceil = v.to_i
        when "charge_foot"     then @charge_foot = v.to_i
        when "charge_lost"     then @charge_lost = v.to_i
        when "charge_pull_max" then @charge_pull_max = v.to_i
        when "charge_pull_min" then @charge_pull_min = v.to_i
        when "discharge"       then @discharge = bool_parse(v) # the discharge is internally controlled
        else
          super(k, v)
        end
      end

      ### registration
      register('capacitor')

    end
  end
end

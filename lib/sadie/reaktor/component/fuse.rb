#
# Sadie/lib/sadie/reaktor/component/fuse.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 22/06/2013
module Sadie
  module Reaktor
    class Fuse < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_ID  = :input, "input")

      ## outputs
      register_port(:out, OUTPUT_ID = :output, "output")

      ### instance_attributes
      attr_accessor :threshold # Integer
      attr_accessor :broken # Boolean

      ##
      # init
      def init
        super
        @threshold = 1
        reset
      end

      ##
      # reset
      def reset
        super
        self.broken = false
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        if !broken
          if energy.value >= threshold
            self.broken = true
            try_callback(:on_react_fuse_break, self, port, energy)
          else
            emit(OUTPUT_ID, energy)
          end
        else
          try_callback(:on_react_fuse_broken, self, port, energy)
        end
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(threshold: @threshold, broken: @broken)
      end

      def property_get(k)
        case k.to_s
        when "broken"    then @broken
        when "threshold" then @threshold
        else
          super(k)
        end
      end

      def property_set(k, v)
        case k.to_s
        when "broken"    then @broken = bool_parse(v)
        when "threshold" then @threshold = v.to_i
        else
          super(k, v)
        end
      end

      ### registration
      register('fuse')

    end
  end
end

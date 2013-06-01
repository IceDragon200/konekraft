#
# Sadie/lib/sadie/mixin/switch_state2.rb
#   by IceDragon
#   dc 31/05/2013
#   dm 31/05/2013
# vr 1.0.0
module Sadie
  module Mixin
    module SwitchState2

      def state_toggle
        @state = !@state
      end

      def state_press
        @state = !@default_state
      end

      def state_depress
        @state = @default_state
      end

      def state_nc?
        @default_state == true
      end

      def state_no?
        @default_state == false
      end

      def state_pressed?
        @state != @normal_state
      end

      def state_closed?
        @state == true
      end

      def state_open?
        @state == false
      end

    end
  end
end

#
# Sadie/lib/sadie/reaktor/component/base_switch.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 22/06/2013
module Sadie
  module Reaktor
    class BaseSwitch < Base

      ### constants
      VERSION = "2.0.0".freeze

      ### extensions
      extend Sadie::Reaktor::Mixin::SwitchState2
      ss2_def :state

      ### instance_attributes
      attr_accessor :state # Boolean

      ##
      # init
      def init
        reset
        super
      end

      ##
      # reset
      def reset
        self.state = false
        super
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(state: state)
      end

    end
  end
end

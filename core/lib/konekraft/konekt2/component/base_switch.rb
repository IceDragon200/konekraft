#
# Konekraft/lib/konekraft/konekt/component/base_switch.rb
#
require 'konekraft/konekt2/component/base'
module Konekraft
  module Konekt2
    class BaseSwitch < Base

      ### constants
      VERSION = "2.0.0".freeze

      ### extensions
      extend Konekraft::Konekt2::Mixin::SwitchState2
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

      def property_get(k)
        case k.to_s
        when "state" then @state
        else
          super(k)
        end
      end

      def property_set(k, v)
        case k.to_s
        when "state" then @state = bool_parse(v)
        else
          super(k, v)
        end
      end

    end
  end
end

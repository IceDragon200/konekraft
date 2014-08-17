#
# Konekraft/lib/konekraft/konekt/component/switch_dpst.rb
#   by IceDragon
#   dc 15/08/2013
#   dm 15/08/2013
require 'konekraft/konekt2/component/base'
module Konekraft
  module Konekt2
    class SwitchDPST < BaseSwitch

      ### constants
      VERSION = "2.0.0".freeze

      ## bi-directional
      register_port(:bi, CONTACT_L1_ID = :l1, "l1")
      register_port(:bi, CONTACT_L2_ID = :l2, "l2")
      register_port(:bi, CONTACT_X1_ID = :x1, "x1")
      register_port(:bi, CONTACT_X2_ID = :x2, "x2")

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        case port.id
        when CONTACT_L1_ID
          state_callback = @state ? :on_react_l1_x1_on : :on_react_l1_x1_off
          abs_callback = :on_react_l1_x1
          emit_id = CONTACT_X1_ID
        when CONTACT_L2_ID
          state_callback = @state ? :on_react_l2_x2_on : :on_react_l2_x2_off
          abs_callback = :on_react_l2_x2
          emit_id = CONTACT_X2_ID
        when CONTACT_X1_ID
          state_callback = @state ? :on_react_x1_l1_on : :on_react_x1_l1_off
          abs_callback = :on_react_x1_l1
          emit_id = CONTACT_L1_ID
        when CONTACT_X2_ID
          state_callback = @state ? :on_react_x2_l2_on : :on_react_x2_l2_off
          abs_callback = :on_react_x2_l2
          emit_id = CONTACT_L2_ID
        end
        if @state
          en = energy
        else
          en = emit_energy_null
        end
        try_callback(state_callback, self, port, en)
        try_callback(abs_callback, self, port, en)
        emit(emit_id, en)
      end

      ### registration
      register('switch_dpst')

    end
  end
end

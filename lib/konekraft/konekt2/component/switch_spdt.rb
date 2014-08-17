#
# Konekraft/lib/konekraft/konekt/component/switch_spdt.rb
#   by IceDragon
#   dc 15/08/2013
#   dm 15/08/2013
require 'konekraft/konekt2/component/base'
module Konekraft
  module Konekt2
    class SwitchSPDT < BaseSwitch

      ### constants
      VERSION = "2.0.0".freeze

      ## bi-directional
      register_port(:bi, CONTACT_L1_ID = :l1, "l1")
      register_port(:bi, CONTACT_X1_ID = :x1, "x1")
      register_port(:bi, CONTACT_X2_ID = :x2, "x2")

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        case port.id
        when CONTACT_L1_ID
          if @state
            emit(CONTACT_X1_ID, emit_energy_null)
            emit(CONTACT_X2_ID, energy)
            try_callback(:on_react_common_l1, self, port, energy)
          else
            emit(CONTACT_X1_ID, energy)
            emit(CONTACT_X2_ID, emit_energy_null)
            try_callback(:on_react_common_l2, self, port, energy)
          end
        when CONTACT_X1_ID
          en = !@state ? energy : emit_energy_null
          callback_name = !@state ? :on_react_l1_common : :on_react_l1_common_null
          emit(CONTACT_L1_ID, energy)
          try_callback(callback_name, self, port, en)
        when CONTACT_X2_ID
          en = @state ? energy : emit_energy_null
          callback_name = @state ? :on_react_l2_common : :on_react_l2_common_null
          emit(CONTACT_L1_ID, energy)
          try_callback(callback_name, self, port, energy)
        end
      end

      ### registration
      register('switch_spdt')

    end
  end
end

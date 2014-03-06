#
# Sadie/lib/sadie/reaktor/component/switch_spst.rb
#   by IceDragon
#   dc 15/08/2013
#   dm 15/08/2013
require 'sadie/reaktor2/component/base'
module Sadie
  module Reaktor2
    class SwitchSPST < BaseSwitch

      ### constants
      VERSION = "2.0.0".freeze

      ## bi-directional
      register_port(:bi, CONTACT_L1_ID = :l1, "l1")
      register_port(:bi, CONTACT_X1_ID = :x1, "x1")

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        op_id = (port.id == CONTACT_L1_ID) ? CONTACT_X1_ID : CONTACT_L1_ID
        if @state
          emit(op_id, energy)
          try_callback(:on_react_common, self, port, energy)
        else
          emit(op_id, emit_energy_null)
          try_callback(:on_react_common_null, self, port, energy)
        end
      end

      ### registration
      register('switch_spst')

    end
  end
end

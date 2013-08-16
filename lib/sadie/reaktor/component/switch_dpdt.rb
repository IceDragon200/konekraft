#
# Sadie/lib/sadie/reaktor/component/switch_dpdt.rb
#   by IceDragon
#   dc 15/08/2013
#   dm 15/08/2013
module Sadie
  module Reaktor
    class SwitchDPDT < BaseSwitch

      ### constants
      VERSION = "2.0.0".freeze

      ## bi-directional
      register_port(:bi, CONTACT_L1_ID = :l1, "l1")
      register_port(:bi, CONTACT_L2_ID = :l2, "l2")
      # load 1
      register_port(:bi, CONTACT_X1C1_ID = :x1c1, "x1c1")
      register_port(:bi, CONTACT_X1C2_ID = :x1c2, "x1c2")
      # load 2
      register_port(:bi, CONTACT_X2C1_ID = :x2c1, "x2c1")
      register_port(:bi, CONTACT_X2C2_ID = :x2c2, "x2c2")

      CONTACT_PAIR_X1 = [CONTACT_X1C1_ID, CONTACT_X1C2_ID].freeze
      CONTACT_PAIR_X2 = [CONTACT_X2C1_ID, CONTACT_X2C2_ID].freeze

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        case port.id
        when CONTACT_L1_ID, CONTACT_L2_ID
          if port.id == CONTACT_L1_ID
            contact_pair = CONTACT_PAIR_X1
          else
            contact_pair = CONTACT_PAIR_X2
          end
          i1, i2 = 0, 1
          i1, i2 = i2, i1 if @state
          emit(contact_pair[i1], energy)
          emit(contact_pair[i2], emit_energy_null)
        when CONTACT_X1C1_ID, CONTACT_X2C1_ID
          line1 = (port.id == CONTACT_X1C1_ID)
          emit_id = line1 ? CONTACT_L1_ID : CONTACT_L2_ID
          en = !@state ? energy : emit_energy_null
          emit(emit_id, en)
          if !@state
            callback_name = line1 ? :on_react_x1c1_l1_null : :on_react_x1c1_l2_null
          else
            callback_name = line1 ? :on_react_x1c1_l1 : :on_react_x1c1_l2
          end
          try_callback(callback_name, self, port, en)
        when CONTACT_X1C2_ID, CONTACT_X2C2_ID
          line1 = (port.id == CONTACT_X1C2_ID)
          emit_id = line1 ? CONTACT_L1_ID : CONTACT_L2_ID
          en = @state ? energy : emit_energy_null
          emit(emit_id, en)
          if @state
            callback_name = line1 ? :on_react_x1c2_l1_null : :on_react_x1c2_l2_null
          else
            callback_name = line1 ? :on_react_x1c2_l1 : :on_react_x1c2_l2
          end
          try_callback(callback_name, self, port, en)
        end
      end

      ### registration
      register('switch_dpdt')

    end
  end
end

#
# Konekraft/lib/konekraft/konekt/component/contactor.rb
#
require 'konekraft/konekt2/component/base'
module Konekraft
  module Konekt2
    class Contactor < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_AUX1_ID    = INPUT_COIL1_ID = :aux1_in, "aux1")
      register_port(:in,  INPUT_AUX2_ID    = INPUT_COIL2_ID = :aux2_in, "aux2")
      register_port(:in,  INPUT_COMMON1_ID = :common1_in, "common1")
      register_port(:in,  INPUT_COMMON2_ID = :common2_in, "common2")
      register_port(:in,  INPUT_COMMON3_ID = :common3_in, "common3")

      ## outputs
      register_port(:out, OUTPUT_AUX1_ID    = :aux1_out, "aux-w1")
      register_port(:out, OUTPUT_AUX2_ID    = :aux2_out, "aux-w2")
      register_port(:out, OUTPUT_COMMON1_ID = :common1_out, "common1")
      register_port(:out, OUTPUT_COMMON2_ID = :common2_out, "common2")
      register_port(:out, OUTPUT_COMMON3_ID = :common3_out, "common3")

      ### instance_attributes
      attr_reader :aux_state             # Array<Boolean>
      attr_accessor :aux_trigger_energy  # Array<Integer>
      attr_accessor :coil_state_normal   # Boolean

      ##
      # init
      def init
        super
        # constant
        @coil_state_normal   = false           # N(ormally)O(pen)
        @aux_trigger_energy  = {
                                 aux1_in: 1,
                                 aux2_in: 1,
                               }

        # internal_variable
        @aux_state           = {
                                 aux1_in: false,
                                 aux2_in: false,
                               }
      end

      ##
      # coil_state_inverted -> Boolean
      def coil_state_inverted
        !coil_state_normal
      end

      ##
      # coil_trigger?(Integer id, Energy energy) -> Boolean
      def aux_trigger?(id, energy)
        # can the coil be trigger from the given energy?
        energy.value >= @aux_trigger_energy[id]
      end

      ##
      # full_aux?
      #   are all the auxillaries set?
      def full_aux?
        @coil_state_normal ? !@aux_state.all? : @aux_state.all?
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        case id = port.id
        when INPUT_AUX1_ID, INPUT_AUX2_ID
          @aux_state[id] = aux_trigger?(id, energy) ? coil_state_inverted :
                                                  coil_state_normal
          #emit(OUTPUT_COIL_ID, energy)
          try_callback(:on_react_coil, self, port, energy)
          emit(OUTPUT_AUX1_ID, energy) if @aux_state[:aux1_in]
          emit(OUTPUT_AUX2_ID, energy) if @aux_state[:aux2_in]
        when INPUT_COMMON1_ID, INPUT_COMMON2_ID, INPUT_COMMON3_ID
          if full_aux?
            en = energy
            callback_name = :on_react_common
          else
            en = emit_energy_null
            callback_name = :on_react_common_off
          end
          case id
          when INPUT_COMMON1_ID
            emit(OUTPUT_COMMON1_ID, en)
          when INPUT_COMMON2_ID
            emit(OUTPUT_COMMON2_ID, en)
          when INPUT_COMMON3_ID
            emit(OUTPUT_COMMON3_ID, en)
          end
          try_callback(callback_name, self, port, en)
        end
      end

      ##
      # export_h
      def export_h
        super.merge(coil_state_normal: coil_state_normal,
                    aux_state: aux_state.to_s,
                    aux_trigger_energy: aux_trigger_energy.to_s)
      end

      def property_get(k)
        case k.to_s
        when "aux_state1"          then @aux_state[:aux1_in]
        when "aux_state2"          then @aux_state[:aux2_in]
        when "aux_trigger_energy1" then @aux_trigger_energy[:aux1_in]
        when "aux_trigger_energy2" then @aux_trigger_energy[:aux2_in]
        when "coil_state_normal"   then @coil_state_normal
        else
          super(k)
        end
      end

      def property_set(k, v)
        case k.to_s
        when "aux_state1"          then @aux_state[:aux1_in] = bool_parse(v)
        when "aux_state2"          then @aux_state[:aux2_in] = bool_parse(v)
        when "aux_trigger_energy1" then @aux_trigger_energy[:aux1_in] = v.to_i
        when "aux_trigger_energy2" then @aux_trigger_energy[:aux2_in] = v.to_i
        when "coil_state_normal"   then @coil_state_normal = bool_parse(v)
        else
          super(k, v)
        end
      end

      ### registration
      register('contactor')

    end
  end
end

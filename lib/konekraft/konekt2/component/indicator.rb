#
# Konekraft/lib/konekraft/konekt/component/indicator.rb
#   by IceDragon
#   dc 30/05/2013
#   dm 22/06/2013
require 'konekraft/konekt2/component/base'
module Konekraft
  module Konekt2
    class Indicator < Base

      ### constants
      VERSION = "2.2.0".freeze

      ## inputs
      register_port(:in,  INPUT_ID  = :input, "input")

      ## outputs
      register_port(:out, OUTPUT_ID = :output, "output")

      ### extensions
      extend Konekraft::Konekt2::Mixin::SwitchState2
      ss2_def :lit

      ### instance_attributes
      attr_accessor :state
      attr_accessor :threshold

      ##
      # init
      def init
        super
        @lit = false
        @threshold = 1
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        super(port, energy)
        @lit = energy.value >= threshold
        if @last_lit != @lit
          # trigger state
          try_callback(@lit ? :on_react_just_lit : :on_react_just_unlit,
                       self, port, energy)
        else
          # held state
          try_callback(@lit ? :on_react_still_lit : :on_react_still_unlit,
                       self, port, energy)
        end
        # absolute state
        try_callback(@lit ? :on_react_lit : :on_react_unlit,
                     self, port, energy)
        emit(OUTPUT_ID, energy)
        @last_lit = @lit
      end

      ##
      # export_h -> Hash
      def export_h
        super.merge(threshold: @threshold, lit: @lit)
      end

      def property_get(k)
        case k.to_s
        when "threshold" then @threshold
        when "lit"       then @lit
        else
          super(k)
        end
      end

      def property_set(k, v)
        case k.to_s
        when "threshold" then @threshold = v.to_i
        when "lit"       then @lit = bool_parse(v)
        else
          super(k, v)
        end
      end

      ### registration
      register('indicator')

    end
  end
end

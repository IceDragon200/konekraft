#
# Sadie/lib/sadie/easy/easy.rb
#   by IceDragon
#   dc 31/05/2013
#   dm 31/05/2013
# vr 1.0.0
module Sadie
  module EasyReaktor

    @@available_shorthand = {}

    ##
    # ::shorthand(Symbol fullname, Symbol hostname)
    def self.shorthand(fullname, shortname)
      name = fullname.to_s
      fullname_c  = fullname.to_s + "_c"
      shortname_c = shortname.to_s + "_c"

      define_method(fullname_c) do
        Sadie::ReaktorBase[name]
      end
      define_method(fullname) do
        send(fullname_c).new
      end
      alias_method(shortname, fullname)
      alias_method(shortname_c, fullname_c)
      @@available_shorthand[shortname] = fullname
    end

    ### reaktor_shorthands
    shorthand :busbar,          :bbr # Busbar
    shorthand :callback,        :cbk # Callback
    shorthand :capacitor,       :cpc # Capacitor
    shorthand :contactor,       :cot # Contactor
    shorthand :counter,         :con # Counter
    shorthand :drain,           :drn # Drain
    shorthand :emitter,         :emt # Emitter
    shorthand :floodgate,       :flg # Floodgate
    shorthand :fuse,            :fus # Fuse
    shorthand :indicator,       :ind # Indicator
    shorthand :multiplex,       :mpx # Multiplex
    shorthand :relay,           :rly # Relay
    shorthand :seven_segment,   :l7s # LED Seven Segment
    shorthand :two_way_switch,  :tws # TwoWaySwitch

    ##
    # easy
    def easy
      yield self
    end

    extend self

  end
end















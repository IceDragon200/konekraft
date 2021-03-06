#
# Konekraft/lib/konekraft/easy/easy.rb
#
module Konekraft
  module EasyKonekt
    ### constants
    VERSION = "2.0.0".freeze

    ### class_variables
    @@available_shorthand = {}

    ##
    # ::shorthand(Symbol fullname, Symbol hostname)
    def self.shorthand(fullname, shortname)
      new_fullname = "new_" + fullname
      new_shortname = "new_" + shortname
      fullname_c  = fullname.to_s + "_c"
      shortname_c = shortname.to_s + "_c"

      define_method(fullname_c) do
        Konekraft::Konekt[name]
      end
      define_method(new_fullname) do
        send(fullname_c).new
      end
      alias_method(new_shortname, new_fullname)
      alias_method(shortname_c, fullname_c)
      @@available_shorthand[shortname] = fullname
    end

    ### konekt_shorthands
    shorthand :busbar,           :bbr # Busbar
    shorthand :capacitor,        :cpc # Capacitor
    shorthand :contactor,        :cot # Contactor
    shorthand :counter,          :con # Counter
    shorthand :drain,            :drn # Drain
    shorthand :emitter,          :emt # Emitter
    shorthand :floodgate,        :flg # Floodgate
    shorthand :fuse,             :fus # Fuse
    shorthand :indicator,        :ind # Indicator
    shorthand :momentary_switch, :mts # Momentary Switch
    shorthand :passive,          :pss # Passive
    shorthand :relay,            :rly # Relay
    shorthand :seven_segment,    :l7s # LED Seven Segment
    shorthand :two_way_switch,   :tws # TwoWaySwitch

    ##
    # easy
    def easy
      yield self
    end

    extend self
  end
end

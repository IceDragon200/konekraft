#
# Sadie/lib/sadie/reaktor/mixin/switch_state2.rb
#   by IceDragon
#   dc 31/05/2013
#   dm 31/05/2013
# vr 1.0.0
module Sadie
  module Reaktor
    module Mixin
      module SwitchState2

        def ss2_def(statename, target=statename)
          @states ||= []
          @states.push(statename)
          vget = "#{target}"
          vset = "#{target}="
          dget = "default_#{target}"
          dset = "default_#{target}="
          ##
          # state_toggle
          define_method("#{statename}_toggle") do
            send(vset, !send(vget))
          end
          ##
          # state_press
          define_method("#{statename}_press") do
            send(vset, !send(dget))
          end
          ##
          # state_depress
          define_method("#{statename}_depress") do
            send(vset, send(dget))
          end
          ##
          # state_nc?
          define_method("#{statename}_nc?") do
            send(dget) == true
          end
          ##
          # state_no?
          define_method("#{statename}_no?") do
            send(dget) == false
          end
          ##
          # state_pressed?
          define_method("#{statename}_pressed?") do
            send(vget) != send(dget)
          end
          ##
          # state_closed?
          define_method("#{statename}_closed?") do
            send(vget) == true
          end
          ##
          # state_open?
          define_method("#{statename}_open?") do
            send(vget) == false
          end
          alias_method("#{statename}_reset", "#{statename}_depress")
        end


      end
    end
  end
end
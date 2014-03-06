#
# Sadie/lib/sadie/reaktor/mixin/reaktorable.rb
#
module Sadie
  module Reaktor2
    module Mixin
      module Reaktorable

        def emit_energy
          Sadie::Reaktor2::Energy.new
        end

        def emit(port_id, energy=emit_energy)
        end

        def react(port_id, energy=emit_energy)
        end

      end
    end
  end
end
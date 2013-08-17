#
# Sadie/lib/sadie/reaktor/mixin/reaktorable.rb
#
module Sadie
  module Reaktor
    module Mixin
      module Reaktorable

        def emit_energy
          Sadie::Reaktor::Energy.new
        end

        def emit(port_id, energy=emit_energy)
        end

        def react(port_id, energy=emit_energy)
        end

      end
    end
  end
end
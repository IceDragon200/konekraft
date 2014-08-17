#
# Konekraft/lib/konekraft/konekt/mixin/konektable.rb
#
module Konekraft
  module Konekt2
    module Mixin
      module Konektable
        def emit_energy
          Konekraft::Konekt2::Energy.new
        end

        def emit(port_id, energy=emit_energy)
        end

        def react(port_id, energy=emit_energy)
        end
      end
    end
  end
end

#
# Sadie/src/reaktors/Emitter.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 20/04/2013
class Sadie::EmitterReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.3".freeze

  # outputs
    OUTPUT_ID = 0x0

  def emit_energy
    @energy.dup
  end

  def trigger
    emit(OUTPUT_ID)
  end

  def setup_ports
    @output[OUTPUT_ID] = nil
  end

  register('emitter')

end

#
# Sadie/src/reaktors/Emitter.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 18/05/2013
class Sadie::EmitterReaktor < Sadie::ReaktorBase

  ### constants
  VERSION = "1.1.0".freeze

  ##
  # Output
  register_output(OUTPUT_ID = 0x0, "output")

  def emit_energy
    @energy.dup
  end

  def trigger
    emit(OUTPUT_ID)
  end

  register('emitter')

end

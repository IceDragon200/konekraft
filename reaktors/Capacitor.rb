#
# Sadie/src/reaktors/Capacitor.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 20/04/2013
class Sadie::CapacitorReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.2".freeze

  # input
    INPUT_ID  = 0x0
  # output
    OUTPUT_ID = 0x0

  int_accessor :charge_pull_min,
               :charge_pull_max,
               :charge_lost,
               :charge_foot,
               :charge_ceil

  def init
    super
    @charge_lost = 1
    @charge_pull_min = 1
    @charge_pull_max = 1
    @charge_foot = 0
    @charge_ceil = 1
  end

  def setup_ports
    @input[INPUT_ID] = nil
    @output[OUTPUT_ID] = nil
  end

  def discharge?(energy)
    energy.value < @charge_pull_min
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      if discharge?(energy)
        @energy.value = (@energy.value -
                         @charge_lost).clamp(@charge_foot, @charge_ceil)
      else
        pull = @energy.calc_pull(energy,
                                 @charge_pull_max,
                                 @charge_pull_min, @charge_ceil)
        @energy.value = (@energy.value + pull).clamp(@charge_foot, @charge_ceil)
        energy.value -= pull
      end
      emit(OUTPUT_ID)
    end
    super(input_id, energy)
  end

  register('capacitor')

end

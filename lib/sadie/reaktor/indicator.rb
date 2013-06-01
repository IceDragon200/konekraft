#
# EDOS/lib/sadie/reaktor/indicator.rb
#   by IceDragon
#   dc 30/05/2013
#   dm 30/05/2013
class Sadie::IndicatorReaktor < Sadie::ReaktorBase

  ### constants
  VERSION = "1.0.0".freeze

  ## input
  register_input(INPUT_ID  = 0x0, "input")

  ## output
  register_input(OUTPUT_ID = 0x0, "output")

  ### instance_variables
  attr_accessor :lit

  ##
  # init
  def init
    super
    @threshold = 1
  end

  ##
  # react(INPUT_ID input_id, Energy energy)
  def react(input_id, energy)
    if connection = @input[input_id]
      @lit = energy.value >= @threshold
      emit(OUTPUT_ID, energy)
      try_callback(@lit ? :on_react_lit : :on_react_not_lit,
                   self, connection, energy)
    end
    super(input_id, energy)
  end

  register('indicator')

end

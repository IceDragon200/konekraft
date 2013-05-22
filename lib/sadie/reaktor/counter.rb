#
# Sadie/src/reaktors/Counter.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 18/05/2013
class Sadie::CounterReaktor < Sadie::ReaktorBase

  ## constants
  VERSION = "1.1.0".freeze

  ##
  # Input
  register_input(INPUT_RESET_ID = 0x0, "resetter")   # resetter
  register_input(INPUT_INC_ID   = 0x1, "adder")      # adder
  register_input(INPUT_DEC_ID   = 0x2, "subtracter") # subtracter

  ##
  # Output
  register_output(OUTPUT_ID     = 0x0, "output") # unused

  attr_accessor :counter # Integer

  def init
    super
    reset
  end

  def reset
    self.counter = 0
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      case connection.input_id
      when INPUT_RESET_ID then reset
      when INPUT_INC_ID   then self.counter += 1
      when INPUT_DEC_ID   then self.counter -= 1
      end
    end
    super(input_id, energy)
  end

  register('counter')

end

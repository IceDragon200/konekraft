#
# Sadie/src/reaktors/Counter.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 20/04/2013
class Sadie::CounterReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.2".freeze

  # input
    INPUT_RESET_ID = 0x0 # resetter
    INPUT_INC_ID   = 0x1 # adder
    INPUT_DEC_ID   = 0x2 # subtracter
  # output
    OUTPUT_ID      = 0x0 # unused

  int_accessor :counter

  def init
    super
    reset
  end

  def reset
    self.counter = 0
  end

  def setup_ports
    @input[INPUT_RESET_ID] = nil
    @input[INPUT_INC_ID] = nil
    @input[INPUT_DEC_ID] = nil
    @output[OUTPUT_ID] = nil
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

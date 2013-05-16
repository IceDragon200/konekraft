#
# Sadie/src/reaktors/CircuitBreaker.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 14/05/2013
class Sadie::CircuitBreakerReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.0".freeze

  # input
    INPUT_ID  = 0x0
  # output
    OUTPUT_ID = 0x0

  int_accessor :threshold
  bool_accessor :broken

  def init
    super
    reset
  end

  def reset
    self.broken = false
  end

  def setup_ports
    @input[INPUT_ID] = nil
    @output[OUTPUT_ID] = nil
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      if !broken
        if energy.value > threshold
          self.broken = true
          try_callback(:on_fuse_break, self, connection, energy)
        else
          emit(OUTPUT_ID, energy)
        end
      else
        try_callback(:on_react_fuse_broken, self, connection, energy)
      end
    end
    super(input_id, energy)
  end

  register('fuse')

end

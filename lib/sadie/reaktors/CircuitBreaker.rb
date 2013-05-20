#
# Sadie/src/reaktors/CircuitBreaker.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 18/05/2013
class Sadie::CircuitBreakerReaktor < Sadie::ReaktorBase

  ## constants
  VERSION = "1.1.0".freeze

  ##
  # Input
  register_input(INPUT_ID   = 0x0, "input")

  ##
  # Output
  register_output(OUTPUT_ID = 0x0, "output")

  attr_accessor :threshold # Integer
  attr_accessor :tripped   # Boolean

  def init
    super
    reset
  end

  def reset
    self.tripped = false
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      if !tripped
        if energy.value > threshold
          self.tripped = true
          try_callback(:on_breaker_trip, self, connection, energy)
        else
          emit(OUTPUT_ID, energy)
        end
      else
        try_callback(:on_react_breaker_tripped, self, connection, energy)
      end
    end
    super(input_id, energy)
  end

  register('circuitbreaker')

end

#
# Sadie/src/reaktors/Fuse.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 18/05/2013
class Sadie::FuseReaktor < Sadie::ReaktorBase

  ### constants
  VERSION = "1.1.0".freeze

  ##
  # Input
  register_input(INPUT_ID   = 0x0, "input")

  ##
  # Output
  register_output(OUTPUT_ID = 0x0, "output")

  attr_accessor :threshold # Integer
  attr_accessor :broken # Boolean

  def init
    super
    reset
  end

  def reset
    self.broken = false
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

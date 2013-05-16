#
# Sadie/src/reaktors/Callback.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 14/05/2013
class Sadie::CallbackReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.3".freeze

  REACT_ID_START = 0x80

  def valid_input?(input_id)
    return true
  end

  def react(input_id, energy)
    if connection = @input_id[input_id]
      try_callback(REACT_ID_START + connection.input_id,
                   self, connection, energy)
    end
    super(input_id, energy)
  end

  register('callback')

end

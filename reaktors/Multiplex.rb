#
# Sadie/src/reaktors/Multiplex.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 20/04/2013
class Sadie::MultiplexReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.2".freeze

  attr_accessor :channel

  def init
    super
    @channel = {}
  end

  def valid_input?(input_id)
    return true
  end

  def valid_output?(output_id)
    return true
  end

  def add_channel(input, *outputs)
    (@channel[input] ||= []).concat(outputs).uniq!
  end

  def set_channels(channel_hash)
    @channel.merge!(channel_hash)
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      output_ids = @channel[connection.input_id]
      output_ids.each { |output_id| emit(output_id, energy) } if output_ids
    end
    super(input_id, energy)
  end

  register('multiplex')

end

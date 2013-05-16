#
# Sadie/src/reaktors/SevenSegment.rb
#   by IceDragon
#   dc 14/04/2013
#   dm 20/04/2013
class Sadie::SevenSegmentReaktor < Sadie::ReaktorBase

  # constants
  VERSION = "1.0.1".freeze

  ##
  # Input
    INPUT_ID_CLEAR_SEGS = 0x0
    INPUT_ID_SEG1       = 0x1
    INPUT_ID_SEG2       = 0x2
    INPUT_ID_SEG3       = 0x3
    INPUT_ID_SEG4       = 0x4
    INPUT_ID_SEG5       = 0x5
    INPUT_ID_SEG6       = 0x6
    INPUT_ID_SEG7       = 0x7

  ##
  # Output
    OUTPUT_ID           = 0x0

  int_accessor :segment_trigger_energy

  def init
    super
    @segments = Array.new(7, false)
    @segment_trigger_energy = 1
  end

  def setup_ports
    @input[INPUT_ID_CLEAR_SEGS] = nil
    @input[INPUT_ID_SEG1]       = nil
    @input[INPUT_ID_SEG2]       = nil
    @input[INPUT_ID_SEG3]       = nil
    @input[INPUT_ID_SEG4]       = nil
    @input[INPUT_ID_SEG5]       = nil
    @input[INPUT_ID_SEG6]       = nil
    @input[INPUT_ID_SEG7]       = nil
    @output[OUTPUT_ID]          = nil
  end

  def react(input_id, energy)
    if connection = @input[input_id]
      case id = connection.input_id
      when INPUT_ID_CLEAR_SEGS
        @segments.fill(false)
      when INPUT_ID_SEG1, INPUT_ID_SEG2, INPUT_ID_SEG3, INPUT_ID_SEG4,
           INPUT_ID_SEG5, INPUT_ID_SEG6, INPUT_ID_SEG7
        @segments[id - 0x1] =
          (energy.cast_value_type(Sadie::Energy::TYPE_POWER) >=
          @segment_trigger_energy)
      end
    end
    try_callback(REACT_ID_START + connection.input_id, self, connection, energy)
    super(input_id, energy)
  end

  register('sevensegment')

end

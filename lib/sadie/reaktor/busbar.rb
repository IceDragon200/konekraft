#
# Sadie/lib/sadie/reaktor/busbar.rb
#   by IceDragon
#   dc 30/05/2013
#   dm 30/05/2013
class Sadie::BusbarReaktor < Sadie::ReaktorBase

  ### constans
  VERSION = "1.0.0".freeze

  ## input
  register_input(INPUT_COMMON_ID = 0x0, "common")

  ## output
  register_output(OUTPUT_FEED1_ID = 0x1, "feed1")
  register_output(OUTPUT_FEED2_ID = 0x2, "feed2")
  register_output(OUTPUT_FEED3_ID = 0x3, "feed3")
  register_output(OUTPUT_FEED4_ID = 0x4, "feed4")
  register_output(OUTPUT_FEED5_ID = 0x5, "feed5")
  register_output(OUTPUT_FEED6_ID = 0x6, "feed6")
  register_output(OUTPUT_FEED7_ID = 0x7, "feed7")
  register_output(OUTPUT_FEED8_ID = 0x8, "feed8")

  ##
  # react(input_id, energy)
  def react(input_id, energy)
    if connection = @input[input_id]
      @output.each_key { |output_id| emit(output_id, energy) }
    end
    super(input_id, energy)
  end

  register('busbar')

end

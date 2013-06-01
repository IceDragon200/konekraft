#
# Sadie/lib/sadie/reaktor/passive.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 31/05/2013
module Sadie
  class PassiveReaktor < Sadie::ReaktorBase

    ### constants
    VERSION = "1.1.0".freeze

    ## inputs
    register_input(INPUT_ID = 0x0, "input")

    ## outputs
    register_output(OUTPUT_ID = 0x0, "output")


    register('callback')

  end
end

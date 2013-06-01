#
# Sadie/src/sadie/easy/reaktor.rb
#   by IceDragon
#   dc 31/05/2013
#   dm 31/05/2013
module Sadie
  class ReaktorBase
    alias :ii :input_id
    alias :oi :output_id

    class << self
      alias :ii :input_id
      alias :oi :output_id
    end
  end
end

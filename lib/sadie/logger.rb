#
# Sadie/lib/sadie/logger.rb
#   by IceDragon (mistdragon100@gmail.com)
#   dc 28/07/2013
#   dm 28/07/2013
module Sadie
  module Logger

    ### instance_variables
    attr_accessor :log # IO

    def try_log
      yield(@log) if @log
    end

  end
end
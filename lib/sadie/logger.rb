#
# Sadie/lib/sadie/logger.rb
#   by IceDragon (mistdragon100@gmail.com)
require 'sadie/version'
module Sadie
  module Logger

    ### instance_variables
    attr_accessor :log # IO

    def try_log
      yield(@log) if @log
    end

  end
  extend Logger
end
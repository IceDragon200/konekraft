#
# Sadie/src/sadie.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 11/03/2013
module Sadie

  VERSION = "1.1.2".freeze

  class SadieError < Exception
  end

  class ReaktorError < SadieError
  end

  class << self
    attr_accessor :log # IO
    def try_log
      yield(@log) if @log
    end
  end

end

require 'sadie/internal'
require 'sadie/reaktors'
require 'sadie/sasm'

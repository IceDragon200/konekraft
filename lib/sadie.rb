#
# Sadie/src/sadie.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 11/03/2013
module Sadie

  VERSION = "1.1.1".freeze

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

dir = File.dirname(__FILE__)
require File.join(dir, 'sadie', 'internal.rb')
require File.join(dir, 'sadie', 'reaktors.rb')
require File.join(dir, 'sadie', 'sasm.rb')

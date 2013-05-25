#
# Sadie/src/sadie.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 23/05/2013
module Sadie

  class SadieError < Exception
  end

  class ReaktorError < SadieError
  end

  class << self

    ## instance_variables
    attr_accessor :log # IO

    def try_log
      yield(@log) if @log
    end

  end

end

require 'sadie/version'
require 'sadie/prototype'
require 'sadie/internal'
require 'sadie/reaktors'
require 'sadie/sasm'

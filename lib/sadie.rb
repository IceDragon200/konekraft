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

end

# remove this when building gem
$:.unshift(Dir.getwd)

require 'sadie/logger'
Sadie.extend(Sadie::Logger)
#Sadie.log = STDERR
require 'sadie/version'
require 'sadie/prototype'
require 'sadie/internal'
require 'sadie/reaktor'
require 'sadie/sasm'
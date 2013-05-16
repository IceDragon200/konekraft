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

end

##
# TEMP
#dir = File.dirname(__FILE__)
#$LOAD_PATH.push("/home/icy/Dropbox/code/Git") # temp
#require 'RGSS3-MACL/MACL.rb'

require_relative 'internal/BitArray.rb'
require_relative 'reaktors.rb'
require_relative 'Energy.rb'
require_relative 'Connection.rb'
# WIP
#require_relative 'wippy/CPU.rb'  # Sadie CPU
#require_relative 'wippy/SASM.rb' # Sadie Assembly Language

__END__

file = <<__EOF__
label: ; :D
  NOP ; No Operation
  ;DOSOMETHING param ; skip this
  ADD A, B ; Add with other register
  ADDI A, 12 ; Add with immediate value
__EOF__

p Sadie::SASM.build(file)

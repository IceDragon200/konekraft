#
# Sadie/lib/sadie/sasm.rb
#   by IceDragon
#   dc 19/05/2013
#   dm 19/05/2013
# WIP
dir = File.dirname(__FILE__)
require File.join(dir, 'sasm', 'SASM') # Sadie Assembly Language
require File.join(dir, 'sasm', 'CPU') # Sadie CPU

__END__

file = <<__EOF__
label: ; :D
  NOP ; No Operation
  ;DOSOMETHING param ; skip this
  ADD A, B ; Add with other register
  ADDI A, 12 ; Add with immediate value
__EOF__

p Sadie::SASM.build(file)

#
# Sadie/src/reaktors.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 21/05/2013
dir = File.dirname(__FILE__)
Dir.glob(File.join(dir, 'reaktors', '*.rb')).each do |fn|
  require fn
end

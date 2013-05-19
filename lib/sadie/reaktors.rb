#
# Sadie/src/reaktors.rb
#   dc 11/03/2013
#   dm 14/04/2013
# vr 1.1.0
dir = File.dirname(__FILE__)
Dir.glob(File.join(dir, 'reaktors', '*.rb')).each do |fn|
  require fn
end

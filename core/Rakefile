#
# Sadie/Rakefile
#
require 'rubygems'
require 'rubygems/package_task'
require 'rake'
require 'rake/clean'
require 'rdoc/task'

spec = Gem::Specification.load('sadie.gemspec')
Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

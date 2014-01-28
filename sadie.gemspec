#
# Sadie/sadie.gemspec
#
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'sadie/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "sadie"
  s.summary     = "Sadie"
  s.description = %q(Reactive component library)
  s.date        = %q(2013-05-21)
  s.version     = Sadie::VERSION
  s.homepage    = %q{https://github.com/IceDragon200/Sadie}
  s.license     = 'MIT'

  s.author = "Corey Powell"
  s.email  = %q{mistdragon100@gmail.com}

  s.add_runtime_dependency 'colorize', '~> 0.6'
  s.add_runtime_dependency 'narray',   '~> 0.6' # NArray is required for Slate::Memory
  s.add_runtime_dependency 'rltk',     '~> 2.2' # RLTK is needed for SASM

  s.require_path = "lib"
  s.test_file = 'test/test-suite.rb'
  s.executables = Dir.glob("bin/*").map { |s| File.basename(s) }
  s.files = ["Rakefile", "LICENSE", "README.md"]
  s.files.concat(Dir.glob("lib/**/*"))
  s.files.concat(Dir.glob("test/**/*.{rb,sasm,rasm}"))
end
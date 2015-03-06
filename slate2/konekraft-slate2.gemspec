#
# Konekraft/konekraft-slate2.gemspec
#
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'konekraft/slate2/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "konekraft-slate2"
  s.summary     = "Konekraft SlateVM V2"
  s.description = %q(Konekraft Slate Virtual Machine library V2)
  s.date        = Time.now.to_date.to_s
  s.version     = Konekraft::Slate2::VERSION
  s.homepage    = %q{https://github.com/IceDragon200/konekraft}
  s.license     = 'MIT'

  s.author = "Corey Powell"
  s.email  = %q{mistdragon100@gmail.com}

  s.add_runtime_dependency 'konekraft-core',  '~> 1.8'
  s.add_runtime_dependency 'konekraft-sasm1', '~> 1.0'
  s.add_runtime_dependency 'colorize', '~> 0.6'

  s.require_path = "lib"
  #s.test_file = 'test/test-suite.rb'
  s.executables = Dir.glob("bin/*").map { |s| File.basename(s) }
  s.files = ["LICENSE", "README.md"]
  s.files.concat(Dir.glob("lib/**/*"))
  s.files.concat(Dir.glob("test/**/*.{rb,sasm,rsasm}"))
  s.files.concat(Dir.glob("spec/**/*.{rb,sasm,rsasm}"))
end

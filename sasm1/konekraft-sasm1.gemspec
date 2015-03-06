#
# Konekraft/konekraft.gemspec
#
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'konekraft/sasm1/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'konekraft-sasm1'
  s.summary     = 'Konekraft SlateAssembly V1'
  s.description = 'Konekraft Slate assembly library V1'
  s.date        = Time.now.to_date.to_s
  s.version     = Konekraft::SlateAssembly1::VERSION
  s.homepage    = 'https://github.com/IceDragon200/konekraft'
  s.license     = 'MIT'

  s.authors = ['Corey Powell']
  s.email  = 'mistdragon100@gmail.com'

  s.add_runtime_dependency 'konekraft-core', '~> 1.8'
  s.add_runtime_dependency 'colorize',       '~> 0.6'

  s.require_path = 'lib'
  #s.test_file = 'test/test-suite.rb'
  s.executables = Dir.glob('bin/*').map { |s| File.basename(s) }
  s.files = ['LICENSE', 'README.md']
  s.files.concat(Dir.glob('lib/**/*.rb'))
  s.files.concat(Dir.glob('test/**/*.{rb,sasm,rsasm}'))
  s.files.concat(Dir.glob('spec/**/*.{rb,sasm,rsasm}'))
end

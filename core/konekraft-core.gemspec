lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'konekraft/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'konekraft-core'
  s.summary     = 'Konekraft Core library'
  s.description = %q(Konekraft common source library)
  s.date        = Time.now.to_date.to_s
  s.version     = Konekraft::VERSION
  s.homepage    = %q{https://github.com/IceDragon200/konekraft}
  s.license     = 'MIT'

  s.author = 'Corey Powell'
  s.email  = %q{mistdragon100@gmail.com}

  s.require_path = 'lib'
  s.test_file = 'test/test-suite.rb'
  s.executables = Dir.glob('bin/*').map { |s| File.basename(s) }
  s.files = ['LICENSE', 'README.md']
  s.files.concat(Dir.glob('lib/**/*.rb'))
  s.files.concat(Dir.glob('test/**/*.{rb,sasm,rsasm}'))
  s.files.concat(Dir.glob('spec/**/*.{rb,sasm,rsasm}'))
end

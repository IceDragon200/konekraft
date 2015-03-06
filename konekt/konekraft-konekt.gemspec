Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'konekraft-konekt'
  s.summary     = 'Konekraft Core library'
  s.description = 'Konekraft common source library'
  s.date        = Time.now.to_date.to_s
  s.version     = '3.0.0'
  s.homepage    = 'https://github.com/IceDragon200/konekraft'
  s.license     = 'MIT'

  s.authors = ['Corey Powell']
  s.email  = 'mistdragon100@gmail.com'

  s.add_runtime_dependency 'konekraft-konekt3', '~> 3.0'

  s.require_path = 'lib'
  #s.test_file = 'test/test-suite.rb'
  s.executables = Dir.glob('bin/*').map { |s| File.basename(s) }
  s.files = ['LICENSE', 'README.md']
  s.files.concat(Dir.glob('lib/**/*.rb'))
  s.files.concat(Dir.glob('test/**/*.{rb,sasm,rsasm}'))
  s.files.concat(Dir.glob('spec/**/*.{rb,sasm,rsasm}'))
end

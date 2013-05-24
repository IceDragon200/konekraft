#
# Sadie/sadie.gemspec
#
PKG_VERSION = "1.2.0"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "sadie"
  s.summary     = "Sadie's Reaktors"
  s.description = %q(Reactive component library)
  s.date        = %q(2013-05-21)
  s.version     = PKG_VERSION
  s.homepage = %q{https://github.com/IceDragon200/Sadie}
  s.license = 'MIT'

  s.author = "Corey Powell"
  s.email = %q{mistdragon100@gmail.com}

  s.require_path = "lib"

  s.files = ["Rakefile", "MIT-LICENSE", "README.md"]
  s.files.concat(Dir.glob( "lib/**/*" ).delete_if { |item| item.include?( "\.svn" ) })
  s.files.concat(Dir.glob( "test/**/*" ).delete_if { |item| item.include?( "\.svn" ) })
end

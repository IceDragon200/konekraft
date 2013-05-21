#
# Sadie/sadie.gemspec
#
Gem::Specification.new do |s|
  s.name               = "sadie"
  s.version            = "1.1.2"
  #s.default_executable = ""

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Corey Powell"]
  s.date = %q(2013-05-21)
  s.description = %q{A kind of circuit simulation library}
  s.email = %q{mistdragon100@gmail.com}
  s.files = ["Rakefile", "lib/sadie/sadie.rb", "lib/sadie/sadie/*"]
  s.test_files = []
  #s.homepage = %q{}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Sadie's Reaktors}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

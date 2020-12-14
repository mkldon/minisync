Gem::Specification.new do |s|
  s.name        = 'minisync'
  s.version     = '0.0.1'
  s.date        = '2020-01-01'
  s.summary     = "Revision tables generator for Rails & PostgreSQL"
  s.description = "some description"
  s.authors     = ["Mikhail Ryanzin"]
  s.email       = "mryanzin@gmail.com"
  s.homepage    = "https://github.com/mkldon/minisync"
  s.files       = ["lib/minisync.rb"]
  s.license       = 'MIT'

  s.add_runtime_dependency "zeitwerk"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "dry-initializer"
end

require './lib/resizer/version'
Gem::Specification.new do |s|
  s.name = "resizer_service"
  s.version = Resizer.version
  s.summary = "Image resizer."
  s.description = "Online image resizer service."
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/rstacruz/resizer_service"
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }

  s.add_dependency "sinatra", "~> 1.2.6"
  s.add_dependency "hashie", "~> 1.0.0"
  s.add_dependency "rack-cache", "~> 1.0.2"

  s.add_development_dependency "para", "~> 0.1.1"
  s.add_development_dependency "fakeweb", "~> 1.3.0"
  s.add_development_dependency "chunky_png", "~> 1.2.0"
  s.add_development_dependency "rack-test", "~> 0.6.0"
end

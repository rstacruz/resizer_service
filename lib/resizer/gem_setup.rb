require 'rubygems'  unless defined?(::Gem)

deps = Gem::Specification.load(Dir['*.gemspec'].first).dependencies
deps = deps.select { |gem| gem.type == :runtime }  if ENV['RACK_ENV'] == 'production'

fails = deps.map { |gem|
    begin
      Gem.activate(gem); nil
    rescue Gem::LoadError => e
      versions = gem.requirement.requirements.map { |req, ver| "-v \"#{req} #{ver}\"" }
      "gem install #{gem.name} #{versions.join(' ')}"
    end
  }.compact

if fails.any?
  commands = fails.map { |s| "  #{s}" }.join("\n")
  raise Gem::LoadError, "Some gems failed to load.\nSome gems could not be loaded. Try:\n\n#{commands}\n\n"
end


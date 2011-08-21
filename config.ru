# Pseudo-Bundler
require 'rubygems'
Gem::Specification.load(Dir['*.gemspec'].first).dependencies.each { |gem| Gem.activate gem  if gem.type == :runtime }

require './lib/resizer'
run Resizer::App

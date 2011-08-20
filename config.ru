# Pseudo-Bundler
require 'rubygems'
Gem::Specification.load(Dir['*.gemspec'].first).dependencies.each { |gem| Gem.activate gem }

require './lib/resizer'
run Resizer::App

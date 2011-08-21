require 'hashie'

module Resizer
  PREFIX = File.expand_path('../../', __FILE__)

  autoload :ImageConverter, "#{PREFIX}/lib/resizer/image_converter"
  autoload :App,            "#{PREFIX}/lib/resizer/app"

  def self.root(*a)
    File.join PREFIX, *a
  end

  def self.config
    @config ||= begin
      require 'yaml'
      file = root('config/resizer.yml')

      config = Hashie::Mash.new YAML::load_file(root('config/resizer.yml.example'))
      config.merge! YAML::load_file(file)  if File.file?(file)
      config
    end
  end

  def self.config?
    ! config.empty?
  end

  def self.imagemagick?
    `convert --version` rescue false
  end

  require "#{PREFIX}/lib/resizer/version"
end

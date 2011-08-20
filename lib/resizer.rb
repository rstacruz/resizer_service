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

      h = if File.file?(file)
        YAML::load_file(file)
      else
        Hash.new
      end

      Hashie::Mash.new h
    end
  end

  def self.config?
    ! config.empty?
  end

  require "#{PREFIX}/lib/resizer/version"
end

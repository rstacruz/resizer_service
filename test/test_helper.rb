require 'rubygems'
Gem::Specification.load(Dir[File.expand_path('../../*.gemspec', __FILE__)].first).dependencies.each { |gem| Gem.activate gem }

require File.expand_path('../../lib/resizer', __FILE__)
require 'contest'
require 'renvy'
require 'fakeweb'
require 'fileutils'
require 'chunky_png'

class UnitTest < Test::Unit::TestCase
  URL = "http://example.org/image.jpg"

  def fx(*a)
    File.join File.expand_path('../', __FILE__), 'fixtures', *a
  end

  def identify(filename)
    output = `identify "#{filename}"`.force_encoding('utf-8')
    _, type, size = output.split(' ')

    { :type => type,
      :size => size }
  end

  setup do
    FakeWeb.register_uri :get, URL, :body => File.read(fx('image.jpg'))
  end

  teardown do
    FileUtils.rm_rf Resizer::ImageConverter.images_root
  end
end

# Stub
module Resizer
  class ImageConverter
    def self.images_root(*a)
      @temp ||= "resizer-#{Time.now.to_i}"
      path = "/tmp/#{@temp}"

      FileUtils.mkdir_p path
      File.join path, *a
    end
  end
end

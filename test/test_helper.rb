require File.expand_path('../../lib/resizer/gem_setup', __FILE__)
require File.expand_path('../../lib/resizer', __FILE__)
require 'para'
require 'fakeweb'
require 'fileutils'
require 'chunky_png'
require 'rack/test'

class UnitTest < Para::Test
  URL = "http://example.org/image.jpg"
  include Rack::Test::Methods

  def app
    Resizer::App
  end

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
end

# Stub
module Resizer
  class ImageConverter
    def self.images_root(*a)
      @temp ||= begin
        $temppath = "/tmp/resizer-#{Time.now.to_i}"
        at_exit { FileUtils.rm_rf $temppath }
        $temppath
     end

      FileUtils.mkdir_p @temp
      File.join @temp, *a
    end
  end
end

class Para::Should
  def the_same_png_as(right)
    one = ChunkyPNG::Image.from_file left
    two = ChunkyPNG::Image.from_file right

    one.pixels.join('-').should.blaming("Images #{left} and #{right} are not the same.") == two.pixels.join('-')
  end
end

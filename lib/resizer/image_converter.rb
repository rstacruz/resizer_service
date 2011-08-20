module Resizer
  class ImageConverter
    COMMAND = "convert -size '%s' '%s' -resize '%s' -background black -compose copy -gravity center -extent '%s' -quality 80 '%s'"

    # Works. Returns the URL.
    def self.work(source, dim, format='jpg')
      i = new(source, dim, format)
      i.convert!
      i.url
    end

    def self.cleanup!
      FileUtils.rm_rf Main.root("public/images/original")
    end

    attr_reader :url
    attr_reader :original    # Full path to original image
    attr_reader :filename    # Full path to resized image
    attr_reader :source      # http://example.com/image.jpg

    def initialize(source, dim, format='jpg')
      @source   = source
      @dim      = dim
      @format   = format
      @base     = "#{dim}/#{slugify(source.to_s)}.#{@format}"
      @url      = "/images/#{@base}"
      @original = root("public", "images/original/#{slugify(source)}")
      @filename = root("public", url)

      mkdir
    end

    def mkdir
      FileUtils.mkdir_p File.dirname(@original)
      FileUtils.mkdir_p File.dirname(@filename)
    end

    # Download and write to disk
    def download!
      return @original  if File.exists?(@filename)

      # Download
      require 'open-uri'
      temp = open(@source)
      temp.close

      FileUtils.mv temp.path, @original

      @original
    end

    def convert!
      return  if File.exists?(@filename)

      system sprintf(COMMAND, @dim, download!, "#{@dim}^", @dim, @filename)

      @filename
    end

  private
    def slugify(str)
      str.scan(/[A-Za-z0-9\-_\.]+/).join('-')
    end

    def root(*a)
      Resizer.root *a
    end
  end
end

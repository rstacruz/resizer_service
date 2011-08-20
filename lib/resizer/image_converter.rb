module Resizer
  class ImageConverter
    EXTENT  = "-background black -compose copy -gravity center -extent '%s'"
    COMMAND = "convert -size '%s' '%s' -resize '%s' %s -quality %s '%s'"

    # Works. Returns the URL.
    def self.work(source, dim, format='jpg', quality=80)
      i = new(source, dim, format, quality)
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

    def initialize(source, dim, format='jpg', quality=80)
      @source   = source
      @dim      = dim
      @format   = format
      @quality  = 80
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
      return @original  if File.exists?(@original)

      # Download
      require 'open-uri'
      temp = open(@source)
      temp.close

      FileUtils.mv temp.path, @original

      @original
    end

    def convert!
      return  if File.exists?(@filename)

      if @dim =~ /^[0-9]+x[0-9]+$/
        # If given fixed dimensions, crop it
        extent = sprintf(EXTENT, @dim)
        dim    = "#{@dim}^"
      else
        # Otherwise, there's no need
        extent = ''
        dim    = @dim
      end

      system sprintf(COMMAND, @dim, download!, dim, extent, @quality, @filename)

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

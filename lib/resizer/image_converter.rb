module Resizer
  class ImageConverter
    EXTENT  = "-background black -compose copy -gravity center -extent '%s'"
    COMMAND = "convert -size '%s' '%s' -resize '%s' %s -quality %s '%s'"

    # Works. Returns the URL.
    def self.work(options={})
      i = new(options)
      i.convert!
      i.url
    end

    def self.images_root(*a)
      File.join Main.root("public/images"), *a
    end

    def self.cleanup!
      FileUtils.rm_rf images_root("original")
    end

    attr_reader :url
    attr_reader :original    # Full path to original image
    attr_reader :filename    # Full path to resized image
    attr_reader :source      # http://example.com/image.jpg
    attr_reader :options

    def initialize(options={})
      @options  = options
      @source   = options[:source]
      @dim      = options[:resize]
      @format   = options[:format] || 'jpg'
      @quality  = options[:quality] || 80
      @base     = "#{@dim}/#{slugify(@source.to_s)}.#{@format}"
      @url      = "/images/#{@base}"
      @original = self.class.images_root("original/#{slugify(source)}")
      @filename = self.class.images_root(@base)

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
      extras = Array.new

      if fixed_dimensions?
        extras << sprintf(EXTENT, @dim)  # Crop it
        dim     = "#{@dim}^"
      else
        dim     = @dim
      end

      extras << '-flip' if options[:vflip]
      extras << '-flop' if options[:hflip]
      extras << "-rotate #{options[:rotate].to_i}" if options[:rotate]

      system sprintf(COMMAND, @dim, download!, dim, extras.join(' '), @quality, @filename)

      @filename
    end

  private
    def fixed_dimensions?
      @dim =~ /^[0-9]+x[0-9]+$/
    end

    def slugify(str)
      str.scan(/[A-Za-z0-9\-_\.]+/).join('-')
    end

    def root(*a)
      Resizer.root *a
    end
  end
end

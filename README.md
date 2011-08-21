# Image resizer service
#### A small image resizing proxy app

Start me like you would any Rack app.

    $ rackup

Now request for an image this way:

    http://localhost:3000/image?resize=200x200&source=http://example.org/image.png

..and the resizer service will grab your image and resize it for you.

## Available parameters

These parameters have to be passed onto `/image` as GET parameters.

* __source__   
  (Required) The URL of the image to process.

* __resize__  
  (Required) Resizes the image in `WIDTHxHEIGHT` format. Both width and height are
  optional, but at least one has to be defined. Examples:

  * `500x200`
  * `500x`
  * `x40`

* __format__  
  The image format you need it in. Can be any of the following:

  * `png`
  * `jpg`
  * `gif`

* __quality__  
  The JPEG quality level (defaults to 80). Has to be a number between `0` and `100`.

## Examples

This resizes to *200px* width as a *JPEG* with *30%* quality.

    http://localhost:3000/image?resize=200x&source=http://example.org/image.png&format=jpg&quality=30

## Sinatra/Rails usage

Here! Use this helper:

``` ruby
# Place this somewhere in your initializers
ENV['RESIZER_URL'] ||= "http://image.resizer.org/image"

# These are the helpers
# (Adapt to your favorite web framework as needed)
helpers {
  def get_params(hash)
    hash.map { |k, v| "#{Rack::Utils.escape k}=#{Rack::Utils.escape v}" }.join("&")
  end

  def img_url(url, options={})
    options[:source] = url
    "#{ENV['RESIZER_URL']}?#{get_params(options)}"
  end
}
```

## Acknowledgements

Inspired by http://boxresizer.com/, which this is (mostly) compatible with.

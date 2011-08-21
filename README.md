# Image resizer service
#### A small image resizing proxy app

## Requirements

* __ImageMagick__
  - OSX/Homebrew: `brew install imagemagick`
  - Ubuntu: `sudo apt-get install imagemagick`

* __Ruby__ 1.8+
  - OSX: You already have it
  - Ubuntu: `sudo apt-get install ruby19`

* Some Ruby gems
  - (The app will alert you when you have missing Ruby gems.)

## Usage

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

### Optional parameters

* __format__  
  The image format you need it in. Can be any of the following:

  * `png`
  * `jpg`
  * `gif`

* __quality__  
  The JPEG quality level (defaults to 80). Has to be a number between `0` and `100`.

* __rotate__  
  (Integer) The number of degrees to rotate the image in.

* __vflip__  
  When set to `1`, flips the image vertically.

* __hflip__  
  When set to `1`, flips the image horizontally.

## Examples

This resizes to *200px* width as a *JPEG* with *30%* quality.

    http://localhost:3000/image?resize=200x&source=http://example.org/image.png&format=jpg&quality=30

## Acknowledgements

Inspired by http://boxresizer.com/, which this is (mostly) compatible with.

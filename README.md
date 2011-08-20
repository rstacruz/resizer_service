# Image resizer service
#### A small image resizing proxy app

Start me like you would any Rack app.

    $ rackup

Now request for an image this way:

    http://localhost:3000/image?resize=200x200&source=http://example.org/image.png

Parameters:

 * `source=URL` to define where the (required)
 * `resize=WIDTHxHEIGHT` to specify the dimensions you need. You may also use:
   - `resize=WIDTHx` (eg, *200x*) to resize to a specific width, but dynamic height, or
   - `resize=xHEIGHT` (eg, *x50*) for a dynamic width
 * `format=X` to specify what image format you need it in (*png, jpg, gif*)
 * `quality=N` to specify the JPEG quality level (0..100)

### Acknowledgements

Inspired by http://boxresizer.com/, which this is (mostly) compatible with.

# Image resizer service
#### A small image resizing proxy app

Start me like you would any Rack app.

    $ rackup

Now request for an image this way:

    http://localhost:3000/image.jpg?resize=200x200&source=http://example.org/image.png

Parameters:

 * `source=URL` to define where the (required)
 * `resize=WIDTHxHEIGHT` to specify the dimensions you need
 * `format=X` to specify what image format you need it in (*png, jpg, gif*)

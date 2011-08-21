require File.expand_path('../test_helper', __FILE__)

class ResizerTest < UnitTest
  def resize!(options={})
    @image = Resizer::ImageConverter.new options
    @image.convert!
  end

  def info
    identify(@image.filename)
  end

  test "original" do
    resize! :source => URL, :resize => "50x50"
    File.read(@image.original).should == File.read(fx('image.jpg'))
  end

  test "#url" do
    resize! :source => URL, :resize => "50x50"
    @image.url.should == "/images/50x50/http-example.org-image.jpg.jpg"
  end

  test "format default" do
    resize! :source => URL, :resize => "50x50"
    info[:type].should == "JPEG"
  end

  test "format=png" do
    resize! :source => URL, :resize => "50x50", :format => "png"

    info[:type].should == "PNG"
  end

  test "width resize" do
    resize! :source => URL, :resize => "100x", :format => "png"

    info[:size].should == "100x65"
  end

  test "height resize" do
    resize! :source => URL, :resize => "x100", :format => "png"

    info[:size].should == "154x100"
  end

  test "flip" do
    resize! :source => URL, :resize => "50x50", :format => "png", :vflip => 1

    @image.filename.should.be.the_same_png_as fx('flip50.png')
  end

  test "flop" do
    resize! :source => URL, :resize => "50x50", :format => "png", :hflip => 1

    @image.filename.should.be.the_same_png_as fx('flop50.png')
  end
end

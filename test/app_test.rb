require File.expand_path('../test_helper', __FILE__)

class AppTest < UnitTest
  test "/image with just source" do
    get "/image?source=#{URL}"
    last_response.status.should == 400
  end

  test "/image with nothing" do
    get "/image"
    last_response.status.should == 400
  end

  test "/image with invalid format" do
    get "/image?source=#{URL}&resize=50x50&format=bmp"
    last_response.status.should == 400
  end

  test "ok" do
    get "/image?source=#{URL}&resize=50x50&format=png"
    last_response.status.should == 302
    last_response.header["Location"].should == "http://example.org/images/50x50/http-example.org-image.jpg.png"

    fn = Resizer::ImageConverter.images_root('50x50/http-example.org-image.jpg.png')
    File.file?(fn).should == true
    identify(fn)[:size].should == '50x50'
  end
end

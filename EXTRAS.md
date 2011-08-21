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


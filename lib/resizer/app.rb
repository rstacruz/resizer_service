require 'sinatra/base'
require 'hashie'

unless Resizer.imagemagick?
  $stderr.write "Error: ImageMagick not found.\nYou need ImageMagick to run this app.\n"
  exit 256
end

module Resizer
  class App < Sinatra::Base
    set :public, Resizer.root('public')

    get '/image' do
      return 403  unless allowed?

      url     = params[:source]
      dim     = params[:resize]  # 50x50
      format  = params[:format]
      quality = params[:quality]

      return 400 unless url && dim

      begin
        url = ImageConverter.work(url, dim, format, quality)
        redirect url
      rescue Errno::ENOENT => e
        404
      end
    end

    helpers do
      def allowed?
        return true  unless Resizer.config?

        config = Resizer.config

        if config.allow_any_referrer
          true
        elsif request.referrer.nil?
          true  if config.allow_no_referrer
        else
          config.referrer_whitelist.any? { |domain| request.referrer.include?(domain) }
        end
      end
    end
  end
end

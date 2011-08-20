require 'sinatra/base'
require 'hashie'

module Resizer
  class App < Sinatra::Base
    set :public, Resizer.root('public')

    get '/image' do
      pass  unless allowed?

      url = params[:source]
      dim = params[:resize]  # 50x50
      format = params[:format]

      url = ImageConverter.work(url, dim, format)
      redirect url
    end

    helpers do
      def allowed?
        if Resizer.config?
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
end

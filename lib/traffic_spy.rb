Bundler.require

require 'sinatra'
require 'sinatra/base'
require './lib/traffic_spy/models/client'

module TrafficSpy
  class Server < Sinatra::Base

    get '/' do
      erb :error
    end

    post '/sources' do
      # client will submit a post to http://ourapplication:port/sources
      client = Client.new(:identifier => params["identifier"],
                          :rooturl => params["rootUrl"])

      if client.missing?
        status 400
      elsif Client.exist?(params[:identifier])
        status 403
      elsif client.save
        status 200
      end
    end

  end
end

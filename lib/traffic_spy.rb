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
                          :rooturl => params["rooturl"])
      # Send user descriptive error messages if param(s) is missing or if
      # if param(s) are missing then redirect to error message
      if client.save
        status 200
      else
        status 400
      end
    end

  end
end

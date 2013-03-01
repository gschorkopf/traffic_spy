Bundler.require

require 'sinatra'
require 'sinatra/base'
require './lib/traffic_spy/models/client'

module TrafficSpy
  class Server < Sinatra::Base

    get '/' do
      erb :error
    end

    # get '/sources' do 
    # end

    post '/sources' do
      client = Client.new(identifier: params["identifier"],
                          rooturl: params["rootUrl"])

      if client.missing?
        status 400
      # elsif Client.exists?(client)
      #   status 403
      else
        status 200
        client.save
      end
    end

  end
end

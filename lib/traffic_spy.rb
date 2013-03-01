Bundler.require

require 'sinatra'
require 'sinatra/base'
require './lib/traffic_spy/models/client'
require './lib/traffic_spy/models/payload'

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
      elsif Client.exists?(client)
        status 403
      else 
        client.save
        status 200
      end
    end

    post '/sources/:identifier/data' do
      # client_id = FIND ID associated with params[:identifier]

      # payload = Payload.new()

      # if payload is missing
      #   status 400
      # elsif payload has already been received
      #   status 403
      # else 
      #   status 200
      # end
    end

  end
end

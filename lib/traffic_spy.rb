Bundler.require

require 'sinatra'
require 'sinatra/base'
require 'sequel'
require 'sqlite3'
require 'json'
require './lib/traffic_spy/models/client'
require './lib/traffic_spy/models/payload'
# require 'digest'

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
        "{\"400 Bad Request\":\"missing identifer or rootUrl\"}"
      elsif Client.exists?(client)
        status 403
        "{\"403 Forbidden\":\"identifier already exists\"}"
      else
        client.save
        status 200
        "{\"identifier\":\"jumpstartlab\"}"
      end
    end

    post '/sources/:identifier/data' do


      client_id = Client.data.where(identifier: params[:identifier]).to_a.first[:id].inspect

      # MD5 stuff here
      hash = JSON.parse(params["payload"])
      payload = Payload.new(url: hash["url"],
                          client_id: client_id.to_i,
                          requestedAt: hash["requestedAt"])

      if payload.empty?
        status 400
      elsif Payload.exists?(payload)
        status 403
      else
        payload.commit
        status 200
      end

      # Entry looks like:
      # curl -i -d 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700"}'  http://localhost:9393/sources/jumpstartlab/data
    end

  end
end

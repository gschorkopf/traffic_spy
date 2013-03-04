Bundler.require
require './lib/traffic_spy/models/init'

module TrafficSpy
  class Server < Sinatra::Base

    get '/' do
      erb :error
    end

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

      # Entry looks like:
      # curl -i -d 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'  http://localhost:9393/sources
    end

    post '/sources/:identifier/data' do

      hash = JSON.parse(params["payload"])
      client_id = Client.data.where(identifier: params[:identifier]).to_a.first[:id]
      payload = Payload.new(hash, client_id)

      if payload.empty?
        status 400
        "{\"400 Bad Request\":\"payload missing\"}"
      elsif Payload.exists?(payload)
        status 403
        "{\"403 Forbidden\":\"payload already received\"}"
      else
        payload.commit
        status 200
        "{\"200 Success\":\"unique payload confirmed\"}"
      end

      # Entry looks like:
      # curl -i -d 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700"}'  http://localhost:9393/sources/jumpstartlab/data
    end

    get '/sources/:identifier' do
      # get client id from identifier
      # find all payloads where clinet_id == client id
      # count and store urls associated with client_id
      source_idents = Client.data.where(identifier: params[:identifier])
      client_id = Client.data.where(identifier: params[:identifier]).to_a.first[:id]
      payloads_to_use = Payload.find_all_by_client_id(client_id)

      if Client.data.where(identifier: params[:identifier]).to_a.count == 0
        status 400
        "{\"400 Bad Request\":\"the identifier does not exist\"}"
        erb :error
      else
        client_id = Client.data.where(identifier: params[:identifier]).to_a.first[:id]
        payloads_to_use = Payload.find_all_by_client_id(client_id)
        @urls = Payload.url_sorter(payloads_to_use)
        # @urls = source_idents.select(:rooturl).to_a
        @browsers = Payload.data.select(:user_agent).to_a
        @opp_systems = Payload.os_sorter(payloads_to_use)
        @screen_rezs = Payload.rez_sorter(payloads_to_use)
        @response_times = Payload.rt_sorter(payloads_to_use)
        # @url_spec_data =
        # @agg_event_data =
        erb :data
      end

    end

  end
end

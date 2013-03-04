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

      @source = Client.data.where(identifier: params[:identifier]).to_a.first[:identifier]
      # raise @source.inspect

      # if @source.count == 0
      #   status 400
      #   erb :error
      # else
        client_id = Client.data.where(identifier: params[:identifier]).to_a.first[:id]
        @rooturl = Client.data.where(identifier: params[:identifier]).to_a.first[:rooturl]
        payloads_to_use = Payload.find_all_by_client_id(client_id)
        @urls = Payload.url_sorter(payloads_to_use)
        @paths = @urls.collect do |url|
          Payload.get_path(url.first, @rooturl)
        end

        @browsers = Payload.browser_sorter(payloads_to_use)
        @opp_systems = Payload.os_sorter(payloads_to_use)
        @screen_rezs = Payload.rez_sorter(payloads_to_use)
        @response_times = Payload.avg_response_times(payloads_to_use)
        @url_spec_metrics = Payload.url_sorter(payloads_to_use).to_a
        # @agg_event_data =

        erb :app_details_index
      # end

    end

  get "/sources/:identifier/urls/:path" do
    @identifier = params[:identifier]
    @relative_path = params[:path]
    # raise @path.inspect

    @source = Client.data.where(identifier: @identifier).to_a[0]
    # raise @source.inspect

    # @rooturl = @source[:rooturl]
    # raise @rooturl.inspect

    # @relative_path = @path.gsub(@rooturl, '')
    # raise @relative_path.inspect

    # if @source.count == 0 && @relative_path.count == 0
    #   status 400
    #   "{\"message\":\"No url for identifier.\"}"

    # LOOKUP IN PAYLOADS TABLE FOR PATH RESPONSE TIMES
    # else
      payloads_to_use = Payload.find_all_by_path(params[:path])
      @response_times = Payload.response_times_for_path(payloads_to_use)
      erb :url_stats
    # end
  end

    # get "/sources/:identifier/:events" do

    # if #no events have been defined
    #   status 400
    #   "{\"message\":\"No events have been defined.\"}"
    # else
    #   payloads_to_use = Payload.find_all_by_path(path)
    #   @response_times = Payload.response_times_for_path(payloads_to_use)
    #   erb :app_events_index
    # end

  end
end

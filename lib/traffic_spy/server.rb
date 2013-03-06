module TrafficSpy
  class Server < Sinatra::Base
    set :views, 'lib/traffic_spy/views'

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
        # Client.create(params[:identifier] params[:rooturl])
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
      # Client.find_by_identifier
      payload = Payload.new(hash, client_id)

      if hash == {} || hash == "" || hash == []
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
    end

    get '/sources/:identifier' do
      # @client = Client.find_by_identifier(params[:identifier])
      @source = Client.data.where(identifier: params[:identifier]).to_a.first[:identifier]
      # raise @source.inspect

      if @source == ""
        erb :error_400
      else
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
        erb :app_details_index

      end

    end

    get "/sources/:identifier/urls/:path" do
      @identifier = params[:identifier]
      @relative_path = params[:path]
      @source = Client.data.where(identifier: @identifier).to_a[0]

      if @source == nil || @relative_path == nil
        erb :error
      else
        path = "/#{@relative_path}"
        payloads_to_use = Payload.find_all_by_path(path)
        @response_times = Payload.response_times_for_path(payloads_to_use)

        erb :url_stats
      end
    end

    get "/sources/:identifier/events" do
      @identifier = params[:identifier]

      client_id = Client.data.where(identifier: params[:identifier]).to_a.first[:id]
      events = Event.find_all_by_client_id(client_id).inspect

# if event has not been defined, message no events have been defined
      if  events.count == 0
        "{\"message\":\"No events have been defined.\"}"
        erb :error
      else
        @events = Event.most_events_sorter
        erb :app_events_index
      end
    end

    get "/sources/:identifier/events/:name" do
      @identifier = params[:identifier]
      @name = params[:name]
      @event = Event.data.where(name: @name).to_a

      if @event.count == 0
        "{\"message\":\"No events have been defined.\"}"
      else
        @hourly_events = Event.hourly_events_sorter(@event.first[:id])
        erb :event_stats

      end
    end

  end
end

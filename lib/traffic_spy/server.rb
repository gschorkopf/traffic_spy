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
        "{ \"400 Bad Request\":\"missing identifer or rootUrl\" }"
      elsif Client.exists?(client)
        status 403
        "{ \"403 Forbidden\":\"identifier already exists\" }"
      else
        client.save
        halt 200, "identifier: #{params["identifier"]}, "+
                  "rooturl: #{params["rootUrl"]}"
      end
    end

    post '/sources/:identifier/data' do
      if params["payload"] == nil
        halt 400, "missing payload"
      elsif Payload.exists? JSON.parse(params["payload"])
        status 403
      else
        hash = JSON.parse(params["payload"])
        client = Client.find_by_identifier(params[:identifier])
        client_id = client[:id]
        payload = Payload.new(hash, client_id)
        payload.commit
        status 200
      end
    end

    get '/sources/:identifier' do
      @identifier = params[:identifier]
      @source = Client.data.where(identifier: @identifier).to_a.first

      if @source.nil?
        status 404
        erb :error_404
      else
        client = Client.data.where(identifier: params[:identifier])
        client_id = client.to_a.first[:id]
        @rooturl = client.to_a.first[:rooturl]
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

    get "/sources/:identifier/urls/*" do
      @identifier = params[:identifier]
      @path = "/" + params[:splat].first.to_s

      payloads = Payload.find_all_by_path(@path).to_a.first

      @source = Client.find_by_identifier(params[:identifier])

      if @source.nil? || payloads.nil?
        status 404
        erb :error
      else
        payloads_to_use = Payload.find_all_by_path(@path)
        @response_times = Payload.response_times_for_path(payloads_to_use)
        erb :url_stats
      end
    end

    get "/sources/:identifier/events" do
      @identifier = params[:identifier]
      @source = Client.find_by_identifier(params[:identifier])
      assoc_client = Client.find_by_identifier(@identifier)

      if assoc_client.nil? || @source.nil?
        erb :error
      else
        client_id = assoc_client[:id]
        events_to_use = Payload.find_all_by_client_id(client_id).to_a
        if events_to_use.to_a.count == 0
          "{\"message\":\"No events have been defined.\"}"
          erb :error
        else
          @events = Event.most_events_sorter(events_to_use)
          erb :app_events_index
        end
      end
    end

    get "/sources/:identifier/events/:name" do
      @identifier = params[:identifier]
      @source = Client.data.where(identifier: @identifier).to_a
      @name = params[:name]
      @event = Event.data.where(name: @name).to_a

      if @event.count == 0
        erb :error_with_event_index
      else
        @hourly_events = Event.hourly_events_sorter(@event.first[:id])
        erb :event_stats

      end
    end

    post "/sources/:identifier/campaigns" do
      identifier = params[:identifier]
      hash = {"campaignName" => params["campaignName"],
              "eventNames" => params["eventNames"]}
      campaign = Campaign.new(identifier, hash)

      if campaign.missing?
        status 400
        "{\"400 Bad Request\":\"params missing\"}"
      elsif Campaign.exists?(params['campaignName'])
        status 403
        "{\"403 Forbidden\":\"campaign name exists\"}"
      else
        campaign.register
        status 200
        "{\"campaign\":\"registered\"}"
      end
    end

    get "/sources/:identifier/campaigns" do
      @identifier = params[:identifier]
      client_count = Client.data.where(identifier: @identifier).to_a.count
      campaign_count = Campaign.find_all_by_identifier(@identifier).count
      if client_count == 0 || campaign_count == 0
        erb :error
      else
        @campaigns = Campaign.find_all_by_identifier(@identifier)
        erb :app_campaigns_index
      end
    end

    get "/sources/:identifier/campaigns/:campaignname" do
      @identifier = params[:identifier]
      @name = params[:campaignname]
      client_count = Client.data.where(identifier: @identifier).count

      unless Campaign.exists?(@name) && client_count > 0
         erb :error_with_campaign_index
      else
        @events = Campaign.campaign_event_sorter(@name)
        erb :campaigns
      end
    end

  end
end

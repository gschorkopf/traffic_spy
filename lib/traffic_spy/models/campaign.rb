module TrafficSpy
  class Campaign
    def self.find_or_create(name, event_names)
      # For traffic_spy.rb, put Campaign.find_or_create(params(campaignName), params(eventNames))
      Campaign.register(name)
      Event.loop_register(event_names) #array of event ids
      # Campaign.find_by_name(name)[:id] <-campaign id
    end

    def self.find_by_name(name)
      Campaign.data.where(name: name).to_a[0]
    end

    def self.exists?(name)
      Campaign.find_by_name(name).to_a.count > 0
    end

    def self.register(name)
      Campaign.data.insert(name: name)
    end

    def self.data
      DB.from(:campaigns)
    end

  end
end
module TrafficSpy
  class Campaign
    def self.switchboard(name, event_names)
      # For traffic_spy.rb, put Campaign.switchboard(params(campaignName), params(eventNames))
      Campaign.register(name)
      Event.loop_register(event_names) #array of event ids
      # Campaign.find_by_campaign(name)[:id] <-campaign id
    end

    def self.find_by_campaign(name)
      Campaign.data.where(name: name).to_a[0]
    end

    def self.exists?(name)
      Campaign.find_by_campaign(name).to_a.count > 0
    end

    def self.register(name)
      Campaign.data.insert(name: name)
    end

    def self.create_table
      Client.database.create_table? :campaigns do
        primary_key :id
        String      :name
      end
    end

    def self.data
      verify_table_exists
      Client.database.from(:campaigns)
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end

  end
end
module TrafficSpy
  class CampaignEvent


    def self.create_table
      Client.database.create_table? :campaign_events do
        primary_key :id
        String      :name
      end
    end

    def self.register(name)
      Campaign.data.insert(name: name)
    end

    def self.data
      verify_table_exists
      Client.database.from(:campaign_events)
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end


  end
end
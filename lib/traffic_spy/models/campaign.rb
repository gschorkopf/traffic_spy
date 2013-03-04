module TrafficSpy
  class Campaign
    def self.switchboard(name, event_names)
      if Campaign.exists?(name)
        Campaign.find_by_campaign(name)[:id]
      else
        Campaign.register(name, event_names)
        Campaign.find_by_campaign(name)[:id]
      end
    end

    def self.find_by_campaign(name)
      Campaign.data.where(name: name).to_a[0]
    end

    def self.exists?(name)
      Campaign.find_by_campaign(name).to_a.count > 0
    end

    def self.create_table
      Client.database.create_table? :campaigns do
        primary_key :id
        String      :name
        String      :event_names
      end
    end

    def self.data
      verify_table_exists
      Client.database.from(:campaigns)
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end

    def self.register(name, event_names)
      Campaign.data.insert(
        :name => name, 
        :event_names => event_names
        )
    end

  end
end
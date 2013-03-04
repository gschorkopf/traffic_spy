module TrafficSpy
  class Campaign

    def self.switchboard(name)
      # if Campaign.exists?(name)
      #   Campaign.find_by_campaign(name)[:id]
      # else
      #   Campaign.register(name)
      #   Campaign.find_by_campaign(name)[:id]
      # end
    end

    def self.create_table
      Client.database.create_table? :campaigns do
        primary_key :id
        String      :name
        # DateTime    :created_at
      end
    end

  end
end
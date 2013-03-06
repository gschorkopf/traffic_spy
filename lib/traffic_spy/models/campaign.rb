module TrafficSpy
  class Campaign
    attr_accessor :name, :identifier, :event_names

    def initialize(identifier, params)
      @name         = params['campaignName']
      @event_names  = params['eventNames']
      @identifier   = identifier
    end

    def self.find_by_name(name)
      Campaign.data.where(name: name).to_a[0]
    end

    def self.exists?(name)
      Campaign.find_by_name(name).to_a.count > 0
    end

    def register
      Campaign.data.insert(
        name:       name,
        identifier: identifier
        )
    end

    def self.data
      DB.from(:campaigns)
    end

  end
end
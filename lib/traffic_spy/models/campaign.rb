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

    def self.find_all_by_identifier(identifier)
      data.where(identifier: identifier).to_a
    end

    def missing?
      self.event_names == "" || self.event_names.nil? ||
      self.name == "" || self.name.nil?
    end

    def self.exists?(name)
      Campaign.find_by_name(name).to_a.count > 0
    end

    def register
      event_ids = Event.loop_register(event_names)
      id = Campaign.data.insert(name: name,
                                identifier: identifier)

      CampaignEvent.loop_register(identifier, id, event_ids)
    end

    def self.data
      DB.from(:campaigns)
    end

    def self.campaign_event_sorter(name)
      id = Campaign.find_by_name(name)[:id].inspect
      ces = CampaignEvent.find_all_by_campaign_id(id)
      hash = Hash.new(0)
      ces.collect {|ces| ces[:event_id]}.each do |event_id|
        Payload.find_all_by_event_id(event_id).to_a.each do |payload|
          hash[Event.find_by_id(payload[:event_id])] += 1
        end
      end
      hash
    end

  end
end
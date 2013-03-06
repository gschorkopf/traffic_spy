module TrafficSpy
  class CampaignEvent
    attr_accessor :identifier, :campaign_id, :event_id

    def initialize(identifier, campaign_id, event_id)
      @identifier   = identifier
      @campaign_id  = campaign_id
      @event_id     = event_id
    end

    def self.loop_register(identifier, campaign_id, event_ids)
      event_ids.each do |event_id|
        ce = CampaignEvent.new(identifier, campaign_id, event_id)
        ce.register
      end
    end

    def self.find_all_by_campaign_id(campaign_id)
      CampaignEvent.data.where(campaign_id: campaign_id).to_a
    end

    def self.data
      DB.from(:campaign_events)
    end

    def register
      CampaignEvent.data.insert(
        identifier:   identifier,
        campaign_id:  campaign_id,
        event_id:     event_id)
    end

  end
end
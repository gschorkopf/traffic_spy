require 'spec_helper'

describe TrafficSpy::CampaignEvent do

  let(:app) {TrafficSpy::CampaignEvent}

  describe "initialize" do
    it "stores a group of attributes for a campaign event" do
      ce = app.new('jumpstartlab', 49, 32)
      expect(ce.identifier).to eq 'jumpstartlab'
      expect(ce.campaign_id).to eq 49
      expect(ce.event_id).to eq 32
    end
  end

  describe ".loop_register" do
    it "registers a group of campaign events" do
      app.loop_register('jumpstartlab', 1, [1,2,3,4])
      expect(app.find_all_by_campaign_id(1).count).to eq 4
    end
  end

  describe ".find_all_by_campaign_id" do
    it "finds all campaign events by campaign id" do
      app.loop_register('jumpstartlab', 1, [1,2,3,4])
      app.loop_register('bananarama', 1, [5,6,7,8])
      expect(app.find_all_by_campaign_id(1).count).to eq 8
    end
  end

  describe "#register" do
    it "inserts a single campaign / event pair into the table" do
      app.new('jumpstartlab', 1, 10).register
      expect(app.find_all_by_campaign_id(1).first[:event_id]).to eq 10
    end
  end

end
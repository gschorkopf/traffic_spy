require 'spec_helper'

describe TrafficSpy::Event do

  let(:app) { TrafficSpy::Event }
  let(:cl_app) { TrafficSpy::Client }

  before do
    app.create_table
    TrafficSpy::Payload.create_table
    cl_app.create_table
    TrafficSpy::Campaign.create_table
    TrafficSpy::CampaignEvent.create_table
    @client = cl_app.new(identifier: 'jumpstartlab', rooturl: 'http://jumpstartlab.com')
    @client.save
    hash = {
      "url" => "http://jumpstartlab.com/blog",
      "requestedAt" => "2013-02-16 21:38:28 -0700",
      "respondedIn" => 37,
      "referredBy" => "http://jumpstartlab.com",
      "requestType" => "GET",
      "eventName" => "socialLogin",
      "userAgent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth" => "1920",
      "resolutionHeight" => "1280",
      "ip" => "63.29.38.211"
      }
    @payload = TrafficSpy::Payload.new(hash, 1)
    @payload.commit
  end

  after do
    @payload, @client = nil
    cl_app.database.drop_table(:events)
    cl_app.database.drop_table(:payloads)
    cl_app.database.drop_table(:identifiers)
    cl_app.database.drop_table(:campaigns)
    cl_app.database.drop_table(:campaign_events)
  end

  describe ".create_table auto-loads event" do
    it "payload creates new event from payload event_name" do
      app.create_table
      expect(app.data.select.to_a.count).to eq 1
    end
  end

  describe ".find_by_event" do
    it "finds the first instance of an event given the event name" do
      expect(app.find_by_event("socialLogin")[:id]).to eq 1
    end
  end

  describe ".exists?" do
    it "returns true if event exists in database" do
      expect(app.exists?('socialLogin')).to eq true
    end

    it "returns false if event does not exist in database" do
      expect(app.exists?('puppyBowl')).to eq false
    end
  end

  describe ".switchboard" do
    it "returns an event_id field for payload" do
      expect(app.switchboard('socialLogin')).to eq 1
    end
  end

  describe ".most_events_sorter" do
    it "returns list of events from most received to least" do
      expect(app.most_events_sorter.first.first).to eq 'socialLogin'
    end
  end

  describe ".hourly_events_sorter" do
    it "returns hourly breakdown of particular event creation dates" do
      event_id = app.find_by_event('socialLogin')[:id]
      hour_breakdown = app.hourly_events_sorter(event_id)
      expect(hour_breakdown.first.first).to eq 21
      expect(hour_breakdown.first.last).to eq 1
    end
  end
  
  describe "verify_table_exists" do
    it "returns true if the table exists" do
      expect(app.verify_table_exists).to be true
    end
  end


end

require 'spec_helper'

describe TrafficSpy::Campaign do

  let(:app) {TrafficSpy::Campaign}
  let(:cl_app) {TrafficSpy::Client}

  before do
    TrafficSpy::Client.create_table
    TrafficSpy::Event.create_table
    TrafficSpy::Campaign.create_table
    TrafficSpy::Payload.create_table
    TrafficSpy::CampaignEvent.create_table
    app.find_or_create('socialSignup',
      ['registrationStep1', 'registrationStep2',
      'registrationStep3', 'registrationStep4'])
  end

  after do
    cl_app.database.drop_table(:events)
    cl_app.database.drop_table(:payloads)
    cl_app.database.drop_table(:identifiers)
    cl_app.database.drop_table(:campaigns)
    cl_app.database.drop_table(:campaign_events)
  end

  describe ".find_or_create" do
    it "returns an array of old or new event_ids" do
      expect(app.find_or_create('socialSignup',
      ['registrationStep1', 'registrationStep2',
      'registrationStep3', 'registrationStep4'])).to eq [1,2,3,4]
    end

    it "creates a new campaign" do
      expect(app.find_by_campaign('socialSignup')[:name]).to eq 'socialSignup'
    end
  end

  describe ".exists?" do
    it "returns true if campaign already exists" do
      expect(app.exists?('socialSignup')).to be true
    end

    it "returns false if campaign does not exist" do
      expect(app.exists?('bananaRama')).to be false
    end
  end

  describe "verify_table_exists" do
    it "returns true if the table exists" do
      expect(app.verify_table_exists).to be true
    end
  end

  describe ".register" do
    it "registers a new campaign name" do
      app.register('bananaRama')
      expect(app.find_by_campaign('bananaRama')[:name]).to eq "bananaRama"
    end
  end



end

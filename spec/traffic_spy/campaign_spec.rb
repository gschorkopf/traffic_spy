require 'spec_helper'

describe TrafficSpy::Campaign do

  let(:app) {TrafficSpy::Campaign}
  let(:cl_app) {TrafficSpy::Client}
  let(:data) { TrafficSpy::DummyData}

  before do
    data.before
    @hash = {'campaignName' => 'socialSignup',
      'eventNames' =>
      ['registrationStep1', 'registrationStep2',
      'registrationStep3', 'registrationStep4']}
    @campaign = app.new('jumpstartlab', @hash)
    @bad_hash = {'campaignName' => '',
      'eventNames' =>
      ['registrationStep1', 'registrationStep2',
      'registrationStep3', 'registrationStep4']}
  end

  after do
    data.after
  end

  describe "initialize stores variables" do
    it "stores a hash of data and identifier from post" do
      expect(@campaign.name).to eq 'socialSignup'
      expect(@campaign.identifier).to eq 'jumpstartlab'
      expect(@campaign.event_names[1]).to eq 'registrationStep2'
    end
  end

  describe "#missing?" do
    it "returns true if parameters are missing" do
      expect(app.new('jumpstartlab', @bad_hash).missing?).to be true
    end

    it "returns false if parameters are present" do
      expect(@campaign.missing?).to be false
    end
  end

  describe ".exists?" do
    it "returns true if campaign already exists" do
      @campaign.register
      expect(app.exists?('socialSignup')).to be true
    end

    it "returns false if campaign does not exist" do
      expect(app.exists?('bananaRama')).to be false
    end
  end

  describe ".find_all_by_identifier" do
    it "returns all campaigns by identifier" do
      @campaign.register
      campaigns = app.find_all_by_identifier('jumpstartlab')
      expect(campaigns.count).to eq 1
    end
  end

  describe "#register" do
    it "registers a new campaign name" do
      @campaign.register
      expect(app.find_by_name('socialSignup')[:name]).to eq "socialSignup"
    end

    it "registers a campaign with identifier" do
      @campaign.register
      expect(app.find_by_name('socialSignup')[:identifier]).to eq "jumpstartlab"
    end
  end

  describe ".campaign_event_sorter" do
    it "sorts campaign events from most to least received" do
      @campaign.register
      event_list = app.campaign_event_sorter('socialSignup')
      expect(event_list).to eq {}
    end
  end



end

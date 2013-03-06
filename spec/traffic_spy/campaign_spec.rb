require 'spec_helper'

describe TrafficSpy::Campaign do

  let(:app) {TrafficSpy::Campaign}
  let(:cl_app) {TrafficSpy::Client}
  let(:data) { TrafficSpy::DummyData}

  before do
    data.before
    hash = {'campaignName' => 'socialSignup',
      'eventNames' =>
      ['registrationStep1', 'registrationStep2',
      'registrationStep3', 'registrationStep4']}
    @campaign = app.new('jumpstartlab', hash)
  end

  after do
    data.after
  end

  describe "initialize stores variables" do
    it "stores a hash of data" do
      expect(@campaign.name).to eq 'socialSignup'
      expect(@campaign.identifier).to eq 'jumpstartlab'
      expect(@campaign.event_names[1]).to eq 'registrationStep2'
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

  describe "#register" do
    it "registers a new campaign name" do
      @campaign.register
      expect(app.find_by_name('socialSignup')[:name]).to eq "socialSignup"
    end
  end



end

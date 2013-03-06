require 'spec_helper'

describe TrafficSpy::Campaign do

  let(:app) {TrafficSpy::Campaign}
  let(:cl_app) {TrafficSpy::Client}
  let(:data) { TrafficSpy::DummyData}

  before do
    data.before
    app.find_or_create('socialSignup',
      ['registrationStep1', 'registrationStep2',
      'registrationStep3', 'registrationStep4'])
  end

  after do
    data.after
  end

  describe ".find_or_create" do
    it "returns an array of old or new event_ids" do
      expect(app.find_or_create('socialSignup',
      ['registrationStep1', 'registrationStep2',
      'registrationStep3', 'registrationStep4'])).to eq [1,2,3,4]
    end

    it "creates a new campaign" do
      expect(app.find_by_name('socialSignup')[:name]).to eq 'socialSignup'
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

  describe ".register" do
    it "registers a new campaign name" do
      app.register('bananaRama')
      expect(app.find_by_name('bananaRama')[:name]).to eq "bananaRama"
    end
  end



end

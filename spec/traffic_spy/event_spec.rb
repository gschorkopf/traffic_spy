require 'spec_helper'

describe TrafficSpy::Event do

  let(:app) { TrafficSpy::Event }

  before do
    @event = nil
  end

  after do
    @event = nil
  end

  describe ".create_table" do
    it "creates table for :identifiers" do
      app.create_table
      expect(app.data.select.to_a).to eq []
    end
  end


end

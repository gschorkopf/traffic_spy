require 'spec_helper'

describe TrafficSpy::Payload do

  let(:app) { TrafficSpy::Payload }

  before do
    app.create_table
    @payload = app.new(
      # client_id: need to connect
      # event_id: need to connect
      url:"http://jumpstartlab.com/blog",
      requestedAt:"2013-02-16 21:38:28 -0700",
      respondedIn:37,
      referredBy:"http://jumpstartlab.com",
      requestType:"GET",
      userAgent:"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      resolutionWidth:"1920",
      resolutionHeight:"1280",
      ip:"63.29.38.211"
      )
  end

  after do
    TrafficSpy::Client.database.drop_table(:payloads)
    @payload = nil
  end

  describe "initialize stores variables" do
    it "stores a hash of data" do
      expect(@payload.url).to eq "http://jumpstartlab.com/blog"
      expect(@payload.requestedAt).to eq "2013-02-16 21:38:28 -0700"
      expect(@payload.respondedIn).to eq 37
      expect(@payload.referredBy).to eq "http://jumpstartlab.com"
      expect(@payload.requestType).to eq "GET"
      expect(@payload.userAgent).to eq "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
      expect(@payload.resolutionWidth).to eq "1920"
      expect(@payload.resolutionHeight).to eq "1280"
      expect(@payload.ip).to eq "63.29.38.211"
    end
  end

  describe ".create_table" do
    it "creates table for :payloads" do
      app.create_table
      expect(app.data.select.to_a).to eq []
    end
  end

  describe ".commit" do
    it "inserts the current payload into the payloads table" do
      @payload.commit
      expect(app.data.where(id: 1).to_a.count).to eq 1
      expect(app.data.where(id: 1).to_a[0][:resolutionWidth]).to eq "1920"
    end
  end


end

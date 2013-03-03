require 'spec_helper'

describe TrafficSpy::Payload do

  let(:app) { TrafficSpy::Payload }

  before do
    app.create_table

    hash_one = {
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
    hash_two = {
      "url" => "http://jumpstartlab.com/gschool",
      "requestedAt" => "2013-02-15 21:37:28 -0700",
      "respondedIn" => 35,
      "referredBy" => "http://jumpstartlab.com",
      "userAgent" => "Safari/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth" => "800",
      "resolutionHeight" => "600",
      }
    hash_three = {
      "url" => "http://jumpstartlab.com/gschool",
      "requestedAt" => "2013-02-14 21:37:28 -0700",
      "respondedIn" => 23,
      "referredBy" => "http://jumpstartlab.com",
      "userAgent" => "Safari/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth" => "800",
      "resolutionHeight" => "600",
      }
    @payload_one = app.new(hash_one, 1)
    @payload_two = app.new(hash_two, 1)
    @payload_three = app.new(hash_three, 1)
    @empty_payload = app.new({}, 1)
  end

  after do
    TrafficSpy::Client.database.drop_table(:payloads)
    @payload_one, @payload_two, @payload_three = nil
    @empty_payload = nil
  end

  describe "initialize stores variables" do
    it "stores a hash of data" do
<<<<<<< HEAD
      expect(@payload.url).to eq "http://jumpstartlab.com/blog"
      expect(@payload.requestedAt).to eq "2013-02-16 21:38:28 -0700"
      expect(@payload.respondedIn).to eq 37
      expect(@payload.referredBy).to eq "http://jumpstartlab.com"
      expect(@payload.requestType).to eq "GET"
      expect(@payload.userAgent).to eq "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
      expect(@payload.resolutionWidth).to eq "1920"
      expect(@payload.resolutionHeight).to eq "1280"
      expect(@payload.ip).to eq "63.29.38.211"
=======
      expect(@payload_one.url).to eq "http://jumpstartlab.com/blog"
      expect(@payload_one.requestedAt).to eq "2013-02-16 21:38:28 -0700"
      expect(@payload_one.respondedIn).to eq 37
      expect(@payload_one.referredBy).to eq "http://jumpstartlab.com"
      expect(@payload_one.requestType).to eq "GET"
      expect(@payload_one.userAgent).to eq "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
      expect(@payload_one.resolutionWidth).to eq "1920"
      expect(@payload_one.resolutionHeight).to eq "1280"
      expect(@payload_one.ip).to eq "63.29.38.211" 
>>>>>>> 6d25ae5f78dc78999c579437a3fc97f64e7ab078
    end
  end

  describe ".create_table" do
    it "creates table for :payloads" do
      app.create_table
      expect(app.data.select.to_a).to eq []
    end
  end

  describe "#commit" do
    it "inserts the current payload into the payloads table" do
      @payload_one.commit
      expect(app.data.where(id: 1).to_a.count).to eq 1
      expect(app.data.where(id: 1).to_a[0][:resolutionWidth]).to eq "1920"
    end
  end

  describe "#empty?" do
    it "returns true if payload is an empty hash" do
      expect(@empty_payload.empty?).to eq true
    end

    it "return false if payload is an at least partially full hash" do
      expect(@payload_one.empty?).to eq false
    end
  end

  describe ".exists?" do
    it "returns true if payload exists in :payloads" do
      @payload_one.commit
      expect(app.exists?(@payload_one)).to eq true
    end

    it "return false if the payload does not exist in :payloads" do
      expect(app.exists?(@empty_payload)).to eq false
    end
  end

  describe "data analysis" do
    describe "url_sorter" do
      it "sorts from most requested URLS to least requested URLS" do
        @payload_one.commit
        @payload_two.commit
        @payload_three.commit
        clients = app.find_all_by_client_id(1)
        expect(app.url_sorter(clients).to_a.first.first).to eq "http://jumpstartlab.com/gschool"
      end
    end

    describe ".browser_sorter" do
      it "outputs web browser breakdown across all requests" do
        pending
        # @payload.commit
        # @payloadtwo.commit
        # expect(app.browser_sorter.to_a).to eq nil
      end
    end

    describe "os_sorter" do
      it "outputs OS breakdown across all requests" do
        pending
      end
    end

    describe "resolution_sorter" do
      it "outputs screen Resolution across all requests" do
        pending
      end
    end

    describe "rt_sorter" do
      it "outputs longest, average response time per URL to shortest, average response time per URL" do
        pending
      end
    end
  end


end

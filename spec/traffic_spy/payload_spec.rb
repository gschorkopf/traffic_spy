require 'spec_helper'

describe TrafficSpy::Payload do

  let(:app) { TrafficSpy::Payload }
  let(:cl_app) { TrafficSpy::Client }

  before do
    app.create_table
    cl_app.create_table
    @client = cl_app.new(identifier: 'jumpstartlab', rooturl: 'http://jumpstartlab.com')
    @client.save
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
      "userAgent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth" => "800",
      "resolutionHeight" => "600",
      }
    hash_three = {
      "url" => "http://jumpstartlab.com/gschool",
      "requestedAt" => "2013-02-14 21:37:28 -0700",
      "respondedIn" => 23,
      "referredBy" => "http://jumpstartlab.com",
      "userAgent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth" => "800",
      "resolutionHeight" => "600",
      }
    @payload_one = app.new(hash_one, 1)
    @payload_two = app.new(hash_two, 1)
    @payload_three = app.new(hash_three, 1)
    @empty_payload = app.new({}, 1)
  end

  after do
    cl_app.database.drop_table(:payloads)
    cl_app.database.drop_table(:identifiers)
    @payload_one, @payload_two, @payload_three = nil
    @empty_payload, @client = nil
  end

  describe "initialize stores variables" do
    it "stores a hash of data" do
      expect(@payload_one.url).to eq "http://jumpstartlab.com/blog"
      expect(@payload_one.requested_at).to eq "2013-02-16 21:38:28 -0700"
      expect(@payload_one.responded_in).to eq 37
      expect(@payload_one.referred_by).to eq "http://jumpstartlab.com"
      expect(@payload_one.request_type).to eq "GET"
      expect(@payload_one.user_agent).to eq "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
      expect(@payload_one.resolution_width).to eq "1920"
      expect(@payload_one.resolution_height).to eq "1280"
      expect(@payload_one.ip).to eq "63.29.38.211" 
    end
  end

  describe "creates and stores attribute for path" do
    it "path gets stored" do
      @payload_one.commit
      expect(app.data.select(:path).first[:path]).to eq "/blog"
    end
  end

  describe ".get_path" do
    it "returns the path for the url parameter" do
      path = app.get_path("http://jumpstartlab.com/gschool/", "http://jumpstartlab.com")
      expect(path).to eq "/gschool/"
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
      expect(app.data.where(id: 1).to_a[0][:resolution_width]).to eq "1920"
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
    describe ".url_sorter" do
      it "sorts from most requested URLS to least requested URLS" do
        @payload_one.commit
        @payload_two.commit
        @payload_three.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.url_sorter(payloads).to_a.first.first).to eq "http://jumpstartlab.com/gschool"
      end
    end

    describe ".browser_sorter" do
      it "outputs web browser breakdown across all requests" do
        @payload_one.commit
        @payload_two.commit
        @payload_three.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.browser_sorter(payloads).to_a.first.first).to eq "Chrome"
      end
    end

    describe ".os_sorter" do
      it "outputs OS breakdown across all requests" do
        @payload_one.commit
        @payload_two.commit
        @payload_three.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.os_sorter(payloads).to_a.first.first).to eq "Macintosh"
      end
    end

    describe ".rez_sorter" do
      it "outputs screen Resolution across all requests" do
        @payload_one.commit
        @payload_two.commit
        @payload_three.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.rez_sorter(payloads).to_a.first.first).to eq "800 x 600"
      end
    end

    describe ".avg_response_times" do
      it "outputs longest, average response time per URL to shortest, average response time per URL" do
        @payload_one.commit
        @payload_two.commit
        @payload_three.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.avg_response_times(payloads).first.first).to eq "http://jumpstartlab.com/blog"
        expect(app.avg_response_times(payloads).first.last).to eq 37
      end
    end

    describe ".response_times_for_path" do
      it "outputs longest response time to shortest response time" do
        @payload_one.commit
        @payload_two.commit
        @payload_three.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.response_times_for_path(payloads).first.last).to eq 2
        expect(app.response_times_for_path(payloads).first.first).to eq '/gschool'
      end
    end

  end


end

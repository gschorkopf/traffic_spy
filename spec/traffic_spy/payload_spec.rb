require 'spec_helper'

describe TrafficSpy::Payload do

  let(:app) { TrafficSpy::Payload }
  let(:cl_app) { TrafficSpy::Client }
  let(:data) { TrafficSpy::DummyData}

  before do
    data.before
    @client = cl_app.new(identifier: 'jumpstartlab', rooturl: 'http://jumpstartlab.com')
    @client.save
    @p1 = data.payload_one
    @p2 = data.payload_two
    @p3 = data.payload_three
    @empty_payload = app.new({}, 1)
  end

  after do
    data.after
    @p1, @p2, @p3 = nil
    @empty_payload, @client = nil
  end

  describe "initialize stores variables" do
    it "stores a hash of data" do
      expect(@p1.url).to eq "http://jumpstartlab.com/blog"
      expect(@p1.requested_at).to eq "2013-02-16 21:38:28 -0700"
      expect(@p1.responded_in).to eq 37
      expect(@p1.referred_by).to eq "http://jumpstartlab.com"
      expect(@p1.request_type).to eq "GET"
      expect(@p1.user_agent).to eq "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
      expect(@p1.resolution_width).to eq "1920"
      expect(@p1.resolution_height).to eq "1280"
      expect(@p1.ip).to eq "63.29.38.211" 
    end
  end

  describe "creates and stores attribute for path" do
    it "path gets stored" do
      @p1.commit
      expect(app.data.select(:path).to_a.first[:path]).to eq "/blog"
    end
  end

  describe ".get_path" do
    it "returns the path for the url parameter" do
      path = app.get_path("http://jumpstartlab.com/gschool/", "http://jumpstartlab.com")
      expect(path).to eq "/gschool/"
    end
  end

  describe "#commit" do
    it "inserts the current payload into the payloads table" do
      @p1.commit
      expect(app.data.where(id: 1).to_a.count).to eq 1
      expect(app.data.where(id: 1).to_a[0][:resolution_width]).to eq "1920"
    end
  end

  describe "#empty?" do
    it "returns true if payload is an empty hash" do
      expect(@empty_payload.empty?).to eq true
    end

    it "return false if payload is an at least partially full hash" do
      expect(@p1.empty?).to eq false
    end
  end

  describe ".exists?" do
    it "returns true if payload exists in :payloads" do
      @p1.commit
      expect(app.exists?(@p1)).to eq true
    end

    it "return false if the payload does not exist in :payloads" do
      expect(app.exists?(@empty_payload)).to eq false
    end
  end

  describe "data analysis" do
    describe ".url_sorter" do
      it "sorts from most requested URLS to least requested URLS" do
        @p1.commit
        @p2.commit
        @p3.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.url_sorter(payloads).to_a.first.first).to eq "http://jumpstartlab.com/gschool"
      end
    end

    describe ".browser_sorter" do
      it "outputs web browser breakdown across all requests" do
        @p1.commit
        @p2.commit
        @p3.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.browser_sorter(payloads).to_a.first.first).to eq "Chrome"
      end
    end

    describe ".os_sorter" do
      it "outputs OS breakdown across all requests" do
        @p1.commit
        @p2.commit
        @p3.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.os_sorter(payloads).to_a.first.first).to eq "Macintosh"
      end
    end

    describe ".rez_sorter" do
      it "outputs screen Resolution across all requests" do
        @p1.commit
        @p2.commit
        @p3.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.rez_sorter(payloads).to_a.first.first).to eq "800 x 600"
      end
    end

    describe ".avg_response_times" do
      it "outputs longest, average response time per URL to shortest, average response time per URL" do
        @p1.commit
        @p2.commit
        @p3.commit
        payloads = app.find_all_by_client_id(1)
        expect(app.avg_response_times(payloads).first.first).to eq "http://jumpstartlab.com/blog"
        expect(app.avg_response_times(payloads).first.last).to eq 37
      end
    end

    describe ".response_times_for_path" do
      it "outputs longest response time to shortest response time" do
        @p1.commit
        @p2.commit
        @p3.commit
        payloads = app.find_all_by_path('/gschool')
        expect(app.response_times_for_path(payloads).first).to eq 35
        expect(app.response_times_for_path(payloads).last).to eq 23
      end
    end

  end


end

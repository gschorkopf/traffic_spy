require 'spec_helper'

describe TrafficSpy::Client do

  let(:app) { TrafficSpy::Client }
  let(:data) { TrafficSpy::DummyData}

  before do
    data.before
    @good_client = app.new(identifier: 'Amazon', rooturl: 'www.amazon.com')
    @bad_client = app.new(identifier: nil, rooturl: '')
    @stored_client = app.new(identifier: 'Google', rooturl: 'www.google.com')
  end

  after do
    data.after
    @good_client, @bad_client, @stored_client = nil
  end

  describe "initialize stores variables" do
    it "stores a hash of data" do
      expect(@good_client.identifier).to eq 'Amazon'
      expect(@good_client.rooturl).to eq 'www.amazon.com'
    end
  end

  describe ".find_by_identifier" do
    it "returns a client associated with the identifier" do
      @good_client.save
      client = app.find_by_identifier('Amazon')
      expect(client[:rooturl]).to eq 'www.amazon.com'
    end
  end

  describe "#missing?" do
    it "returns true if both paramaters are provided" do
      expect(@bad_client.missing?).to eq true
    end
  end

  describe ".exists?" do
    it "returns true if client already exists in :identifiers table" do
      @good_client.save
      expect(app.exists?(@good_client)).to eq true
    end

    it "returns false if client does not exist in :identifiers table" do
      expect(app.exists?(@bad_client)).to eq false
    end
  end

  describe ".save" do
    it "inserts the current client into the :identifiers table" do
      @stored_client.save
      expect(app.data.where(id: 1).to_a.count).to eq 1
      expect(app.data.where(rooturl: 'www.google.com').to_a[0][:identifier]).to eq "Google"
    end
  end

  describe ".find_root_by_id" do
    it "given the client_id of the payload, returns the rooturl" do
      @good_client.save
      expect(app.find_root_by_id(1)).to eq "www.amazon.com"
    end
  end


end

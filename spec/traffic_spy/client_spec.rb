require 'spec_helper'

describe TrafficSpy::Client do

  let(:app) { TrafficSpy::Client }

  before do
    app.create_table
    @good_client = app.new(identifier: 'Amazon', rooturl: 'www.amazon.com/doggie_sweaters')
    @bad_client = app.new(identifier: nil, rooturl: 'www.amazon.com/doggie_sweaters')
    @stored_client = app.new(identifier: 'Google', rooturl: 'www.google.com/offers')
  end

  after do
    app.database.drop_table(:identifiers)
    @good_client, @bad_client, @stored_client = nil
  end


  describe "initialize stores variables" do
    it "stores a hash of data" do
      expect(@good_client.identifier).to eq 'Amazon'
      expect(@good_client.rooturl).to eq 'www.amazon.com/doggie_sweaters'
    end
  end

  describe ".create_table" do
    it "creates table for :identifiers" do
      app.create_table
      expect(app.data.select.to_a).to eq []
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
      expect(app.data.where(rooturl: 'www.google.com/offers').to_a[0][:identifier]).to eq "Google"
    end
  end


end

require 'spec_helper'

describe TrafficSpy::Client do

  let(:app) { TrafficSpy::Client }

  before do
    app.data.where(identifier: 'Amazon').delete
    @good_client = app.new(identifier: 'Amazon', rooturl: 'www.amazon.com/doggie_sweaters')
    @bad_client = app.new(identifier: nil, rooturl: 'www.amazon.com/doggie_sweaters')
    @stored_client = app.new(identifier: 'Google', rooturl: 'www.google.com/offers')
  end

  after do
    @good_client, @bad_client, @stored_client = nil
    app.data.where(identifier: 'Amazon').delete
    app.data.where(identifier: 'Google').delete
  end


  describe "initialize stores variables" do
    it "stores a hash of data" do
      expect(@good_client.identifier).to eq 'Amazon'
      expect(@good_client.rooturl).to eq 'www.amazon.com/doggie_sweaters'
    end
  end

  describe ".create_table" do
    it "creates table" do
      app.create_table
      expect(app.data.select.to_a).to eq []
    end
  end

  describe "#missing?" do
    it "determines if both paramaters are provided" do
      expect(@bad_client.missing?).to eq true
    end
  end

  describe ".exists?" do
    it "determines if parameters already exist in :identifiers table" do
      @good_client.save
      expect(app.exists?).to eq true
    end
  end

  describe ".save" do
    it "inserts the current client into the :identifiers table" do
      @stored_client.save
      expect(app.data.where(identifier: 'Google').to_a.count).to eq 1
    end
  end


end

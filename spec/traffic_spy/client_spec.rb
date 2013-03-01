require 'spec_helper'
require 'rack/test'



describe TrafficSpy::Client do

  include Rack::Test::Methods

  describe "initialize stores variables" do
    it "stores a hash of data" do
      client = TrafficSpy::Client.new(identifier: 'Amazon', rooturl: 'www.amazon.com/doggie_sweaters')
      expect(client.identifier).to eq 'Amazon'
      expect(client.rooturl).to eq 'www.amazon.com/doggie_sweaters'
    end
  end

  describe ".create_table" do
    it "creates table" do
      TrafficSpy::Client.create_table
      expect(TrafficSpy::Client.data.select.to_a).to eq []
    end
  end

  describe "#missing?" do
    it "determines if both paramaters are provided" do
      client = TrafficSpy::Client.new(identifier: nil, rooturl: 'www.amazon.com/doggie_sweaters')
      expect(client.missing?).to eq true
    end
  end

  describe ".exists?" do
    it "determines if parameters already exist in :identifiers table" do
      new_client = TrafficSpy::Client.new(identifier: 'Amazon', rooturl: 'www.amazon.com/doggie_sweaters')
      new_client.save
      expect(new_client.exists?).to eq true
    end
  end

  describe ".save" do
    it "inserts the current client into the :identifiers table" do
      new_client = TrafficSpy::Client.new(identifier: 'Amazon', rooturl: 'www.amazon.com/doggie_sweaters')
      new_client.save
      (TrafficSpy::Client.data.where(identifier: 'Amazon').where(rooturl: 'www.amazon.com/doggie_sweaters').to_a.count).to eq 1
    end
  end


end

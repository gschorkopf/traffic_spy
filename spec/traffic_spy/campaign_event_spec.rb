require 'spec_helper'

describe TrafficSpy::CampaignEvent do

  let(:app) {TrafficSpy::CampaignEvent}
  let(:cl_app) {TrafficSpy::Client}

  before do
    TrafficSpy::Client.create_table
    TrafficSpy::Event.create_table
    TrafficSpy::Campaign.create_table
    TrafficSpy::Payload.create_table
  end

  after do
    cl_app.database.drop_table(:events)
    cl_app.database.drop_table(:payloads)
    cl_app.database.drop_table(:identifiers)
    cl_app.database.drop_table(:campaigns)
  end

end
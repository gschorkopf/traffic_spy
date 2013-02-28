require_relative './lib/beta_app'
require 'sinatra'

set :environment, :test

describe "test params exist" do

  include Rack::Test::Methods

  it "returns message if params do not exist" do
    post '/'
    last_response.should_not be_ok
  end

end

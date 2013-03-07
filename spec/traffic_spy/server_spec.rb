require 'spec_helper'

describe TrafficSpy::Server do
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  describe "/sources" do

    describe "application registration at /sources" do
      context "given valid and unique parameters" do
        it "registers the application" do
          post "/sources", {"identifier" => 'google', "rootUrl" => 'http://google.com'}
          expect(last_response).to be_ok
          expect(last_response.body.downcase).to include("identifier") && include("rooturl")
        end
      end
    end

    context "given parameters for an already existing application" do
      it "returns an error" do
        2.times { post "/sources", {"identifier" => 'google', "rootUrl" => 'http://google.com'} }
        expect(last_response.status).to eq 403
      end
    end

    context "given parameters are missing" do
      it "returns and error" do
        post "/sources", {"identifier" => 'google'}
        expect( last_response.status ).to eq 400
      end
    end
  end

  describe "/sources/:identifier/data" do

    context "without a payload" do
      it "complains about missing arguments" do
        post '/sources/jumpstartlab/data'
        expect(last_response.status).to eq 400
      end
    end

    context "with a payload" do
      let(:payload) do
          {"url"              => "http://jumpstartlab.com/blog",
          "requestedAt"      => "2013-02-16 21:38:28 -0700",
          "respondedIn"      => 37,
          "referredBy"       => "http://jumpstartlab.com",
          "requestType"      => "GET",
          "parameters"       => [],
          "eventName"        => "socialLogin",
          "userAgent"        => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2)"+
          " AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          "resolutionWidth"  => "1920",
          "resolutionHeight" => "1280",
          "ip"               => "63.29.38.211"}.to_json
      end

      before do
        if TrafficSpy::Client.find_by_identifier("jumpstartlab").nil?
          client = TrafficSpy::Client.new(:identifier => "jumpstartlab",
                                    :rooturl => "http://jumpstartlab.com")
          client.save
        end
      end

      it "creates the payload" do
        post '/sources/jumpstartlab/data', payload: payload
        expect(last_response.status).to eq 200
      end

      it "gives and error if payload is a duplicate" do
        post '/sources/jumpstartlab/data', payload: payload
        post '/sources/jumpstartlab/data', payload: payload
        expect(last_response.status).to eq 403
      end
    end
  end

  describe "/sources/:identifier" do

    context "when identifier does not exist" do

      it "gives an error message that identifier does not exist" do
        get '/sources/newbelgium'
        expect(last_response.status).to eq 404
      end
    end
  end

  describe "/sources/:identifier/urls/*" do
    context "when the url for the identifier does not exist" do
      it "gives an error message that url does not exist for identifier" do
        get '/sources/:identifier/urls/*'
        expect(last_response.status).to eq 404
      end

    end


  end


end

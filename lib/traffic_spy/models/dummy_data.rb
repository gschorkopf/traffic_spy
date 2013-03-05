module TrafficSpy
  class DummyData
    def self.before
      
    end

    def self.after
      
    end

    def self.payload_one
      hash = {
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
      @payload_one ||= Payload.new(hash, 1)
    end

    def self.payload_two
      hash = {
      "url" => "http://jumpstartlab.com/gschool",
      "requestedAt" => "2013-02-15 21:37:28 -0700",
      "respondedIn" => 35,
      "referredBy" => "http://jumpstartlab.com",
      "userAgent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth" => "800",
      "resolutionHeight" => "600",
      }
      @payload_two ||= Payload.new(hash, 1)
    end

    def self.payload_three
      hash = {
      "url" => "http://jumpstartlab.com/gschool",
      "requestedAt" => "2013-02-14 21:37:28 -0700",
      "respondedIn" => 23,
      "referredBy" => "http://jumpstartlab.com",
      "userAgent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth" => "800",
      "resolutionHeight" => "600",
      }
      @payload_three ||= Payload.new(hash, 1)
    end
    
    #   ### 3 sets client data
    #   def client_setup
    #     client = Client.new(identifier: 'jumpstartlab', rooturl: 'http://jumpstartlab.com')
    #     client.save
    #   end

    #   def empty_payload
    #     app.new({}, 1)
    #   end

  end
end
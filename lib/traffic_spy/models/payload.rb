module TrafficSpy
  class Payload
    attr_accessor :id,          :client_id,   :event_id,
                  :url,         :requestedAt,
                  :respondedIn, :referredBy,  :requestType,
                  :useragent_id,:resolutionWidth,
                  :resolutionHeight,  :ip

    def initialize(hash = {referredBy: "no one!"})
      unless hash == {}
        @id              = hash[:id]
        @client_id       = hash[:client_id]
        @event_id        = hash[:event_id]
        @useragent_id    = hash[:useragent_id]
        @url             = hash[:url]
        @requestedAt     = hash[:requestedAt]
        @respondedIn     = hash[:respondedIn]
        @referredBy      = hash[:referredBy]
        @requestType     = hash[:requestType]
        @resolutionWidth = hash[:resolutionWidth]
        @resolutionHeight= hash[:resolutionHeight]
        @ip              = hash[:ip]
      end
    end

    def empty?
      self.referredBy == "no one!"
    end

    def self.exists?(payload)
      Payload.data.where(url: payload.url).where(requestedAt: payload.requestedAt).count > 0
      # Iterate through all available attributes
    end

    def self.data
      verify_table_exists
      Client.database.from(:payloads)
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end

    def self.create_table
      Client.database.create_table? :payloads do
        primary_key :id
        foreign_key :client_id
        foreign_key :event_id
        # "eventName": "socialLogin" Connect to event.rb
        foreign_key :useragent_id
        # "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
        # Connect to user_agent.rb
        String      :url
        DateTime    :requestedAt
        Integer     :respondedIn
        String      :referredBy
        String      :requestType
        String      :resolutionWidth
        String      :resolutionHeight
        String      :ip
        # Parameters? WHAT'S UP WIT DATTT
      end
    end

    def commit
      Payload.data.insert(
        id: id,
        client_id: client_id,
        event_id: event_id,
        useragent_id: useragent_id,
        url: url,
        requestedAt: requestedAt,
        respondedIn: respondedIn,
        referredBy: referredBy,
        resolutionWidth: resolutionWidth,
        resolutionHeight: resolutionHeight,
        ip: ip
        )
    end

  end
end

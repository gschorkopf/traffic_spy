module TrafficSpy
  class Payload
    attr_accessor :id,          :client_id,   :event_id,
                  :url,         :requestedAt,
                  :respondedIn, :referredBy,  :requestType,
                  :userAgent,   :resolutionWidth,
                  :resolutionHeight,  :ip

    def initialize(hash = {referredBy: "no one!"})
      @id              = hash[:id]
      @client_id       = hash[:client_id]
      @event_id        = hash[:event_id]
      @url             = hash[:url]
      @requestedAt     = hash[:requestedAt]
      @respondedIn     = hash[:respondedIn]
      @referredBy      = hash[:referredBy]
      @requestType     = hash[:requestType]
      @userAgent       = hash[:userAgent]
      @resolutionWidth = hash[:resolutionWidth]
      @resolutionHeight= hash[:resolutionHeight]
      @ip              = hash[:ip]
    end

    def empty?
      self.referredBy == "no one!"
    end

    def self.exists?(payload)
      Payload.data.where(client_id: payload.client_id).where(event_id: payload.event_id).count > 0
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
        String      :url
        DateTime    :requestedAt
        Integer     :respondedIn
        String      :referredBy
        String      :requestType
        String      :userAgent
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
        url: url,
        requestedAt: requestedAt,
        respondedIn: respondedIn,
        referredBy: referredBy,
        userAgent: userAgent,
        resolutionWidth: resolutionWidth,
        resolutionHeight: resolutionHeight,
        ip: ip
        )
    end

  end
end

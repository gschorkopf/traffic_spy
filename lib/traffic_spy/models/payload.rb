module TrafficSpy
  class Payload
    attr_accessor :id,          :client_id,   :event_id,
                  :url,         :requestedAt,
                  :respondedIn, :referredBy,  :requestType,
                  :userAgent,   :resolutionWidth,
                  :resolutionHeight,  :ip, :status

    def initialize(hash = {}, client_id = nil)
      if hash == {}
        @status = :empty
      else
        @client_id       = client_id
        # @event_id        = Event.find_event_id(stuff)
        @userAgent       = hash["userAgent"]
        @url             = hash["url"]
        @requestedAt     = hash["requestedAt"]
        @respondedIn     = hash["respondedIn"]
        @referredBy      = hash["referredBy"]
        @requestType     = hash["requestType"]
        @resolutionWidth = hash["resolutionWidth"]
        @resolutionHeight= hash["resolutionHeight"]
        @ip              = hash["ip"]
      end
    end

    def empty?
      status == :empty
    end

    def self.exists?(payload)
      Payload.data.where(url: payload.url).where(requestedAt: payload.requestedAt).count > 0
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
        String      :userAgent
        String      :url
        DateTime    :requestedAt
        Integer     :respondedIn
        String      :referredBy
        String      :requestType
        String      :resolutionWidth
        String      :resolutionHeight
        String      :ip
      end
    end

    def commit
      Payload.data.insert(
        id: id,
        client_id: client_id,
        event_id: event_id,
        userAgent: userAgent,
        url: url,
        requestedAt: requestedAt,
        respondedIn: respondedIn,
        referredBy: referredBy,
        resolutionWidth: resolutionWidth,
        resolutionHeight: resolutionHeight,
        ip: ip
        )
    end

    def self.find_all_by_client_id(client_id)
      data.where(client_id: client_id)
    end

    def self.url_sorter(clients)
      url_hash = Hash.new(0)
      clients.collect {|client| client[:url]}.each do |url|
       url_hash[url] += 1
      end
      url_hash.sort_by {|url, hits| hits}.reverse
    end

    

  end
end

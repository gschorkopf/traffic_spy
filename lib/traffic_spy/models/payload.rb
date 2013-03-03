module TrafficSpy
  class Payload
    attr_accessor :id,          :client_id,   :event_id,
                  :url,         :requested_at,
                  :responded_in, :referred_by,  :request_type,
                  :user_agent,   :resolution_width,
                  :resolution_height,  :ip, :status

    def initialize(hash = {}, client_id = nil)
      if hash == {}
        @status = :empty
      else
        @client_id        = client_id
        # @event_id        = Event.find_event_id(stuff)
        @user_agent       = hash["userAgent"]
        @url              = hash["url"]
        @requested_at     = hash["requestedAt"]
        @responded_in     = hash["respondedIn"]
        @referred_by      = hash["referredBy"]
        @request_type     = hash["requestType"]
        @resolution_width = hash["resolutionWidth"]
        @resolution_height= hash["resolutionHeight"]
        @ip               = hash["ip"]
      end
    end

    def empty?
      status == :empty
    end

    def self.exists?(payload)
      Payload.data.where(url: payload.url).where(requested_at: payload.requested_at).count > 0
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
        String      :user_agent
        String      :url
        DateTime    :requested_at
        Integer     :responded_in
        String      :referred_by
        String      :request_type
        String      :resolution_width
        String      :resolution_height
        String      :ip
      end
    end

    def commit
      Payload.data.insert(
        id: id,
        client_id: client_id,
        event_id: event_id,
        user_agent: user_agent,
        url: url,
        requested_at: requested_at,
        responded_in: responded_in,
        referred_by: referred_by,
        resolution_width: resolution_width,
        resolution_height: resolution_height,
        ip: ip
        )
    end

    def self.find_all_by_client_id(client_id)
      data.where(client_id: client_id)
    end

    def self.url_sorter(payloads)
      url_hash = Hash.new(0)
      payloads.collect {|payload| payload[:url]}.each do |url|
       url_hash[url] += 1
      end
      url_hash.sort_by {|url, hits| hits}.reverse
    end

    def self.browser_sorter(payloads)
      browser_hash = Hash.new(0)
      payloads.collect {|payload| payload[:user_agent]}.each do |ua|
        browser_hash[UserAgent.parse(ua).browser] += 1
      end
      browser_hash.sort_by {|browser, hits| hits}.reverse
    end

    def self.os_sorter(payloads)
      os_hash = Hash.new(0)
      payloads.collect {|payload| payload[:user_agent]}.each do |ua|
        os_hash[UserAgent.parse(ua).platform] += 1
      end
      os_hash.sort_by {|os, hits| hits}.reverse
    end

    def self.rez_sorter(payloads)
      rez_hash = Hash.new(0)
      payloads.collect do |pl|
        "#{pl[:resolution_width]} x #{pl[:resolution_height]}"
      end.each do |rez|
        rez_hash[rez] += 1
      end
      rez_hash.sort_by {|rez, hits| hits}.reverse
    end
    
    def self.rt_sorter(payloads)
      ri_hash = Hash.new(0)
      payloads.collect do |pl|
        ri_hash[pl[:url]] += pl[:responded_in] if pl[:responded_in] != nil
      end
      ri_hash
    end

    def self.rt_
    end

  end
end

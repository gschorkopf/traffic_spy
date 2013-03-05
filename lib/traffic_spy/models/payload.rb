module TrafficSpy
  class Payload
    attr_accessor :id,          :client_id,   :event_id,
                  :url,         :requested_at,
                  :responded_in, :referred_by,  :request_type,
                  :user_agent,   :resolution_width,
                  :resolution_height,  :ip, :status

    def initialize(hash = {}, client_id = nil)
      if hash == {} || hash == ""
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
        String      :path
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
        path: Payload.get_path(url, Client.find_root_by_id(client_id)),
        requested_at: requested_at,
        responded_in: responded_in,
        referred_by: referred_by,
        resolution_width: resolution_width,
        resolution_height: resolution_height,
        ip: ip
        )
    end

      def self.get_path(url, rooturl)
        url.gsub(rooturl, '')
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

    def self.avg_response_times(payloads)
      urls = payloads.exclude(responded_in: nil).select(:url, :responded_in)
      counts =  urls.group_and_count(:url).inject({}) do |memo, url|
        memo[url[:url]] = url[:count]; memo
      end

      response_times = urls.inject(Hash.new(0)) do |memo, url|
        memo[url[:url]] += url[:responded_in]
        memo
      end

      avg = Hash.new(0)
      response_times.each do |url, total_time|
        avg[url] = total_time / counts[url]
      end
      avg.sort_by {|k,v| v}.reverse
    end

    def self.find_all_by_path(path)
      data.where(path: path)
    end

    def self.response_times_for_path(payloads)
      paths = payloads.exclude(responded_in: nil).select(:path, :responded_in).to_a

      paths.collect {|path| path[:responded_in]}.sort.reverse
    end

  end
end

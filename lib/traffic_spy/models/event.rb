module TrafficSpy
  class Event

    def self.switchboard(name)
      if Event.exists?(name)
        Event.find_all_by_event_name(name)[0][:id]
      else
        Event.register(name)
        Event.find_all_by_event_name(name)[0][:id]
      end
    end

    def self.find_all_by_event_name(name)
      Event.data.where(name: name).to_a
    end
    
    def self.create_table
      Client.database.create_table? :events do
        primary_key :id
        String      :name
        DateTime    :created_at
      end
    end

    def self.exists?(name)
      Event.find_all_by_event_name(name).to_a.count > 0
    end

    def self.register(name)
      Event.data.insert(
        :name => name, 
        :created_at => Time.now
        )
    end

    def self.data
      verify_table_exists
      Client.database.from(:events)
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end

    def self.most_events_sorter
      event_hash = Hash.new(0)
      Event.data.collect {|event| event[:name]}.each do |name|
       event_hash[name] += 1
      end
      event_hash.sort_by {|name, hits| hits}.reverse
    end

    def self.hourly_events_sorter(events)
      "pending"
    end

  end
end
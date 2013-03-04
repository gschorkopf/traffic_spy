module TrafficSpy
  class Event

    def self.find_or_create(name)
      if Event.exists?(name)
        Event.find_by_url(name)[:id]
      else
        Event.register(name)
        Event.find_by_url(name)[:id]
      end
    end

    def self.find_by_url(name)
      Event.data.where(name: name).to_a[0]
    end
    
    def self.create_table
      Client.database.create_table? :events do
        primary_key :id
        String      :name
        DateTime    :created_at
      end
    end

    def self.exists?(name)
      Event.find_by_url(name).to_a.count > 0
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

  end
end
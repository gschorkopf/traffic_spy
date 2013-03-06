module TrafficSpy
  class Event

    def self.find_or_create(name)
      if Event.exists?(name)
        Event.find_by_name(name)[:id]
      else
        Event.register(name)
        Event.find_by_name(name)[:id]
      end
    end

    def self.find_by_name(name)
      Event.data.where(name: name).to_a[0]
    end

    def self.find_all_by_client_id(client_id)
      client_payloads = Payload.data.where(client_id: client_id)
      event_ids = client_payloads.collect {|payload| payload[:event_id] }
      events = event_ids.collect do |id|
        Event.data.where(id: id).to_a
      end
      events.first
    end

    def self.exists?(name)
      Event.find_by_name(name).to_a.count > 0
    end

    def self.loop_register(events)
      #untested method
      event_ids = []
      events.each do |event|
        id = Event.find_or_create(event)
        event_ids.push(id)
      end
      event_ids
    end

    def self.register(name)
      Event.data.insert(
        :name => name,
        :created_at => Time.now
        )
    end

    def self.data
      DB.from(:events)
    end

    def self.most_events_sorter(payloads)
      event_hash = Hash.new(0)
      payloads.collect {|event| event[:name]}.each do |name|
       event_hash[name] += 1
      end
      event_hash.sort_by {|name, hits| hits}.reverse
    end

    def self.hourly_events_sorter(event_id)
      hour_hash = Hash.new(0)
      payloads = Payload.find_all_by_event_id(event_id)
      payloads.each do |payload|
        hour_hash[payload[:requested_at].hour] += 1
      end
      hour_hash.sort_by {|hour, hits| hour}.reverse
    end

  end
end

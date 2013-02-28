module TrafficSpy
  class Client
    attr_accessor :id, :identifier, :rooturl

    def initialize(hash)
      @id =         hash[:id]
      @identifier = hash[:identifier]
      @rooturl =    hash[:rooturl]
    end

    def self.database
      @database ||= Sequel.sqlite('./db/client_data.sqlite3')
    end

    def self.create_table
      database.create_table? :identifiers do
        primary_key :id
        String      :identifier
        String      :rooturl
      end
    end

    def save
      true
      # database.insert(
        # identifier: identifier,
        # rooturl: rooturl
        # )
    end

  end
end

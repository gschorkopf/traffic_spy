module TrafficSpy
  class Client
    attr_accessor :id, :identifier, :root_url

    def initialize(hash)
      @id =         hash[:id]
      @identifier = hash[:identifier]
      @rooturl =    hash[:root_url]
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
      database.insert(
        identifier: identifier,
        rooturl: rooturl
        )
    end

    def missing?
      
    end

    def self.exists?(params[:identifier])
      
    end

  end
end

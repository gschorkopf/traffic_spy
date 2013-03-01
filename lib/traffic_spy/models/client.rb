require 'sequel'
require 'sqlite3'

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

    def missing?
      if self.identifier.nil? || self.rooturl.nil?
        true
      else
        false
      end 
    end

    def self.exists?
      false
    end

    def self.data
      database.from(:identifiers)
    end

    def save
      Client.data.insert(
        identifier: identifier,
        rooturl: rooturl
        )
    end

  end
end

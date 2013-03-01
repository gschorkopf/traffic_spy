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
      @database ||= Sequel.sqlite('./db/database.sqlite3')
    end

    def self.create_table
      database.create_table? :identifiers do
        primary_key :id
        String      :identifier
        String      :rooturl
      end
    end

    def missing?
      self.identifier == "" || self.identifier.nil? ||
      self.rooturl == "" || self.rooturl.nil?
    end

    def self.exists?(client)
      Client.data.where(identifier: client.identifier).count > 0
    end

    def self.data
      verify_table_exists
      database.from(:identifiers)
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end

    def save
      Client.data.insert(
        identifier: identifier,
        rooturl: rooturl)
    end

  end
end

require 'sequel'
require 'sqlite3'

module TrafficSpy
  class Payload
    attr_accessor :id

    def initialize(hash)
      @id = hash[:id]
    end

    def self.create_table
      Client.database.create_table :payloads do
        primary_key :id
        String      :url
        DateTime    :requestedAt
        Integer     :respondedIn
        String      :referredBy
        String      :requestType
        foreign_key :event_id
        String      :userAgent
        String      :resolutionWidth
        String      :resolutionHeight
        String      :ip
      end
    end

  end
end

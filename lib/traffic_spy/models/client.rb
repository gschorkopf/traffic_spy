module TrafficSpy
  class Client
    attr_accessor :id, :identifier, :rooturl

    def initialize(hash = {})
      @id =         hash[:id]
      @identifier = hash[:identifier]
      @rooturl =    hash[:rooturl]
    end

    def self.find_root_by_id(client_id)
      data.where(id: client_id).to_a.first[:rooturl]
    end

    def self.find_by_identifier(identifier)
      data.where(identifier: identifier).to_a.first
    end

    def missing?
      self.identifier == "" || self.identifier.nil? ||
      self.rooturl == "" || self.rooturl.nil?
    end

    def self.exists?(client)
      data.where(identifier: client.identifier).count > 0
    end

    def self.data
      DB.from(:identifiers)
    end

    def save
      Client.data.insert(
        identifier: identifier,
        rooturl: rooturl)
    end

  end
end

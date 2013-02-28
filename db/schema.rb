require 'sequel'

module TrafficSpy
  class Schema
    # puts "Creating Table X"
    # raise "No table created" unless DB.table_exists? "x"
    # puts "Creating Table Y"
    DB = Sequel.sqlite

    DB.create_table :sources do
      primary_key :id
      String      :identifier
      String      :rooturl
    end

    DB.create_table :traffics do
      primary_key :id
      String      :url
      DateTime    :requestedAt
      Integer     :respondedIn
      String      :referredBy
      String      :requestType
      String      :parameters
      foreign_key :event_id
      String      :userAgent
      String      :resolutionWidth
      String      :resolutionHeight
      String      :ip
    end

    DB.create_table :events do
      primary_key :id
      String      :name
      foreign_key :campaign_id
    end

    DB.create_table :campaigns do
      primary_key :id
      String      :name
      foreign_key :event_id
    end

    dataset = DB.from(:traffics)
    payload = {
        "url":"http://jumpstartlab.com/blog",
        "requestedAt":"2013-02-16 21:38:28 -0700",
        "respondedIn":37,
        "referredBy":"http://jumpstartlab.com",
        "requestType":"GET",
        "parameters":[],
        "eventName": "socialLogin",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211" 
        }
    dataset.insert(payload)



  end
end

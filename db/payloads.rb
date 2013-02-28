module TrafficSpy
  class Payloads
    DB = Sequel.sqlite

    DB.create_table :payloads do 
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

    traffics_dataset = DB.from(:traffics)
    traffics_payload = {
        url:"http://jumpstartlab.com/blog",
        requestedAt:"2013-02-16 21:38:28 -0700",
        respondedIn:37,
        referredBy:"http://jumpstartlab.com",
        requestType:"GET",
        event_id:1,
        userAgent:"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        resolutionWidth:"1920",
        resolutionHeight:"1280",
        ip:"63.29.38.211" 
        }
    traffics_dataset.insert(traffics_payload)

    events_dataset = DB.from(:events)
    events_payload = {
        name:"socialLogin",
        campaign_id:12345
        }
    events_dataset.insert(events_payload)

    joined_dataset = events_dataset.join(:traffics, :event_id=>:id)
    puts joined_dataset.to_a

  end
end
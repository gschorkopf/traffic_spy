require "traffic_spy/version"
require "sequel"
require "pg"

module TrafficSpy
  class TrafficSpy
    ### Create database in postgresql
    createdb DB
    ### resources: http://www.postgresql.org/docs/8.3/static/app-createdb.html

    ### Example table
    DB.create_table :sources do
      primary_key :id
      String      :identifier
      String      :rooturl
    end
    ###

  end
end

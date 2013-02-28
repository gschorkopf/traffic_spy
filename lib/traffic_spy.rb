require "traffic_spy/version"
require "sequel"
require "pg"
require "sinatra"

module TrafficSpy
  class TrafficSpy

    get '/' do
      "HELLO WORLD"
    end

  end
end

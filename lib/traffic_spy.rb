Bundler.require

module TrafficSpy
  class TrafficSpy

    get '/' do
      erb :error
    end

    post '/sources' do
      # client will submit a post to http://ourapplication:port/sources
      client = Client.new(:identifier => params["identifier"],
                          :rooturl => params["rooturl"])
      # Send user descriptive error messages if param(s) is missing or if
      # if param(s) are missing then redirect to error message
      redirect to ('/')

      # Save application somewhere
      client.save
    end

  end
end

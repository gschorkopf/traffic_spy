require 'sinatra'

module TrafficSpy
  class Application

    POST '/sources' do
      if params[:rootUrl].nil?
        status 400
        {'/'message'/'}
    end

  end
end

require 'sinatra'

module REDIRECTOR
  
  class App < Sinatra::Base
  
    get '/' do
      url = request.env["SERVER_NAME"]
      if ENV[url]
        redirect ENV[url]
      else
        not_found
      end
    end

    not_found do
      @title = "Redirect not configured"
      @host_name = request.env["SERVER_NAME"]
      erb :not_found
    end

  end

end
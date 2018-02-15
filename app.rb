require 'sinatra'

module REDIRECTOR
  
  class App < Sinatra::Base
  
    set :reflections, {
      "artslectures.ucsc.edu" => "https://events.ucsc.edu",
      "calendar.ucsc.edu" => "https://events.ucsc.edu",      
      "urhelp.ucsc.edu" => "https://urishelp.atlassian.net/servicedesk/customer/portal/2"
    }

    get '/' do
      url = request.env["SERVER_NAME"]
      if settings.reflections[url]
        redirect settings.reflections[url]
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
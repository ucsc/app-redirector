require 'sinatra'

module REDIRECTOR
  
  class App < Sinatra::Base
  
    set :redirects, {
      "community.ucsc.edu" => "https://connect.ucsc.edu",
      "stayconnected.ucsc.edu" => "alumni.ucsc.edu/stay-connected/",
      "artslectures.ucsc.edu" => "https://events.ucsc.edu",
      "calendar.ucsc.edu" => "https://events.ucsc.edu",      
      "urhelp.ucsc.edu" => "https://urishelp.atlassian.net/servicedesk/customer/portal/2"
    }

    get '/' do
      url = request.env["SERVER_NAME"]
      if settings.redirects[url]
        redirect settings.redirects[url]
      else
        @host_name = request.env["SERVER_NAME"]
        not_found
      end
    end

    get '/test/:cname' do |domain|
      if settings.redirects[domain]
        @title = "Redirect exists for this domain"
        @host_name = domain
        @redirect = settings.redirects[domain]
        @body_class = "found"
        erb :found
      else
        @host_name = domain
        not_found
      end            
    end

    not_found do
      @title = "Redirect not configured"      
      @body_class = "not-found"
      erb :not_found
    end

  end

end
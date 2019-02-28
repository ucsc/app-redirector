require 'sinatra'
require 'staccato'

module REDIRECTOR
  
  class App < Sinatra::Base
  
    set :redirects, {
      "artslectures.ucsc.edu" => "https://events.ucsc.edu",
      "calendar.ucsc.edu" => "https://events.ucsc.edu",      
      "community.ucsc.edu" => "https://connect.ucsc.edu",
      "podcasts.ucsc.edu" => "https://soundcloud.com/ucsantacruz",
      "stayconnected.ucsc.edu" => "https://alumni.ucsc.edu/stay-connected/",
      "urhelp.ucsc.edu" => "https://urishelp.atlassian.net/servicedesk/customer/portals",
      "urtoolkit.ucsc.edu" => "https://sites.google.com/a/ucsc.edu/ur-toolkit/home?pli=1"
    }
    
    tracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'], nil, ssl: true)

    get '/' do
      url = request.env["SERVER_NAME"]
      if settings.redirects[url]
        tracker.event(category: 'App', action: 'Redirect', label: url, value: 1)
        redirect settings.redirects[url]
      else
        tracker.event(category: 'App', action: 'Not found', label: url, value: 0)
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
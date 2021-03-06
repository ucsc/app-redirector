require 'sinatra'
require 'staccato'

module REDIRECTOR
  
  class App < Sinatra::Base
  
    set :redirects, {
      "artslectures.ucsc.edu" => "https://calendar.ucsc.edu",
      "community.ucsc.edu" => "https://connect.ucsc.edu",
      "podcasts.ucsc.edu" => "https://soundcloud.com/ucsantacruz",
      "stayconnected.ucsc.edu" => "https://alumni.ucsc.edu/stay-connected",
      "urhelp.ucsc.edu" => "https://urishelp.atlassian.net/servicedesk/customer/portals",
      "urtoolkit.ucsc.edu" => "https://sites.google.com/ucsc.edu/urtoolkit-2",
      "maps-gis.ucsc.edu" => "https://maps.ucsc.edu",
      "www.maps.ucsc.edu" => "https://maps.ucsc.edu",
      "slugsupport.ucsc.edu" => "https://ucscslugsupport.communityfunded.net",
      "www.lrdp.ucsc.edu" => "https://lrdp.ucsc.edu",
      "santacruzinstitute.ucsc.edu" => "https://transform.ucsc.edu",
      "m.ucsc.edu" => "https://www.ucsc.edu",
      "mobile.ucsc.edu" => "https://www.ucsc.edu",
      "keepworking.ucsc.edu" => "https://its.ucsc.edu/covid-19/working-remotely.html"
    }
    
    tracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'], nil, ssl: true)

    get '/debug/:cname', :host_name => /^ucsc-redirector\./ do |domain|
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

    get '/*' do
      url = request.env["SERVER_NAME"]
      if settings.redirects[url]
        tracker.event(category: 'App', action: 'Redirect', label: url, value: 1)
        if request.env["PATH_INFO"] != '/'
          redirect settings.redirects[url] + request.env["PATH_INFO"]
        else
          redirect settings.redirects[url]
        end
      else
        tracker.event(category: 'App', action: 'Not found', label: url, value: 0)
        @host_name = request.env["SERVER_NAME"]
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

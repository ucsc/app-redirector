require 'sinatra'
require 'open-uri'
require 'uri'
require 'redis'

class Redirector < Sinatra::Base

  redis = Redis.new

  get '/' do
    @url = redis.get request.host.to_s
    if @url
      redirect to(@url), 302
    else
      404   
    end
  end

  get '/admin' do
    erb :form
  end

  post '/new' do
    if params[:cname] and params[:target]      
      redis.setnx params[:cname], params[:target]
    end
    erb :form
  end

  not_found do
    @title = "Redirect not configured"
    @host_name = request.host
    erb :not_found
  end

end
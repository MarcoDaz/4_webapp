require 'sinatra/base'
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/hello' do
    if params[:name].include?('<')
      status 400
      return 'No Way Jose :P'

    else
      @name = params[:name]
    
      return erb(:hello)
    end
  end
end

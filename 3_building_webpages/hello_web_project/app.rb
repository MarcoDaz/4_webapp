# file: app.rb
require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/hello' do
    return erb(:hello)
  end

  post '/sort-names' do
    names = params[:names]
      .split(',')
      .sort

    return names.join(', ')
  end
end
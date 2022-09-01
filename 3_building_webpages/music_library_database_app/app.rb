# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

# Reset database (uncomment if you want to save changes)
def reset_database
  albums_seed_sql = File.read('spec/seeds/albums_seeds.sql')
  artists_seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library' })
  connection.exec(albums_seed_sql)
  connection.exec(artists_seed_sql)
end

reset_database

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/' do
    return erb(:index)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all

    return erb(:albums)
  end

  get '/albums/new' do
    return erb(:new_album)
  end

  post '/albums' do
    if params[:title] == nil ||
       params[:release_year] == nil ||
       params[:artist_id] == nil

      status 400
      return ''
    end
       
    @album = Album.new
    @album.title = params[:title]
    @album.release_year = params[:release_year].to_i
    @album.artist_id = params[:artist_id].to_i

    repo = AlbumRepository.new 
    repo.create(@album)
    return erb(:album_created)
  end

  get '/albums/:id' do
    album_repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    @album = album_repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    
    return erb(:artists)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])

    return erb(:artist)
  end

  post '/artists' do
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]

    repo = ArtistRepository.new
    repo.create(artist)
    
    return ''
  end
end
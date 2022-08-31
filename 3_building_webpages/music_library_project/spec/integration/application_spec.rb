require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /' do
    it 'returns the html index' do
      response = get('/')

      expect(response.body).to include('<h1>Hello!</h1>')
    end
  end

  context 'GET /albums' do
    it 'should return the list of albums in html' do
      response = get('/albums')
      body = response.body

      expect(response.status).to eq 200
      expect(body).to include '<h1>Albums</h1>'

      expect(body).to include 'Title: <a href="albums/1">Doolittle</a>'
      expect(body).to include 'Released: 1989'

      expect(body).to include 'Title: <a href="albums/2">Surfer Rosa</a>'
      expect(body).to include 'Released: 1988'
    end
  end

  context 'GET /albums/:id' do
    it 'should return a specific album html' do
      response = get('/albums/3')

      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Waterloo</h1>'
      expect(response.body).to include 'Release year: 1974'
      expect(response.body).to include 'Artist: ABBA'
    end
  end
  
  context 'POST /albums' do
    it 'should create a new album' do
      response = post(
        '/albums',
        title: 'Voyage',
        release_year: '2022',
        artist_id: '2'
      )
      
      expect(response.status).to eq 200
      expect(response.body).to eq ''

      repo = AlbumRepository.new
      new_album = repo.all.last

      expect(new_album.title).to eq 'Voyage'
      expect(new_album.release_year).to eq 2022
      expect(new_album.artist_id).to eq 2
    end
  end

  context 'GET /artists' do
    it 'should return the list of artists with links to their html pages' do
      response = get('/artists')
      body = response.body

      expect(response.status).to eq 200
      expect(body).to include '<h1>Artists</h1>'

      expect(body).to include '<a href="/artists/1">Pixies</a>'
      expect(body).to include '<a href="/artists/2">ABBA</a>'
    end
  end

  context 'GET /artists/:id' do
    it 'should return a specific artist html' do
      response = get('/artists/2')
      body = response.body

      expect(response.status).to eq 200
      expect(body).to include '<h3><a href="/artists">Back to Artists</a></h3>'
      expect(body).to include '<h1>ABBA</h1>'
      expect(body).to include 'Genre: Pop'
    end
  end

  context 'POST /artists' do
    it 'should create a new artist' do
      response = post(
        '/artists',
        name: 'Wild nothing',
        genre: 'Indie'
      )
  
      expect(response.status).to eq 200
      expect(response.body).to eq ''
  
      repo = ArtistRepository.new
      latest_artist = repo.all.last
  
      expect(latest_artist.name).to eq 'Wild nothing'
      expect(latest_artist.genre).to eq 'Indie'
    end
  end
end

require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_database
  albums_seed_sql = File.read('spec/seeds/albums_seeds.sql')
  artists_seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(albums_seed_sql)
  connection.exec(artists_seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Reset database before each test
  before(:each) do
    reset_database
  end

  # Reset database after all tests are done
  after(:all) do
    reset_database
  end

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
      expect(body).to include 'Release Year: 1989'

      expect(body).to include 'Title: <a href="albums/2">Surfer Rosa</a>'
      expect(body).to include 'Release Year: 1988'
    end
  end

  context 'GET /albums/new' do
    it 'returns an html form to create a new album' do
      response = get('/albums/new')
      body = response.body

      expect(response.status).to eq 200
      expect(body).to include '<h1>Create New Album</h1>'
      expect(body).to include '<form action="/albums" method="POST">'
      expect(body).to include '<input type="text" name="title" id="title" required>'
      expect(body).to include '<input type="number" name="release_year" id="release_year" required>'
      expect(body).to include '<input type="number" name="artist_id" id="artist_id" required>'
      expect(body).to include '<input type="submit" value="Create Album">'
    end
  end

  context 'POST /albums' do
    it 'validates album parameters' do
      response = post('/albums',
        invalid_param: 'invalid',
        another_invalid_thing: 123,
      )

      expect(response.status).to eq 400
    end

    it 'creates an album and returns a confirmation page' do
      response = post('/albums',
        title: 'Album_1',
        release_year: '2021',
        artist_id: '1'
      )
      
      expect(response.status).to eq 200
      expect(response.body).to include '<h1>You Added Album: Album_1</h1>'

      # Check the newest album added to database
      repo = AlbumRepository.new
      new_album = repo.all.last

      expect(new_album.title).to eq 'Album_1'
      expect(new_album.release_year).to eq 2021
      expect(new_album.artist_id).to eq 1
    end

    it 'creates an album and returns a confirmation page with different message' do
      response = post('/albums',
        title: 'Album_2',
        release_year: '2022',
        artist_id: '2'
      )
      
      expect(response.status).to eq 200
      expect(response.body).to include '<h1>You Added Album: Album_2</h1>'

      # Check the newest album added to database
      repo = AlbumRepository.new
      new_album = repo.all.last

      expect(new_album.title).to eq 'Album_2'
      expect(new_album.release_year).to eq 2022
      expect(new_album.artist_id).to eq 2
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

  context 'GET /artists/new' do
    it 'returns html form for adding an artist' do
      response = get('/artists/new')
      body = response.body

      expect(response.status).to eq 200
      expect(body).to include '<h1>Create New Artist</h1>'
      expect(body).to include '<form action="/artists" method="POST">'
      expect(body).to include '<input type="text" name="name" id="name" required>'
      expect(body).to include '<input type="text" name="genre" id="genre" required>'
      expect(body).to include '<input type="submit" value="Create Artist">'
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
    it 'validates artist parameters' do
      response = post('/artists',
        invalid_param: 'invalid',
        another_invalid_thing: 123,
      )

      expect(response.status).to eq 400
    end

    it 'should create a new artist' do
      response = post('/artists',
        name: 'Wild nothing',
        genre: 'Indie'
      )
  
      expect(response.status).to eq 200
      expect(response.body).to include '<h1>You Added Artist: Wild nothing</h1>'
      
      # Check newest artist added in database
      repo = ArtistRepository.new
      latest_artist = repo.all.last
  
      expect(latest_artist.name).to eq 'Wild nothing'
      expect(latest_artist.genre).to eq 'Indie'
    end
  end
end

require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /albums' do
    it 'should return the list of albums' do
      response = get('/albums')

      expected_response = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

      expect(response.status).to eq 200
      expect(response.body).to eq expected_response
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
    it 'should return the list of artists' do
      response = get('/artists')

      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos'

      expect(response.status).to eq 200
      expect(response.body).to eq expected_response
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

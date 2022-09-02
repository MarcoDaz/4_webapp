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
    it 'should get the form' do
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form action="/hello" method="POST">')
    end
  end

  context 'POST /hello' do
    it 'validates user input, and reject injected scripts' do
      response = post('/hello',
        name: "<script>window.alert(\"You've been p0wn3d!!!!\"); document.location.href=\"https://www.youtube.com/watch?v=34Ig3X59_qA\";</script>"
      )

      expect(response.status).to eq 400
      expect(response.body).to eq 'No Way Jose :P'
    end 

    it 'should get greeting message' do
      response = post('/hello', name: 'Aurora')

      expect(response.status).to eq(200)
      expect(response.body).to include('Hi Aurora!')
    end
  end
end
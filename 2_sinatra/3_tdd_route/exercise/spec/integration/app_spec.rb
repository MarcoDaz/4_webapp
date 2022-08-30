require 'spec_helper'
require 'rack/test'
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /hello' do
    it 'should return "Hello Name1!"' do
      response = get('/hello?name=Name1')

      expect(response.status).to eq 200
      expect(response.body).to eq 'Hello Name1!'
    end

    it 'should return "Hello Name2!"' do
      response = get('/hello?name=Name2')

      expect(response.status).to eq 200
      expect(response.body).to eq 'Hello Name2!'
    end
  end
end
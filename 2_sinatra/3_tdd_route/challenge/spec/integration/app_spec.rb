require 'spec_helper'
require 'rack/test'
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST /sort-names" do
    it 'returns "Aname"' do
      response = post('/sort-names', names: 'Aname')

      expect(response.status).to eq 200
      expect(response.body).to eq 'Aname'
    end

    it 'returns "Aname, Bname"' do
      response = post('/sort-names', names: 'Aname,Bname')

      expect(response.status).to eq 200
      expect(response.body).to eq 'Aname, Bname'
    end

    it 'returns "Aname, Bname, Cname"' do
      response = post('/sort-names', names: 'Bname,Aname,Cname')

      expect(response.status).to eq 200
      expect(response.body).to eq 'Aname, Bname, Cname'
    end

    it 'returns "Alice, Joe, Julia, Kieran, Zoe"' do
      response = post('/sort-names', names: 'Joe,Alice,Zoe,Julia,Kieran')

      expect(response.status).to eq 200
      expect(response.body).to eq 'Alice, Joe, Julia, Kieran, Zoe'
    end
  end
end
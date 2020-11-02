require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'server'

set :environment, :test

RSpec.describe 'Servers' do
    include Rack::Test::Methods

    def app
        Server
    end

    it 'get systems page' do 
        get '/systems'
        puts last_response.status
        expect(last_response.body).to include("Systems")
    end


end

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

    context 'Get to /systems' do
        let(:response) { get '/systems'}

        it 'return status 200' do 
            expect(response.status).to eq 200
        end

        it 'the page should include systems title' do
            expect(response.body).to include("Systems")
        end

        it 'should include link to S5B first system' do
            expect(response.body).to have_tag(:a, :href => '/systems/1', :text => 'S5B')
        end
    end


    context 'get to /systems/:id' do
        let(:response) { get '/systems/1'}
        it 'return status 200' do
            expect(response.status).to eq 200
        end

        it 'show S5B detailed system page' do
            expect(response.body).to have_tag(:h1, :text => 'S5B')
        end
        
    end


    context 'get /systems/new' do
        let(:response) { get '/systems/new'}
        it 'return status 200' do
            expect(response.status).to eq 200
        end
        it 'display a form that POST to /systems/create' do 
            expect(response.body).to have_tag(:form, :action => "/systems/create", :method => "post")
        end
        it 'display the input tags' do 
            expect(response.body).to have_tag(:input, :type => "text", :name => "model")
            expect(response.body).to have_tag(:input, :type => "text", :name => "username")
            expect(response.body).to have_tag(:input, :type => "text", :name => "password")
            expect(response.body).to have_tag(:input, :type => "text", :name => "comments")
            expect(response.body).to have_tag(:input, :type => "text", :name => "bmc_mac")
        end

    end

    context 'get /systems/' do
        let(:response) { get '/systems/'}

        it 'redirect to /systems' do 
            expect(response.status).to eq 302
        end
    end


    context 'post to /systems/create' do 
        let!(:response) { post '/systems/create', :model => "Seed" }
        it 'create a new system and saved in the system.yml file'
    end

end

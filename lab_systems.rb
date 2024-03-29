require 'rack'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/url_for' 
require 'sinatra/custom_logger'
require 'logger'
require 'socket'
require 'will_paginate'
require 'will_paginate/active_record'  # or data_mapper/sequel
require 'active_record'
require "sinatra/reloader"



class LabSystems < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  include WillPaginate::Sinatra::Helpers
  helpers Sinatra::CustomLogger
  helpers Sinatra::UrlForHelper

  Socket.do_not_reverse_lookup = true

  # Load library files
  puts "Root folder is #{settings.root}"
  Dir["#{settings.root}" + "/lib/**"].each do |lib|
    puts "loading #{lib}..."
    require lib
  end

  
  enable :method_override
  enable :logging
  set :sessions, true
  set :static, true
  set :public_folder, "#{settings.root}" + '/static'
  set :cache_control, :no_store
  set :show_exceptions, true
  logger = Logger.new(STDOUT)
  logger.level = Logger::DEBUG
  set :logger, logger
  # set :logger, Logger.new(STDOUT)

  configure :production do
    set :bind, '0.0.0.0'
    set server: 'thin'
  end

  configure :development do
    register Sinatra::Reloader
    after_reload do
      puts 'reloaded using Reloader'
    end
  end

  configure :development, :test do
    # puts "database file is #{settings.root}/db/systems.sqlite3"
    # set :database, {adapter: "sqlite3", database: "#{settings.root}/db/systems.sqlite3", timeout: 20000}
    # Move database configuration to config/database.yml
  end

  configure :development, :production do
    Dir.mkdir('log') unless File.exist?('log')
    # logger = Logger.new(File.open("#{root}/log/#{environment}.log", 'a'))
  end

  configure :test do
  end

end
    









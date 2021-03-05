require 'rack'
require 'sinatra/base'
require 'socket'
require 'logger'
require "sinatra/activerecord"
require 'will_paginate'
require 'will_paginate/active_record'  # or data_mapper/sequel

class LabSystems < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  include WillPaginate::Sinatra::Helpers
  # helpers Sinatra::CustomLogger

  Socket.do_not_reverse_lookup = true
  # Load all route files
  Dir[File.dirname(__FILE__) + "/app/routes/**"].each do |route|
    require route
  end

  # Load library files
  logger.info "Root folder is #{settings.root}"
  Dir["#{settings.root}" + "/lib/**"].each do |lib|
    puts "loading #{lib}..."
    require lib
  end

  
  enable :method_override
  set :sessions, true
  # set :logging, true
  set :public_folder, "#{settings.root}" + '/static'
  set :cache_control, :no_store
  logger.info "database file is #{settings.root}/db/systems.sqlite3"
  set :database, {adapter: "sqlite3", database: "#{settings.root}/db/systems.sqlite3", timeout: 20000}
  set :show_exceptions, true

  configure :production do
    set :bind, '0.0.0.0'
    set server: 'thin'
  end

  configure :development do
  end

  configure :development, :production do
    Dir.mkdir('log') unless File.exist?('log')
    logger = Logger.new(File.open("#{root}/log/#{environment}.log", 'a'))
    logger.level = Logger::DEBUG if development?
    set :logger, logger
  end

  configure :test do
  end

end
    









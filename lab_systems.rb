require 'rack'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/url_for' 
require 'sinatra/custom_logger'
require 'socket'
require 'logger'
require 'will_paginate'
require 'will_paginate/active_record'  # or data_mapper/sequel



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
  set :sessions, true
    # set :logging, true
  set :static, true
  set :public_folder, "#{settings.root}" + '/static'
  set :cache_control, :no_store
  set :show_exceptions, true

  configure :production do
    set :bind, '0.0.0.0'
    set server: 'thin'
    ActiveRecord::Base.logger.level = :info
  end

  configure :development do
#    ActiveRecord::Base.logger.level = :info
    register Sinatra::Reloader
    after_reload do
      puts 'reloaded'
    end
  end

  configure :development, :test do
    # puts "database file is #{settings.root}/db/systems.sqlite3"
    # set :database, {adapter: "sqlite3", database: "#{settings.root}/db/systems.sqlite3", timeout: 20000}
    # Move database configuration to config/database.yml
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
    









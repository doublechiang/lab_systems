require 'sinatra'
require 'system'
require 'system_store'
require 'socket'
require 'get_dhcpd_leases'
require 'ipmi_proxy'
require "sinatra/activerecord"

class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  Socket.do_not_reverse_lookup = true
  # Load all route files
  Dir[File.dirname(__FILE__) + "/app/routes/**"].each do |route|
    require route
  end

  enable :method_override
  set :sessions, true
  set :logging, true
  set :public_folder, File.dirname(__FILE__) + '/static'
  set :cache_control, :no_store
  set :database, {adapter: "sqlite3", database: "db/systems.sqlite3", timeout: 20000}

  if ENV["APP_ENV"] == "production"
    set :bind, '0.0.0.0'
    set :environment, :production
    set server: 'thin'
  end
 
  run! if app_file == $0

end
    









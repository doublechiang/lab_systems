require 'sinatra'
require 'system'
require 'system_store'
require 'nic'
require 'nic_store'
require 'socket'
require 'get_dhcpd_leases'
require 'ipmi_proxy'

class Server < Sinatra::Base

  Socket.do_not_reverse_lookup = true
  configure :production do
    set :port, 80
    set :public_folder, '/var/www/html'
  end

  # Load all route files
  Dir[File.dirname(__FILE__) + "/app/routes/**"].each do |route|
    require route
  end

  enable :method_override
  set :sessions, true
  set :logging, true
  set :bind, '0.0.0.0'
  set :public_folder, File.dirname(__FILE__) + '/static'

  if ENV["APP_ENV"] == "production"
    set :port, 80
  end
 

  get '/' do
    redirect '/index.html'
  end

  run! if app_file == $0

end
    









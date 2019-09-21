require 'sinatra'
require 'system'
require 'system_store'
require 'socket'
require 'get_dhcpd_leases'

set :sessions, true
set :logging, true
set :bind, '0.0.0.0'
set :port, 80
set :public_folder, '/var/www/html'
set :environment, :production

Socket.do_not_reverse_lookup = true


store = SystemStore.new('system.yml')

get '/' do
  redirect '/index.html'
end

get('/systems') do
  @systems = store.all
  leases = Lease.get_current
  @systems.each do |sys|
    if leases.has_key?(sys.bmc_mac.to_sym)
      sys.ipaddr = leases[sys.bmc_mac.to_sym].ipaddr
    end
  end

  erb :index
end

get('/systems/new') do
  erb :new
end

post('/systems/create') do
#    "Received: #{params.inspect}"
  @system = System.new
  @system.model = params['model']
  @system.comments = params['comments']
  @system.bmc_mac = params['bmc_mac']

  store.save(@system)
  redirect '/systems'

end

patch ('/systems/:id') do
#  puts "Received a request for ID: #{params['id']}"
  id = params['id'].to_i
  @system = System.new
  @system.id = id
  @system.model = params['model']
  @system.comments = params['comments']
  @system.bmc_mac = params['bmc_mac']
  store.save(@system)
  redirect "/systems"
end

delete ('/systems/:id') do 
#  puts "Delete receive a request for ID: #{params['id']}"
  id = params['id'].to_i
  store.delete id
  redirect '/systems'
end

get('/systems/:id') do
#  puts "Received a request for movie ID: #{params['id']}"
  id = params['id'].to_i
  @system = store.find(id)
  erb :show
end



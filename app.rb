require 'sinatra'
require 'system'
require 'system_store'

store = SystemStore.new('system.yml')

get('/systems') do
  @systems = store.all

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
  redirect '/systems/new'

end

get('/systems/:id') do
#  "Received a request for movie ID: #{params['id']}"
  id = params['id'].to_i
  @system = store.find(id)
  erb :show
end

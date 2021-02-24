require 'json'
require 'sinatra/base'

require 'lab_systems'
require 'inventory'
require 'nic'

class Inventories < LabSystems

    set :views, "views/inventories"

    get('/') do 
        @invs = Inventory.all
        erb :index
    end

    get('/:id') do
        @inv =Inventory.find(params['id'].to_i)
        @cpus = @inv.cpus.all
        @mems = @inv.mems.all
        @nics = @inv.nics.all
        @storage = @inv.storage.all
        @disks = @inv.disks.all
        @nvmes = @inv.nvmes.all
      
        erb :show
    end

    # Receive System configuratin to create the record.
    post('/create') do
#        puts "Received: #{params.inspect}"
        Inventory.procPayload(request.body.read)
        redirect '/'
    end
    

    error do
        "Please contact chunyu.chiang@qct.io for the error."
    end

    run! if __FILE__ == $0
end    



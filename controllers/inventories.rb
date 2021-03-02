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

    get('/cpus') do
        @cpus = Cpu.all
        erb :cpus
    end

    get('/mems') do
        @mems = Mem.all
        erb :mems
    end

    get('/nics') do
        @nics = Nic.all
        erb :nics
    end

    get('/storage') do
        @storage_all = Storage.all
        erb :storage
    end

    get('/disks') do
        @disks = Disk.all
        erb :disks
    end

    get('/nvmes') do
        @nvmes = Nvme.all
        erb :nvmes
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



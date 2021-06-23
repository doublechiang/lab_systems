require 'json'
require 'sinatra/base'
require 'logger'

require 'lab_systems'
require 'inventory'
require 'nic'

class Inventories < LabSystems

    set :views, "views/inventories"

    get('/') do 
        @invs = Inventory.all.order(:timestamp).reverse
        erb :index
    end

    get('/cpus') do
        @cpus = Cpu.all.order(:timestamp).reverse
        erb :cpus
    end

    get('/mems') do
        @mems = Mem.all.order(:timestamp).reverse
        erb :mems
    end

    get('/nics') do
        @nics = Nic.all.order(:timestamp).reverse
        erb :nics
    end

    get('/storage') do
        @storage_all = Storage.all.order(:timestamp).reverse
        erb :storage
    end

    get('/disks') do
        @disks = Disk.all.order(:timestamp).reverse
        erb :disks
    end

    get('/nvmes') do
        @nvmes = Nvme.all.order(:timestamp).reverse
        erb :nvmes
    end



    get('/:id') do
        @inv =Inventory.find(params['id'].to_i)

        r= @inv.cpus.order(:timestamp).last
        if r.nil?
            @cpus = @inv.cpus.all
        else
            @cpus = @inv.cpus.where(timestamp: r.timestamp).where.not(product: nil)
        end

        r = @inv.mems.order(:timestamp).last
        if r.nil?
            @mems = @inv.mems.all
        else
            @mems = @inv.mems.where(timestamp: r.timestamp).where.not(product: nil)
        end

        r = @inv.nics.order(:timestamp).last
        # Search for the last timestamp, if not found, then get all records
        if r.nil?
            @nics = @inv.nics.all
        else
            @nics = @inv.nics.where(timestamp: r.timestamp).where.not(product: nil)
        end

        r = @inv.storage.order(:timestamp).last
        if r.nil?
            @storage = @inv.storage.all
        else
            @storage = @inv.storage.where(timestamp: r.timestamp).where.not(description: [nil, ""])
        end

        r = @inv.disks.order(:timestamp).last
        if r.nil?
            @disks = @inv.disks.all
        else
            @disks = @inv.disks.where(timestamp: r.timestamp).where.not(description: nil)
        end

        r = @inv.nvmes.order(:timestamp).last
        if r.nil?
            @nvmes = @inv.nvmes.all
        else
            @nvmes = @inv.nvmes.where(timestamp: r.timestamp).where.not(model: nil)
        end
      
        erb :show
    end

    # Receive System configuratin to create the record.
    post('/create') do
        # puts "Received: #{params.inspect}"
        logger.info "Received: #{params.inspect}"
        Inventory.procPayload(request.body.read)
        redirect url_for '/'
    end

    

    error do
        "Please contact chunyu.chiang@qct.io for the error."
    end

    run! if __FILE__ == $0
end    



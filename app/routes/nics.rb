class Server < Sinatra::Base
    nicstore = NicStore.new('nic.yml')

    get('/nics') do
        @nics = nicstore.all
        leases = Lease.get_current
        @nics.each do |nic|
          if leases.has_key?(nic.mac1.downcase.to_sym)
            nic.ip1 = leases[nic.mac1.downcase.to_sym].ipaddr
          end
          if leases.has_key?(nic.mac2.downcase.to_sym)
            nic.ip2 = leases[nic.mac2.downcase.to_sym].ipaddr
          end
          if leases.has_key?(nic.mac3.downcase.to_sym)
            nic.ip3 = leases[nic.mac3.downcase.to_sym].ipaddr
          end
          if leases.has_key?(nic.mac4.downcase.to_sym)
            nic.ip4 = leases[nic.mac4.downcase.to_sym].ipaddr
          end
        end
        erb :"nics/index"
    end
      
    get('/nics/new') do
        erb :"nics/new"
    end
      
    post('/nics/create') do
      #    "Received: #{params.inspect}"
        @nic = Nic.new
        @nic.model = params['model']
        @nic.comments = params['comments']
        @nic.mac1 = params['mac1'].downcase
        @nic.mac2 = params['mac2'].downcase
        @nic.mac3 = params['mac3'].downcase
        @nic.mac4 = params['mac4'].downcase
      
        nicstore.save(@nic)
        redirect '/nics'
        
    end
      
    patch ('/nics/:id') do
      #  puts "Received a request for ID: #{params['id']}"
        id = params['id'].to_i
        @nic = Nic.new
        @nic.id = id
        @nic.model = params['model']
        @nic.comments = params['comments']
        @nic.mac1 = params['mac1'].downcase
        @nic.mac2 = params['mac2'].downcase
        @nic.mac3 = params['mac3'].downcase
        @nic.mac4 = params['mac4'].downcase
        nicstore.save(@nic)
        redirect "/nics"
    end
      
      delete ('/nics/:id') do 
      #  puts "Delete receive a request for ID: #{params['id']}"
        id = params['id'].to_i
        nicstore.delete id
        redirect '/nics'
      end
      
      get('/nics/:id') do
      #  puts "Received a request for movie ID: #{params['id']}"
        id = params['id'].to_i
        @nic = nicstore.find(id)
        erb :"nics/show"
      end
      
      
      
end

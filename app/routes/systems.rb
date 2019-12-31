
class Server < Sinatra::Base
    store = SystemStore.new('system.yml')

    get('/systems') do
        @systems = store.all
        leases = Lease.get_current
        @systems.each do |sys|
            if leases.has_key?(sys.bmc_mac.downcase.to_sym)
                sys.ipaddr = leases[sys.bmc_mac.downcase.to_sym].ipaddr
            end
        end
        erb :"systems/index"
    end
    
    get('/systems/new') do
        erb :"systems/new"
    end
    
    post('/systems/create') do
    #    "Received: #{params.inspect}"
        @system = System.new
        @system.model = params['model']
        @system.username=params['username']
        @system.password=params['password']
        @system.comments = params['comments']
        @system.bmc_mac = params['bmc_mac'].to_s.downcase
    
        store.save(@system)
        redirect '/systems'
    
    end
    
    patch ('/systems/:id') do
    #  puts "Received a request for ID: #{params['id']}"
        "Received: #{params.inspect}"
        id = params['id'].to_i
        @system = System.new
        @system.id = id
        @system.model = params['model']
        @system.username=params['username']
        @system.password=params['password']
        @system.comments = params['comments']
        @system.bmc_mac = params['bmc_mac'].to_s.downcase
        store.save(@system)
        redirect "/systems"
    end
    
    delete ('/systems/:id') do 
        puts "Delete receive a request for ID: #{params['id']}"
        id = params['id'].to_i
        store.delete id
        redirect '/systems'
    end
    
    get('/systems/:id') do
    #  puts "Received a request for movie ID: #{params['id']}"
        id = params['id'].to_i
        @system = store.find(id)
        leases = Lease.get_current
        if leases.has_key?(@system.bmc_mac.to_sym)
            @system.ipaddr = leases[@system.bmc_mac.to_sym].ipaddr
        end
        if @system.ipaddr && @system.username && @system.password
            conn = IpmiProxy.new(@system.ipaddr, @system.username, @system.password)
            @system.bios_ver = conn.get_bios_version
            @system.bmc_ver =  conn.get_bmc_version
            @system.cpld = conn.get_cpld
        end

        erb :"systems/show"
    end
  
end    

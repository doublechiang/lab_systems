require 'json'

class Server < Sinatra::Base

    set :views, "views/systems"
    enable :sessions

    @@store = SystemStore.new('system.yml')

    get('/systems/') do
        redirect('/systems')
    end

    get('/systems') do
        headers['Cache-Control'] = 'no-store'
        @systems = @@store.all
        leases = Lease.get_current
        @systems.each do |sys|
            if leases.has_key?(sys.bmc_mac.downcase.to_sym)
                sys.ipaddr = leases[sys.bmc_mac.downcase.to_sym].ipaddr
            end
        end
        if request.xhr?
            erb :'_systems_table', :layout => false, :locals => {:update => true}
        else
            erb :"index"
        end
    end

    
    get('/systems/new') do
        cache_control :no_store
        @errors = session[:errors]
        session[:errors] =  nil
        @system = session[:system]
        session[:system] = nil
        if !@system
            @system = System.new
        end
        erb :"new"
    end
    
    post('/systems/create') do
    #    "Received: #{params.inspect}"

        @system = System.new
        @system.model = params['model']
        @system.username=params['username']
        @system.password=params['password']
        @system.comments = params['comments']
        @system.bmc_mac = params['bmc_mac'].to_s.downcase


        if @@store.save(@system)
            redirect '/systems'
        else
            session[:errors] = "The system has already been added to QCT lab database - need a cup of coffee?"
            session[:system] = @system
            redirect '/systems/new'
        end
    
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
        @@store.save(@system)
        redirect "/systems"
    end
    
    delete ('/systems/:id') do 
        puts "Delete receive a request for ID: #{params['id']}"
        id = params['id'].to_i
        @@store.delete id
        redirect '/systems'
    end
    
    get('/systems/:id') do
        puts "Received a request for system ID: #{params['id']}"
        @system = get_system_from_store_by_id(params['id'].to_i)

        erb :"show"
    end

    get('/systems/:id/inband_mac') do 
        puts "Received inband_mac call request for system ID: #{params['id']}"
        @system = get_system_from_store_by_id(params['id'].to_i)
        erb :'_inband_mac', :layout => false, :locals => {:update => true}
    end

    get('/systems/:id/sys_info') do 
        puts "Received sys_info call request for system ID: #{params['id']}"
        @system = get_system_from_store_by_id(params['id'].to_i)
        erb :'_sys_info', :layout => false, :locals => {:update => true}
    end

    private

    def get_system_from_store_by_id (id)
        id = params['id'].to_i
        @system = @@store.find(id)
        @leases = Lease.get_current
        if @leases.has_key?(@system.bmc_mac.to_sym)
            @system.ipaddr = @leases[@system.bmc_mac.to_sym].ipaddr
        end
        @system
    end 




end    



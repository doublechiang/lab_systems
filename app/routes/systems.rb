require 'json'
require 'sinatra/base'
require 'system'

class Server < Sinatra::Base

    set :views, "views/systems"
    enable :sessions

    get('/systems/') do
        redirect('/systems')
    end

    get('/systems') do
        headers['Cache-Control'] = 'no-store'
        @systems = System.all
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


        begin
            @system.save 
        rescue => exception
            session[:errors] = "The system has already been added to QCT lab database - need a cup of coffee?"
            session[:system] = @system
            redirect '/systems/new'
        end
        redirect '/systems'

    end
    
    patch ('/systems/:id') do
        puts "Received a PATCH request for ID: #{params['id']}"
        # "Received: #{params.inspect}"
        id = params['id'].to_i
        params['bmc_mac'] = params['bmc_mac'].to_s.downcase
        sys =System.find_by(id: id)
        sys.model = params['model']
        sys.username=params['username']
        sys.password=params['password']
        sys.comments = params['comments']
        sys.bmc_mac = params['bmc_mac'].to_s.downcase
        begin
            sys.save
        rescue => exception
            puts exception.inspect
            session[:errors] = "The system has already been added to QCT lab database - need a cup of coffee?"
            redirect "/systems/#{id}"
        end
        redirect "/systems"
    end
    
    delete ('/systems/:id') do 
        puts "Delete receive a request for ID: #{params['id']}"
        sys = System.find_by(id: params['id'].to_i)
        sys.destroy
        redirect '/systems'
    end

    get('/systems/:id') do
        puts "Received a request for system ID: #{params['id']}"
        @errors = session[:errors]
        session[:errors] =  nil
        @system = get_system_from_store_by_id(params['id'].to_i)

        erb :"show"
    end

    get('/systems/:id/power_status') do
        @system = get_system_from_store_by_id(params['id'].to_i)
        return @system.getPowerStatus?
    end
    
    get('/systems/:id/inband_mac') do 
        @system = get_system_from_store_by_id(params['id'].to_i)
        erb :'_inband_mac', :layout => false, :locals => {:update => true}
    end


    get('/systems/:id/sys_info') do 
        @system = get_system_from_store_by_id(params['id'].to_i)
        erb :'_sys_info', :layout => false, :locals => {:update => true}
    end

    get('/systems/:id/con_logs') do 
        # puts "Receiving logs request #{params['id']}"
        @system = get_system_from_store_by_id(params['id'].to_i)
        erb :'conn_logs'
    end

    private

    def get_system_from_store_by_id (id)
        id = params['id'].to_i
        @system = System.find(id)
        @leases = Lease.get_current
        if @leases.has_key?(@system.bmc_mac.to_sym)
            @system.ipaddr = @leases[@system.bmc_mac.to_sym].ipaddr
        end
        @system
    end 




end    



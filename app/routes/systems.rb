require 'json'

class Server < Sinatra::Base

    set :views, "views/systems"

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
    
        @@store.save(@system)
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
    #  puts "Received a request for movie ID: #{params['id']}"
        id = params['id'].to_i
        @system = @@store.find(id)
        @leases = Lease.get_current
        if @leases.has_key?(@system.bmc_mac.to_sym)
            @system.ipaddr = @leases[@system.bmc_mac.to_sym].ipaddr
        end

        # move all of the BMC retrivals server sent events.

#        if @system.ipaddr && @system.username && @system.password
#            conn = IpmiProxy.new(@system.ipaddr, @system.username, @system.password)
#            @system.bios_ver = conn.get_bios_version
#            @system.bmc_ver =  conn.get_bmc_version
#        end

        erb :"show"
    end

    get('/systems/:id/system.json') do 
        content_type 'text/event-stream'

        stream :keep_open do |out|
        contents = {}
        id = params['id'].to_i
        @system = @@store.find(id)
        leases = Lease.get_current
        if leases.has_key?(@system.bmc_mac.to_sym)
            @system.ipaddr = leases[@system.bmc_mac.to_sym].ipaddr
        end

        if @system.ipaddr && !@system.username.empty? && !@system.password.empty?
            contents[:online] = true
            out << "data: "
            out << contents.to_json
            out << "\n\n"

            contents = {}
            contents= @system.get_bios_version
            out << "data: "
            out << contents.to_json
            out << "\n\n"

            contents = {}
            contents= @system.get_bmc_version
            out << "data: "
            out << contents.to_json
            out << "\n\n"

            contents={}
            contents=@system.get_board_id
            out << "data: "
            out << contents.to_json
            out << "\n\n"

            mac_ips = @system.get_system_macs_with_ip
            contents = {}
            contents[:mac_ips] = mac_ips
            out << "data: "
            out << contents.to_json
            out << "\n\n"

            # keep get_cpld in the last of the update, client will close it when receive it.
            contents = {}
            contents = @system.get_cpld
            out << "data: "
            out << contents.to_json
            out << "\n\n"
            else
                # do not have enough information to connect to server
                contents[:online] = false
                out << "data: "
                out << contents.to_json
                out << "\n\n"
            end 

            # puts @system.get_system_json
            out.callback {
                # delete the connections
                out.close()
            }
        end
    end
end    



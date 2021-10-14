require 'json'
require 'sinatra/base'
require 'logger'
require 'lab_systems'
require 'system'
require 'ipmi_proxy'
require 'get_dhcpd_leases'
require 'connection'


class MacAddressFormatError < StandardError
end

class Systems < LabSystems
    helpers Sinatra::CustomLogger
    set :views, "views/systems"

    get('/') do
        logger.debug "GET /"
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

    
    get('/new') do
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
    
    post('/create') do
    #    "Received: #{params.inspect}"

        @system = System.new
        @system.model = params['model']
        @system.username=params['username']
        @system.password=params['password']
        @system.comments = params['comments']
        bmc_mac = params['bmc_mac'].to_s.downcase
        bmc_mac.gsub!("-", ":")
        @system.bmc_mac = bmc_mac

        begin
            raise MacAddressFormatError.new "MAC address format wrong" unless @system.mac_valid?
            @system.save 

        rescue MacAddressFormatError
            session[:errors] = "MAC address format incorrect - need a cup of coffee?"
            session[:system] = @system
            redirect url_for '/new'
        rescue
            session[:errors] = "The system has already been added to QCT lab database - need a cup of coffee?"
            session[:system] = @system
            redirect url_for '/new'
        end

        redirect url_for '/'

    end
    
    patch ('/:id') do
        logger.debug "Received a PATCH request for ID: #{params['id']}"
        # "Received: #{params.inspect}"
        id = params['id'].to_i
        params['bmc_mac'] = params['bmc_mac'].to_s.downcase
        sys =System.find_by(id: id)
        sys.model = params['model']
        sys.username=params['username']
        sys.password=params['password']
        sys.comments = params['comments']
        bmc_mac = params['bmc_mac'].to_s.downcase
        bmc_mac.gsub!("-", ":")
        sys.bmc_mac = bmc_mac
    
        begin
            raise MacAddressFormatError.new "MAC address format wrong" unless sys.mac_valid?
            sys.save
        rescue MacAddressFormatError => e
            session[:errors] = "MAC address format incorrect - need a cup of coffee?"
            redirect url_for "/#{id}"

        rescue => e
            logger.error e.inspect
            session[:errors] = "The system has already been added to QCT lab database - need a cup of coffee?"
            redirect url_for "/#{id}"
        end
        redirect url_for '/'
    end

    # API to retrieve sel information
    post ('/:id') do
        logger.debug "Received a POST request for ID: #{params['id']}"
        # "Received: #{params.inspect}"
        @system = get_system_from_store_by_id(params['id'].to_i)
        @system.save_sels()
    end

    
    delete ('/:id') do 
        logger.debug "Delete receive a request for ID: #{params['id']}"
        sys = System.find_by(id: params['id'].to_i)
        sys.destroy
        redirect url_for '/'
    end

    get('/:id') do
        logger.debug "Received a request for system ID: #{params['id']}"
        @errors = session[:errors]
        session[:errors] =  nil
        @system = get_system_from_store_by_id(params['id'].to_i)

        erb :"show"
    end

    get('/:id/power_status') do
        @system = get_system_from_store_by_id(params['id'].to_i)
        return @system.getPowerStatus?
    end
    
    get('/:id/inband_mac') do 
        @system = get_system_from_store_by_id(params['id'].to_i)
        erb :'_inband_mac', :layout => false, :locals => {:update => true}
    end


    get('/:id/sys_info') do 
        @system = get_system_from_store_by_id(params['id'].to_i)
        erb :'_sys_info', :layout => false, :locals => {:update => true}
    end

    get('/:id/conn_logs') do 
        @system = get_system_from_store_by_id(params['id'].to_i)
        @cons = Connection.where(mac: @system.bmc_mac).order(:tod).reverse_order.paginate(page: params[:page], per_page: 40)
        erb :'_conn_logs'
   end

    get('/:id/sels') do 
        @system = get_system_from_store_by_id(params['id'].to_i)
        @sels = @system.sels.order(:timestamp).reverse_order.paginate(page: params[:page], per_page: 40)
        erb :'sels'
    end


    private

    def get_system_from_store_by_id (id)
        @system = System.find(id)
        @leases = Lease.get_current
        if @leases.has_key?(@system.bmc_mac.to_sym)
            @system.ipaddr = @leases[@system.bmc_mac.to_sym].ipaddr
        end
        @system
    end 

    error do
        "Please contact chunyu.chiang@qct.io for the error."
    end

    run! if __FILE__ == $0
end    



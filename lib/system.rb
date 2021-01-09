#require 'json'
require 'date'
require 'sinatra/activerecord'

# local require
require 'ipmi_sel'
require 'sel'

class System < ActiveRecord::Base
  attr_accessor :ipaddr
  attr_accessor :bios_ver, :bmc_ver, :cpld
  attr_accessor :sysmacs

  validates_presence_of :model, :bmc_mac
  has_many :sels, :dependent => :destroy

  # If the ip address and username password is persent, the it's is queryable
  def queryable?()
    puts ipaddr.inspect, username.inspect, password.inspect
    if (ipaddr && username && password)
      return !(ipaddr.empty? || username.empty? || password.empty?)
    end
  end

  # If get system_name will get the string, the the system is online
  # return true if get system name, othewise false
  def online?()
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      sys_name = conn.get_system_name.to_s
      if sys_name != ''
        con = Connection.new
        con.mac = bmc_mac
        con.user = username
        con.pass = password
        con.ip = ipaddr
        con.tod = DateTime.now
        con.save
        Thread.new {
          # Due to solite3 performance issue,we will delay write the sel processing to upmost 1 minutes later
          sleep rand(10..60)
          save_sels
        }
        return true
      end
    end
    return false
  end

  def getPowerStatus?()
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      conn.get_power_status
    end
  end

   # return true if use the credential can't get the correct name
  def offline?()
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      return conn.get_system_name.to_s == ''
    end
    return false
  end

  def get_cpld()
    # retrieve system information and save return json format
    content = {}
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      @cpld = conn.get_cpld
    end
  end

  def get_bios_version()
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      conn.get_bios_version
    end
  end

  def get_bmc_version()
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      conn.get_bmc_version
    end
  end

  def get_board_id()
    content = {}
    if queryable?
      # board_id is a has structure
      conn = IpmiProxy.new(ipaddr, username, password)
      content=conn.get_board_id
    end
    content
   end

  def get_system_mac()
    # Get in-band system macs and returned in an array form
    macs = []
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      macs = conn.get_system_mac
    end
    return macs
  end

  def get_system_macs_with_ip()
    # retreive the json format with system mac with matching IP.
    mac_ips = []
    sysmacs = get_system_mac
    leases = Lease.get_current
    sysmacs.each do |mac|
      ipaddr = nil
      if leases.has_key?(mac.to_sym)
        ipaddr = leases[mac.to_sym].ipaddr
      end
      pairs = { mac: mac, ipaddr: ipaddr }
      mac_ips << pairs
    end
    return mac_ips
  end

  # Query BMC to get sels and save into database without duplication
  def save_sels()
    content = ""
    if queryable?
      # board_id is a has structure
      conn = IpmiProxy.new(ipaddr, username, password)
      content=conn.get_sel_elist
      sellib = IpmiSel.new
      sel_content = sellib.parse(content)
      sel_content.each do |s|
        # calling collections to get dependent object 
        sel = sels.new
        reference = {}
        s.each do | key, value|
          # our field name is a lower case and replace the space with undercore
          field = key.downcase.tr(' ', '_')
          if field == 'timestamp' 
            value = DateTime.strptime(value, '%m/%d/%Y %H:%M:%S')
          end
          sel[field] = value
          reference[field] = value if value 
        end

        # reference do not hold the foreign key, add it manually.
        reference[:system_id] = sel[:system_id]
        # puts Sel.find(reference)
        Sel.exists?(reference)
        sel.save unless Sel.exists?(reference)
      end
      logger.info "Processed #{sel_content.length} sel records on system #{id} into database."
      return true
    end
  end

end

#sys = System.new
#sys.ipaddr = "10.16.0.22"
#sys.username = "admin"
#sys.password = "cmb9.admin"
#puts sys.get_system_mac
#puts sys.get_system_json

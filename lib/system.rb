#require 'json'
require 'date'
require 'sinatra/activerecord'
require 'logger'

# local require
require 'ipmi_sel'
require 'sel'

require_relative 'mylogger'

class System < ActiveRecord::Base
  include Mylogger
  attr_accessor :ipaddr
  attr_accessor :bios_ver, :bmc_ver, :cpld
  attr_accessor :sysmacs
  attr_accessor :device_id

  validates_presence_of :model, :bmc_mac
  has_many :sels, :dependent => :destroy
  has_many :connections, :dependent => :destroy


  # Adding validate uniquences in the model will result in exception in database save not working.
    
  # If the ip address and username password is persent, the it's is queryable
  def queryable?()
    logger.debug ("checking system queryable? #{self.id} #{ipaddr}, #{username}, #{password}")
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
        # logger.level = Logger::DEBUG
        con = self.connections.new
        con.mac = bmc_mac
        con.user = username
        con.pass = password
        con.ip = ipaddr
        con.tod = DateTime.now
        logger.debug con.inspect
        # puts con.inspect
        # Check last connetion record, if nothing change, just update tod.
        last = self.connections.last
        # last = Connection.where(mac: bmc_mac).last
        logger.debug "last record #{last.inspect}"
        if last && last.user == username && last.pass == password && last.ip == ipaddr
          last.tod = DateTime.now
          logger.debug "Update connection time to system #{self.id}, #{last.tod}"
          last.save
        else
          logger.debug "New connection time to sys #{self.id} #{con.tod}"
          con.save
        end
        Thread.new {
          # Due to sqlite3 performance issue,we will delay write the sel processing to upmost 1 minutes later
          sleep rand(0..10)
          save_sels
        }
        return true
      end
    end
    return false
  end

  # return the last access time.
  def last_access?
    last = self.connections.last
    logger.debug "self #{self.inspect}, last #{last.inspect}"
    tod =""
    tod = last.tod  if last != nil
  end

  def getPowerStatus?()
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      conn.get_power_status
    end
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
    
    if !device_id 
      device_id = get_product_id()
    end
    macs = []
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      macs = conn.get_system_mac device_id
    end
    return macs
  end

  def get_product_id()
    id = nil
    if queryable?
      conn = IpmiProxy.new(ipaddr, username, password)
      id = conn.get_product_id
      # logger.info "Product ID is #{id}"
    end
    id
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

  # return true if teh mac address fomat is valid
  def mac_valid?()
    bmc_mac.match?("^([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})")
  end

  private
 
  # convert the ipmi_sel hash entry to the ActiveRecord searchable hash
  def map_hash(sel)
    ref = {}
    sel.each do |key, value|
      # our field name is a lower case and replace the space with undercore
      field = key.downcase.tr(' ', '_')
      if field == 'timestamp' 
        value = DateTime.strptime(value, '%m/%d/%Y %H:%M:%S')
      end
      ref[field] = value if value
    end
    ref
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

      reference = {}
      # check the last sel entry if in databse
      # if it's in database, then we don't need to process.
      last_sel = sel_content[-1]
      if last_sel
        reference = map_hash(last_sel)
        sel = sels.new(reference)
        reference[:system_id] =  sel[:system_id]
        if not Sel.exists?(reference)
          # last sel is not in database, process whole sel entries to database
          sel_content.each do |s|
            reference = map_hash(s)
            sel = sels.new(reference)
            reference[:system_id] =  sel[:system_id]
            sel.save unless Sel.exists?(reference)
            logger.info "Processed #{sel_content.length} sel records on system #{id} into database."
          end
        else
          logger.info "Lastest SEL recored for system #{id} already in the database"
        end
      end
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

require 'json'
#require_relative 'ipmi_proxy'
#require_relative 'get_dhcpd_leases'

class System
  attr_accessor :model, :comments, :bmc_mac, :ipaddr, :id, :username, :password
  attr_accessor :bios_ver, :bmc_ver, :cpld
  attr_accessor :sysmacs

  def get_cpld()
    # retrieve system information and save return json format
    content = {}
    if (@ipaddr && @username && @password)
      conn = IpmiProxy.new(@ipaddr, @username, @password)
      @cpld = conn.get_cpld
      content = { cpld: @cpld }
    end
    return content
  end

  def get_bios_version()
    if (@ipaddr && !@username.empty? && !@password.empty? )
      conn = IpmiProxy.new(@ipaddr, @username, @password)
      bios_ver = conn.get_bios_version
      content = { bios: bios_ver }
    end
  end

  def get_bmc_version()
    if (@ipaddr && !@username.empty? && !@password.empty?)
      conn = IpmiProxy.new(@ipaddr, @username, @password)
      bmc_ver = conn.get_bmc_version
      content = { bmc: bmc_ver }
    end
  end

  def get_system_mac()
    # Get in-band system macs and returned in an array form
    macs = []
    if (@ipaddr && !@username.empty? && !@password.empty?)
      conn = IpmiProxy.new(@ipaddr, @username, @password)
      macs = conn.get_system_mac
    end
    return macs
  end

  def get_system_macs_with_ip()
    # retreive the json format with system mac with matching IP.
    mac_ips = []
    sysmacs = self.get_system_mac
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
end

sys = System.new
sys.ipaddr = "10.16.0.22"
sys.username = "admin"
sys.password = "cmb9.admin"
#puts sys.get_system_mac
#puts sys.get_system_json

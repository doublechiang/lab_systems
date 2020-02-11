#require_relative '../lib/ipmi_proxy.rb'
require 'json'

class System
  attr_accessor :model, :comments, :bmc_mac, :ipaddr, :id, :username, :password
  attr_accessor :bios_ver, :bmc_ver, :cpld
  attr_accessor :sysmacs

  def get_system_json()
    # retrieve system information and save return json format
    content = {}
    puts @ipaddr, @username, @password
    if (@ipaddr && @username && @password)
      conn = IpmiProxy.new(@ipaddr, @username, @password)
      @cpld = conn.get_cpld
      content = { cpld: @cpld }
    end
    return content.to_json
  end

end

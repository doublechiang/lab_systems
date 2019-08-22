#!/usr/bin/ruby -w

# list current active (non-expired) leases
# Author: Jiang Junyu

require 'date'
require 'time'
FILE="/var/lib/dhcpd/dhcpd.leases"

class Lease
  attr_accessor :ipaddr, :macaddr, :date, :time
  def initialize args
    args.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  # class method to turn an hash of current valid leases
  def self.get_current
    lease = ipaddr = macaddr=date=time=nil
    leases = Hash.new

# We are processing fixed dhcpd.lease format, no nested braces.
    f = File.open(FILE)
    f.each do |line|
      case line
      when /lease (.*) \{/
	ipaddr = $1
      when /hardware ethernet (.*);/
	macaddr = $1
      when /ends (.*);/
	date_fmt = $1.split()
	date, time = date_fmt[1], date_fmt[2]
      when /}/
	next if Date.parse(date) < Date.today 
	next if Time.parse(time) < Time.now && Date.parse(date) == Date.today

	lease = Lease.new(ipaddr: ipaddr, macaddr: macaddr, date: date, time: time)
	leases[macaddr.to_sym] = lease
      end
    end

    f.close
    leases
  end
end

leases = Lease.get_current
leases.each do |k, v|
  puts "#{v.ipaddr} \t#{v.macaddr}"
end

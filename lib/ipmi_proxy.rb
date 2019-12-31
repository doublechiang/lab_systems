#!/usr/bin/ruby -w

# IPMI wrapper to get system information from BMC.
# Author: Jiang Junyu

class IpmiProxy

    def initialize(host, username, password)
        @host = host
        @username = username
        @password = password
    end

    def get_bmc_version
        f= IO.popen("ipmitool -H #{@host} -U #{@username} -P #{@password} mc info")
        version=aux_version = 0
        next_line_is_aux = false
        f.each do |line|
            if next_line_is_aux
                aux_version = line
                aux_version = aux_version.to_i(16).to_s(16).rjust(2, "0")
                next_line_is_aux = false
            end
            case line
            when /Firmware Revision (.*) : (.*)/
                version=$2
            when /Aux Firmware Rev Info/
                next_line_is_aux = true
            end
        end
        f.close
        ret = version.to_s+"."+aux_version.to_s
        return ret.upcase
    end

    def get_bios_version
        f=IO.popen("ipmitool -H #{@host} -U #{@username} -P #{@password} raw 0x6 0x59 0x0 0x1 0x0 0x0")
        content = f.readlines.map(&:chomp).join.split
        content.shift(4)
        ret = ""
        for i in content
            ret += i.to_i(16).chr
        end
        f.close
        return ret
    end

    def get_cpld
        f=IO.popen("ipmitool -H #{@host} -U #{@username} -P #{@password} raw 0x30 0x17 3")
        version=f.readlines.join.strip
        f.close
        ret = version.upcase
        return ret
    end


end

conn=IpmiProxy.new("10.16.1.149", "root", "root")
#puts conn.get_bmc_version
#puts conn.get_bios_version
#puts conn.get_cpld


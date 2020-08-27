#!/usr/bin/ruby -w

# IPMI wrapper to get system information from BMC.
# Author: Jiang Junyu

require 'json'

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

    def get_board_id
        content= {}
        IO.popen("ipmitool -H #{@host} -U #{@username} -P #{@password} raw 0x6 0x52 0x7 0xa8 0x80 0x00 0") { |f|
            # Board ID sequential contents
            f.gets
            f.gets
            model = xxd_reverse_str f.gets
            mb_type = xxd_reverse_str f.gets
            f.gets
            bmc_chip = xxd_reverse_str f.gets
            customer_code = xxd_reverse_str f.gets
            date_code = xxd_reverse_str f.gets

            content = {
                    model: model,
                    mb_type: mb_type,
                    bmc_chip: bmc_chip,
                    customer_code: customer_code,
                    date_code: date_code
                }
	    }
        if $?.success?
            return content
        end
        return "Invalide command, check #{__LINE__}, #{__FILE__}"
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
	# There is special charater, use zero terminated string convert to array then get first element
        return ret.unpack('Z*')[0]
    end

    def get_cpld
        f=IO.popen("ipmitool -H #{@host} -U #{@username} -P #{@password} raw 0x30 0x17 3")
        version=f.readlines.join.strip
        f.close
        @cpld_ver = version.upcase
        return @cpld_ver
    end

    # return the systems mac address.
    def get_system_mac
        sysarray = []
        for i in 0..15 do
            f=IO.popen("ipmitool -H #{@host} -U #{@username} -P #{@password} raw 0x30 0x19 #{i} 0")
            if (mac = parse_ipmi_raw_mac_resp(f.readlines.join.strip)) != nil
                if mac.length != 0
                    sysarray << mac
                end
            end
            f.close
        end
        return sysarray
    end

    def get_system_name
        f=IO.popen("ipmitool -H #{@host} -U #{@username} -P #{@password} mc getsysinfo system_name")
        system_name =f.readlines.join.strip
        f.close
        return system_name
    end

    private
    def parse_ipmi_raw_mac_resp(macstr)
        strary = macstr.split
        strary.shift(2)
        if strary[0] != "ff"
            return strary.slice(0,6).join(":")
        else
            return nil
        end
    end

    def xxd_reverse_str(buf)
       if buf
            buf = buf.strip.split
            str = ""
            for i in buf
                str += i.to_i(16).chr
            end
            return str
        else
            return ""
        end
    end
end

#conn=IpmiProxy.new("10.16.0.170", "admin", "admin")
# conn=IpmiProxy.new("10.16.1.149", "root", "root")
#puts conn.get_bmc_version
#puts conn.get_bios_version
# puts conn.get_cpld
# conn.save
#puts conn.get_system_mac


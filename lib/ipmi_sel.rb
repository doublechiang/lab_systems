#!/usr/bin/ruby -w

require 'date'

# Ipmi Sel class libray
class IpmiSel
    # Parse sel elist -v format output in string array
    # return the sel entries array, sel attribute is defined hash
    def parse(buf)
        sels = []
        sel = nil
        buf.each do |line| 
#        buf.readlines.each do |line|
            if line.include?  'SEL Record ID'
                tokens = line.split(':', 2)
                key = tokens[0].strip
                value = tokens[1].strip
                sel = Hash.new
                sel[key] =value
                next
            elsif line.strip.to_s == ''
                if sel
                    sels << sel 
                    # puts sel
                    sel = nil
                end
                next
            end
            # for every other line items with a ':' semicolons in it, store it into the sel entry
            if sel
                if line.include? ':'
                    tokens = line.split(':', 2)
                    key = tokens[0].strip
                    value = tokens[1].strip
                    sel[key] = value
                end
            end
        end
        return sels
    end
end




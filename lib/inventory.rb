require 'sinatra/activerecord'
require 'json'
require 'date'

# class attribute is created by migration.
class Inventory < ActiveRecord::Base
    validates_presence_of :bmc_mac
    validates_uniqueness_of :bmc_mac
    has_many :nics, :dependent => :destroy
    has_many :cpus, :dependent => :destroy
    has_many :mems, :dependent => :destroy
    has_many :storage, :dependent => :destroy
    has_many :disks, :dependent => :destroy
    has_many :nvmes, :dependent => :destroy

    # class method to analysis payload 
    def self.procPayload(str)
        payload = JSON.parse(str)

        bmc_mac = payload['bmc']
        timestamp = payload['timestamp']
        # Have trouble to convert time, use system time now.
        timestamp=DateTime.now
        inv = Inventory.find_by(bmc_mac: bmc_mac)
        if inv == nil
            # sysetm not in the database, save all the inventories
            inv = Inventory.new
            inv.bmc_mac = bmc_mac
            inv.save
        end 

        # payload['nics'].each do |n|
        #     nic = inv.nics.new
        #     n.each do |k, v|
        #         # set activerecord attribute programmatically
        #         nic.send("#{k}=", v)
        #     end
        #     nic.save
        # end
        # payload['nics'].each do |n|
        #     nic = inv.nics.new(n)
        #     nic.save
        # end
        cpus = payload['cpus'].map { |n| 
            r = inv.cpus.new(n)
            r.timestamp = timestamp
            r
        }
        nics = payload['nics'].map { |n| 
            r = inv.nics.new(n) 
            r.timestamp= timestamp
            r
         }
        mems = payload['mems'].map { |n| 
            r= inv.mems.new(n)
            r.timestamp= timestamp
            r  
        }
        storage = payload['storage'].map { |n| 
            r= inv.storage.new(n)
            r.timestamp= timestamp
            r  
        }
        disks = payload['disks'].map { |n| 
            r= inv.disks.new(n)  
            r.timestamp= timestamp
            r  
            }
        nvmes = payload['nvmes'].map { |n| 
            r= inv.nvmes.new(n)
            r.timestamp= timestamp
            r  
          }

        
        # check latest configuration is match to the request, if not match update the config

        # Check CPUs
        latest_item = inv.cpus.order('timestamp').last
        if latest_item
            latest_sets =inv.cpus.where(timestamp: latest_item.timestamp).order('product').to_a.map(&:attributes)
            matching = 'product slot'.split()
            sets_in_hash = latest_sets.map { |a| a.slice(*matching) }
            req_inv = payload['cpus'].map { |a| a.slice(*matching)}
            if req_inv != sets_in_hash
                puts "Save the cpus records"
                cpus.each { |n| n.save }
            end
        else
            # Can't find any previous record, just save the record
            puts "Can't find any previous record, just save the record"
            cpus.each { |n| n.save }
        end

        # Check Mems
        latest_item = inv.mems.order('timestamp').last
        if latest_item
            latest_sets =inv.mems.where(timestamp: latest_item.timestamp).order('product').to_a.map(&:attributes)
            matching = 'product description vendor physid serial slot size'.split()
            sets_in_hash = latest_sets.map { |a| a.slice(*matching) }
            req_inv = payload['mems'].map { |a| a.slice(*matching)}
            if req_inv != sets_in_hash
                puts "Save the cpus records"
                mems.each { |n| n.save }
            end
        else
            # Can't find any previous record, just save the record
            puts "Can't find any previous record, just save the record"
            mems.each { |n| n.save }
        end

        # Check Storage
        latest_item = inv.storage.order('timestamp').last
        if latest_item
            latest_sets =inv.storage.where(timestamp: latest_item.timestamp).order('product').to_a.map(&:attributes)
            matching = 'product description vendor physid serial slot size'.split()
            sets_in_hash = latest_sets.map { |a| a.slice(*matching) }
            req_inv = payload['storage'].map { |a| a.slice(*matching)}
            if req_inv != sets_in_hash
                puts "Save the cpus records"
                storage.each { |n| n.save }
            end
        else
            # Can't find any previous record, just save the record
            puts "Can't find any previous record, just save the record"
            storage.each { |n| n.save }
        end

        # Check Disks
        latest_item = inv.disks.order('timestamp').last
        if latest_item
            latest_sets =inv.disks.where(timestamp: latest_item.timestamp).order('product').to_a.map(&:attributes)
            matching = 'description product version serial businfo'.split()
            sets_in_hash = latest_sets.map { |a| a.slice(*matching) }
            req_inv = payload['disks'].map { |a| a.slice(*matching)}
            if req_inv != sets_in_hash
                puts "Save the cpus records"
                disks.each { |n| n.save }
            end
        else
            # Can't find any previous record, just save the record
            puts "Can't find any previous record, just save the record"
            disks.each { |n| n.save }
        end

        # Check NVMEs
        latest_item = inv.nvmes.order('timestamp').last
        if latest_item
            latest_sets =inv.nvmes.where(timestamp: latest_item.timestamp).order('product').to_a.map(&:attributes)
            matching = 'product description vendor physid serial slot size'.split()
            sets_in_hash = latest_sets.map { |a| a.slice(*matching) }
            req_inv = payload['nvmes'].map { |a| a.slice(*matching)}
            if req_inv != sets_in_hash
                puts "Save the cpus records"
                nvmes.each { |n| n.save }
            end
        else
            # Can't find any previous record, just save the record
            puts "Can't find any previous record, just save the record"
            nvmes.each { |n| n.save }
        end

        # Check NICs
        latest_item = inv.nics.order('timestamp').last
        if latest_item
            puts "found latest timestamp #{latest_item.timestamp}"
            latest_sets =inv.nics.where(timestamp: latest_item.timestamp).order('product').to_a.map(&:attributes)
            matching = 'description product vendor businfo'.split()
            sets_in_hash = latest_sets.map { |a| a.slice(*matching) }
            req_nics = payload['nics'].map { |a| a.slice(*matching)}
            if req_nics != sets_in_hash
                puts "Configuration not matched, save new data sets #{nics}"
                nics.each { |n| n.save }
            end
        else
            nics.each { |n| n.save }
        end

 
    end

end
require 'sinatra/activerecord'
require 'json'
require 'date'
require 'logger'

#local require
require_relative 'cpu'
require_relative 'mem'
require_relative 'nic'
require_relative 'nvme'
require_relative 'storage'
require_relative 'disk'

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


    # class method (self) to analysis payload 
    def self.procPayload(str)
        logger.info "Processing payload...."
        payload = JSON.parse(str)

        bmc_mac = payload['bmc']
        product= payload['product']
        timestamp = payload['timestamp']
    
        # Have trouble to convert time, use system time now.
        timestamp=DateTime.now
        inv = Inventory.find_by(bmc_mac: bmc_mac)
        if inv !=  nil
            inv.destroy
        end

        inv = Inventory.new
        inv.bmc_mac = bmc_mac
        inv.product=product
        inv.timestamp = timestamp
        inv.save

        # production description might be update due to fru change, we update here first.

        cpus = list2AR(payload['cpus'], inv.cpus, timestamp)
        mems = list2AR(payload['mems'], inv.mems, timestamp)
        storage = list2AR(payload['storage'], inv.storage, timestamp)
        nics = list2AR(payload['nics'], inv.nics, timestamp)
        disks = list2AR(payload['disks'], inv.disks, timestamp)
        nvmes = list2AR(payload['nvmes'], inv.nvmes, timestamp)

        # previous implmention we save the last configuration. 
        # latest_item = inv.cpus.order('timestamp').last
        # if latest_item
        #     latest_sets =inv.cpus.where(timestamp: latest_item.timestamp).order('product').to_a.map(&:attributes)
        #     matching = 'product slot'.split()
        #     sets_in_hash = latest_sets.map { |a| a.slice(*matching) }
        #     req_inv = cpus.to_a.map { |a| a.slice(*matching)}
        #     if req_inv != sets_in_hash
        #         cpus.each { |n| n.save }
        #     end
        # else
        #     # Can't find any previous record, just save the record
        #     puts "Can't find any previous record, just save the record"
        #     cpus.each { |n| n.save }
        # end
    end

    private
    # transform pyload structure to list active record
    # return list of Acitve Record
    def self.list2AR(data, ar, timestamp)
        list_ar = data.map { |n|
            r=ar.new(n)
            r.timestamp = timestamp
            r
        }

        # save all records
        list_ar.each { |n| n.save }
        return list_ar


    end


end
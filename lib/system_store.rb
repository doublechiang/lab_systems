require 'yaml/store'

class SystemStore
  def initialize(file_name)
    @store = YAML::Store.new(file_name, thread_safe=true)
    @store.ultra_safe = true
  end

  def save(system)
    @store.transaction do
      # When save into database, if mac address is duplicated, then abort.
      saved_macs = @store.roots.map { |id| @store[id].bmc_mac }
      if saved_macs.include? system.bmc_mac
        @store.abort
      end

      unless system.id
        highest_id =@store.roots.max || 0
        system.id = highest_id + 1
      end
      @store[system.id] = system
    end
  end

  def all
    @store.transaction read_only=true do
      @store.roots.map { |id| @store[id] }
    end
  end

  def find(id)
    begin
	    @store.transaction read_only=true do
	      @store[id]
	    end
    rescue Excetion => e
	puts e.message
	puts e.backtrace.inspect
    end
  end

  def delete(id)
    @store.transaction do
      @store.delete id
    end
  end
end

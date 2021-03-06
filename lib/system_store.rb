require 'yaml/store'

class SystemStore

  # Phase out Yaml store method, please use ActiveRecord instead.
  extend Gem::Deprecate


  def initialize(file_name)
    @store = YAML::Store.new(file_name, thread_safe=true)
    @store.ultra_safe = true
  end

  def save(system)
    # Save system to the original file
    @store.transaction do
    unless system.id
      highest_id =@store.roots.max || 0
      system.id = highest_id + 1
    end
    @store[system.id] = system
      # When save into database, if mac address is duplicated and the id is different from the current one, then abort
      systems = @store.roots.map { |id| @store[id] }
      systems.each do |sys|
        if system.bmc_mac == sys.bmc_mac and system.id != sys.id
          @store.abort
        end
      end

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

  deprecate :save, "ActiveRecord", 2020, 12
  deprecate :all, "ActiveRecord", 2020, 12
  deprecate :find, "ActiveRecord", 2020, 12
  deprecate :delete, "ActiveRecord", 2020, 12


end

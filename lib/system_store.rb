require 'yaml/store'

class SystemStore
  def initialize(file_name)
    @store = YAML::Store.new(file_name)
  end

  def save(system)
    @store.transaction do
      unless system.id
        highest_id =@store.roots.max || 0
        system.id = highest_id + 1
      end
      @store[system.id] = system
    end
  end

  def all
    @store.transaction do
      @store.roots.map { |id| @store[id] }
    end
  end

  def find(id)
    @store.transaction read_only=true do
      @store[id]
    end
  end

  def delete(id)
    @store.transaction do
      @store.delete id
    end
  end
end

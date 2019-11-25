require 'yaml/store'

class NicStore
  def initialize(file_name)
    @store = YAML::Store.new(file_name)
  end

  def save(nic)
    @store.transaction do
      unless nic.id
        highest_id =@store.roots.max || 0
        nic.id = highest_id + 1
      end
      @store[nic.id] = nic
    end
  end

  def all
    @store.transaction do
      @store.roots.map { |id| @store[id] }
    end
  end

  def find(id)
    @store.transaction do
      @store[id]
    end
  end

  def delete(id)
    @store.transaction do
      @store.delete id
    end
  end
end

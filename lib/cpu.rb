require 'sinatra/activerecord'


# class attribute is created by migration.
class Cpu < ActiveRecord::Base
    belongs_to :inventory

end
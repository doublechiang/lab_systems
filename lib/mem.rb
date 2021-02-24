require 'sinatra/activerecord'


# class attribute is created by migration.
class Mem < ActiveRecord::Base
    belongs_to :inventory

end
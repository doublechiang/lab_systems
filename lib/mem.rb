require 'sinatra/activerecord'


# class attribute is created by migration, looking for attribute in the db:schema
class Mem < ActiveRecord::Base
    belongs_to :inventory

end
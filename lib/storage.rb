require 'sinatra/activerecord'


# class attribute is created by migration.
class Storage < ActiveRecord::Base
    belongs_to :inventory

end
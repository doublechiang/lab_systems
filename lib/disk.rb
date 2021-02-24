require 'sinatra/activerecord'


# class attribute is created by migration.
class Disk < ActiveRecord::Base
    belongs_to :inventory

end
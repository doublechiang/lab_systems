require 'sinatra/activerecord'


# class attribute is created by migration.
class Nic < ActiveRecord::Base
    belongs_to :inventory

end
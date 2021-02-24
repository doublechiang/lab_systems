require 'sinatra/activerecord'


# class attribute is created by migration.
class Nvme < ActiveRecord::Base
    belongs_to :inventory

end
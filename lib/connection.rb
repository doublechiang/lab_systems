#!/usr/bin/ruby -w

require 'sinatra/activerecord'


# class attribute is created by migration.
class Connection < ActiveRecord::Base
    validates_presence_of :mac, :user, :pass, :ip, :tod
    belongs_to :system
end
#!/usr/bin/ruby -w

require 'sinatra/activerecord'


# class attribute is created by migration.
class Sel < ActiveRecord::Base
    validates_presence_of :sel_record_id, :timestamp
    belongs_to :system
end
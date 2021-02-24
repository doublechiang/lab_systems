require 'sinatra/base'
Dir.glob('./{lib,controllers}/*.rb').each { |file| require file }

map('/inventories') { run Inventories }
map('/systems') { run Systems}
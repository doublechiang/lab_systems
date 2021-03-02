require 'sinatra/base'
# require 'sinatra/custom_logger'
Dir.glob('./{lib,controllers}/*.rb').each { |file| require file }

map('/inventories') { run Inventories }
map('/systems') { run Systems}
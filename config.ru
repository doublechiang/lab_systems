# require 'rack'
require 'sinatra/base'

# require 'sinatra/custom_logger'
Dir.glob('./{lib,controllers}/*.rb').each { |file| require file }

map('/inventories') { run Inventories }
map('/systems') { run Systems}


# run Rack::URLMap.new "/systems" => Systems.new, "/inventories" => Inventories.new


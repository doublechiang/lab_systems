# require 'rack'
require 'sinatra/base'
require 'sinatra/custom_logger'
require 'logger'

$LOAD_PATH.unshift('lib')

Dir.glob('./{lib,controllers}/*.rb').each { |file| require file }

map('/inventories/') { run Inventories }
map('/systems/') { run Systems}


# run Rack::URLMap.new "/systems" => Systems.new, "/inventories" => Inventories.new


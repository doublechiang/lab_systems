# lab_systems
Manage the Lab Server

WEBrick very slow, check the solution from https://stackoverflow.com/questions/1156759/webrick-is-very-slow-to-respond-how-to-speed-it-up

Changed the source of ruby code /share/ruby/webrick/server.rb to remove dns lookup, otherwise it's very slow


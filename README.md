# lab_systems


Manage the Lab Server

# Preface
Due to we hardly know which IP address to the systems in the lab. So it's the simple web management to read the DHCP serve leases.
And show the matching IP address if you register the MAC on the system.


# Problem when deploy

WEBrick very slow, check the solution from https://stackoverflow.com/questions/1156759/webrick-is-very-slow-to-respond-how-to-speed-it-up
Changed the source of ruby code /share/ruby/webrick/server.rb to remove dns lookup, otherwise it's very slow

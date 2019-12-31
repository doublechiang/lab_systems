# lab_systems


Manage the Lab Server

## Preface
Due to we hardly know which IP address to the systems in the lab. So it's the simple web management to read the DHCP serve leases.
And show the matching IP address if you register the MAC on the system.

## Description
Can add/edit/delete a system's description with MAC address. This application will read the DHCP server's lease files, check the lease validation.
If the systems in the database has MAC matching the leases file MAC address, it will show the IP address on that server.

## Testing
Since it will check the current time.
You can copy dhcpd.leases file from the server to get the working valid sample.
scp cchiang@10.16.0.1:/var/lib/dhcpd/dhcpd.leases .


## Problem when deploy

WEBrick very slow, check the solution from https://stackoverflow.com/questions/1156759/webrick-is-very-slow-to-respond-how-to-speed-it-up
Changed the source of ruby code /share/ruby/webrick/server.rb to remove dns lookup, otherwise it's very slow

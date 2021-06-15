# lab_systems
Manage the Lab Server

## Preface
Due to we hardly know which IP address to the systems in the lab. So it's the simple web management to read the DHCP serve leases.
And show the matching IP address if you register the MAC on the system.

## Description
Can add/edit/delete a system's description with MAC address. This application will read the DHCP server's lease files, check the lease validation.
If the systems in the database has MAC matching the leases file MAC address, it will show the IP address on that server.

## Installation & Deployment
support bundle, use "bundle install" to update the required module.
database: use ActiveRecord
bundle exec rake -I lib db:migrate
### mySql database
mysql> CREATE USER 'lab_systems'@'localhost' IDENTIFIED BY 'password';
mysql> GRANT ALL PRIVILEGES ON * . * TO 'lab_systems'@'localhost';


## Development
$ gem install bundler first
$ bundle install
### Ubuntu & Debian
sudo apt-get install libmysqlclient-dev
sudo apt-get install ruby-dev
sudo apt-get install libssl-dev
apt-get install libsqlite3-dev

Since it will check the current time.
You can copy dhcpd.leases file from the server to get the working valid sample.
$ rake development
### in WSL, start mysql service.
Start sudo /etc/init.d/mysql start 
If the service can't be started due to "mysqld_safe Directory '/var/run/mysqld' for UNIX socket file don't exists"
sudo mkdir -p /var/run/mysqld 
sudo chown mysql:mysql /var/run/mysqld

## Testing
Use bundle exec rake to test the application, default is to run the spec with rspec

## Problem when deploy

WEBrick very slow, check the solution from https://stackoverflow.com/questions/1156759/webrick-is-very-slow-to-respond-how-to-speed-it-up
Changed the source of ruby code /share/ruby/webrick/server.rb to remove dns lookup, otherwise it's very slow


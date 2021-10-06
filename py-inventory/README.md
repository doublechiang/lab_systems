# py-inventory
Python program to list out inventory on a system.


# Install Dependency
pip3 install -r requirements.txt

## WSL Debian development environment.
sudo apt-get install rubygems
sudo apt-get install bundler
sudo apt-get install rails

# Running Test unit
python -m unittest discover

# sending the json file to target
inventory.py -file seeds/s5b.json --target http://localhost:9292/inventories/create


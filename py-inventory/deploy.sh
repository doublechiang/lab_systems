#!/bin/bash
yum install -y python3
pip3 install -r /mnt/smbfs/py-inventory/requirements.txt
python3 /mnt/smbfs/py-inventory/inventory.py --target http://10.16.0.1/inventories/create

#!/bin/bash
yum install -y python3
# ssl error correction, https://stackoverflow.com/questions/49324802/pip-always-fails-ssl-verification
pip3 install -r /mnt/smbfs/py-inventory/requirements.txt  --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org
python3 /mnt/smbfs/py-inventory/inventory.py --target http://10.16.0.1/inventories/create

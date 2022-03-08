#!/bin/bash -v
echo "userdata-start"
# yum update -y
# yum install -y git python37
apt-get update
apt-get install -y git python37
cd /root/
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
git clone http://github.com/bootcamp-institute-aws/bootcamp-module-sre
cd ~/bootcamp-module-sre/backend/
pip install -r requirements.txt
nohup gunicorn -w 3 -b 0.0.0.0:8000 app:app &
echo "userdata-end"

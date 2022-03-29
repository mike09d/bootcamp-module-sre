#!/bin/bash -v
sudo amazon-linux-extras enable docker
sudo yum -y install docker

sudo tee /etc/docker/daemon.json<<EOF
{
  "bridge": "none",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "10"
  },
  "live-restore": true,
  "max-concurrent-downloads": 10
}
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now docker
systemctl status docker
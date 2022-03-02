#!/bin/sh

# Install Docker
apt update
apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/docker.gpg --import
chmod 644 /etc/apt/trusted.gpg.d/docker.gpg
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt -y install docker-ce docker-ce-cli containerd.io

# Install Docker-Compose
curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url  | grep docker-compose-linux-x86_64 | cut -d '"' -f 4 | wget -qi -
chmod +x docker-compose-linux-x86_64
mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose

# Configure Jitsi-Meet-Torture
cd /root/docker
docker-compose build
docker-compose pull

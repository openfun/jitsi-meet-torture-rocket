#!/bin/sh

# Launch Jitsi-Meet-Torture
cd /root/docker
docker-compose up -d selenium-hub
docker-compose up -d selenium-node --scale selenium-node=3
docker-compose up jitsi-torture

# Shutdown the instance when Jitsi-Meet-Torture has exited
shutdown now

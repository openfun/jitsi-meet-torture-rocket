#!/bin/sh

# Move into the Docker working directory
cd /root/docker

# Launch Jitsi-Meet-Torture
docker-compose up jitsi-torture > /var/log/jitsi-meet-torture.log

# Shutdown the instance when Jitsi-Meet-Torture has exited
shutdown now

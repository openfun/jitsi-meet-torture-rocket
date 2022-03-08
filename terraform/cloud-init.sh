#!/bin/sh

# Move into the Docker working directory
cd /root/docker

# Configure env variables at runtime
sed -i -e "s/MALLEUS_ROOM_NAME_PREFIX=.*/MALLEUS_ROOM_NAME_PREFIX=${room_prefix}${stack}-/" .env
sed -i -e "s/MALLEUS_PARTICIPANTS=.*/MALLEUS_PARTICIPANTS=${participants_per_instance}-/" .env

# Launch Jitsi-Meet-Torture
docker-compose up -d selenium-hub
docker-compose up -d selenium-node --scale selenium-node=${selenium_nodes}
docker-compose up jitsi-torture

# Shutdown the instance when Jitsi-Meet-Torture has exited
shutdown now

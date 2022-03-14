#!/bin/sh

# Move into the Docker working directory
cd /root/docker

# Configure env variables at runtime
sed -i -e "s/MALLEUS_ROOM_NAME_PREFIX=.*/MALLEUS_ROOM_NAME_PREFIX=${room_prefix}${stack}-/" ../env.d/docker
sed -i -e "s/MALLEUS_PARTICIPANTS=.*/MALLEUS_PARTICIPANTS=${participants_per_instance}/" ../env.d/docker

# Launch Jitsi-Meet-Torture environment
docker-compose up -d selenium-hub
docker-compose up -d selenium-node --scale selenium-node=${selenium_nodes}

if [ -z "${scheduled_start_time}" ]; then
    /root/start.sh
else
    at ${scheduled_start_time} -f /root/start.sh
fi

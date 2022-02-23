# jitsi-meet-torture-docker

This repository aims at simplifying the use of jitsi-meet-torture, specifically for load testing. A selenium hub is created, so that multiple connections, with or without video/audio, can connect to given jitsi instance.

## Prerequisite

Make sure you have a recent version of [Docker](https://docs.docker.com/install)
and [Docker Compose](https://docs.docker.com/compose/install) installed on your
laptop:

```bash
$ docker -v
  Docker version 20.10.12, build e91ed57

$ docker-compose --version
  docker-compose version v2.2.3
```

## Usage

### Environment variables

Before running the hub, you must create a `.env` file. It is recommended to copy `.env.template` file with `cp .env.template .env`, and then modify the variables as needed.

### Run

To run with docker-compose, 

```shell
docker-compose up
    -d
    --scale selenium-node=5
    --build
```

Scale selenium nodes as needed for the test. The number of selenium nodes must be equal or greater than number of participants.

To see logs of the test, 

```shell
docker logs -f jitsi-torture
```

Don't forget to run `docker-compose down` when done testing.

## Monitoring (with Prometheus)

A Prometheus exporter may be used to monitor the Selenium hub and expose some metrics:

Name | Description
--- | ---
`selenium_grid_hub_sessions_backlog`|number of waiting sessions
`selenium_grid_hub_slotsFree`|number of free nodes
`selenium_grid_hub_slotsTotal`|total number of nodes
`selenium_grid_up`|boolean that indicates if the hub is up

To enable it, just uncomment the corresponding lines in the docker-compose file. Metrics are exported on port `8080` and on path `/metrics`.

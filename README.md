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

Scale selenium nodes as needed for the test.

To see logs of the test, 

```shell
docker logs -f jitsi-torture
```

Don't forget to run `docker-compose down` when done testing.

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

## Architecture

This repository is composed of three parts:

- A [Docker](https://www.docker.com) project which include the [Jitsi-Meet-Torture](https://github.com/jitsi/jitsi-meet-torture).

- A [Packer](https://www.packer.io) project, whose goal is to build an image with docker and docker-compose on it.

- A [Terraform](https://www.terraform.io/) project which deploys the docker project on the image, and launch the tests.

We use [Scaleway](https://www.scaleway.com/) as the cloud provider.

## Getting started

### GPG secret key

To use the Packer project, you will need an SSH key. There are two commands to manage encryption of the private key. We use [GnuPG](https://gnupg.org) for encryption.

- Execute: ```make encrypt_key```to encrypt the secret key with the passphrase you specified as an environnement variable.
- Execute: ```make decrypt_key```to decrypt the secret key from secrets.key.gpg.

### Environment variables

Before running the hub, you need to provide the required environnement variables to authentificate on Scaleway, provide the GPG key and the size of the tests you want to perform.

You can initialize the `.env` file by executing the following command:

```
make bootstrap
```

Then, edit this file with your credentials and the values you want for the tests.

- The number of selenium nodes depends on the size of the tests you want to perform.
- According to this, you can use either bigger or smaller instance on Scaleway for the JMT image and the instance type.

### Run

To run the project, execute the following command:

```
make build
```

## Monitoring (with Prometheus)

A Prometheus exporter may be used to monitor the Selenium hub and expose some metrics:

Name | Description
--- | ---
`selenium_grid_hub_sessions_backlog`|number of waiting sessions
`selenium_grid_hub_slotsFree`|number of free nodes
`selenium_grid_hub_slotsTotal`|total number of nodes
`selenium_grid_up`|boolean that indicates if the hub is up

To enable it, just uncomment the corresponding lines in the docker-compose file. Metrics are exported on port `8080` and on path `/metrics`.

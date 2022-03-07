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
To improve interaction with the Cloud provider and enable remote command line control over the image, make sure you have a recent version of [Scaleway CLI](https://github.com/scaleway/scaleway-cli):

```
$ brew install scw

$ scw init
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

- `TF_VAR_number_of_selenium_node` defines the number of selenium nodes which depends on the size of the tests you want to perform. One selenium node is equivalent to one participant in a conference.

- `SCALEWAY_INSTANCE_TYPE` defines the size of the JMT image you want to use. You can use either bigger or smaller instance on Scaleway. A Dev-S size is equivalent to two participants.

### Run

To run the project, execute the following command:

```
make build
```

This command makes sure the image you are trying to create isn't already created. If so, the image is deleted before building.

## Monitoring (with Prometheus)

A Prometheus exporter may be used to monitor the Selenium hub and expose some metrics:

Name | Description
--- | ---
`selenium_grid_hub_sessions_backlog`|number of waiting sessions
`selenium_grid_hub_slotsFree`|number of free nodes
`selenium_grid_hub_slotsTotal`|total number of nodes
`selenium_grid_up`|boolean that indicates if the hub is up

To enable it, just uncomment the corresponding lines in the docker-compose file. Metrics are exported on port `8080` and on path `/metrics`.

## Cleaning

If you want to delete the image and the snapshot created, you can execute the following command :

```
make destroy
```

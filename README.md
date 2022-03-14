# Jitsi-Meet-Torture Rocket

This repository aims at simplifying the use of [Jitsi-Meet-Torture](https://github.com/jitsi/jitsi-meet-torture), specifically for load testing. A selenium hub is created, so that multiple connections, with or without video/audio, can be made to a given Jitsi instance.

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

- A [Docker](https://www.docker.com) project to manipulate the [Jitsi-Meet-Torture](https://github.com/jitsi/jitsi-meet-torture) repository.
Before running the hub, you must create an env file. It is recommended to copy the `env.d/docker.dist` file with `cp env.d/docker.dist env.d/docker`, and then modify the variables as needed.

- A [Packer](https://www.packer.io) project, whose goal is to build an image with docker and docker-compose on it and with pre-installed Jitsi-Meet-Torture.

- A [Terraform](https://www.terraform.io/) project which deploys the docker project on the image on multiple instances, and launches the tests.

We use [Scaleway](https://www.scaleway.com/) as the cloud provider, but PRs are welcome to add other cloud providers. We also use the [Scaleway CLI](https://github.com/scaleway/scaleway-cli), which allows us to control deletion and creation of Jitsi-Meet-Torture instances.

## Getting started

### GPG secret key

To use the Packer project, you will need an SSH key. There are two commands to manage encryption of the private key. We use [GnuPG](https://gnupg.org) for encryption.

- Launch `make encrypt-key` to encrypt the secret key with the passphrase you specified as an environnement variable.
- Launch `make decrypt-key` to decrypt the secret key from the `secrets.key.gpg` file.

### Environment variables

Before launching the tests, you need to provide the required environment variables to authentificate on Scaleway and the GPG key. You may also edit the environment variables to deit the configuration.

### Build

To build the image, execute the following command:

```bash
make build
```

This command makes sure the image you are trying to create isn't already created. If so, the image is deleted before the build.

### Run

To apply the terraform configuration and launch the tests, you can execute the following command:

```
make apply
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

## Cleaning

If you want to delete the created image and the snapshot, you can execute the following command:

```
make destroy-images
```

You can also clean the terraform ressources with:

```
make destroy-terraform
```

You can even do both with:

```
make destroy
```

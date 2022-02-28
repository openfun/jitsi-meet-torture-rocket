terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
      version = "2.2.0"
    }
  }

  backend "s3" {
    bucket = "jitsi-k8s-terraform"
    key = "torture.tfstate"
    region = "fr-par"
    endpoint = "https://s3.fr-par.scw.cloud"
    skip_region_validation = true
    skip_credentials_validation = true
  }

  required_version = ">= 0.15"
}

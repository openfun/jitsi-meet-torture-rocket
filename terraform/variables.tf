variable "jmt_size" {
  type        = map(number)
  description = "The list of the different size available on Scaleway"

  default     = {
    "DEV1-S"    = 0.01,
    "DEV1-M"    = 0.02,
    "DEV1-L"    = 0.04,
    "DEV1-XL"   = 0.06
  }
}

variable "jmt_instance_size" {
  type        = string
  description = "The size of the Scaleway instances to use for the JMT instances"

  # Available sizes with their corresponding prices are described 
  # on https://www.scaleway.com/en/pricing/
  default = "DEV1-S"
}

variable "jmt_image_name" {
  type        = string
  description = "Name of the image created by Packer"

  default = "jmt-image"
}

variable "jmt_conferences" {
  type        = number
  description = "The number of different JMT conferences"

  default = 1
}

variable "jmt_participants_per_conference" {
  type        = number
  description = "The number of JMT participants in each conference"

  default = 2
}

variable "jmt_participants_per_instance" {
  type        = number
  description = "The number of JMT participants per instance (to be adapted with instance size)"

  default = 2
}

variable "jmt_room_prefix" {
  type        = string
  description = "The prefix of the rooms for the JMT tests"

  default = "scalingteam"
}

locals {
  jmt_stacks = var.jmt_conferences
  jmt_instances_per_stack = ceil(var.jmt_participants_per_conference / var.jmt_participants_per_instance)
  jmt_selenium_nodes = var.jmt_participants_per_instance
}

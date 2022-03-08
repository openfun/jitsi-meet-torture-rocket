variable "jmt_instance_size" {
  type        = string
  description = "The size of the Scaleway instances to use for the JMT instances"

  # Available sizes with their corresponding prices are described 
  # on https://www.scaleway.com/en/pricing/
  default = "DEV1-S"
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

variable "jmt_stacks" {
  type        = number
  description = "The number of stacks of JMT instances to deploy"

  default = var.jmt_conferences
}

variable "jmt_instances_per_stack" {
  type        = number
  description = "The number of JMT instances per stack to deploy"

  default = ceil(var.jmt_participants_per_conference / var.jmt_participants_per_instance)
}

variable "jmt_selenium_nodes" {
  type        = number
  description = "The number of selenium nodes for the JMT tests"

  default = var.jmt_participants_per_instance
}

variable "jmt_room_prefix" {
  type        = string
  description = "The prefix of the rooms for the JMT tests"

  default = "scalingteam"
}

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
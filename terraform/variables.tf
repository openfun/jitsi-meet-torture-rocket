variable "jmt_instance_size" {
  type        = string
  description = "The size of the Scaleway instances to use for the JMT instances"

  # Available sizes with their corresponding prices are described 
  # on https://www.scaleway.com/en/pricing/
  default = ""
}

variable "jmt_replicas_per_stack" {
  type        = number
  description = "The number of JMT instances per stack to deploy"

  default = 5
}

variable "jmt_stacks" {
  type        = number
  description = "The number of stacks of JMT instances to deploy"

  default = 18
}

variable "jmt_room_prefix" {
  type        = string
  description = "The prefix of the rooms for the JMT tests"

  default = "scalingteam"
}

variable "jmt_selenium_nodes" {
  type        = number
  description = "The number of selenium nodes for the JMT tests"

  default = 0
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
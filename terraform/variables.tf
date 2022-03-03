variable "jmt_instance_size" {
  type        = string
  description = "The size of the Scaleway instances to use for the JMT instances"

  # Available sizes with their corresponding prices are described 
  # on https://www.scaleway.com/en/pricing/
  default = "DEV1-M"
}

variable "jmt_replicas_per_stack" {
  type        = number
  description = "The number of JMT instances per stack to deploy"

  default = 2
}

variable "jmt_stacks" {
  type        = number
  description = "The number of stacks of JMT instances to deploy"

  default = 2
}

variable "jmt_room_prefix" {
  type        = string
  description = "The prefix of the rooms for the JMT tests"

  default = "scalingteam"
}

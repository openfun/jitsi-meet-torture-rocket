variable "jmt_instance_size" {
  type        = string
  description = "The size of the Scaleway instances to use for the JMT instances"

  # Available sizes with their corresponding prices are described 
  # on https://www.scaleway.com/en/pricing/
  default = "DEV1-M"
}

variable "jmt_replicas" {
  type        = number
  description = "The number of JMT instances to deploy"

  default = 2
}

# We fetch the ID of the image that was built with Packer
data "scaleway_instance_image" "jmt_image" {
  name = "jmt-image"
}

# We create one IP address for each instance that we will
# deploy on Scaleway
resource "scaleway_instance_ip" "jmt_ip" {
  count = var.jmt_replicas_per_stack * var.jmt_stacks
}

# We create the JMT Scaleway instances
resource "scaleway_instance_server" "jmt_instance" {
  count = var.jmt_replicas_per_stack * var.jmt_stacks

  name  = "jmt-${count.index}"
  type  = var.jmt_instance_size
  image = data.scaleway_instance_image.jmt_image.id
  ip_id = scaleway_instance_ip.jmt_ip[count.index].id

  # Configuration options of the instance with cloud-init
  # are described on https://cloudinit.readthedocs.io/en/latest
  user_data = {
    cloud-init = templatefile("${path.module}/cloud-init.sh", { 
        stack = count.index % var.jmt_stacks
        room_prefix = var.jmt_room_prefix
        selenium_nodes = var.jmt_selenium_nodes
    })
  }
}

# We print the IP addresses of JMT instances
output "jmt_ip_addresses" {
  value = [for ip in scaleway_instance_ip.jmt_ip : ip.address]
}

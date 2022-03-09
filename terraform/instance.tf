# We fetch the ID of the image that was built with Packer
data "scaleway_instance_image" "jmt_image" {
  name = var.jmt_image_name
}

# We create one IP address for each instance that we will
# deploy on Scaleway
resource "scaleway_instance_ip" "jmt_ip" {
  count = var.jmt_instances_per_stack * var.jmt_stacks
}

# We create the JMT Scaleway instances
resource "scaleway_instance_server" "jmt_instance" {
  count = var.jmt_instances_per_stack * var.jmt_stacks

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
        participants_per_instance = var.jmt_participants_per_instance
    })
  }
}

# We print the IP addresses of JMT instances
output "jmt_ip_addresses" {
  value = [for ip in scaleway_instance_ip.jmt_ip : ip.address]
}

# We print the price of the deployment
output "price" {
  value = join(" ",[tostring(var.jmt_replicas_per_stack * var.jmt_stacks * var.jmt_size[var.jmt_instance_size]),"€/h"])
}
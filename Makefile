bootstrap : ## Bootstrap the Jitsi-Meet-torture project
	cp env.d/terraform.dist env.d/terraform

build : ## Build and deploy Jitsi-Meet-torture with the specified configuration
	./bin/packer build packer.json
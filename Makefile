bootstrap : ## Bootstrap the Jitsi-Meet-torture project
	cp env.dist env

build : ## Build and deploy Jitsi-Meet-torture with the specified configuration
	./bin/packer build packer.json

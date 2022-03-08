include env.d/terraform

bootstrap: ## Bootstrap the Jitsi-Meet-torture project
	cp env.d/docker.dist env.d/docker
	cp env.d/terraform.dist env.d/terraform

build: ## Build the Jitsi-Meet-torture image with the specified configuration
ifneq (${shell ./bin/scaleway-cli instance image list | grep jmt-image | cut -d " " -f1},)
	make destroy
endif
ifneq ($(wildcard ./docker/.env),)
	./bin/packer build -var SCALEWAY_INSTANCE_TYPE=${SCALEWAY_INSTANCE_TYPE} packer.json
else 
	@echo "ERROR : The file env.d/docker doesn't exist."
endif

apply: ## Apply to terraform to deploy ressources and launch tests
	./bin/terraform apply -parallelism=${TF_OPERATIONS_PARALLELISM}

destroy: ## Destroy terraform ressources that were created
	./bin/terraform destroy -parallelism=${TF_OPERATIONS_PARALLELISM}
	
encrypt_key: ## Encrypt the secret key
	gpg --symmetric --armor --batch --passphrase="${SECRET_GPG_PASSPHRASE}" --output packer/.ssh/secrets.key.gpg packer/.ssh/id_ed25519

decrypt_key: ## Decrypt the secret key
	gpg --decrypt --batch --passphrase="${SECRET_GPG_PASSPHRASE}" packer/.ssh/secrets.key.gpg > packer/.ssh/id_ed25519

destroy: ## Delete the image created 
	./bin/scaleway-cli instance image delete ${shell ./bin/scaleway-cli instance image list | grep jmt-image | cut -d " " -f1} zone=fr-par-1
	./bin/scaleway-cli instance snapshot delete ${shell ./bin/scaleway-cli instance snapshot list | grep jmt-snapshot | cut -d " " -f1} zone=fr-par-1


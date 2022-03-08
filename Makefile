include env
export ${SECRET_GPG_PASSPHRASE}
export ${SCALEWAY_INSTANCE_TYPE}

bootstrap: ## Bootstrap the Jitsi-Meet-torture project
	cp env.dist env

build: ## Build the Jitsi-Meet-torture image with the specified configuration
ifneq (${shell scw instance image list | grep jmt-image | cut -d " " -f1},)
	make destroy
endif
ifneq ($(wildcard ./docker/.env),)
	./bin/packer build -var SCALEWAY_INSTANCE_TYPE=${SCALEWAY_INSTANCE_TYPE} packer.json
else 
	@echo "ERROR : The file .env doesn't exist."
endif
	
encrypt_key: ## Encrypt the secret key
	gpg --symmetric --armor --batch --passphrase="${SECRET_GPG_PASSPHRASE}" --output packer/.ssh/secrets.key.gpg packer/.ssh/id_ed25519

decrypt_key: ## Decrypt the secret key
	gpg --decrypt --batch --passphrase="${SECRET_GPG_PASSPHRASE}" packer/.ssh/secrets.key.gpg > packer/.ssh/id_ed25519

destroy: ## Delete the image created 
	./bin/scaleway-cli instance image delete ${shell ./bin/scaleway-cli instance image list | grep jmt-image | cut -d " " -f1} zone=fr-par-1
	./bin/scaleway-cli instance snapshot delete ${shell ./bin/scaleway-cli instance snapshot list | grep jmt-snapshot | cut -d " " -f1} zone=fr-par-1


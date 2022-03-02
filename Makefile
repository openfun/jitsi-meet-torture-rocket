include env
export ${SECRET_GPG_PASSPHRASE}

bootstrap: ## Bootstrap the Jitsi-Meet-torture project
	cp env.dist env

build: ## Build and deploy Jitsi-Meet-torture with the specified configuration
ifneq ($(wildcard ./docker/.env),)
	./bin/packer build packer.json
else 
	@echo "WARNING : La fichier .env n'existe pas."
endif
	
encrypt_key: ## Encrypt the secret key
	gpg --symmetric --armor --batch --passphrase="${SECRET_GPG_PASSPHRASE}" --output packer/.ssh/secrets.key.gpg packer/.ssh/id_ed25519

decrypt_key: ## Decrypt the secret key
	gpg --decrypt --batch --passphrase="${SECRET_GPG_PASSPHRASE}" packer/.ssh/secrets.key.gpg > packer/.ssh/id_ed25519



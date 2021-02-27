deploy: deploy-init build test
	terraform -chdir=terraform apply --auto-approve

deploy-init:
	if [ ! -d terraform/.terraform ]; then terraform -chdir=terraform init; fi

destroy:
	terraform -chdir=terraform destroy

install:
	if [ ! -d lambda/get_device_reading/node_modules ]; then npm install --unsafe-perm; fi

build:
	npm run build

test: install
	npm test
	

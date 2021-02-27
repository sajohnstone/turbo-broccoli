deploy: deploy-init test
	terraform -chdir=terraform apply --auto-approve

deploy-init:
	if [ ! -d terraform/.terraform ]; terraform -chdir=terraform init

destroy:
	terraform -chdir=terraform destroy

build:
	if [ ! -d lambda/get_device_reading/node_modules ]; then npm install --unsafe-perm; fi

test: build
	npm test
	

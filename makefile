deployment_env ?= dev

deploy:
  terraform -chdir=terraform init
  terraform -chdir=terraform apply

destroy:
  terraform -chdir=terraform destroy	
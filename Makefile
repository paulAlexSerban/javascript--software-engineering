INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR := ./infrastructure/orchestration/docker
INFRA_PROVISIONING_SCRIPTS := ./infrastructure/provisioning/scripts
INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS := ./infrastructure/server-templating/docker
INFRA_PROVISIONING_TERRAFORM_DIR := ./infrastructure/provisioning/terraform

# ----------------------------------------------
# Start localstack services
# ----------------------------------------------
define lambda-localstack-compose_template
$(1)-localstack_compose-up:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/lambda.locakstack.docker-compose.bash --phase=up --app-name=$(1)

$(1)-localstack_compose-down:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/lambda.locakstack.docker-compose.bash --phase=down --app-name=$(1)

$(1)-localstack_compose-down-clean:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/lambda.locakstack.docker-compose.bash --phase=down-clean --app-name=$(1)
endef

$(eval $(call lambda-localstack-compose_template,aws-getting-started-with-lambda))
$(eval $(call lambda-localstack-compose_template,hello-lambda))

.PHONY: hello-lambda-localstack_compose-up aws-getting-started-with-lambda-localstack_compose-up \
		hello-lambda-localstack_compose-down aws-getting-started-with-lambda-localstack_compose-down \
		hello-lambda-localstack_compose-down-clean aws-getting-started-with-lambda-localstack_compose-down-clean

hello-lambda-localstack_compose-up: 
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/lambda.locakstack.docker-compose.bash --phase=up --app-name=hello-lambda

aws-getting-started-with-lambda-localstack_compose-up: 
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/lambda.locakstack.docker-compose.bash --phase=up --app-name=aws-getting-started-with-lambda

# ----------------------------------------------
# Build and deploy lambda functions via Bash scripts
# ----------------------------------------------
define localstack-lambda-deploy-via-scripts-template
$(1)_localstack-deploy:
	@bash $(INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS)/simple-lambda.bash --phase=build --app-name=$(1)
	@bash $(INFRA_PROVISIONING_SCRIPTS)/simple-lambda.localstack.bash --phase=deploy --app-name=$(1)
endef

$(eval $(call localstack-lambda-deploy-via-scripts-template,aws-getting-started-with-lambda))
$(eval $(call localstack-lambda-deploy-via-scripts-template,hello-lambda))

.PHONY: hello-lambda_localstack-deploy aws-getting-started-with-lambda_localstack-deploy \
		hello-lambda-tf_init aws-getting-started-with-lambda-tf_init \
		hello-lambda-tf_apply aws-getting-started-with-lambda-tf_apply \
		hello-lambda-tf_destroy aws-getting-started-with-lambda-tf_destroy

hello-lambda_localstack-deploy:
	@bash $(INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS)/simple-lambda.bash --phase=build --app-name=hello-lambda
	@bash $(INFRA_PROVISIONING_SCRIPTS)/simple-lambda.localstack.bash --phase=deploy --app-name=hello-lambda

aws-getting-started-with-lambda_localstack-deploy:
	@bash $(INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS)/simple-lambda.bash --phase=build --app-name=aws-getting-started-with-lambda
	@bash $(INFRA_PROVISIONING_SCRIPTS)/simple-lambda.localstack.bash --phase=build --app-name=aws-getting-started-with-lambda

# ----------------------------------------------
# Build and deploy lambda functions via Terraform
# ----------------------------------------------
define localstack-lambda-deploy-via-terraform-template
$(1)-tf_init:
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-init --app-name=$(1)

$(1)-tf_apply:
	@bash $(INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS)/simple-lambda.bash --phase=build --app-name=$(1)
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-apply --app-name=$(1)

$(1)-tf_destroy:
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-destroy --app-name=$(1)
endef

$(eval $(call localstack-lambda-deploy-via-terraform-template,hello-lambda))
$(eval $(call localstack-lambda-deploy-via-terraform-template,aws-getting-started-with-lambda))

.PHONY: hello-lambda-tf_init aws-getting-started-with-lambda-tf_init \
		hello-lambda-tf_apply aws-getting-started-with-lambda-tf_apply \
		hello-lambda-tf_destroy aws-getting-started-with-lambda-tf_destroy

hello-lambda-tf_init:
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-init --app-name=hello-lambda

aws-getting-started-with-lambda-tf_init:
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-init --app-name=aws-getting-started-with-lambda

# ----------------------------------------------
# Base Django compose
# ----------------------------------------------
define base-django-compose_template
$(1)-compose-up:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.django.docker-compose.bash --phase=up --app-name=$(1)

$(1)-compose-down:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.django.docker-compose.bash --phase=down --app-name=$(1)

$(1)-compose-down-clean:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.django.docker-compose.bash --phase=down-clean --app-name=$(1)

$(1)-compose-make-migrations:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.django.docker-compose.bash --phase=make-migrations --app-name=$(1)

$(1)-compose-migrate:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.django.docker-compose.bash --phase=migrate --app-name=$(1)

$(1)-compose-createsuperuser:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.django.docker-compose.bash --phase=createsuperuser --app-name=$(1)
endef

$(eval $(call base-django-compose_template,hello-django))
$(eval $(call base-django-compose_template,profiles))
$(eval $(call base-django-compose_template,recipes))

.PHONY: hello-django-compose-up profiles-compose-up recipes-compose-up \
		hello-django-compose-down profiles-compose-down recipes-compose-down \
		hello-django-compose-down-clean profiles-compose-down-clean recipes-compose-down-clean \
		hello-django-compose-make-migrations profiles-compose-make-migrations recipes-compose-make-migrations \
		hello-django-compose-migrate profiles-compose-migrate recipes-compose-migrate \
		hello-django-compose-createsuperuser profiles-compose-createsuperuser recipes-compose-createsuperuser

hello-django-compose-up:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.django.docker-compose.bash --phase=up --app-name=hello-django

profiles-compose-up:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.django.docker-compose.bash --phase=up --app-name=profiles

#!/bin/bash

# These variables should be set in landingzone.conf
GCP_ORG_DOMAIN=""
GCP_BILLING_ID=""
GCP_PROJ_PREFIX=""
source ./landingzone.conf

# set variable for current logged in user
export FAST_BU=$(gcloud config list --format 'value(core.account)')

# find and set your org id
gcloud organizations list --filter display_name:$GCP_ORG_DOMAIN
export FAST_ORG_ID=$( gcloud organizations list --filter display_name:vertexai --format='value(name)' )

echo "Found GCP Org ID: $FAST_ORG_ID"

# set needed roles
export FAST_ROLES="roles/billing.admin roles/logging.admin \
  roles/iam.organizationRoleAdmin roles/resourcemanager.projectCreator"

echo "Adding roles..."
for role in $FAST_ROLES; do
  gcloud organizations add-iam-policy-binding $FAST_ORG_ID \
    --member user:$FAST_BU --role $role
done

echo "Setting up Billing..."

export FAST_BILLING_ACCOUNT_ID=$GCP_BILLING_ID
gcloud beta billing accounts add-iam-policy-binding $FAST_BILLING_ACCOUNT_ID \
  --member user:$FAST_BU --role roles/billing.admin

# TODO
# Create these groups in Workspace:
# gcp-billing-admins
# gcp-devops
# gcp-network-admins
# gcp-organization-admins
# gcp-security-admins

# TODO
# Add $FAST_BU (i.e. current user logged in and running this) to the gcp-organization-admins@ Group

# TODO
# Use the variables here to create 00-bootstrap/terraform.tfvars
#

# Login as $FAST_BU user in gcloud and for application default
gcloud auth application-default login

#########
# Stage 0

cd 00-bootstrap

#terraform init
#terraform plan -input=false -out bootstrap.tfplan
#terraform apply -var bootstrap_user=$(gcloud config list --format 'value(core.account)')

# Migrate state files
terraform output -json providers | jq -r '.["00-bootstrap"]'   > providers.tf
terraform init -migrate-state
# type yes

# Remove bootstrap user
terraform apply
cd ../

#########
# Stage 1
cd 01-resourcemanager

# Link configuration files
ln -s ../00-bootstrap/fast-config/tfvars/globals.auto.tfvars.json .
ln -s ../00-bootstrap/fast-config/tfvars/00-bootstrap.auto.tfvars.json .
ln -s ../00-bootstrap/fast-config/providers/01-resman-providers.tf .

terraform init

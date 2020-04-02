#!/bin/sh
echo "Setting environment variables for Terraform"
export ARM_SUBSCRIPTION_ID=7c3c145b-1b71-4d71-8628-b51b830e8ae3
export ARM_CLIENT_ID=c985a006-ff2f-420b-bb5e-766923258fe4
export ARM_CLIENT_SECRET=8bd769b0-0ad9-4b63-a58f-c2bf80eb6e0b
export ARM_TENANT_ID=24041256-c834-468a-b7e7-c4dc34322cfe

# Not needed for public, required for usgovernment, german, china
export ARM_ENVIRONMENT=public

export TF_VAR_client_id=c985a006-ff2f-420b-bb5e-766923258fe4
export TF_VAR_client_secret=8bd769b0-0ad9-4b63-a58f-c2bf80eb6e0b


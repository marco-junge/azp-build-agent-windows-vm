#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR=${SCRIPT_DIR:="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"}
TERRAFORM_IMAGE_VERSION=${TERRAFORM_IMAGE_VERSION:='0.12.18'}

usage="Usage: $0 <plan|apply|destroy> <module>"

tfvar_file="deploy.auto.tfvars"

subcommand="$1"
module="$2"

case $subcommand in
plan)
  tf_action="plan"
  ;;
apply)
  tf_action="apply"
  ;;
destroy)
  tf_action="destroy"
  ;;
-h | --help)
  echo "$usage"
  exit 2
  ;;
*)
  echo "Unknown option '$1'!"
  echo "$usage"
  exit 2
  ;;
esac

checkenv() {
  local env_vars=("$@")

  msg="required environment variables are unset:\n"
  for var in "${env_vars[@]}"; do
    if [[ -z ${!var+x} ]]; then # indirect expansion here
      local error=1
      msg+=" $var\n"
    fi
  done
  if [ "$error" ]; then
    echo -e "$msg"
    return 1
  fi
}

setup() {
  echo "Preparing dockerized terraform..."

  docker pull -q "hashicorp/terraform:$TERRAFORM_IMAGE_VERSION"

  function terraform() {
    TF_IN_AUTOMATION=${TF_IN_AUTOMATION:=true}

    docker run --rm \
      -v "$SCRIPT_DIR:/repo/terraform" \
      -w /repo/terraform \
      -e TF_IN_AUTOMATION="$TF_IN_AUTOMATION" \
      -e ARM_CLIENT_ID="$ARM_CLIENT_ID" \
      -e ARM_CLIENT_SECRET="$ARM_CLIENT_SECRET" \
      -e ARM_SUBSCRIPTION_ID="$ARM_SUBSCRIPTION_ID" \
      -e ARM_TENANT_ID="$ARM_TENANT_ID" \
      -e ARM_SKIP_PROVIDER_REGISTRATION=true \
      hashicorp/terraform:$TERRAFORM_IMAGE_VERSION "$@"
  }
  export -f terraform
}

cleanup() {
  echo "Cleanup..."
  find . -type f -name "$tfvar_file" -exec rm -f \{\} + || :
  find . -type d -name .terraform -exec rm -rf \{\} + || :
  echo "Unset local functions..."
  unset terraform || :
}
trap cleanup EXIT

# -----------------------------------------------------------------------
# Check and setup environment
# -----------------------------------------------------------------------

environment=(
  ARM_TENANT_ID ARM_SUBSCRIPTION_ID ARM_CLIENT_ID ARM_CLIENT_SECRET VM_ADMIN_PASSWORD AZP_ACCOUNT AZP_PERSONAL_ACCESS_TOKEN
)

checkenv "${environment[@]}"
setup

# -----------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------

rm -f "$tfvar_file"

echo "vm_admin_password         = \"$VM_ADMIN_PASSWORD\"" > "$tfvar_file"
echo "azp_account               = \"$AZP_ACCOUNT\"" >> "$tfvar_file"
echo "azp_personal_access_token = \"$AZP_PERSONAL_ACCESS_TOKEN\"" >> "$tfvar_file"

declare -a terraform_var_options
terraform_var_options+=("-var-file=$tfvar_file")

# -----------------------------------------------------------------------
# Run terraform
# -----------------------------------------------------------------------

terraform init "-lock=false" "$module"

case "$tf_action" in
plan)
  terraform_options+=( "${terraform_var_options[@]}" "$module" )
  terraform plan "${terraform_options[@]}"
  ;;
apply|destroy)
  terraform_options+=( "${terraform_var_options[@]}" "-auto-approve" "$module" )
  terraform $tf_action "${terraform_options[@]}"
  ;;
esac

cleanup

#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR=${SCRIPT_DIR:="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"}
TERRAFORM_IMAGE_VERSION=${TERRAFORM_IMAGE_VERSION:='0.12.18'}

setup() {
  echo "Preparing containerized command terraform..."

  images=( "hashicorp/terraform:$TERRAFORM_IMAGE_VERSION" )
  for image in "${images[@]}"; do
    docker pull -q "$image"
  done

  function terraform() {
    TF_IN_AUTOMATION=${TF_IN_AUTOMATION:=true}

    docker run --rm \
      -v "$SCRIPT_DIR:/repo" \
      -w /repo \
      -e ARM_SKIP_PROVIDER_REGISTRATION=true \
      hashicorp/terraform:$TERRAFORM_IMAGE_VERSION "$@"
  }
  export -f terraform
}

cleanup() {
  echo "Cleanup..."
  find . -type d -name .terraform -exec rm -rf \{\} + || :
  echo "Unset local functions..."
  unset terraform || :
}
trap cleanup EXIT

setup

terraform_modules=()
while IFS='' read -r directory; do terraform_modules+=("$directory"); done < <(ls -d modules/*)
while IFS='' read -r directory; do terraform_modules+=("$directory"); done < <(ls -d examples/*)

for terraform_module in "${terraform_modules[@]}"; do
  echo "Validating '$terraform_module'"
  terraform init -backend=false "$terraform_module"
  terraform validate "$terraform_module"
done

#!/usr/bin/env bash

set -eo pipefail

SHELLCHECK_IMAGE_VERSION=${SHELLCHECK_IMAGE_VERSION:='latest'}
SCRIPT_DIR=${SCRIPT_DIR:="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"}

setup() {
  echo "Preparing dockerized shellcheck..."

  docker pull -q "koalaman/shellcheck:$SHELLCHECK_IMAGE_VERSION"

  function shellcheck() {
    docker run --rm \
      -v "$SCRIPT_DIR:/repo" \
      -w /repo \
      koalaman/shellcheck:"$SHELLCHECK_IMAGE_VERSION" "$@"
  }
  export -f shellcheck
}

cleanup() {
  echo "Unset local functions..."
  unset shellcheck
}
trap cleanup EXIT

setup

shellcheck --version

find . -type f -not -path "./.git/*" -exec grep -Eq '^#!(.*/|.*env +)(sh|bash|ksh)' {} \; -print |
while IFS="" read -r file; do
  printf %s "$file: " 
  shellcheck -x "$file" && echo OK
done

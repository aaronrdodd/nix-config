#! /usr/bin/env nix-shell
#! nix-shell -i bash -p sops
# shellcheck shell=bash

if [[ -z "$1" ]]; then
  SECRETS_FILE="nixos/$(hostname)/secrets.yaml"
elif [[ -z "$2" ]]; then
  SECRETS_FILE="nixos/${1}/secrets.yaml"
else
  SECRETS_FILE="nixos/${1}/secrets/${2}.yaml"
fi

sops "$SECRETS_FILE"


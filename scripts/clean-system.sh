#! /usr/bin/env bash
# shellcheck shell=bash

echo 'Cleaning garbage: '
sudo nix-collect-garbage -d
nix-collect-garbage -d

echo 'Optimizing store: '
sudo nix-store --optimize -v
nix-store --optimize -v

echo 'Remaining gcroots: '
nix-store --gc --print-roots | grep -E -v "^(/nix/var|/run/\w+-system|/proc|\{memory)"


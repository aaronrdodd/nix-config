#!/usr/bin/env bash
# zfs-diff.sh
set -euo pipefail

sudo zfs diff -FH zroot/ROOT/toplevel@blank zroot/ROOT/toplevel | grep -v "@" | awk '{print $3}'


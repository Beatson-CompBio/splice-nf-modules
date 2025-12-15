#!/usr/bin/env bash
set -euo pipefail

TEST_FILE="${1:?Usage: scripts/nftest.sh <path/to/main.nf.test> [profile]}"
PROFILE="${2:-docker}"

nf-test test "$TEST_FILE" --profile "$PROFILE"

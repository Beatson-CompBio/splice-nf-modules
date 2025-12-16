#!/usr/bin/env bash
set -euo pipefail

TEST_FILE="${1:?Usage: scripts/nftest.sh <path/to/main.nf.test> [profile] [verbose]}"
PROFILE="${2:-docker}"
VERBOSE="${3:-false}"

VERBOSE_FLAG=""
if [[ "$VERBOSE" == "true" ]]; then
  VERBOSE_FLAG="--verbose"
fi

nf-test test "$TEST_FILE" --profile "$PROFILE" $VERBOSE_FLAG
  
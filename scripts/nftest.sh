#!/usr/bin/env bash
set -euo pipefail

TEST_FILE="${1:?Usage: scripts/nftest.sh <path/to/main.nf.test> [profile] [verbose] [update]}"
PROFILE="${2:-docker}"
VERBOSE="${3:-false}"
UPDATE="${4:-false}"

VERBOSE_FLAG=""
if [[ "$VERBOSE" == "true" ]]; then
  VERBOSE_FLAG="--verbose"
fi

UPDATE_FLAG=""
if [[ "$UPDATE" == "true" ]]; then
  UPDATE="--update-snapshot"
else
  UPDATE=""
fi  

nf-test test "$TEST_FILE" --profile "$PROFILE" $VERBOSE_FLAG $UPDATE_FLAG
  
#!/usr/bin/env bash

set -eu

mkdir -p "$INPUT_PROJECT_LOCATION"

/ghidra/support/analyzeHeadless \
  "$INPUT_PROJECT_LOCATION" \
  "$INPUT_PROJECT_NAME" \
  -import "$INPUT_IMPORT" \
  -log "$INPUT_LOG"

echo "::set-output name=log::$(cat "$INPUT_LOG")"

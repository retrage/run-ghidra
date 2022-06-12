#!/usr/bin/env bash

set -eux

readarray -t -d '' args < <(xargs printf '%s\0' <<<"$INPUT_ARGS")

mkdir -p "$INPUT_PROJECT_LOCATION"

/ghidra/support/analyzeHeadless \
  "$INPUT_PROJECT_LOCATION" \
  "$INPUT_PROJECT_NAME" \
  -import "$INPUT_IMPORT" \
  -log "$INPUT_LOG" \
  "${args[@]}"

echo "::set-output name=log::$(cat "$INPUT_LOG")"

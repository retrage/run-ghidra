#!/usr/bin/env bash

set -eux

readarray -t -d '' args < <(xargs printf '%s\0' <<<"$INPUT_ARGS")
readarray -t -d '' plugins < <(xargs printf '%s\0' <<<"$INPUT_PLUGINS")



# Download and install Ghidra plugins
for plugin in "${plugins[@]}"; do
  wget -P /ghidra/Ghidra/Extensions "$plugin"
  unzip -q -d /ghidra/Ghidra/Extensions "/ghidra/Ghidra/Extensions/$(basename "$plugin")"
done

mkdir -p "$INPUT_PROJECT_LOCATION"

/ghidra/support/analyzeHeadless \
  "$INPUT_PROJECT_LOCATION" \
  "$INPUT_PROJECT_NAME" \
  -import "$INPUT_IMPORT" \
  -log "$INPUT_LOG" \
  "${args[@]}"

echo "::set-output name=log::$(cat "$INPUT_LOG")"

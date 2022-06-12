#!/usr/bin/env bash

set -eu

if [[ -n "$INPUT_PLUGINS" ]]; then
  echo "::group::Download and install Ghidra plugins"
  readarray -t -d '' plugins < <(xargs printf '%s\0' <<<"$INPUT_PLUGINS")
  for plugin in "${plugins[@]}"; do
    wget -P /ghidra/Ghidra/Extensions "$plugin"
    unzip -d /ghidra/Ghidra/Extensions "/ghidra/Ghidra/Extensions/$(basename "$plugin")"
  done
  echo "::endgroup::"
fi

echo "::group::Run Ghidra"
readarray -t -d '' args < <(xargs printf '%s\0' <<<"$INPUT_ARGS")
mkdir -p "$INPUT_PROJECT_LOCATION"
/ghidra/support/analyzeHeadless \
  "$INPUT_PROJECT_LOCATION" \
  "$INPUT_PROJECT_NAME" \
  -import "$INPUT_IMPORT" \
  -log "$INPUT_LOG" \
  "${args[@]}"
echo "::endgroup::"

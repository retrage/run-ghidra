#!/usr/bin/env bash

set -eu

if [[ -n "$INPUT_PLUGINS" ]]; then
  echo "::group::Download and install Ghidra plugins"
  readarray -t -d '' plugins < <(xargs printf '%s\0' <<<"$INPUT_PLUGINS")
  for plugin in "${plugins[@]}"; do
    wget -q -P /ghidra/Ghidra/Extensions "$plugin"
    unzip -q -d /ghidra/Ghidra/Extensions "/ghidra/Ghidra/Extensions/$(basename "$plugin")"
  done
  echo "::endgroup::"
fi

echo "::group::Run Ghidra"
if [[ -n "$INPUT_LOG" ]]; then
  log_args=("-log" "$INPUT_LOG")
else
  log_args=()
fi
readarray -t -d '' args < <(xargs printf '%s\0' <<<"$INPUT_ARGS")
mkdir -p "$INPUT_PROJECT_LOCATION"
/ghidra/support/analyzeHeadless \
  "$INPUT_PROJECT_LOCATION" \
  "$INPUT_PROJECT_NAME" \
  -import "$INPUT_IMPORT" \
  "${log_args[@]}" \
  "${args[@]}"
echo "::endgroup::"

echo "::set-output name=log::$(cat "$INPUT_LOG")"

#!/usr/bin/env bash
set -o pipefail

# dispatch.sh — Invoke an opencode subagent with model fallback
#
# Usage: dispatch.sh <agent> <dir> <prompt>
#
# Environment variables:
#   OPENCODE_DISPATCH_MODEL     Primary model (default: opencode/deepseek-v4-flash-free)
#   OPENCODE_DISPATCH_FALLBACK  Fallback model (default: opencode-go/deepseek-v4-flash)

AGENT="${1:?Usage: dispatch.sh <researcher|editor|reviewer> <dir> <prompt>}"
DIR="${2:?}"
PROMPT="${3:?}"

PRIMARY="${OPENCODE_DISPATCH_MODEL:-opencode/deepseek-v4-flash-free}"
FALLBACK="${OPENCODE_DISPATCH_FALLBACK:-opencode-go/deepseek-v4-flash}"

run() {
    local model="$1"
    opencode run --agent "$AGENT" --model "$model" --format json --dir "$DIR" "$PROMPT" \
        | jq -r 'select(.type=="text") | .part.text'
}

if output=$(run "$PRIMARY" 2>&1); then
    echo "$output"
    exit 0
fi

echo "$output" >&2
echo "[dispatch] primary model ($PRIMARY) failed, trying fallback ($FALLBACK)..." >&2

if output=$(run "$FALLBACK" 2>&1); then
    echo "$output"
    exit 0
fi

echo "$output" >&2
echo "[dispatch] both models failed" >&2
exit 1


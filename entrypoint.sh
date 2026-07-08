#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]] || [[ -z "${*// }" ]]; then
  echo "::error::No commands provided. Pass shell commands via the 'args' input."
  exit 1
fi

# GitHub Actions mounts the workspace here for Docker actions.
WORKSPACE="${GITHUB_WORKSPACE:-/github/workspace}"
if [[ -d "${WORKSPACE}" ]]; then
  cd "${WORKSPACE}"
fi

export GRADLE_USER_HOME="${GRADLE_USER_HOME:-${WORKSPACE}/.gradle}"

exec bash -lc "$*"

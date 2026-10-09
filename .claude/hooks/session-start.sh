#!/bin/bash
# Ensure Python and MarkItDown are installed at session start.
set -euo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  apt-get update -qq && apt-get install -y -qq python3 python3-pip
fi

if ! command -v markitdown >/dev/null 2>&1; then
  python3 -m pip install --quiet 'markitdown[all]'
fi

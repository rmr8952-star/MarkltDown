#!/bin/bash
# Ensure Python and MarkItDown are installed at session start.
set -euo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  apt-get update -qq && apt-get install -y -qq python3 python3-pip
fi

if ! command -v markitdown >/dev/null 2>&1; then
  python3 -m pip install --quiet 'markitdown[all]'
fi

# Design skills and plugins (user scope). Failures here must not block the session.
if [ ! -d "$HOME/.claude/skills/design-taste-frontend" ]; then
  (cd "$HOME" && npx -y skills add https://github.com/Leonxlnx/taste-skill -g -a claude-code -y >/dev/null 2>&1) \
    || echo "warning: taste-skill install failed" >&2
fi

if [ ! -d "$HOME/.claude/skills/emil-design-eng" ]; then
  (cd "$HOME" && npx -y skills@latest add emilkowalski/skills -g -a claude-code -y >/dev/null 2>&1) \
    || echo "warning: Emil Kowalski skills install failed" >&2
fi

if command -v claude >/dev/null 2>&1 && ! claude plugin list 2>/dev/null | grep -q 'impeccable@impeccable'; then
  (cd "$HOME" \
    && claude plugin marketplace add pbakaus/impeccable --scope user >/dev/null 2>&1 \
    ; claude plugin install impeccable@impeccable --scope user >/dev/null 2>&1) \
    || echo "warning: impeccable plugin install failed" >&2
fi

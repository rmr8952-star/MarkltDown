#!/bin/bash
# Ensure Python and MarkItDown are installed at session start.
set -euo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  apt-get update -qq && apt-get install -y -qq python3 python3-pip
fi

if ! command -v markitdown >/dev/null 2>&1; then
  python3 -m pip install --quiet 'markitdown[all]'
fi

# Design skills and plugins (user scope). Each install retries, then falls back
# to a second method; failures only warn and never block the session.
SKILLS_DIR="$HOME/.claude/skills"
LOG="$HOME/.claude/session-start-install.log"
mkdir -p "$SKILLS_DIR"

warn() { echo "warning: $*" >&2; echo "$(date -Is) $*" >>"$LOG"; }

# retry CMD...: up to 3 attempts with 2s/4s backoff.
retry() {
  local delay=2 i
  for i in 1 2 3; do
    "$@" >>"$LOG" 2>&1 && return 0
    if [ "$i" -lt 3 ]; then sleep "$delay"; delay=$((delay * 2)); fi
  done
  return 1
}

# Fallback: clone the repo and copy every skill folder, named by its SKILL.md
# frontmatter `name` (the same name `npx skills` installs it under).
install_skills_from_git() {
  local repo=$1 tmp file dir name
  tmp=$(mktemp -d)
  retry git clone --quiet --depth 1 "https://github.com/$repo" "$tmp/repo" || { rm -rf "$tmp"; return 1; }
  while IFS= read -r file; do
    dir=$(dirname "$file")
    name=$(sed -n 's/^name:[[:space:]]*//p' "$file" | head -1 | tr -d "\"'\r")
    [ -n "$name" ] || name=$(basename "$dir")
    rm -rf "${SKILLS_DIR:?}/$name"
    cp -r "$dir" "$SKILLS_DIR/$name"
  done < <(find "$tmp/repo" -name SKILL.md -not -path '*/.git/*')
  rm -rf "$tmp"
}

ensure_skills() {
  local repo=$1 marker=$2 npx_source=$3
  [ -f "$SKILLS_DIR/$marker/SKILL.md" ] && return 0
  if command -v npx >/dev/null 2>&1 \
    && (cd "$HOME" && retry npx -y skills@latest add "$npx_source" -g -a claude-code -y) \
    && [ -f "$SKILLS_DIR/$marker/SKILL.md" ]; then
    return 0
  fi
  warn "npx install of $repo failed; falling back to git clone"
  if ! { install_skills_from_git "$repo" && [ -f "$SKILLS_DIR/$marker/SKILL.md" ]; }; then
    warn "$repo skills install failed (see $LOG)"
  fi
}

ensure_skills Leonxlnx/taste-skill design-taste-frontend https://github.com/Leonxlnx/taste-skill
ensure_skills emilkowalski/skills emil-design-eng emilkowalski/skills

# Fallback: register the marketplace and enable the plugin in user settings,
# which Claude Code reads on startup.
enable_impeccable_in_settings() {
  python3 - "$HOME/.claude/settings.json" <<'PY'
import json, os, sys
path = sys.argv[1]
try:
    with open(path) as f:
        data = json.load(f)
except (FileNotFoundError, ValueError):
    data = {}
data.setdefault("extraKnownMarketplaces", {})["impeccable"] = {
    "source": {"source": "github", "repo": "pbakaus/impeccable"}
}
data.setdefault("enabledPlugins", {})["impeccable@impeccable"] = True
os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, "w") as f:
    json.dump(data, f, indent=2)
PY
}

if ! { command -v claude >/dev/null 2>&1 && claude plugin list 2>/dev/null | grep -q 'impeccable@impeccable'; }; then
  if command -v claude >/dev/null 2>&1 && (cd "$HOME" \
      && { claude plugin marketplace list 2>/dev/null | grep -q impeccable \
           || retry claude plugin marketplace add pbakaus/impeccable --scope user; } \
      && retry claude plugin install impeccable@impeccable --scope user); then
    :
  else
    warn "impeccable plugin install failed; enabling it in ~/.claude/settings.json instead"
    enable_impeccable_in_settings || warn "could not update ~/.claude/settings.json"
  fi
fi

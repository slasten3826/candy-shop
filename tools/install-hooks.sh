#!/usr/bin/env bash
# Installs the redact-check pre-commit hook into the local git repo.
# Run once after cloning: tools/install-hooks.sh

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hook="$root/.git/hooks/pre-commit"

if [ ! -d "$root/.git" ]; then
  echo "install-hooks: run 'git init' first" >&2
  exit 1
fi

cat > "$hook" <<'EOF'
#!/usr/bin/env bash
# Auto-installed by tools/install-hooks.sh
exec "$(git rev-parse --show-toplevel)/tools/redact-check.sh"
EOF

chmod +x "$hook"
echo "install-hooks: pre-commit hook installed at .git/hooks/pre-commit"

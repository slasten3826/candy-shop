#!/usr/bin/env bash
# Blocks sensitive content from entering this public repository.
# Usage: tools/redact-check.sh [path ...]   (default: repo root)
# Exit 0 = clean, 1 = sensitive content found.

set -uo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"

# Targets to scan: explicit args, else the repository root.
targets=("$@")
[ ${#targets[@]} -eq 0 ] && targets=("$root")

# Each pattern: LABEL<TAB>REGEX
# IPv4 uses non-word boundaries so version-like tokens such as 1.0.0.87-2 are
# not mistaken for addresses.
patterns=$(cat <<'EOF'
IPv4 address	(^|[^0-9A-Za-z._-])((25[0-5]|2[0-4][0-9]|1?[0-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1?[0-9]?[0-9])([^0-9A-Za-z._-]|$)
IPv6 address	([0-9a-fA-F]{0,4}:){3,}[0-9a-fA-F]{1,4}
MAC address	([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}
private key	BEGIN [A-Z ]*PRIVATE KEY
ssh key material	ssh-(rsa|ed25519|dss) AAAA
api key	(sk|pk|ghp|gho|glpat|xox[baprs])[-_][A-Za-z0-9]{16,}
aws key	AKIA[0-9A-Z]{16}
password	pass(word|wd|phrase)\s*[:=]\s*\S+
token	(tok|secret|api[-_]?key)[-_]?\s*[:=]\s*\S+
wireless SSID	SSID\s*[:=]\s*\S+
EOF
)

is_binary() {
  case "$1" in
    *.png|*.jpg|*.jpeg|*.gif|*.pdf|*.bin|*.iso|*.webp|*.zip|*.tar|*.gz) return 0 ;;
    *) return 1 ;;
  esac
}

is_self() {
  case "$1" in
    */tools/redact-check.sh|tools/redact-check.sh) return 0 ;;
    *) return 1 ;;
  esac
}

scan_file() {
  local f="$1" label regex hits
  is_binary "$f" && return 0
  is_self "$f" && return 0
  while IFS=$'\t' read -r label regex; do
    [ -z "$label" ] && continue
    hits=$(grep -nEI -- "$regex" "$f" 2>/dev/null | head -3)
    if [ -n "$hits" ]; then
      if [ "$found" -eq 0 ]; then
        echo "redact-check: sensitive content detected" >&2
        echo >&2
      fi
      found=1
      printf '%s\n' "  [$label] $f" >&2
      printf '%s\n' "$hits" | sed 's/^/      /' >&2
    fi
  done <<< "$patterns"
}

found=0

for target in "${targets[@]}"; do
  if [ -f "$target" ]; then
    scan_file "$target"
    continue
  fi
  if [ -d "$target" ]; then
    if git -C "$target" rev-parse --git-dir >/dev/null 2>&1; then
      mapfile -d '' -t files < <(git -C "$target" ls-files -co --exclude-standard -z)
      for f in "${files[@]}"; do
        [ -n "$f" ] && scan_file "$target/$f"
      done
    else
      while IFS= read -r -d '' f; do
        scan_file "$f"
      done < <(find "$target" -type f -not -path '*/.git/*' -print0)
    fi
    continue
  fi
  echo "redact-check: no such path: $target" >&2
  found=1
done

if [ "$found" -ne 0 ]; then
  echo >&2
  echo "redact-check: commit blocked. Remove or placeholder the values above." >&2
  exit 1
fi

echo "redact-check: clean"
exit 0

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

# Every pattern except the first uses portable ERE. The first needs a negative
# lookahead to exempt this machine's own private ranges, which only PCRE offers,
# so it is handled separately below rather than through this loop.
patterns=$(cat <<'EOF'
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

# This machine's LAN is private and belongs to this tree, so `192.168.31.42`
# and other RFC1918 addresses pass. Two things do not:
#
#   - the VPN tunnel's subnet, whose addresses identify a network exit point
#     rather than describing this machine's LAN;
#   - any routable IPv4 literal.
#
# They are scanned by two separate functions because a negative lookahead cannot
# carve a hole inside an allowed range.
TUNNEL_SUBNET='172\.19'

scan_tunnel_subnet() {
  local f="$1" hits
  hits=$(grep -nPI -- "(?<![0-9A-Za-z._-])(?:${TUNNEL_SUBNET})\.(?:(?:25[0-5]|2[0-4][0-9]|1?[0-9]?[0-9])\.)(?:25[0-5]|2[0-4][0-9]|1?[0-9]?[0-9])(?![0-9A-Za-z._-])" "$f" 2>/dev/null | head -3)
  [ -n "$hits" ] || return 0
  if [ "$found" -eq 0 ]; then
    echo "redact-check: sensitive content detected" >&2
    echo >&2
  fi
  found=1
  printf '%s\n' "  [tunnel address] $f" >&2
  printf '%s\n' "$hits" | sed 's/^/      /' >&2
}

scan_public_ipv4() {
  local f="$1" hits
  hits=$(grep -nPI -- '(?<![0-9A-Za-z._-])(?!(?:10|127|192\.168|169\.254|100\.(?:6[4-9]|[7-9][0-9]|1[0-2][0-7])|172\.(?:1[6-9]|2[0-9]|3[01]))\.)(?:(?:25[0-5]|2[0-4][0-9]|1?[0-9]?[0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|1?[0-9]?[0-9])(?![0-9A-Za-z._-])' "$f" 2>/dev/null | head -3)
  [ -n "$hits" ] || return 0
  if [ "$found" -eq 0 ]; then
    echo "redact-check: sensitive content detected" >&2
    echo >&2
  fi
  found=1
  printf '%s\n' "  [public IPv4] $f" >&2
  printf '%s\n' "$hits" | sed 's/^/      /' >&2
}

# Link-local addresses are published for the LAN interface but not for the
# tunnel, so the tunnel's is scanned separately.
LAN_LINKLOCAL='289a:7b79'

scan_tunnel_linklocal() {
  local f="$1" hits
  hits=$(grep -nPI -- "(?<![0-9a-fA-F:])fe80:(?![0-9a-fA-F:]*:${LAN_LINKLOCAL})[0-9a-fA-F:]{4,}" "$f" 2>/dev/null | head -3)
  [ -n "$hits" ] || return 0
  if [ "$found" -eq 0 ]; then
    echo "redact-check: sensitive content detected" >&2
    echo >&2
  fi
  found=1
  printf '%s\n' "  [tunnel link-local] $f" >&2
  printf '%s\n' "$hits" | sed 's/^/      /' >&2
}

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

# Machine-local material that is never published. .gitignore covers the normal
# case; this catches it when a path is forced onto the index.
is_local_only() {
  case "$1" in
    local/*|*/local/*|*.local.md) return 0 ;;
    *) return 1 ;;
  esac
}

scan_file() {
  local f="$1" label regex hits
  is_binary "$f" && return 0
  is_self "$f" && return 0
  if is_local_only "$f"; then
    if [ "$found" -eq 0 ]; then
      echo "redact-check: sensitive content detected" >&2
      echo >&2
    fi
    found=1
    printf '%s\n' "  [local-only file] $f" >&2
    printf '%s\n' "      this file is machine-local by design and must not be published" >&2
    return 0
  fi
  scan_tunnel_subnet "$f"
  scan_public_ipv4 "$f"
  scan_tunnel_linklocal "$f"
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

#!/bin/sh
# Resolve the X authority file of the live graphical session, then exec the
# daemon.
#
# SDDM starts this desktop's Xorg with a per-boot authority file under /tmp
# (the path changes on every login), so XAUTHORITY cannot be hardcoded in the
# systemd unit. KDE's env has the real value; fall back to probing.

set -eu

get_env_from_session() {
    key="$1"
    for proc in plasmashell ksmserver kwin_x11 kded6; do
        pid=$(pgrep -u "$(id -u)" -x "$proc" 2>/dev/null | head -n 1) || continue
        [ -n "$pid" ] || continue
        value=$(tr '\0' '\n' < "/proc/$pid/environ" 2>/dev/null \
            | sed -n "s/^${key}=//p" | head -n 1)
        if [ -n "$value" ]; then
            printf '%s' "$value"
            return 0
        fi
    done
    return 1
}

display=$(get_env_from_session DISPLAY || true)
authority=$(get_env_from_session XAUTHORITY || true)

[ -n "$display" ] || display=":0"

if [ -z "$authority" ] || [ ! -r "$authority" ]; then
    for candidate in /run/sddm/* /tmp/xauth_* "$HOME/.Xauthority"; do
        if [ -r "$candidate" ]; then
            authority="$candidate"
            break
        fi
    done
fi

[ -n "$authority" ] || { echo "no readable X authority file found" >&2; exit 1; }

export DISPLAY="$display"
export XAUTHORITY="$authority"

echo "session env: DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
exec /usr/bin/python3 "$HOME/.local/bin/processglyphd.py"

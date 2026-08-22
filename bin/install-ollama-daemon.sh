#!/usr/bin/env bash
#
# Install the yadm-tracked ollama LaunchDaemon into /Library/LaunchDaemons.
#
# The source of truth is ~/.config/launchd/local.ollama.plist — a yadm alt file,
# so each daemon host materialises its own tuned copy (lem serves the tailnet at
# 64K context, tiptree stays headless at 16K). The copy under
# /Library/LaunchDaemons is the installed artifact: never edit it directly, edit
# the tracked file and re-run this.
#
# A LaunchDaemon rather than a LaunchAgent because these boxes serve ollama with
# nobody logged in, and a gui-domain agent only loads inside a login session.
# verne is the exception and deliberately keeps an agent — see
# ~/Library/LaunchAgents/local.ollama.plist.
#
# Needs sudo: both the root-owned plist and the system domain require it. Safe
# to re-run — the old copy is booted out before the new one is bootstrapped.
set -euo pipefail

LABEL="local.ollama"
SRC="$HOME/.config/launchd/${LABEL}.plist"
DEST="/Library/LaunchDaemons/${LABEL}.plist"

die() { echo "install-ollama-daemon: ERROR - $*" >&2; exit 1; }

[ "$(uname -s)" = Darwin ] || die "macOS only"

# On a host with no alt of its own, yadm leaves the ##hostname.* variants
# unmaterialised and $SRC never appears. That is the correct answer for verne
# (gui-domain agent) and huxley (Homebrew's own service), not a failure to fix
# by hand-copying another machine's plist.
[ -f "$SRC" ] || die "no $SRC on $(hostname -s).
  Only hosts with a local.ollama.plist##hostname.<host> alt run the daemon;
  see ~/.config/launchd/. If this IS a daemon host, check 'hostname -s' —
  yadm keys the alt on it."

# A daemon runs as root unless the plist says otherwise, and a root-owned ollama
# writes to the wrong ~/.ollama. Refuse an agent plist rather than install one
# into the system domain and find out later.
grep -q '<key>UserName</key>' "$SRC" \
    || die "$SRC declares no UserName — that is an agent plist, not a daemon."

# Both this and brew's service want :11434, and only one can have it.
# `brew services stop` also removes brew's LaunchAgent, so afterwards there is
# exactly one claimant at boot and no race.
if command -v brew >/dev/null 2>&1 && command -v jq >/dev/null 2>&1 \
   && brew services info ollama --json 2>/dev/null | jq -e '.[0].loaded' >/dev/null 2>&1; then
    echo "Stopping the Homebrew ollama service in favour of ${LABEL}"
    brew services stop ollama >/dev/null 2>&1 \
        || echo "install-ollama-daemon: WARN - could not stop brew's ollama service" >&2
fi

echo "Installing ${SRC} -> ${DEST}"
sudo install -m 644 -o root -g wheel "$SRC" "$DEST"

# launchctl refuses to bootstrap a label that is already loaded, so bootout
# first. Expected to fail on a first install, hence the discarded output.
sudo launchctl bootout "system/${LABEL}" 2>/dev/null || true
sudo launchctl bootstrap system "$DEST"

echo "Loaded ${LABEL}. Listening on:"
lsof -nP -iTCP:11434 -sTCP:LISTEN 2>/dev/null | sed -n '2,$p' \
    || echo "  nothing on :11434 yet — check /opt/homebrew/var/log/ollama.log"

#!/usr/bin/env bash
#
# Install a tracked LaunchDaemon plist into /Library/LaunchDaemons and load it.
#
#   install-launch-daemon.sh ~/.config/launchd/local.ollama.plist
#
# The source of truth is the file under ~/.config/launchd — a yadm alt, so each
# machine materialises its own tuned copy. The one under /Library/LaunchDaemons
# is the installed artifact: never edit it, edit the tracked file and re-run.
#
# A daemon rather than a LaunchAgent because these jobs serve with nobody logged
# in, and a gui-domain agent only loads inside a login session.
#
# Needs sudo. Safe to re-run — the old copy is booted out before the new one is
# bootstrapped.
set -euo pipefail

die() { echo "install-launch-daemon: ERROR - $*" >&2; exit 1; }

[ "$(uname -s)" = Darwin ] || die "macOS only"
[ $# -eq 1 ] || die "usage: install-launch-daemon.sh <plist>"

SRC=$1
[ -f "$SRC" ] || die "no such plist: $SRC"

LABEL=$(basename "$SRC" .plist)
DEST="/Library/LaunchDaemons/${LABEL}.plist"

# A daemon runs as root unless the plist says otherwise, and a root-owned job
# writes to the wrong home. Refuse an agent plist rather than install one into
# the system domain and find out later.
grep -q '<key>UserName</key>' "$SRC" \
    || die "$SRC declares no UserName — that is an agent plist, not a daemon."

# ollama is the one job Homebrew also ships a service for, and both want :11434.
# `brew services stop` also removes brew's LaunchAgent, so afterwards there is
# exactly one claimant at boot and no race.
if [ "$LABEL" = local.ollama ] && command -v brew >/dev/null 2>&1 \
   && command -v jq >/dev/null 2>&1 \
   && brew services info ollama --json 2>/dev/null | jq -e '.[0].loaded' >/dev/null 2>&1; then
    echo "Stopping the Homebrew ollama service in favour of ${LABEL}"
    brew services stop ollama >/dev/null 2>&1 \
        || echo "install-launch-daemon: WARN - could not stop brew's ollama service" >&2
fi

echo "Installing ${SRC} -> ${DEST}"
sudo install -m 644 -o root -g wheel "$SRC" "$DEST"

# launchctl refuses to bootstrap a label that is already loaded, so bootout
# first. Expected to fail on a first install, hence the discarded output.
sudo launchctl bootout "system/${LABEL}" 2>/dev/null || true
sudo launchctl bootstrap system "$DEST"
echo "Loaded ${LABEL}"

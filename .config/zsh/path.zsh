# ~/.config/zsh/path.zsh
#
# The single definition of PATH. Sourced TWICE, on purpose, by ~/.zshenv
# and ~/.zprofile. The rest of this comment explains why that is not a bug.
#
# ---------------------------------------------------------------------------
# Zsh startup sequence on macOS
#
# Files run top to bottom. A given shell only runs the rows whose "runs for"
# column matches it. Note that /etc/* system files are interleaved with your
# own, which is where the surprise below comes from.
#
#   #  File              Runs for                          Notes
#   -  ----------------  --------------------------------  --------------------
#   1  /etc/zshenv       every zsh, no exceptions          (usually absent)
#   2  ~/.zshenv         every zsh, no exceptions          <- sourced here
#   3  /etc/zprofile     login shells only                 RUNS path_helper
#   4  ~/.zprofile       login shells only                 <- sourced here
#   5  /etc/zshrc        interactive shells only
#   6  ~/.zshrc          interactive shells only           aliases, prompt, mise
#   7  /etc/zlogin       login shells only
#   8  ~/.zlogin         login shells only                 (not used here)
#
#   On exit: ~/.zlogout, then /etc/zlogout (login shells only).
#
# What counts as what:
#
#   Terminal tab/window     login + interactive  -> 1,2,3,4,5,6,7,8
#   `zsh` typed at a prompt        interactive  -> 1,2,5,6
#   `./script.zsh`, cron, LaunchAgent, `ssh host cmd`,
#   coding agents (Claude Code)         neither -> 1,2 ONLY
#
# ---------------------------------------------------------------------------
# Why this file is sourced twice
#
# Two different questions have two different right answers:
#
#   "Is this directory on PATH at all?"  -> only ~/.zshenv (step 2) reaches
#     scripts, cron, LaunchAgents and agents. ~/.zprofile never runs for them.
#     Miss this and `uv`-installed tools in ~/.local/bin are invisible to any
#     automation, while working fine when you test by hand. Ask me how I know.
#
#   "In what order?"  -> only ~/.zprofile (step 4) runs AFTER path_helper.
#     At step 3 macOS rebuilds PATH from /etc/paths and /etc/paths.d, putting
#     system directories FIRST and appending whatever you had set. So anything
#     step 2 puts up front gets demoted. Measured, with only .zshenv setting it:
#
#         1  /usr/local/bin
#         3  /usr/bin
#        11  /opt/homebrew/bin     <- demoted, so Apple git beats Homebrew git
#
# Sourcing at step 2 answers the first question, at step 4 the second.
#
# The second pass is a REORDER, not a duplication, because ~/.zshenv sets
# `typeset -U path PATH` before sourcing this. With the unique flag set,
# prepending an entry that already exists promotes it to the front:
#
#     before: /usr/bin:/bin:/opt/homebrew/bin
#     after : /opt/homebrew/bin:/usr/bin:/bin
#
# ---------------------------------------------------------------------------
# Editing
#
# Entries are prepended, so this list reads LOWEST priority first and the
# final PATH comes out in reverse of the order below. Add new entries at the
# bottom to give them high priority, at the top for low.
#
# Deliberately NOT here:
#   `brew shellenv`  - stays in ~/.zprofile. It forks a subprocess and also
#                      sets MANPATH/INFOPATH/HOMEBREW_PREFIX; worth it once per
#                      login, not on every `zsh -c`. The bare bin/sbin entries
#                      below are all a script actually needs.
#   `mise activate`  - stays in ~/.zshrc. Moving it would slow every shell. If
#                      cron ever needs mise tools, add the shim dir here.
# ---------------------------------------------------------------------------

[ -d "$HOME/.local/bin" ]          && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ]                 && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.cargo/bin" ]          && PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.fzf/bin" ]            && PATH="$HOME/.fzf/bin:$PATH"
[ -d "/opt/homebrew/opt/fzf/bin" ] && PATH="/opt/homebrew/opt/fzf/bin:$PATH"
[ -d "/opt/homebrew/sbin" ]        && PATH="/opt/homebrew/sbin:$PATH"
[ -d "/opt/homebrew/bin" ]         && PATH="/opt/homebrew/bin:$PATH"

export PATH
